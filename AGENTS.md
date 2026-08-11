# AGENTS.md

## Project

This is `officer.dev`, a development fork of the R package [`officer`](https://github.com/davidgohel/officer). The R package name is `officer` (not `officer.dev`) for ecosystem compatibility.

## Language & Framework

- Language: R
- Build system: `devtools` / `roxygen2`
- Test framework: `testthat`
- XML handling: `xml2`
- Dependencies: see `DESCRIPTION`

## Commands

```bash
# Run tests
Rscript -e 'Sys.setenv(LANGUAGE = "en"); devtools::test()'

# Build documentation
Rscript -e 'devtools::document()'

# Install locally
Rscript -e 'devtools::install(quick = TRUE)'

# Full R CMD check
Rscript -e 'Sys.setenv(LANGUAGE = "en"); devtools::check()'
```

## Conventions

- Tests require `LANGUAGE=en` (set in `.Renviron` and CI workflows)
- Commit message prefixes: `feat:`, `fix:`, `doc:`, `internals:`
- Commit title references the issue if applicable: `feat: use ... modifiers in ph_with (#681)`
- Commit body should be detailed enough to understand the change without reading the diff
- No direct development on `main`; work on `dev` or feature branches
- PRs go `feature-branch → dev`, then `dev → main` when stable

## Versioning

- Upstream officer uses `.001` – `.999` for dev increments (e.g. `0.7.7.003`)
- officer.dev uses `.9000+` (e.g. `0.7.7.9000`, `0.7.7.9001`)
- This makes versions immediately distinguishable and ensures officer.dev is always numerically higher than upstream
- When upstream releases a new version (e.g. `0.8.0`), officer.dev resets to `0.8.0.9000`

## Branch structure

- `main` – stable/releasable
- `dev` – integration branch
- `upstream-pr-xxx` – cherry-picked upstream PRs
- `feature/xxx` – own features

## Upstream sync

```bash
git fetch upstream
git switch dev
git merge upstream/main
```

Remote `upstream` points to `git@github.com:davidgohel/officer.git`.

## Feature workflow

Features are developed in the personal officer fork (`markheckmann/officer`) for upstream PRs, then cherry-picked into officer.dev:

```bash
# In officer.dev
git switch dev && git pull
git switch -c upstream-pr-xxx
git fetch fork feature/xyz        # 'fork' remote = markheckmann/officer
git cherry-pick <commit(s)>
git push -u origin upstream-pr-xxx
# → PR: upstream-pr-xxx → dev
```

If upstream merges the PR later, conflicts are resolved in favour of the upstream version during the next `git merge upstream/main`.

After integrating a feature:

1. Create a vignette in `vignettes/` with examples and thumbnails
2. Create a technical report in `features/` (e.g. `features/681_ph_with_dots.md`) documenting motivation, changes, affected files, implementation details, and what is needed for an upstream PR
3. Update `NEWS.md` with a short description under the current version heading

## Directory structure

| Directory | Purpose |
|-----------|---------|
| `R/` | Package source code |
| `tests/testthat/` | Unit tests |
| `man/` | Generated roxygen documentation |
| `vignettes/` | User-facing vignettes (one per feature) |
| `features/` | Technical reports per feature (for upstream PR preparation) |
| `inst/` | Installed files (templates, images, examples) |
| `dev_local/` | Local-only dev notes (gitignored) |

## Style

- Follow the [Tidyverse style guide](https://style.tidyverse.org/) with these highlights:
  - `snake_case` for variables and functions
  - `<-` for assignment, not `=`
  - Spaces around infix operators (`+`, `-`, `<-`, `==`) except `::`, `$`, `[`, `^`
  - Space after commas, not before
  - `{` on same line, `}` on own line, body indented by 2 spaces
  - Use `|>` (base pipe), not `%>%`
  - Line length: aim for 80 characters, max 120
  - Each pipe step on its own line, indented by 2 spaces
  - Use `TRUE`/`FALSE`, not `T`/`F`
  - Use `"` for strings, not `'`
- No code comments unless explicitly requested
- Follow existing code patterns (roxygen2 docs, testthat tests)
- Use `xml2` for XML manipulation, `dplyr`/`tidyr` for data wrangling
- Keep roxygen examples using `library(officer)` (not `officer.dev`)
