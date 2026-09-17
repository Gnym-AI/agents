# Gnym Agents

Specialized Codex agents for planning, implementing, testing, and documenting Gnym features.

## Agents

- gnym_roadmapper explores feature ideas, relationships, and sequencing, then shapes selected ideas into planner-sized candidates.
- gnym_planner turns developer intent and repository evidence into an approved feature contract composed of the smallest coherent tasks.
- gnym_coder implements assigned tasks using idiomatic Go and the approved Gnym architecture.
- gnym_tester independently verifies acceptance criteria and adds credible Go test evidence.
- gnym_documenter maintains verified product and architecture documentation under Gnym's docs/ directory.

The primary Codex task remains the orchestrator and the only role that communicates directly with the developer.

## Shared skills

`gnym-youtrack` gives every role the same policy for reading and updating Gnym's YouTrack roadmap and delivery issues. It defines the Epic, Story, and Task boundary; role-owned state transitions; mutation safeguards; and evidence-based handoff comments. The configured YouTrack MCP integration supplies access; the skill supplies workflow behavior.

`gnym-commit` reads the actual YouTrack ticket and formats commits as `<TICKET-ID> <TAG>: <Summary>`, with an optional blank line and at most three short bullets. This agents repository has no YouTrack project, so its commits omit the ticket prefix. Tags are `FEATURE`, `BUGFIX`, `REFACTOR`, `PERF`, `DOCS`, `TEST`, `CHORE`, and `REVERT`.

`gnym-branch` defines the delivery hierarchy: Story branches start from `main`, and each Task branch starts from its parent Story. All five roles reference the skill while preserving read-only planning and roadmapping.

`gnym-pr` formats pull requests with Summary, Background, What changed, Testing approach, and Future wisdom. Task PRs target their parent Story branch and are limited to 500 changed textual lines; Story PRs target `main` as unrestricted minor-release integration reviews. The orchestrator prepares each Task PR after scoped independent verification and applicable documentation, then treats it as the checkpoint for dependent work. Descriptions explain the final change and testing evidence concisely. Publication and merging follow existing authorization.

`gnym-undo` coordinates safe rejection, reversal, and replacement work across GitHub, YouTrack, and Git. Unmerged rejected work closes without deletion and moves its Task to `Rejected`; integrated work uses a linked rollback Task and `REVERT` PR. Dependency checkpoints remain blocked until the outcome is resolved.

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

The installer validates and installs both the Gnym agent TOML files and the shared YouTrack, commit, branching, pull request, and undo skills. It installs missing definitions, leaves identical copies unchanged, and refuses to overwrite a different installed copy. After reviewing an intentional difference, use:

    ./scripts/install.sh --force

The installer uses standard shell tools and has no third-party dependencies. Codex may require a new task before newly installed roles appear in its available-agent list.
