---
name: gnym-undo
description: Safely reject, reverse, or restart Gnym Task work across GitHub, YouTrack, and Git while preserving history and dependency checkpoints. Use when the developer wants to abandon an open Task PR, reject completed work, undo integrated work, or start a replacement approach; do not use for ordinary changes-requested review loops.
---

# Gnym Undo

Coordinate recovery through the existing `gnym-youtrack`, `gnym-pr`, `gnym-branch`, and `gnym-commit` contracts. Undo means a recorded compensating action, never silent deletion or shared-history rewriting.

## Establish the exact state

Before any mutation, identify and read:

- the Task, parent Story, approved plan revision, and Story delivery map;
- the PR URL, state, head, base, reviews, and final candidate SHA;
- whether the candidate is present in the Story branch or `main`;
- local and remote branches, worktrees, and uncommitted changes;
- dependent Tasks and their branch or PR state;
- the configured YouTrack state that exactly maps to `Rejected`.

Stop on an ambiguous Task/PR pairing, unknown integration state, concurrent edit, missing `Rejected` state, or unclear dependency effect. Do not infer success from a closed PR, pushed branch, comment, or attempted state transition; verify resulting state after every write.

## Choose one recovery mode

### Reject unmerged work

Use this mode only when the exact Task PR is confirmed unmerged and the developer has explicitly rejected it.

1. Resolve the complete intended change set before writing: PR comment and closure, Task disposition, Story-map update, blocked dependents, and next owner.
2. Add a concise PR comment stating that the candidate was rejected and why, then close the PR without merging.
3. Add an append-only Task disposition comment with the reason, PR, final SHA, accepted portions if any, Story consequence, blocked dependents, and next action.
4. Move the Task to the configured `Rejected` state. Refresh its Current status from the confirmed result.
5. Update the Story delivery map to show the rejected outcome and dependency consequence.
6. Preserve the branch, commits, worktree contents, ticket, and PR. Do not delete, force-push, reset, archive, or relabel the work as Done.

If a write partially succeeds, stop, report the exact confirmed result, and retry only the missing operation after rereading current state. Do not duplicate comments.

### Reverse integrated work

Use this mode when any rejected change is already present in the Story branch or `main`.

- Keep the original accepted Task and merge record intact.
- Return the dependency and contract impact to the planner.
- Create a linked rollback Task only from an approved plan or revision.
- Use `gnym-branch` from the current intended integration target and `gnym-commit` with the `REVERT` tag.
- Deliver the reversal through its own verification and Task PR checkpoint.
- Never reset or force-push shared history, and never move the original accepted Task to Rejected merely because it was later reversed.

### Start a replacement approach

A fresh approach never reuses the rejected Task or branch.

1. Complete and verify the rejection or reversal checkpoint.
2. Return material scope, behavior, acceptance, or dependency changes to the planner for a recorded revision and required approval.
3. Create a new linked Task with its own review-line budget and checkpoint.
4. Create its branch from the verified current Story branch only after all prerequisites are accepted and integrated.
5. Link the replacement and rejected Tasks in both human-readable records.

## Dependency checkpoint

Only genuinely dependent work halts. Independent Tasks may continue. Dependent work remains blocked while the prerequisite PR is pending or changes-requested. Rejection keeps it blocked until the planner resolves the dependency path and any required revision is approved. Do not bypass the checkpoint through a sibling branch or cherry-pick.

## Authorization boundary

Reading and preparing the recovery plan are non-mutating. Closing a PR, changing a Task to `Rejected`, creating a rollback or replacement Task, pushing a reversal, or publishing a new PR requires authorization that clearly covers that exact operation. An explicit request to reject or undo identified work may supply that authorization; a general discussion of undo behavior does not.

This skill does not automate GitHub review-comment triggers. Treat `Changes requested` as a normal revision loop only when the review outcome is explicitly established through the current workflow.

## Report

Return the recovery mode, exact Task and Story, PR and `head → base`, integration finding, dependent-work disposition, every attempted mutation, resulting YouTrack and GitHub states, preserved artifacts, and the next responsible role. Separate completed recovery from a merely prepared plan.
