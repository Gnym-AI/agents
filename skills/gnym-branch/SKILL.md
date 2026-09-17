---
name: gnym-branch
description: Create or resume Gnym story and task branches from verified YouTrack issues, using main as the story base and the parent story branch as the task base. Use before story delivery, task edits, or branch handoffs; does not create pull requests or authorize merges or pushes.
---

# Gnym Branch

## Branch contract

One coherent feature belongs to one Story. Each delivery Task gets its own branch:

```text
main
└── story/GNY-33-add-claude-reviewer
    ├── task/GNY-34-add-provider
    ├── task/GNY-35-add-tests
    └── task/GNY-36-document-configuration
```

Examples are illustrative. Read the actual issues through `gnym-youtrack`, verify their configured types and parent relationship, and use their exact readable IDs. Never substitute a planner-local identifier such as T-1 for a YouTrack Task ID. This hierarchy applies to Gnym product delivery; `gnym-agents` has no associated YouTrack project, so do not fabricate story or task branches there.

- Story: `story/<STORY-ID>-<short-title>` based on `main`.
- Task: `task/<TASK-ID>-<short-title>` based on its parent Story branch, never directly on `main` or a sibling Task branch.
- Preserve the ticket ID's case. Use a short lowercase title slug with words separated by hyphens; remove punctuation and validate the entire name with `git check-ref-format --branch`.
- Reuse an existing branch for the same ticket, even if the ticket title has changed. Check local branches, the selected remote's branches, and handoff records by exact ticket ID before creating one. Resolve conflicting matches through the orchestrator; do not rename or duplicate silently.
- Task changes are reviewed against the Story branch; the completed Story is reviewed against `main`. This skill records these intended bases but does not create PRs.

## Ownership and timing

The orchestrator creates or confirms the Story branch after the feature contract is approved and before delivery Tasks start. It may persist the approved planning artifact there, preserving the planner's requirement that the artifact be versioned before Tasks are created. Product implementation, tests, and documentation go on Task branches.

Roadmapper and planner remain read-only in Git. They read this convention, identify issue and dependency context, and return branch requirements to the orchestrator; they do not create branches, switch checkouts, or create worktrees.

Coder, tester, and documenter create or resume their assigned Task branch before editing. Switching roles while continuing the same Task reuses that branch. A separately ticketed verification or documentation Task gets its own branch. Task groups remain separate branches per ticket, even when one agent executes several Tasks.

## Safe preparation

1. Inspect repository instructions, status, current branch, remotes, local and remote refs, and `git worktree list`. Confirm the repository, approved Story, assigned Task, and dependencies from current evidence. Choose the repository's established remote; resolve ambiguity before fetching or creating refs.
2. Fetch the selected remote when available. For a new Story, use the verified current `main` tip; preserve local commits and resolve a diverged or ambiguous local/remote main instead of resetting it. If a needed remote or base cannot be verified, report the blocker rather than silently using a stale ref.
3. For a new Task, resolve the parent Story branch and every prerequisite Task PR checkpoint. Required prerequisites must be accepted, merged into the Story branch, and verified there before dependent work starts. A pending PR, changes-requested PR, or rejected prerequisite keeps dependent work blocked; rejection returns the dependency path to planning before replacement work begins. Independent Tasks may proceed. Do not branch from a sibling Task or cherry-pick its changes to bypass the checkpoint or hierarchy. Verify local/remote Story divergence before selecting the base.
4. Create the branch from the explicit verified base ref. Use an isolated worktree when another agent is active or the current checkout contains unrelated work. Do not switch a shared checkout underneath another agent, carry dirty changes onto a different Task, stash/reset others' changes, or force-checkout a branch already used in another worktree. Reuse an existing worktree only after confirming ownership is available.
5. When resuming, inspect the existing branch and its recorded base/dependency history rather than recreating it. If new prerequisites must be incorporated, report the needed update to the orchestrator; branch creation alone does not authorize a merge or rebase.
6. Verify the resulting branch, worktree path, HEAD, and base commit. Before edits, confirm the Task-to-Story diff contains only that Task's intended scope. If unexpected changes appear, resolve the ownership or base issue before proceeding.

An assignment to implement an approved Task authorizes ordinary local branch/worktree preparation within that assignment. Do not request permission again merely to create its branch. Respect read-only agent boundaries and preserve existing work. Do not commit, push, merge, rebase, delete branches, or change YouTrack state solely because this skill was invoked; use the applicable workflow and existing authorization for those actions.

## Verification before integration

A tester may inspect and run checks against an implementation Task's exact candidate commit in an isolated checkout without creating or editing a separate verification branch. Record the tested SHA. If the tester needs to author tests under a separate verification Task, those edits belong on its own branch from the Story once prerequisites are integrated there. Report this dependency to the orchestrator; do not silently merge implementation work or edit it under another Task ID. The orchestrator decides integration sequencing, and final Story verification covers the integrated result.

## Handoff

Return the Story and Task IDs, exact branch name, intended base branch and base SHA, current HEAD, worktree path and owner, prerequisite Task PR checkpoint status, and any uncommitted changes. State whether the branch was created or reused and whether work is ready or blocked. Subsequent agents use this context and verify it before editing. Branch creation does not imply a remote branch, PR, integration, or completed ticket.
