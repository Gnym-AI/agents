# Gnym agent workflow

The primary Codex task acts as orchestrator. It controls developer communication, assignments, feedback loops, approvals, and final acceptance.

## Standard feature flow

1. The developer describes a feature to the orchestrator.
2. The planner investigates the repository and returns focused clarification questions through the orchestrator.
3. The developer answers through the orchestrator.
4. The planner produces an approval-ready feature artifact with acceptance criteria, verification requirements, and the smallest coherent implementation tasks.
5. The developer approves the feature contract.
6. The orchestrator assigns one task or a small coherent task group to the coder.
7. The coder implements the assignment, performs focused verification, and returns an implementation report.
8. The tester independently maps the implementation to the approved criteria, adds or strengthens test evidence, and returns a verification report.
9. The documenter updates Gnym's docs/ content from the approved intent and verified final behavior.
10. The orchestrator confirms that the implementation, testing, and documentation satisfy the approved feature contract.

## Feedback loops

- An implementation defect found by the tester returns to the coder.
- A missing or ambiguous requirement returns to the planner.
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
