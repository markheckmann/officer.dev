# Feature: Modular placeholder annotation (officer#682)

## Summary

Rewrite of `annotate_base()` and introduction of two new functions (`phs_annotate()`, `add_annotated_layouts()`) for a more modular, interactive placeholder annotation workflow.

## Origin

- Issue: https://github.com/davidgohel/officer/issues/682
- Source branch: `fork/682_phs_annotate_modular` (markheckmann/officer)
- officer.dev PR: #2

## Motivation

The existing `annotate_base()` had several shortcomings:

1. Missing type index (e.g. `body[3]`) making it hard to distinguish same-type phs
2. Parameter `index` instead of `id` (inconsistent with `layout_properties`, `ph_location_id`)
3. Poor positioning of layout/master name
4. No visual border around placeholders, making boundaries unclear
5. No way to select a subset of layouts (problematic for templates with 30+ layouts)
6. `annotate_base()` writes to disk immediately, breaking the pipe-based workflow

The new approach is modular: `phs_annotate()` works on the current slide inline (ideal with `print(preview = TRUE)`), while `add_annotated_layouts()` adds overview slides to an existing object.

## Changes

### New functions

| Function | Purpose |
|----------|---------|
| `phs_annotate()` | Annotate phs of current (or selected) slides in-place |
| `add_annotated_layouts()` | Add one annotated slide per layout to rpptx object |
| `annotate_base()` | Rewritten as thin wrapper around `add_annotated_layouts()` |

### `fortify_location.*` enrichment

All `fortify_location.*` methods now consistently return a `location_fortified` object (S3 class) containing:

- `ph_id`: the placeholder's numeric id
- `type`: placeholder type (e.g. "body", "title")
- `type_idx`: index within same-type placeholders (e.g. 2 for `body[2]`)
- `location_class`: original location class used (e.g. "location_label")

A `print.location_fortified()` method provides a compact CLI summary.

### Utility functions added

- `mini_glue()`: lightweight glue-style string interpolation without external dependency
- `file_ext()`: extract file extension (mirrors `tools::file_ext`)

### Modified files

| File | Change |
|------|--------|
| `R/ppt_ph_annotate.R` | New file with `phs_annotate()`, `ph_annotate()` (internal), `add_annotated_layouts()`, `annotate_base()` |
| `R/ph_location.R` | `fortify_location.*` methods return `location_fortified` with new fields; `print.location_fortified()` |
| `R/pptx_informations.R` | Old `annotate_base()` removed |
| `R/utils.R` | `mini_glue()`, `file_ext()` added |
| `R/officer.R` | Minor wording fix |
| `inst/examples/example_phs_annotate.R` | Examples for `phs_annotate()` |
| `inst/examples/example_annotate_base.R` | Examples for new `annotate_base()` |

### Key implementation details

- `phs_annotate()` iterates over slides (`.slide_idx`) and placeholders, calling internal `ph_annotate()` for each
- `ph_annotate()` uses `fortify_location()` to resolve the location, builds an `fpar` with type/label/id info, renders it as PML, and inserts the shape node into the spTree (front or back)
- Annotation boxes use `shape_properties_tags()` for bg/border/position
- `add_annotated_layouts()` adds slides via `add_slide()` and then calls `phs_annotate(.slide_idx = "all")`
- `annotate_base()` is now a thin wrapper: `read_pptx() |> add_annotated_layouts(remove_slides = TRUE)`

## Testing

- 26 dedicated tests in `tests/testthat/test-pptx-ph-annotate.R`
- Covers: `phs_annotate()`, `add_annotated_layouts()`, `annotate_base()`, argument validation, edge cases
- Updated `test-pptx-misc.R` for new `annotate_base()` signature
- Updated `test-pptx-ph-location.R` for `ph_id`/`type_idx` in `as_ph_location()`
- Full suite: 1619 tests pass

## Upstream PR preparation

For submission to `davidgohel/officer`:

1. The `fortify_location` changes add fields without breaking existing return values (additive)
2. `annotate_base()` keeps the same function name but adds `layouts` arg and changes default `output_file` name from `annotated_layout.pptx` to `annotated_layouts.pptx` (minor breaking)
3. `phs_annotate()` and `add_annotated_layouts()` are purely additive
4. Dependencies: only existing imports (xml2, cli) used; `mini_glue()` avoids adding glue dependency
5. The PR should include the `fortify_location` enrichment as prerequisite (could be split into two PRs if preferred)
