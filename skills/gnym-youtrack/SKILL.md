---
name: gnym-youtrack
description: Read and manage Gnym roadmap and delivery work in YouTrack using the configured MCP integration and the project's agent-owned Epic, Story, Task, status, comment, and handoff conventions. Use when a Gnym agent needs to search, create, edit, link, comment on, or advance YouTrack issues. Do not use for non-Gnym projects or as permission to delete, silently rewrite, or broadly reorganize issues.
---

# Gnym YouTrack

Use YouTrack as Gnym's shared workflow and roadmap control plane. Keep versioned product, architecture, code, tests, documentation, and approved feature plans in the Gnym repository.

## Connection

Use the configured YouTrack MCP tools. Do not request, display, persist, or copy authentication tokens. If the MCP tools are unavailable, report that the YouTrack operation cannot be completed in the current task. Do not improvise direct REST calls or browser automation unless the developer explicitly requests a different integration path.

## Before any operation

Identify the Gnym project and resolve the actual project fields, issue types, link types, and state values from YouTrack. Never assume that conceptual workflow labels exactly match configured names.

For read-only search and retrieval, perform the requested operation and return concise results.

Before creating, editing, linking, commenting, changing state, or performing a batch operation, read [references/workflow.md](references/workflow.md) completely and follow its ownership, authorization, mutation-safety, and handoff rules.

## Core invariants

- Roadmapper owns Epics and candidate Stories during discovery.
- Planner owns the approved Story contract and creates executable Tasks after developer approval.
- Coder owns implementation updates for assigned coding Tasks.
- Tester owns independent verification updates.
- Documenter owns documentation updates.
- Orchestrator owns developer communication, conflict resolution, cross-agent progression, and final closure.
- Agents may push work only through their authorized transition; they do not declare downstream work complete.
- Descriptions hold current canonical intent. Comments hold append-only progress, evidence, questions, handoffs, and deviations.
- Search for an existing matching issue before creating another.
- Read current issue state immediately before mutating it.
- Never overwrite newer or unrelated human or agent changes.
- Never delete, archive, bulk-reparent, or broadly reorganize issues without explicit developer authorization.

## Report results

After a write, return the readable issue identifiers, summaries, performed changes, resulting states, and any partial failures or conflicts. Never claim a mutation succeeded without reading a successful MCP result. Provide direct issue links when the integration returns them.
