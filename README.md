officer.dev
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

# officer.dev

`officer.dev` is a development fork of the
[`officer`](https://github.com/davidgohel/officer) R package.

It is **not intended to replace `officer`**. It is a drop-in replacement
that provides early access to selected pull requests, fixes and features
that are still pending in the upstream `officer` repository, as well as
additional features developed independently.

The package name remains `officer`, so installing `officer.dev` replaces
your existing `officer` installation.

The project stays as closely aligned with upstream `officer` as
possible.

## Installation

``` r
pak::pak("markheckmann/officer.dev")
```

## Usage

``` r
library(officer)

read_pptx()
read_docx()
```

## Additional changes

See [UPSTREAM.md](UPSTREAM.md) for a list of integrated upstream PRs and
their current status. Each feature has a detailed technical report in
[`features/`](features/) for reference and upstream PR preparation.

## How it works

Features and fixes are developed in the
[`markheckmann/officer`](https://github.com/markheckmann/officer) fork
(for potential upstream contribution) and then cherry-picked into this
repository. When upstream merges a change, it is picked up automatically
during the next sync via `git merge upstream/main`.

### Branch structure

- `main` – stable, releasable
- `dev` – integration branch for new features and upstream syncs
- `upstream-pr-xxx` / `feature/xxx` – temporary working branches

### Development workflow

1.  Develop feature on `markheckmann/officer` fork (feature branch)
2.  Cherry-pick into `officer.dev` on a new branch off `dev`
3.  PR into `dev`, squash-merge
4.  When `dev` is stable, merge into `main`
5.  Periodically sync upstream changes via `git merge upstream/main`

## Upstream

This package tracks
[`davidgohel/officer`](https://github.com/davidgohel/officer). All
credit for the original work belongs to the officer authors.
