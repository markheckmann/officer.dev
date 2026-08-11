officer.dev
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

# officer.dev

`officer.dev` is a development fork of the
[`officer`](https://github.com/davidgohel/officer) R package.

It is **not intended to replace `officer`**. It is a drop-in replacement
that provides early access to selected pull requests, fixes and features
that are still pending in the upstream `officer` repository.

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
their current status.

## Upstream

This package tracks
[`davidgohel/officer`](https://github.com/davidgohel/officer). All
credit for the original work belongs to the officer authors.
