---
name: gnym-commit
description: Prepare or create Gnym Git commits using a verified YouTrack ticket ID for tracked repositories, a consistent change tag, and a concise changelog summary. Use when drafting a commit message or committing Gnym work; does not authorize pushing or creating pull requests.
---

# Gnym Commit

## Repository scope

The Gnym product repository requires a verified YouTrack ticket. The `gnym-agents` repository has no associated YouTrack project: skip ticket lookup there and use `<TAG>: <Summary>`. Keep the same summary and body rules. Do not treat a missing ticket or unavailable integration in a tracked repository as this exception.

## Resolve the change and ticket

- Inspect repository instructions, Git status, and the relevant diff. Base the message on the changes actually being committed; when drafting, use the requested diff scope.
- For a tracked repository, read the actual YouTrack ticket through the configured MCP integration, following the shared `gnym-youtrack` skill. Use its exact readable ID. Never hard-code a project prefix or infer a valid ticket solely from a branch name, example, or previous commit.
- Use the user's ticket or current task context to find the issue. Confirm that the ticket describes the work. If the intended ticket is missing or ambiguous, ask for it. If YouTrack cannot be read, report the blocker; do not invent an ID or create a commit with an unverified ticket.
- Use the most specific ticket representing the committed work. If unrelated changes need different tickets or summaries, propose separate commits instead of hiding them under a broad message.

## Message format

```text
<TICKET-ID> <TAG>: <Summary>

- Optional concise detail
- Another detail only if useful
```

- Exactly one ticket ID and one uppercase tag in the first line for tracked repositories. In `gnym-agents`, omit the ticket ID and its following space.
- Write one concise changelog summary beginning with a capitalized verb such as `Adds`, `Fixes`, `Updates`, or `Removes`. Describe the concrete change and omit a trailing period. Aim for a subject of 72 characters or fewer, without sacrificing clarity or truncating the ticket ID.
- Omit the body when the summary is enough. Otherwise, insert exactly one blank line, followed by at most three short `- ` bullets, each a single concise sentence or phrase.
- Include only useful context: a non-obvious reason, meaningful limitation, compatibility change, migration requirement, or relevant verification detail. Do not repeat the summary, narrate files, or write an essay. Do not claim tests or outcomes without evidence.
- Put a breaking change or required migration first in the optional bullets and identify it clearly.

## Tags

| Tag | Use |
| --- | --- |
| FEATURE | Adds or extends functionality |
| BUGFIX | Corrects incorrect behavior |
| REFACTOR | Restructures code without changing behavior |
| PERF | Improves performance |
| DOCS | Changes documentation |
| TEST | Adds or improves tests |
| CHORE | Maintenance, dependencies, tooling, or CI |
| REVERT | Reverses an earlier change |

Choose the tag by the commit's primary purpose. Tests and documentation accompanying a feature belong under `FEATURE`; use `TEST` or `DOCS` when that is the primary change.

Example only; resolve the real ticket before use:

```text
GNYM-33 BUGFIX: Fixes incorrect review line numbers

- Accounts for deleted lines when mapping diff positions
```

## Commit and report

- A request for a message produces a message only. A request to commit authorizes creating the local commit; do not request that authorization again.
- Stage only the intended changes. Preserve unrelated work and existing staging; if unrelated staged changes would enter the commit, resolve the scope before committing.
- Follow repository verification requirements and inspect the final staged diff before committing. Use a message file to preserve the subject, blank line, and bullets exactly.
- Do not amend commits, push, create a pull request, or change YouTrack state unless separately authorized. Merely referencing a ticket does not authorize closing it.
- After committing, verify the resulting commit and report its short hash and subject. State any remaining uncommitted changes concisely. Do not claim remote linkage was verified solely because the local message contains the ticket ID.
