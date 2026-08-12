# Global instructions

## General
- Delete files or directories using `rm` without any options. It is aliased to `trash`.
- Don't always assume I know what I'm talking about. If I ask you to do something, and it goes against best practices, warn me about it.
- Don't always automatically make code changes. If the prompt seems to be more of a question than a request to implement, just answer the question. You can ask if you should implement it.
- When reporting information to me, be extremely concise and sacrifice grammar for sake of concision.
- if there are tools or apps that would help with a task, ask me to install instead of skipping and taking a less useful path
- Only run tests, typechecks, verifications, etc. when working on big chunks of work, not small tasks like updating display values.

## Tone
- Be concise. Short, direct responses over long explanations.

## Models
- Match the model to the job, cheapest that will do it. Ladder: haiku → sonnet → opus.
- For subagents, set the `model` param deliberately rather than inheriting by default. Mechanical work (renames, greps, file sweeps, running a known command) goes to haiku; normal implementation to sonnet; genuinely hard design, debugging, or multi-file reasoning to opus.
- Escalate in steps, not straight to the top, and **tell me whenever you escalate** — say what you moved up to and why. Downgrading needs no announcement.
- You can't change the model for the main conversation yourself. If the work in front of us clearly warrants a different one, say so and let me switch with `/model` — don't just push on at the wrong level.

## Code
- Don't write code for future phases or features. Build what the current step needs and nothing more — plans change, and speculative helpers become dead code that still has to be read, tested and maintained.
- Make sure newly created files have a trailing newline.
- Avoid adding docblocks unless specifically asked.
- Don't add comments unless the code itself isn't clear without them.
- single line methods are useful if the make a fluent chain more readable
- Variables and properties are camelCase. Two exceptions:
  - Eloquent model properties/attributes are snake_case, matching their DB columns.
  - Where a framework or library genuinely can't work with camelCase, use whatever it requires. "Surrounding code already uses snake_case" is not a reason — only an actual technical constraint is.
  - Applies to new code only. Don't rename existing code to match unless it's already in scope for the change at hand.
- Don’t add unit tests for local presentational changes, like renaming a label in a specific form, or reordering table columns.

## Laravel
- No `down()` methods in migrations. Forward-only — rollbacks aren't used, and a `down()` nobody runs is untested code that lies about being reversible. `migrate:fresh` and `RefreshDatabase` both wipe rather than roll back, so nothing depends on them.
- Dates are immutable. Set `Date::use(CarbonImmutable::class)` once at the app's root so `now()` and every `datetime` model cast return `CarbonImmutable` — no need for the separate `immutable_datetime` cast. Type-hint and document `CarbonImmutable`, not `Carbon`.
- Prefer Laravel's collection methods over `foreach`. Use `foreach` only when it's genuinely clearer or meaningfully faster — a trivial two-or-three-line loop is fine, but anything that shapes data should be a pipeline.
- An `if` inside a `foreach` is a code smell: it usually means `filter()`, `reject()`, or `first()`. A loop that only accumulates into an array is `map()`, `flatMap()`, or `groupBy()`. A loop that guards and throws is `throw_if`/`throw_unless` inside `each()`.
- DTOs (`spatie/laravel-data` classes) don't get a `Data` suffix — living in a `Data` folder/namespace already says what they are. `Member`, not `MemberData`. If the bare name collides with an existing class (e.g. an Eloquent model of the same name) needed in the same file, that's a signal to name the DTO for what it specifically represents rather than append the suffix as an escape hatch — e.g. `CurrentUser`, not `UserData`, when `Shared\Models\User` is already imported there.
- After adding or updating Composer packages in an app that has Laravel Boost, run `php artisan boost:update --discover` **interactively** (no `-n`) from that app before treating the step as done. Non-interactive update/install skips discovery prompts and won’t add new package skills — verify `boost.json` `packages`/`skills` lists them. `boost:install` is for initial agent wiring, not package pickup.

## Node.js
- Node is managed via nvm; each project's required version lives in its `.nvmrc`. If a project lacks one, stop and ask rather than guessing a version.
- Bash tool calls are non-interactive shells that never source `~/.zshrc`, so nvm isn't auto-loaded and shell state doesn't persist between calls anyway. Prefix any `node`/`npm`/`npx`/`yarn`/`pnpm` command with `with-node` (a wrapper in `~/.local/bin`, already on `PATH`) — e.g. `with-node npx playwright install chromium`.

