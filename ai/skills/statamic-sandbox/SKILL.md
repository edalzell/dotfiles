---
name: statamic-sandbox
description: Spin up a throwaway, fully-booted Statamic site to confirm a fix, reproduce a bug, or check real behavior/performance instead of reasoning about it in the abstract — optionally running a local package/worktree instead of the released version. Trigger on phrases like "spin up", "sandbox", "confirm with a real site", "real app", "throwaway site", "reproduce this in a real Statamic site", or when verifying a statamic/cms core change needs an actual booted app (queue workers, search indexing, CP behavior, asset handling) rather than just unit tests.
---

# Statamic sandbox

Scaffolds a disposable Statamic application for confirming something against
real, running code — not a design doc, not a guess. Use this whenever a claim
needs to be checked against actual behavior: "does this fix actually work",
"how slow is this really", "does this reproduce".

## Running it

The `statamic-sandbox` shell command (`~/.local/bin/statamic-sandbox`, on
`$PATH`) does the scaffolding:

```
statamic-sandbox <name-or-path> [--link=/path/to/local/statamic-cms] [--force]
```

- A bare name (`issue-15118`) creates the site under `~/Sites/`. A path
  containing `/` is used literally.
- `--link=PATH` swaps the installed `statamic/cms` package for a symlink to a
  local checkout — a git worktree, a clone with your fix branch checked out,
  whatever you're trying to validate — then runs `composer dump-autoload`.
  This is the way to confirm an unreleased/local change against a real app.
- `--force` wipes an existing directory at the target path first.

Run `statamic-sandbox --help` for the full usage text.

After scaffolding, `cd` into the site and drive it like any other Statamic
app (`php artisan`, `php please`, tinker, etc.).

## Gotchas learned the hard way (apply these, don't rediscover them)

These came out of a real investigation (statamic/cms issue #15118, a queue
worker performance bug) where getting them wrong produced silently-wrong
"it works!" results before the bug was actually being exercised at all.

- **A "successful", fast-looking run can still be doing zero real work.**
  The first pass at that investigation's benchmark command exited cleanly in
  under a second — because the thing under test was never actually invoked.
  Always verify via a concrete side effect (a row count, a file's contents,
  a document count), not just exit status / "Done" output.

- **Assets fieldtype raw values are bare paths, not `container::path`.**
  `AssetContainer::asset($path)` treats `$path` as already scoped to the
  container. Seeding entry data with `'assets::image-1.jpg'` for an assets
  field silently resolves to nothing (double-prefixed) — use `'image-1.jpg'`.

- **Default field/value access does NOT augment.** e.g. for search indexing,
  `Searchable::getSearchValue()` returns the raw stored value, not an
  augmented one — an assets field just gives you the raw path string, never
  touching asset resolution/metadata at all. If you're trying to reproduce a
  bug that lives in augmentation (asset resolution, relationship resolution,
  computed fields, etc.), you need to force it explicitly — e.g. a search
  index `transformers` config entry that calls
  `$searchable->augmentedValue($field)->value()` and then exercises it
  (`->exists()`, `->url()`, etc.). Multi-value augmented fields (assets with
  more than one file) return a lazy query builder from `->value()`, not an
  eager collection — call `->get()` on it before `collect()`-ing.

- **`queue:work`'s default `--timeout=60` will silently kill and retry a
  long-running job.** If a job takes longer than 60s (exactly the kind of
  thing you're benchmarking when chasing a slowness bug), the worker kills
  it and moves on, corrupting any "jobs completed" count you're tracking.
  Always pass `--timeout=0` when benchmarking or debugging slow queue jobs.

- **Redis queue keys are prefixed with a slugified app name**, e.g.
  `statamic-database-queues:default`, not the bare `queues:default`. If
  `redis-cli llen queues:default` comes back empty/wrong, run
  `redis-cli keys '*'` to find the real key first.

- **Verify queue progress by checking real output, not just queue length.**
  Queue length only tells you what's been popped, not what's completed. For
  search indexing specifically, `storage/statamic/search/<index>.json` is a
  JSON array — `count()` it directly to see how many documents actually got
  indexed so far.

- **Set `STATAMIC_STACHE_WATCHER=false`** in `.env` for reproducible
  performance comparisons — the watcher's cache behavior is a separate,
  compounding variable you usually don't want mixed into a measurement.

- **Seed realistic volume.** Bugs like #15118 only manifest at scale (it
  needed a large asset container and a meaningful document count per queue
  job/chunk) — a handful of test records won't reproduce a perf problem.
  Generate bulk dummy content directly (a fast PHP loop writing files, a
  custom `routes/console.php` `Artisan::command()` seeding entries) rather
  than going through the CP one record at a time.

## Cleanup

The sandbox is throwaway. When you're done:
```
rm -rf <site_path>
```
If you used `--link`, nothing about the linked package/worktree needs
cleanup here — only the sandbox app itself.
