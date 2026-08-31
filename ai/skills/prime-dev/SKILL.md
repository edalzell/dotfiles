---
name: prime-dev
description: >-
  Develop transformstudios/prime from a site workspace or the package repo.
  Use when editing Prime, transformstudios/prime, /Users/erin/Development/prime,
  Prime Livewire/Exception Handler, or when the user says "prime", "in Prime",
  or asks for a Prime PR from a Statamic site chat.
---

# Prime dev

Package source: `/Users/erin/Development/prime`  
Remote: `origin` → `transformstudios/prime`  
Sites path-repo it (e.g. `@dev` in composer); **never edit `vendor/transformstudios/prime`**.

Follow `/Users/erin/.dotfiles/ai/instructions.md` (Prime + TransformStudios package sections).

## Workspace gate (do this first)

1. If Cursor's workspace root **is** `/Users/erin/Development/prime` → normal tools; Write/StrReplace fine.
2. If workspace is a **site** (or anything else) → Prime is outside the sandbox.

When outside the Prime workspace, tell the user (or yourself) up front:

> Prime is outside the workspace — use Shell with all for every write

Then:

- Prefer **Shell with `required_permissions: ["all"]`** for every create/edit/commit/test under `/Users/erin/Development/prime` (Write/StrReplace often can't land there).
- **Don't background** Task/subagents that must write Prime until the first `all` permission card is approved — backgrounded agents stall on that prompt.
- Prefer doing the Prime work in this thread with `all`, or ask the user to open the Prime window and continue there.

## Workflow

- Branch from current `main` (`fix/…`, `feature/…`, or `chore/…` — prefix drives PR labels).
- TDD. Never edit `CHANGELOG.md`.
- Authorship: Erin / edalzell only — no agent co-authors or "Generated with" footers.
- When the fix is ready: push the branch and open a **draft** PR (always draft). Use `References #123` (not `Closes`) when the issue lives in a consuming site.

## Map (common touchpoints)

- Exception reporting: `src/Exceptions/Handler.php` (bound as app ExceptionHandler)
- Livewire blocks: `src/Http/Livewire/Entries/One.php`, `Events/One.php`, `Events/Two.php`
- Tests: `tests/Exceptions/`, `tests/Livewire/…` — run with `php vendor/bin/phpunit <path>` from the package root
