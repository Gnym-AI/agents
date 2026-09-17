---
name: gnym-pr
description: Draft, create, or update Gnym pull requests with verified parent-branch targeting, consistent ticket-and-tag titles, and five concise Markdown sections. Use for PR descriptions and publication; does not authorize merging or ticket closure.
---

# Gnym Pull Request

## Resolve scope and target

Read repository instructions, the approved work and handoff evidence, branch context, and the full PR diff and commits against the intended base. Describe the final combined change, not just the last commit or conversation history. Uncommitted changes are not part of a published PR.

Use `gnym-branch` to verify the originating parent branch. The user's term "source branch" means the branch the work branched from; GitHub calls this the PR **base**, while the working branch is the **head**.

- A Task branch targets its parent Story branch.
- A Story branch targets `main`.
- Never default a Task PR to `main`, or target a sibling Task branch.
- Git does not permanently record the branch of origin. Use verified issue relationships, branch handoffs, and repository refs together; the upstream tracking ref or merge-base alone does not establish the parent branch's identity.
- Read actual YouTrack issues through `gnym-youtrack` to verify IDs, types, and the Task-to-Story relationship. Reuse the recorded branch name even if a ticket title changed.
- `gnym-agents` has no YouTrack project. Omit the ticket prefix there and verify the originating base from branch context or explicit user instructions. Do not invent a ticket or assume a missing parent.
- If the parent is missing, ambiguous, or deleted, resolve it with the orchestrator or user before publication. Do not silently retarget to `main` or recreate a deleted parent.

Compare the head against the verified base using the PR's merge-base diff. Inspect unexpected unrelated changes before publishing.

For a Task PR, calculate its review-line count from that merge-base diff by summing every numeric addition and deletion reported by `git diff --numstat`. Count all textual files, including tests, documentation, generated files, and lockfiles. Report binary entries separately because they do not have a meaningful line count. A Task PR must contain no more than 500 review lines. If it exceeds the limit, do not publish it or describe it as PR-ready; return it to the planner for a coherent split. Do not hide files from the count or mechanically split an inseparable outcome merely to pass the gate.

Story PRs are minor-release integration reviews and have no line-count limit. Their bodies must link the accepted Task PRs that comprise the release and identify any direct Story-branch changes. Direct Story-branch product changes bypass the Task review boundary and must be resolved before Story PR readiness.

## PR timing and readiness

Each Task with a committed diff is the primary PR review boundary. The orchestrator prepares its title, body, head, base, and reviewed diff as soon as the Task's implementation, independent verification, and applicable documentation are complete. Do not wait for the whole Story or combine separate Tasks merely to reduce PR count. Evidence-only Tasks without a diff return a handoff; do not create empty PRs.

Readiness is scoped to the approved Task. A tester can independently inspect and check the implementation candidate at its exact SHA before integration. Tests or documentation explicitly assigned to dependent Tasks remain tracked prerequisites for Story acceptance; name them in the Task PR and do not claim they are complete. Do not wait for a downstream Task that can only branch after this Task is merged. Required checks for the current Task must pass; failed or blocked verification is not ready for review. Same-Task testing and documentation edits stay on that Task branch, with affected verification refreshed after changes.

After all Task PRs are merged into the Story, the orchestrator verifies the combined Story against its acceptance criteria and required integration checks, confirms documentation is complete, and prepares the Story PR to `main`. Task PRs carry detailed implementation review; the Story PR links those reviews and focuses on combined behavior, acceptance evidence, compatibility, and remaining risks. Local Task completion, PR readiness, merge into the Story, and integration into `main` are distinct states.

Prepare PR material as part of delivery without waiting for a separate drafting request. Publish or update the remote PR when existing authorization covers that operation; otherwise return the prepared material for approval. Reuse existing authorization and PRs. PR readiness does not grant merge authorization.

## Task PR checkpoint

A published Task PR is a delivery checkpoint. Work that depends on its changes must wait until the checkpoint is accepted, the PR is merged into the parent Story branch, and that integration is verified. Independent Tasks may continue.

- Accepted and merged: refresh the Story branch, verify the prerequisite there, and then release dependent work.
- Changes requested: return the same Task to active work and keep dependent work blocked while the PR is revised and reverified.
- Rejected: close the PR unmerged, move the Task to the configured `Rejected` state through `gnym-youtrack`, update the Story delivery map, and keep dependent work blocked until the planner supplies any required revision and approval.

