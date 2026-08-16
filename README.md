# Grid-Impact-Aware EVCS Planning — Reproducibility Package

Reproducibility and data package accompanying the IEEE Access article:

> T.-M.-C. Le, T.-K. Nguyen, and T.-N. Le, **“Grid-Impact-Aware Planning of Electric Vehicle Charging Infrastructure for a Tourism-Intensive Island Grid Using Mixed-Integer Optimization and AC Power Flow Assessment,”** *IEEE Access*, 2026. DOI: **10.1109/ACCESS.2026.3718247**.

## What this repository contains

This repository separates **published-result data** from **legacy/provenance files** and from a **supplementary fixed-layout audit**. That separation is intentional: the uploaded working files span more than one modeling/version lineage, and mixing them would create a false claim of exact reproducibility.

- `data/published/` — canonical numerical values reported in the accepted IEEE Access manuscript and values underlying the supplied final plotting scripts.
- `powerworld/cases/` — the 15 supplied PowerWorld cases, renamed consistently as B&C / BIPSO-GR / Hybrid.
- `python/` — cleaned plotting scripts that read canonical CSV data instead of hard-coding publication arrays.
- `matlab/supplementary_fixed_layout_audit/` — the supplied MATLAB fixed-layout audit workflow, preserved as a **supplementary audit**, not represented as the exact generator of all published tables.
- `data/provenance/` — the legacy PowerWorld input workbook and machine-readable P/Q extraction retained for traceability.
- `docs/SOURCE_OF_TRUTH_AUDIT.md` — full audit of version and parameter inconsistencies.

## Published case study

The paper studies 33 charging-demand points, 8 candidate EVCS sites, and a 16-bus 22 kV distribution network in Phu Quoc, Vietnam. Three layouts are compared: an exact B&C benchmark, BIPSO-GR, and a BIPSO-GR-seeded B&C Hybrid. The grid layer evaluates five operating conditions: base operation, two source-side N-1 cases, and 1.2× / 1.5× EVCS-load stress.

The published comparison shows that voltage remains non-discriminating while thermal headroom is binding. Under S2, the maximum branch loadings are 118.6% (B&C), 157.3% (BIPSO-GR), and 116.2% (Hybrid). Under S5, the corresponding HCM values are 34.8%, 5.3%, and 35.3%.

## Quick start — reproduce the supplied figures

```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# Linux/macOS: source .venv/bin/activate
python -m pip install -r requirements.txt
python python/validate_published_data.py
python python/run_all_figures.py
```

Generated PDF, SVG, and 600-dpi PNG files are written to `results/figures/`.

The cleaned scripts reproduce the data-backed figures corresponding to the paper’s charger-allocation comparison, voltage profiles, five-scenario maximum-loading chart, and S2/S3 branch-loading heatmaps.

## PowerWorld cases

The original archive contained 15 primary `.PWB` study cases. They are exposed individually in `powerworld/cases/` and mapped in `powerworld/CASE_INDEX.csv`.

Naming convention:

- `BC` = B&C benchmark
- `BIPSO_GR` = BIPSO-GR heuristic (`HB` in the original filenames)
- `Hybrid` = warm-started exact-refinement layout (`HY` in the original filenames)

PowerWorld Simulator 22 or a compatible installation is required to open/solve the binary case files. See `docs/REPRODUCIBILITY.md` and `powerworld/README.md`.

## Important source-of-truth note

The **accepted manuscript values are the publication source of truth**. The supplied `EVCS_Grid_Analysis_v2_legacy.xlsx` contains per-bus P values that round to the published Table VII rows, but its SCF values and active-power formula are not identical to the formulation stated in the manuscript. For BIPSO-GR and Hybrid, the published Table VII totals equal the sums of the displayed three-decimal bus rows rather than conventional rounding of the workbook’s higher-precision totals. Separately, the supplied MATLAB fixed-layout audit uses parameters from `evcs_data.mat` that differ from the final paper (including Dmax, weights, and SCF representation), and its P_EVCS totals differ from Table VII. Therefore these two artifacts are retained for provenance/audit and are not silently merged into the canonical published dataset.

Read `docs/SOURCE_OF_TRUTH_AUDIT.md` before extending the code.

## Repository map

```text
.
├── data/
│   ├── published/       # canonical publication numbers
│   ├── provenance/      # legacy execution workbook
│   └── audit/           # supplied fixed-layout audit outputs/data
├── docs/
├── matlab/
├── powerworld/
├── python/
└── results/
```

## Citation

Please cite the IEEE Access article when using these data or case models. A repository citation file is supplied as `CITATION.cff`, and a BibTeX entry is available in `citation.bib`.

## Licensing

See `LICENSE_NOTICE.md`. The repository intentionally does not impose a software/data license on behalf of all co-authors; the authors should select and approve the final license before making the repository public.

## Reproducibility scope

The package supports traceability of the fixed EVCS layouts, published bus injections, PowerWorld cases, voltage/thermal results, and final figures. It does **not** claim that the supplied supplementary MATLAB audit is the original end-to-end optimizer that generated every published planning result.
