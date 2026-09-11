# Gnym YouTrack workflow

Read this reference before any YouTrack mutation for Gnym.

## System boundary

YouTrack is the workflow and roadmap control plane. It records hierarchy, current state, assignments, concise scope, links, and agent handoffs.

The Gnym repository remains authoritative for:

- approved feature plans under plans/;
- architecture and accepted decisions;
- production code and configuration;
- tests and verification fixtures;
- product and contributor documentation.

Link YouTrack issues to repository artifacts. Do not duplicate a complete approved plan across both systems or treat a ticket description as a replacement for versioned architecture.

## Conceptual hierarchy

Resolve the project's configured issue types and link names before writing. The labels below describe semantics even if YouTrack uses different configured names.

### Epic

An Epic represents a product outcome or capability area. It contains:

- problem and desired outcome;
- intended users or system actors;
- value or learning sought;
- major constraints and exclusions;
- child Story candidates;
- important dependencies;
- roadmap horizon when the developer wants sequencing.

An Epic does not contain implementation tasks or detailed acceptance criteria.

### Story

A Story represents one planner-sized capability: a coherent outcome that can be specified, implemented, independently verified, and documented without bundling unrelated product decisions.

During discovery, the roadmapper maintains:

- problem and intended outcome;
- primary actor;
- included capability and exclusions;
- value or learning;
- dependencies and related candidates;
- known constraints;
- material unknowns;
- readiness for feature planning.

After selection, the planner owns the Story's feature contract. The canonical approved plan lives in the Gnym repository. The Story records its path or link, revision, concise approved summary, and current delivery state.

### Task

A Task represents the smallest coherent executable assignment. It identifies:

- intended outcome;
- owning specialist;
- parent Story;
- relevant plan revision;
- task and acceptance-criterion identifiers;
- scope and exclusions;
- dependencies;
- required focused verification;
- completion or handoff condition.

Prefer separate Tasks for implementation, independent verification, and documentation when those activities are required. Do not create one Task per test case, documentation paragraph, function, or isolated edit.

## Conceptual states

The developer configures the actual YouTrack state values. Resolve and map them before changing state. Do not create missing fields or values without explicit authorization.

Recommended Story progression:

1. Candidate
2. Ready for Planning
3. Planning
4. Awaiting Approval
5. Approved
6. In Development
7. Verification
8. Documentation
9. Complete

Recommended Task progression:

1. Open
2. In Progress
3. Handoff Ready
4. Verified
5. Done

Blocked may be used from any active state when the configured workflow supports it. A blocked transition requires a comment naming the blocker, owner, consequence, and smallest action needed to resume.

These are semantic stages, not an instruction to manufacture every state. If the configured project combines stages, preserve the same ownership and evidence in comments.

## Ownership and authorized transitions

### Roadmapper

May read the roadmap freely. May create or revise Epics and candidate Stories only when the developer or orchestrator explicitly asks to capture the brainstorm or roadmap in YouTrack.

May advance a selected candidate to Ready for Planning. Must not create implementation Tasks, approve a Story, or assign delivery dates.

### Planner

May begin work on a selected Story, add clarification comments, and advance it through Planning.

After the developer approves the feature contract, may:

- record the approved plan path and revision;
- update the concise Story contract;
- create the smallest coherent implementation, verification, and documentation Tasks;
- link dependencies;
- advance the Story to Approved.

Planner approval is not developer approval. Do not create delivery Tasks from an unapproved plan.

### Coder

May read the full Story, approved plan, and related Tasks. May advance an assigned coding Task to In Progress.

After implementing and running required focused checks, may add an implementation handoff comment and advance its Task to Handoff Ready. Must not mark independent verification complete, close the Story, or silently rewrite scope.

### Tester

May read all related issues and evidence. May advance the verification Task to In Progress.

After independent verification, may:

- add a verification comment;
- mark its verification Task Verified or Done when the configured workflow requires one of those;
- advance the Story to Documentation only when all required implementation work is verified and documentation is required;
- return failed implementation work to the configured actionable state with a reproducible defect comment.

Must not edit production scope or close the Story.

### Documenter

May advance an assigned documentation Task to In Progress. After updating and verifying canonical documentation, may add a documentation handoff comment and mark its Task Handoff Ready or Done according to the configured workflow.

May advance the Story to the final review state when one exists. Must not mark unverified implementation complete or close the Story.