PR publication is not Task acceptance or completion. Do not mark the Task Done until the accepted PR is merged into the Story branch and the resulting integration is verified. Automated transitions from GitHub review comments are deferred; do not infer a workflow transition from arbitrary comment text.

## Title

Follow `gnym-commit` for the exact ticket ID, tag definitions, and concise changelog-style summary:

```text
<TICKET-ID> <TAG>: <Summary>
```

Use the Task's ID for a Task PR and the Story's ID for a Story PR. Choose one tag for the primary purpose of the entire PR. In `gnym-agents`, use `<TAG>: <Summary>`. Capitalize the summary's opening verb, such as Adds or Fixes, and omit its trailing period.

## Body format

Always use these five level-two Markdown headings, in this order and with this capitalization. Leave blank lines around headings and before lists. Replace all instructional text with evidence-based content:

```markdown
## Summary

A short abstract describing the outcome and scope of this change.

## Background

The project context needed to understand the problem, why it matters,
and what this change resolves.

## What changed

- Concrete change and its purpose.
- Significant decision and the reason for choosing it.
- Compatibility impact or limitation, when relevant.

## Testing approach

- Strategy: what behavior or boundary the tests cover.
- Coverage added: the scenarios introduced or strengthened.
- Results: what was run, what passed, and any remaining gaps.

## Future wisdom

A brief, original thought or accurately attributed quotation.
```

## Writing rules

- Professional, direct, and easy to understand. Explain project-specific concepts only as needed. Avoid hype, jargon, long prose, file-by-file narration, and repeated explanations across sections.
- Summary: two or three sentences about the outcome and scope. Include a verified ticket link naturally here or in Background for tracked work.
- Background: one short paragraph or a few bullets explaining the prior behavior, relevant project context, and why the problem matters. Do not repeat implementation details here.
- What changed: concise bullets grouped by behavior or responsibility. Put each significant decision and its reason next to the change it explains. Include material compatibility, migration, or limitation details. Do not invent rationale or include abandoned approaches unless they explain a real tradeoff.
- Testing approach: connect testing strategies to behaviors, risks, and boundaries. Distinguish new or strengthened coverage, existing checks run, actual results, and gaps. Name useful commands or tests without dumping logs. If no tests were added, say so and explain the applicable validation; never imply execution from the existence of a test. Follow repository verification requirements, including container-only Go tooling for Gnym.
- Future wisdom: one brief, professional, encouraging sentence. Prefer an original reflection relevant to the work; never fabricate attribution. Use a quotation only when its wording and attribution are verified.
- Keep all five headings, even for small changes; make the content proportionate. Ten minutes is a ceiling, not a target. Use links to supporting detail rather than expanding into an essay. No extra top-level sections are needed; fit required repository-template information under the appropriate heading when possible and surface irreconcilable requirements.

## Prepare, publish, and verify

A request to draft produces a title and body only. A request to create or update a PR authorizes that PR operation; do not request approval again for the same action. Prepare and inspect the complete title, body, head, base, and diff before publishing. Preserve existing user instructions about pushes; when publication is authorized, publish the intended branch only as needed, without force-pushing or including unrelated commits. Read-only planning roles hand their material to the orchestrator instead of mutating Git or GitHub.

Use the configured GitHub integration or available CLI. Check for an existing PR for the same repository and head branch before creating a duplicate. Read its current title, body, base, and state before updating; preserve relevant human edits and refresh stale claims around the final scope. Resolve conflicting base information before retargeting an existing PR.

Always provide explicit head and base branches. With `gh`, pass the body through `--body-file` to preserve Markdown and avoid shell interpolation. For a Task PR, report and recheck the review-line count against the published head and base. Verify the returned PR's URL, title, body, head, base, state, and line-count gate after creation or update. Report the URL and `head → base`, plus any incomplete step. Do not report success from a draft file alone.

Creating a PR does not authorize merging it, enabling auto-merge, deleting branches, requesting reviewers, or closing/changing YouTrack issues. Integration and final acceptance remain with the orchestrator/developer under their existing authorization.
