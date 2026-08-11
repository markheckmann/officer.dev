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
- No direct development on `main`; work on `dev` or feature branches
- PRs go `feature-branch → dev`, then `dev → main` when stable

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

## Style

- No code comments unless explicitly requested
- Follow existing code patterns (roxygen2 docs, testthat tests)
- Use `xml2` for XML manipulation, `dplyr`/`tidyr` for data wrangling
- Keep roxygen examples using `library(officer)` (not `officer.dev`)
