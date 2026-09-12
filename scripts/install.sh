#!/usr/bin/env bash

set -euo pipefail

force=false
dry_run=false
codex_dir="${CODEX_HOME:-$HOME/.codex}"
target="$codex_dir/agents"
skills_target="$codex_dir/skills"

usage() {
    echo "Usage: scripts/install.sh [--dry-run] [--force] [--target DIRECTORY] [--skills-target DIRECTORY]"
}

while (( $# > 0 )); do
    case "$1" in
        --dry-run)
            dry_run=true
            shift
            ;;
        --force)
            force=true
            shift
            ;;
        --target)
            if (( $# < 2 )); then
                echo "--target requires a directory" >&2
                exit 1
            fi
            target="$2"
            shift 2
            ;;
        --skills-target)
            if (( $# < 2 )); then
                echo "--skills-target requires a directory" >&2
                exit 1
            fi
            skills_target="$2"
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repository_dir="$(cd -- "$script_dir/.." && pwd)"
source_dir="$repository_dir/agents"
skill_sources=("$repository_dir/skills/gnym-youtrack" "$repository_dir/skills/gnym-commit" "$repository_dir/skills/gnym-branch")

if [[ -z "$target" || "$target" == "/" ]]; then
    echo "Refusing unsafe target directory: $target" >&2
    exit 1
fi
if [[ -z "$skills_target" || "$skills_target" == "/" ]]; then
    echo "Refusing unsafe skills target directory: $skills_target" >&2
    exit 1
fi
for skill_source in "${skill_sources[@]}"; do
    if [[ ! -f "$skill_source/SKILL.md" ]]; then
        echo "Skill not found in $skill_source" >&2
        exit 1
    fi
done

shopt -s nullglob
sources=("$source_dir"/gnym_*.toml)
if (( ${#sources[@]} == 0 )); then
    echo "No Gnym agent definitions found in $source_dir" >&2
    exit 1
fi

validate_agent() {
    local source="$1"
    local expected_name
    expected_name="$(basename -- "$source" .toml)"

    if ! grep -Fqx "name = \"$expected_name\"" "$source"; then
        echo "$(basename -- "$source"): missing matching name field" >&2
        return 1
    fi
    if ! grep -Eq '^description = ".+"$' "$source"; then
        echo "$(basename -- "$source"): missing description field" >&2
        return 1
    fi
    if ! grep -Eq '^sandbox_mode = "(read-only|workspace-write)"$' "$source"; then
        echo "$(basename -- "$source"): missing or unsupported sandbox_mode" >&2
        return 1
    fi
    if ! grep -Fqx 'developer_instructions = """' "$source"; then
        echo "$(basename -- "$source"): missing developer instructions" >&2
        return 1
    fi
    if [[ "$(tail -n 1 "$source")" != '"""' ]]; then
        echo "$(basename -- "$source"): developer instructions are not closed" >&2
        return 1
    fi
}

conflicts=()
for source in "${sources[@]}"; do
    validate_agent "$source"
    destination="$target/$(basename -- "$source")"
    if [[ -f "$destination" ]] && ! cmp -s "$source" "$destination" && [[ "$force" != true ]]; then
        conflicts+=("$destination")
    fi
done

for skill_source in "${skill_sources[@]}"; do
    skill_destination="$skills_target/$(basename -- "$skill_source")"
    if [[ -e "$skill_destination" ]] && ! diff -qr "$skill_source" "$skill_destination" >/dev/null && [[ "$force" != true ]]; then
        conflicts+=("$skill_destination")
    fi
done

if (( ${#conflicts[@]} > 0 )); then
    for destination in "${conflicts[@]}"; do
        echo "Refusing to overwrite changed file: $destination" >&2
    done
    echo "Review the differences and rerun with --force if replacement is intended." >&2
    exit 2
fi

if [[ "$dry_run" != true ]]; then
    mkdir -p -- "$target"
    mkdir -p -- "$skills_target"
fi

for source in "${sources[@]}"; do
    destination="$target/$(basename -- "$source")"
    if [[ -f "$destination" ]] && cmp -s "$source" "$destination"; then
        echo "unchanged $destination"
    elif [[ "$dry_run" == true ]]; then
        if [[ -f "$destination" ]]; then
            echo "would replace $destination"
        else
            echo "would install $destination"
        fi
    else
        temporary="$(mktemp "$target/.gnym-agent.XXXXXX")"
        cp -- "$source" "$temporary"
        chmod 0644 "$temporary"
        mv -f -- "$temporary" "$destination"
        echo "installed $destination"
    fi
done

for skill_source in "${skill_sources[@]}"; do
    skill_destination="$skills_target/$(basename -- "$skill_source")"
    if [[ -d "$skill_destination" ]] && diff -qr "$skill_source" "$skill_destination" >/dev/null; then
        echo "unchanged $skill_destination"
    elif [[ "$dry_run" == true ]]; then
        if [[ -e "$skill_destination" ]]; then
            echo "would replace $skill_destination"
        else
            echo "would install $skill_destination"
        fi
    else
        temporary_skill="$(mktemp -d "$skills_target/.gnym-skill.XXXXXX")"
        cp -R "$skill_source/." "$temporary_skill/"
        if [[ -e "$skill_destination" ]]; then
            backup_skill="$(mktemp -d "$skills_target/.gnym-skill-backup.XXXXXX")"
            rmdir "$backup_skill"
            mv -- "$skill_destination" "$backup_skill"
            if ! mv -- "$temporary_skill" "$skill_destination"; then
                mv -- "$backup_skill" "$skill_destination"
                exit 1
            fi
            rm -rf -- "$backup_skill"
        else
            mv -- "$temporary_skill" "$skill_destination"
        fi
        echo "installed $skill_destination"
    fi
done

echo "Validated ${#sources[@]} Gnym agent definitions."
echo "Validated ${#skill_sources[@]} Gnym skills."
if [[ "$dry_run" == true ]]; then
    echo "Dry run complete; no files were written."
else
    echo "Start a new Codex task if the installed roles are not visible in the current task."
fi
