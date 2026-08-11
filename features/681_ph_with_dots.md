# Feature: Use `...` modifiers in `ph_with()` (officer#681)

## Summary

This feature leverages the previously unused `...` argument in all `ph_with.*`
methods to allow direct modification of placeholder properties (position, size,
rotation, background, border, geometry) without constructing explicit
`ph_location_*()` objects.

## Origin

- **Issue:** [davidgohel/officer#681](https://github.com/davidgohel/officer/issues/681)
- **Source branch:** `markheckmann/officer@681_use_dots_in_ph_with`
- **Integration:** Squash-merged into `officer.dev` dev branch
- **Upstream status:** Not submitted (upstream not accepting PRs)

## Motivation

Previously, modifying a placeholder's visual properties (rotation, background
color, border, geometry) required constructing a full `ph_location_*()` object
with all desired attributes. This was verbose for simple styling tasks:

```r
# Before: verbose
loc <- ph_location_type("body", rotation = 10)
# ... and no way to set bg/ln/geom via location

# After: concise
ph_with(x, "Hello", location = "body", rot = 10, bg = "cyan", ln = "red", geom = "roundRect")
```

## Changes

### Core mechanism

A new internal function `update_location_from_dots()` (R/ppt_ph_with_methods.R:765)
extracts known modifier arguments from `...` and `.dots`, and updates the
fortified location object before it is passed to `shape_properties_tags()`.

**Allowed modifiers:**
- `left`, `top`, `width`, `height` — position/size (inches)
- `rotation` (alias: `rot`) — degrees
- `bg` — background color (string, hex, with alpha support)
- `ln` — border (color string or `sp_line()` object)
- `geom` — shape geometry preset (e.g. `"roundRect"`, `"star32"`)

Unknown arguments in `...` raise an error by default. Methods that also pass
`...` to other functions (e.g. `ph_with.gg` passes to `ragg::agg_png()`) use
`discard_unkown_args = TRUE` to silently ignore non-modifier args.

### `.dots` parameter

A new `.dots` parameter (named list) allows bundling modifiers for reuse:

```r
style <- list(ln = "red", rot = 3, geom = "round2SameRect", bg = "#ff000015")
ph_with(x, "Text", location = "body[1]", .dots = style)
```

`.dots` values are merged with `...` (`.dots` takes precedence on conflict).

### Modified files

| File | Change |
|------|--------|
| `R/ppt_ph_with_methods.R` | Added `...` and `.dots` handling to all `ph_with.*` methods; added `update_location_from_dots()`; added `agg_png_safe()` wrapper; rewrote roxygen docs with Modifiers table |
| `R/ph_location.R` | Minor: added `rotation` field to `fortify_location` output |
| `R/utils.R` | Added `is_rpptx()` and `stop_if_not_rpptx()` exported helpers |
| `inst/examples/example_ph_with.R` | Extended examples showing `...` modifiers |
| `inst/img/dog.png`, `inst/img/dog2.png` | Test image assets |
| `tests/testthat/test-pptx-ph-location.R` | Tests for all `ph_with.*` methods with modifiers |
| `tests/testthat/utils.R` | Test helpers: `get_shapetree()`, `get_shapetrees_string()`, `is_identical_shapetree()` |

### Methods affected

All `ph_with.*` methods now accept `...` modifiers:

| Method | Effective modifiers | Notes |
|--------|-------------------|-------|
| `ph_with.character` | all | |
| `ph_with.numeric` | all | `...` also passed to `format()` |
| `ph_with.factor` | all | |
| `ph_with.Date` | all | |
| `ph_with.fpar` | all | |
| `ph_with.block_list` | all | |
| `ph_with.unordered_list` | all | |
| `ph_with.empty_content` | all | |
| `ph_with.data.frame` | `left`, `top`, `width`, `height` | No rotation/ln/bg/geom (table styling) |
| `ph_with.gg` | all except `geom` | `...` also passed to `agg_png()` |
| `ph_with.plot_instr` | all except `geom` | `...` also passed to `agg_png()` |
| `ph_with.external_img` | all except `geom` | |

### Key implementation details

1. **Partial matching:** Modifier names are matched via `pmatch()`, so `rot`
   matches `rotation`, `bg` matches `bg`, etc.

2. **`ln` casting:** String values for `ln` (e.g. `"red"`) are auto-cast to
   `sp_line()` objects via `cast_to_sp_line()`.

3. **`agg_png_safe()`:** A wrapper around `ragg::agg_png()` that filters out
   modifier arguments before forwarding, preventing "unused argument" errors.

4. **Precedence:** `...` modifiers override location object properties. This
   allows setting defaults in the location and overriding per-call.

## Testing

- 118 tests in `test-pptx-ph-location.R` covering all methods
- Roundtrip test: generate PPTX → save → reload → compare shapetrees
- Test helpers compare XML shapetrees with UUIDs stripped for deterministic comparison

## Vignette

See `vignettes/ph_with_modifiers.Rmd` for usage examples and thumbnails.

## Upstream PR preparation

To submit this as an upstream PR, the following would be needed:

1. Rebase onto current `davidgohel/officer` main
2. Split into clean commits (docs separate from implementation)
3. Remove `is_rpptx`/`stop_if_not_rpptx` exports if David prefers them internal
4. Align `example_ph_with.R` formatting with upstream style
5. PR description referencing issue #681
