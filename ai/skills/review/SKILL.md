---
name: review
description: >-
  Choose which review to run. Use when the user says "review", "/review", or
  asks to review something without specifying site vs code. Prompts for site
  review (update smoke checklist) or code review (PR), then follows that skill.
---

# Review (chooser)

Stop and ask which review to run. Do **not** start reviewing until they pick.

## Prompt

Ask exactly once, short:

> Which review?
> 1. **Site** — CP/front-end smoke checklist for a package update (`site-review`)
> 2. **Code** — GitHub PR review (`code-review`)

If the message already names one (e.g. "site review", "review the PR", a PR number, "Prime update checklist"), skip the prompt and run that skill.

## Next

After they choose (or intent is clear):

1. **Site** → read and follow `~/.dotfiles/ai/skills/site-review/SKILL.md` (also `~/.agents/skills/site-review` / `~/.claude/skills/site-review`).
2. **Code** → read and follow `~/.dotfiles/ai/skills/code-review/SKILL.md` (also `~/.agents/skills/code-review` / `~/.claude/skills/code-review`).

Pass through any PR number, issue URL, package name, or branch names from the original message.