## Testing
- Never test the framework. Assert what our code does, not what the framework guarantees. `assertSoftDeleted()` already proves the trait is applied and the row survived — also asserting `Model::find()` returns null just re-tests Eloquent's global scope.
- The same goes for the other direction: a default from our migration, a cast we configured, or a constraint we declared *is* our code and is worth asserting.

## Workflow
- A project's own CLAUDE.md overrides anything here. These are defaults for when a project says nothing.
- Write a failing test before writing the fix/feature code (TDD).
  - If there's no existing test suite/location to put a test, or the change isn't easily testable, stop and discuss before proceeding rather than skipping the test or guessing where it belongs.
- Never perform git commits without asking. One exception: commit work done in a worktree to that worktree's own branch, so I can review it in Tower. Still never push or open a PR without asking.
  - Keep the commits reviewable — separate logical changes into separate commits, and don't fold an unrelated fix into a feature commit.
  - Ask about committing as each logical unit of work lands, not once several have piled up. Once a later change moves or renames an earlier one's files, git only ever sees the final paths and the earlier work can no longer be staged on its own.
- Don't re-run tests, linters or static analysis when the only edits were docs, comments or docblocks — they can't fail on prose. Run them when behaviour, signatures, imports or config could have changed, and fold any docblock tweaks into the run the code change already needs.
- When adding or editing a Cursor project rule under `.cursor/rules/`, sync the substance into `~/.config/ai/instructions.md` in the same turn (Claude/Codex symlink there). Never create that file if missing — stop and ask.

## PR size
- Keep PRs as small as they can reasonably be. Several small PRs beat one big one.
- If a change stands on its own, give it its own PR — don't fold it into a larger one just because it was discovered along the way.
- When splitting would mean untangling shared hunks, or you're unsure where the seam is, ask rather than guessing.

## PR descriptions
- Don't hard-wrap commit messages, PR descriptions, or issue bodies. Write each paragraph as one long line and let the client wrap it — manual line breaks render as ragged mid-sentence breaks on GitHub. Blank lines between paragraphs are fine.
- Never add a "Generated with Claude Code" (or similar) footer to any commit or PR message.
- Never add yourself (Claude) as a co-author on any commit or PR.
- Concise explanation of the actual issue/bug, with a simple example.
- Brief explanation of the approach used to fix it.
- Don't enumerate every code/test file changed.
- Wrap code things (tags, classes, selectors, function/variable names, file paths) in markdown code syntax — e.g. `<h6>`, `.grid_2 .card-footer h6`, `grid_2_card`.
- If an issue drove the PR, mention it — the closing keyword differs by repo, see below.

## Package repos (statamic/cms and any transformstudios/* package)
- Work in a git worktree rather than switching branches in place. **This applies to these package repos only** — application projects use ordinary branches unless their own CLAUDE.md says otherwise.
  - Put worktrees in a consistent place: a sibling of the repo named `<repo>-worktrees/`, one directory per branch — e.g. `/Users/erin/Development/prime-worktrees/2315-browser-timezone-default`. Never drop them loose next to the repo.

## Statamic CMS (statamic/cms repo)
- When creating issues, use the bug fix issue template.
- PR descriptions: see the general "PR descriptions" guidance above. Reference the driving issue with `Closes #123`.

## TransformStudios packages (any transformstudios/* repo)
- Branch names drive automatic PR labelling, so the prefix matters: `fix/details-here` for bug fixes, `feature/new-thing` for new features, `chore/details-here` for dependency updates and minor refactors that aren't a fix or a feature.

## Prime (transformstudios/prime repo)
- Dev repo lives at `/Users/erin/Development/prime`. Before creating a worktree, fetch and make sure its `main` is current with `origin/main`.
- Create the fix in a worktree off that up-to-date `main` (per the global worktree rule above).
- Symlink the worktree into the consuming project (e.g. `vendor/transformstudios/prime` in the project you're fixing the issue for) so the change can be reviewed live in a real site, instead of just reading the diff.
- Stop and wait for manual approval after the symlinked fix is ready for review — don't push or open a PR yet.
- Once approved: push the branch and open a **draft PR** with a concise summary — what the issue was and what changed (see the general "PR descriptions" guidance above). Reference the driving issue with `References #123`, not `Closes` — the issue usually lives in the consuming site's repo, not Prime's, so merging the PR shouldn't auto-close it.