### Orchestrator

Coordinates assignments and agent loops, relays developer decisions, resolves ownership conflicts, and performs final closure after implementation, independent verification, and required documentation are complete.

Only the orchestrator or developer closes the Story unless the developer later authorizes a different rule.

## Authorization model

Read operations require no additional confirmation.

The following writes are authorized by an already approved workflow assignment:

- a specialist advancing its assigned issue through its own states;
- role-specific handoff and evidence comments;
- the planner creating Tasks from a developer-approved plan;
- the planner recording the approved plan link and revision.

The following require explicit developer or orchestrator authorization:

- persisting brainstorm results as new Epics or candidate Stories;
- creating or changing roadmap horizons, priority, ownership, or due dates;
- changing the scope or acceptance contract of an approved Story;
- changing issue types or parent relationships outside an approved plan;
- bulk creation or batch edits beyond the specifically approved feature;
- reopening or closing a Story outside the normal evidence-based workflow.

The following always require explicit developer authorization:

- deleting or archiving issues;
- broad reparenting or roadmap reorganization;
- modifying YouTrack project fields, workflows, state values, permissions, or global settings;
- destructive or difficult-to-reverse operations.

## Mutation safety

Before creating an issue:

1. Search the Gnym project for a matching or substantially overlapping issue.
2. Reuse or update the existing issue when it represents the same outcome.
3. If the overlap is ambiguous, report the candidates and ask rather than creating a duplicate.

Before updating an issue:

1. Read its current description, state, relationships, relevant fields, and recent comments.
2. Confirm it is still the intended target and in a state the acting role may change.
3. Preserve unrelated content and human edits.
4. Update only fields owned by the acting role.

When the integration exposes timestamps or versions, compare them with the version previously read. If the issue changed during the operation, re-read it and merge deliberately. Do not overwrite concurrent changes.

For multi-issue writes:

1. Resolve every intended target first.
2. Present or retain a concise change set.
3. Apply changes in dependency order.
4. Stop on an ambiguous or unsafe failure.
5. Report successful issue identifiers and remaining operations.
6. Retry only operations proven not to have succeeded.

Creation retries must search for the intended summary, parent, and identifying content before retrying. Do not duplicate an issue because an earlier response was uncertain.

## Description and comment policy

Descriptions contain the current canonical purpose and scope for the issue's hierarchy level. Update them deliberately when that canonical content changes.

Comments are append-only records of:

- clarification questions and developer answers;
- planning approval and revision notices;
- implementation, verification, and documentation handoffs;
- blockers and required actions;
- deviations and conflicts;
- links to repository evidence.

Do not use comments to create a second, conflicting feature contract.

Use this compact handoff comment shape:

    Agent: <role>
    Plan: <path or link>#<revision>
    Scope: <task and acceptance identifiers>
    Outcome: <completed or observed result>
    Evidence: <commands, tests, files, or links>
    Status: <resulting workflow state>
    Deviations: <none or concise list>
    Blockers: <none or owner and required action>
    Next: <next role and expected action>

Omit fields that genuinely do not apply, but always identify role, outcome, resulting state, blockers, and next action.

## Planner-created tasks

After plan approval, create only Tasks needed for the approved feature:

- one or more smallest coherent implementation Tasks;
- one independent verification Task;
- one documentation Task when documentation impact is not explicitly none.

Each Task must link to its Story and identify the relevant plan revision. Use the plan's stable T, AC, and VR identifiers rather than duplicating the entire plan.

Do not assign a coding Task that depends on an unresolved product decision. Do not create speculative Tasks for deferred work.

## Failure behavior

If the MCP connection or required YouTrack capability is unavailable, do not claim the issue was changed. Return the intended operation and blocker.

If a field, issue type, link, or state is missing, do not create project configuration. Report the conceptual value needed and wait for the developer to configure or map it.

If a transition fails after a comment succeeds, report the partial result explicitly. Do not duplicate the comment on retry.

If issue content conflicts with the approved repository plan, stop progression and notify the orchestrator. Repository product truth and the approved plan must be reconciled before downstream work continues.

## Result reporting

After a write, report:

- issue readable ID and summary;
- created or changed fields and relationships;
- previous and resulting state;
- comment or handoff added;
- operations not completed;
- conflicts, partial failures, or required developer action;
- direct issue link when available.
