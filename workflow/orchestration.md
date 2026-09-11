# Gnym agent workflow

The primary Codex task acts as orchestrator. It controls developer communication, assignments, feedback loops, approvals, and final acceptance.

## Standard feature flow

1. The developer explores a problem or feature direction with the orchestrator.
2. The roadmapper helps compare possibilities and shapes a selected idea into a planner-sized feature candidate.
3. The planner investigates the repository and returns focused clarification questions through the orchestrator.
4. The developer answers through the orchestrator.
5. The planner produces an approval-ready feature artifact with acceptance criteria, verification requirements, and the smallest coherent implementation tasks.
6. The developer approves the feature contract.
7. The orchestrator assigns one task or a small coherent task group to the coder.
8. The coder implements the assignment, performs focused verification, and returns an implementation report.
9. The tester independently maps the implementation to the approved criteria, adds or strengthens test evidence, and returns a verification report.
10. The documenter updates Gnym's docs/ content from the approved intent and verified final behavior.
11. The orchestrator confirms that the implementation, testing, and documentation satisfy the approved feature contract.

The roadmapper is optional when the developer already presents one bounded feature.

## YouTrack progression

All roles use the shared `gnym-youtrack` skill for issue operations. The configured project may use different state names; the skill defines the semantic mapping and safe mutation rules.

- The roadmapper owns Epics and candidate Stories, then hands selected work to planning.
- The planner advances the Story through planning and approval, then creates delivery Tasks only from a developer-approved, versioned feature plan.
- The coder advances its implementation Task from active work to an evidence-backed handoff.
- The tester independently records verification and advances verified work toward documentation.
- The documenter records canonical documentation changes and advances work to final review.
- The orchestrator resolves loops and performs final Story closure.

Each agent pushes status only across its own boundary. No specialist declares the next specialist's work complete.

## Feedback loops

- An implementation defect found by the tester returns to the coder.
- A missing or ambiguous requirement returns to the planner.
- A feature that is still too broad or uncertain returns to the roadmapper.
- A new product decision returns to the developer through the orchestrator.
- A documentation conflict with implemented or verified behavior returns to the orchestrator.
- A material change to approved behavior requires a recorded planning revision and renewed developer approval.

Specialist agents do not privately redefine the feature contract.

## Handoff contract

Each handoff identifies:

- assigned task and acceptance-criterion identifiers;
- completed outcomes;
- files owned or changed;
- evidence collected;
- deviations from the approved plan;
- assumptions, risks, and blockers;
- consequences for the next specialist.

## Toolchain boundary

Gnym's Go toolchain runs only in the project's containers. Agents must inspect the Gnym repository's current Compose configuration and must not fall back to a host Go installation.

The documentation website and Node toolchain are intentionally outside the current workflow. They will be added when the site implementation is approved.
