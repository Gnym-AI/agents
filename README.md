# Gnym Agents

Specialized Codex agents for planning, implementing, testing, and documenting Gnym features.

## Agents

- gnym_planner turns developer intent and repository evidence into an approved feature contract composed of the smallest coherent tasks.
- gnym_coder implements assigned tasks using idiomatic Go and the approved Gnym architecture.
- gnym_tester independently verifies acceptance criteria and adds credible Go test evidence.
- gnym_documenter maintains verified product and architecture documentation under Gnym's docs/ directory.

The primary Codex task remains the orchestrator and the only role that communicates directly with the developer.

## Workflow

See [workflow/orchestration.md](workflow/orchestration.md) for responsibilities, handoffs, revision rules, and completion behavior.

## Repository boundaries

This repository owns agent definitions and workflow documentation. It does not own Gnym product documentation or architecture.

- Gnym product and architecture truth belongs in the Gnym repository.
- Feature-specific intent belongs in the approved planning artifact.
- Agent responsibilities and handoff behavior belong here.

## Installation

Install the definitions into the local Codex agents directory:

    ./scripts/install.sh

Preview the operation without writing:

    ./scripts/install.sh --dry-run

The installer validates every Gnym TOML file. It installs missing definitions, leaves identical copies unchanged, and refuses to overwrite a different installed copy. After reviewing an intentional difference, use:

    ./scripts/install.sh --force

The installer uses standard shell tools and has no third-party dependencies. Codex may require a new task before newly installed roles appear in its available-agent list.
