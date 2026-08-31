---
name: site-review
description: >-
  Build a click-test checklist for a site package/dependency update (CP + front
  end). Use when updating Prime or another TransformStudios package on a site,
  preparing release smoke tests, or when the user asks for a site review /
  update review checklist. Prefer posting the checklist to a GitHub issue when
  one is named.
---

# Site review checklist

Turn a package version bump into a short **control panel / front-end** smoke checklist for humans. Not a code review — click paths only.

## Inputs

From the user message (ask only what's missing):

1. **Package** — e.g. `transformstudios/prime` (default when the site uses Prime and nothing else is named)
2. **Version range** — old → new. Resolve from git branches if given (`main` vs `update`), else `composer.lock` / tags
3. **Target issue** (optional) — e.g. `#2339` or a full GitHub URL. If given, write the checklist into that issue body (replace or append only as the user asked; default: set the issue body to the checklist)

## Workflow

1. **Resolve versions**
   - Compare `composer.lock` (and `composer.json` constraint) on the base branch vs the update branch, or the installed vs target version.
   - Note sibling package bumps that affect FE (e.g. `transformstudios/events`, Livewire) — fold relevant items in, don't expand into a full second review.

2. **Changelog → reviewable items**
   - Read the package `CHANGELOG.md` for entries **after** the old version through the new version (inclusive of the new tag).
   - Keep only changes a human can verify in **CP** or **site front end**.
   - Drop: CI/workflows, Pint/Prettier, test-only, Satis/packagist, internal refactors with no UI.
   - Prefer concrete click steps over changelog paraphrases ("open search modal on AR", not "search improvements").

3. **Site usage filter**
   - Skim the site for what it actually uses (block types in content, multisite, static cache, search driver, globals/alerts, events pages, category taxonomies).
   - Omit checklist rows for features the site doesn't use.

4. **Release status issues** (TransformStudios org project)
   - Project: org **All Projects** (`transformstudios`), Status option **`Release 🚀`**.
   - Needs `gh` scope `read:project`. If missing, ask the user to run:
     `gh auth refresh -h github.com -s read:project,repo,read:org,workflow`
   - Collect open issues for **this site's repo** with Status `Release 🚀`.
   - Fold in items that match the package bump / changelog (events Tailwind, jQuery, search, hreflang, etc.).
   - Skip issues that aren't FE/CP-verifiable for this bump (pure app bugs, ops/log noise). List skipped numbers briefly at the bottom.

5. **Write the checklist**
   - Simple markdown checkboxes, grouped **Front end** then **Control panel**.
   - Lead with one line: package + version range + branches if used.
   - Link Release issues inline on the relevant rows.
   - Concise — one action per checkbox. No prose essays.
   - If a target issue was given, update it with `gh issue edit` (HEREDOC body). Otherwise paste the checklist in chat and ask whether to put it on an issue.

## Output shape

```markdown
Package **vX → vY** (`base` → `update`). Smoke these in CP / front end after deploy.

## Front end

- [ ] …

## Control panel

- [ ] …

## Release 🚀 issues covered above

Relevant: #… #…
Skipped (not FE/CP for this bump): #… (reason).
```

## Notes

- Do not run the click tests yourself unless asked — produce the list.
- Do not invent CP/FE items that aren't grounded in the changelog or a Release issue.
- Canonical skills live under `~/.dotfiles/ai/skills/` (linked into `~/.claude/skills` and `~/.agents/skills`).
