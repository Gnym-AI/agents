# Gnym agent workflow

The primary Codex task acts as orchestrator. It controls developer communication, assignments, feedback loops, approvals, and final acceptance.

## Standard feature flow

1. The developer explores a problem or feature direction with the orchestrator.
2. The roadmapper helps compare possibilities and shapes a selected idea into a planner-sized feature candidate.
3. The planner investigates the repository and returns focused clarification questions through the orchestrator.
4. The developer answers through the orchestrator.
5. The planner produces an approval-ready feature artifact with acceptance criteria, verification requirements, and the smallest coherent implementation tasks.
6. The developer approves the feature contract.
7. The orchestrator uses `gnym-branch` to create or resume the approved Story branch from `main`, persist the approved plan, and arrange delivery Tasks through the planner. It assigns Tasks with their parent branch and prerequisite context; each Task gets a separate branch from the Story.
8. The coder implements the assignment, performs focused verification, and returns an implementation report.
9. The tester independently maps the implementation to the approved criteria, adds or strengthens test evidence, and returns a verification report.
10. The documenter updates Gnym's docs/ content from the approved intent and verified final behavior.
11. For each Task, the orchestrator confirms scoped verification and documentation readiness and prepares its PR to the parent Story using `gnym-pr`. Repeat delivery and PR review per Task; do not wait for all Story work to finish. Publish and merge under existing authorization, verifying integration before starting dependent Task branches.
12. After all Task PRs are merged, the orchestrator verifies the combined Story, confirms implementation, testing, and documentation satisfy the approved contract, and prepares the Story PR to `main`. Report Story readiness separately from actual integration into `main`.

The roadmapper is optional when the developer already presents one bounded feature.

## Branch ownership

All roles follow `gnym-branch`. The orchestrator owns Story branch preparation and integration sequencing. Roadmapper and planner remain read-only in Git. Delivery agents use a separate branch for each ticketed Task, preserve checkout ownership, and hand off exact branch and commit context. Task review bases are their Story branch; the Story review base is `main`. No PR creation or merge is implied by branch preparation.

Independent testing may inspect an implementation candidate before integration. Edits for a separate verification Task start from the Story after prerequisites are integrated; the orchestrator coordinates that dependency and verifies the final integrated Story.

## Pull request timing and descriptions

Follow the PR timing and readiness rules in `gnym-pr`: the orchestrator prepares a PR at each Task completion boundary after scoped gates pass, then a Story integration PR after all Task PRs merge and combined acceptance passes. Evidence-only Tasks return handoffs without empty PRs. Dependent verification or documentation Tasks remain explicit Story acceptance requirements; they must not cause a circular wait for the prerequisite Task merge. Prepare the review material automatically and publish when authorized. Task PRs target their parent Story branch; Story PRs target `main`. Use the verified ticket and change tag in the title, with the ticket-free exception for `gnym-agents`. Every body uses Summary, Background, What changed, Testing approach, and Future wisdom. Agents contribute evidence from their owned work; the orchestrator coordinates publication and integration. Creating a PR does not authorize merging it.

## YouTrack progression

All roles use the shared `gnym-youtrack` skill for issue operations. The configured project may use different state names; the skill defines the semantic mapping and safe mutation rules.

- The roadmapper owns Epics and candidate Stories, then hands selected work to planning.
- The planner advances the Story through planning and approval, then creates delivery Tasks only from a developer-approved, versioned feature plan.
- The coder advances its implementation Task from active work to an evidence-backed handoff.
- The tester independently records verification and advances verified work toward documentation.
- The documenter records canonical documentation changes and advances work to final review.
- The orchestrator resolves loops, keeps the Story delivery map and affected Task status summaries current, and performs final Story closure. Each completed Task receives its own closing summary with verification and integration evidence and any remaining Story work.

Each agent pushes status only across its own boundary. No specialist declares the next specialist's work complete.

## Feedback loops

- An implementation defect found by the tester returns to the coder.
- A missing or ambiguous requirement returns to the planner.
- A feature that is still too broad or uncertain returns to the roadmapper.
- A new product decision returns to the developer through the orchestrator.
- A documentation conflict with implemented or verified behavior returns to the orchestrator.
- A material change to approved behavior requires a recorded planning revision and renewed developer approval.

Specialist agents do not privately redefine the feature contract.

## Human-readable YouTrack records

Follow the description, progress, and closure rules in `gnym-youtrack/references/workflow.md`. The planner gives each Task enough context to understand its purpose, acceptance conditions, dependencies, and contribution to its linked Story without reading the plan. The Story carries a compact delivery map of its linked Tasks. Specialists maintain their own current-status summaries; the orchestrator reconciles cross-Task progress and verified integration. Before final Story acceptance, check each child for a closing summary consistent with its actual state. Explain remaining Story work even when a Task is Done, and report Story-branch integration separately from main integration.

Keep the detailed specialist handoff below available for execution, but translate it into concise outcome-first prose for YouTrack.

## Handoff contract

Each handoff identifies:

- assigned task and acceptance-criterion identifiers;
- Story/Task branch names, intended base and base SHA, current HEAD, worktree path and owner, prerequisite status, and uncommitted changes;
- completed outcomes;
- files owned or changed;
- evidence collected, tested SHA, scoped PR readiness, documentation disposition, and pending dependent Tasks;
- deviations from the approved plan;
- assumptions, risks, and blockers;
- consequences for the next specialist.

## Toolchain boundary

Gnym's Go toolchain runs only in the project's containers. Agents must inspect the Gnym repository's current Compose configuration and must not fall back to a host Go installation.

The documentation website and Node toolchain are intentionally outside the current workflow. They will be added when the site implementation is approved.
