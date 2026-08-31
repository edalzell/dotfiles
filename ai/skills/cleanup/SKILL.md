---
name: cleanup
description: >-
  Review and delete unused local/remote git branches. Keeps the default branch,
  staging (test env), and branches with open PRs; deletes merged/closed/gone
  leftovers after a plan approval. Use when the user says "cleanup", "/cleanup",
  "clean up branches", "prune branches", or asks to remove stale git branches.
---

# Branch cleanup

Inventory local + remote branches, classify keep vs delete against GitHub PR/issue state, present a plan, then delete only after approval.

## Never touch

- Current checkout / default branch (`main`, or repo default)
- `staging` (local + remote) — test env; leave alone even with no open PR
- Any branch with an **open** PR
- Do not force-push. Do not reset env branches.

## Active vs delete

| Keep | Delete |
| --- | --- |
| Default branch | Local tracking `: gone` whose PR is MERGED or CLOSED |
| `staging` | Remote whose only PR is CLOSED/DRAFT-closed, or tip is ancestor of default (0 unique commits) |
| Open PR head | |

"Ahead of main" after a squash merge is noise — trust PR state, not `git merge-base`.

## Workflow

### 1. Inventory

```bash
git fetch --prune origin
git remote set-head origin -a   # if origin/HEAD is stale/missing
git branch -vv
git branch -r
```

Note last-commit date/subject per branch. Use `gh` with full permissions (keyring auth fails in sandbox).

### 2. Map each branch → PR/issue

For every non-keep candidate:

```bash
gh pr list --head "<branch>" --state all --limit 5 \
  --json number,title,state,mergedAt,closedAt,url,updatedAt,isDraft
```

If the name starts with / contains an issue number, also:

```bash
gh issue view <n> --json number,title,state,url,closedAt
```

List open PRs once: `gh pr list --state open --limit 100 --json number,title,headRefName,url,updatedAt,isDraft`.

### 3. Plan (required before any delete)

Present:

- **Keep** — branch + why (default / staging / open PR #N → issue #M status)
- **Delete local** — branch + PR/issue disposition
- **Delete remote** — branch + PR disposition; note unique unmerged commits (recoverable via closed PR)

Out of scope unless asked: closing stale open PRs/issues; reviving abandoned Cursor draft work.

Stop and wait for approval. Do not delete in the inventory turn.

### 4. Execute (after approval)

```bash
git fetch --prune origin
git branch -D <locals...>          # -D required; squash tips look unmerged
git push origin --delete <remotes...>
```

### 5. Verify

```bash
git branch -vv
git branch -r
```

Expect only: default, `staging`, open-PR heads (local and/or remote).

## Edge cases

- **Unique commits on closed Cursor drafts**: still delete remote if PR was deliberately closed; commits remain on the PR.
- **Open issue, dead branch** (0 ahead of default): delete the branch; leave the issue unless asked to close it.
- **Stale open PR** (months quiet): still keep — open means active for this skill.
- **Push remote**: `transformstudios/*` → `origin`. `statamic/cms` worktrees → push deletes only to `fork`, never `upstream`.
- **No `gh` / private repo**: stop; ask rather than guessing from local git alone.

## Output style

Concise. Lead with keep/delete tables or lists. Link PRs/issues. No emoji.
