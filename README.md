# Grid-Impact-Aware EVCS Planning — Reproducibility Package
[![Published-Data Validation](https://github.com/khainguyentien555/grid-impact-aware-evcs-planning/actions/workflows/validate.yml/badge.svg)](https://github.com/khainguyentien555/grid-impact-aware-evcs-planning/actions/workflows/validate.yml)

Reproducibility and data package accompanying the published IEEE Access article:

**Code, data, PowerWorld cases, and validated numerical artifacts accompanying the published IEEE Access article**

**Associated article:**  
Thi-Minh-Chau Le, Tien-Khai Nguyen, and Trong-Nghia Le,  
“Grid-Impact-Aware Planning of Electric Vehicle Charging Infrastructure for a Tourism-Intensive Island Grid Using Mixed-Integer Optimization and AC Power Flow Assessment,”  
*IEEE Access*, vol. 14, pp. 119449–119466, 2026.  
DOI: https://doi.org/10.1109/ACCESS.2026.3718247

## What this repository contains

This repository separates **canonical published-result data**, **provenance artifacts**, and a **supplementary fixed-layout audit**. This structure preserves traceability across modeling versions while keeping the dataset corresponding to the published article clearly identifiable.

* `data/published/` — canonical numerical values reported in the published IEEE Access article and values underlying the final plotting scripts.
* `powerworld/cases/` — 15 PowerWorld study cases covering S1–S5 for the B&C, BIPSO-GR, and Hybrid layouts.
* `python/` — cleaned, data-driven scripts for reproducing the supplied publication figures.
* `matlab/supplementary_fixed_layout_audit/` — supplementary MATLAB workflow for independently auditing fixed-layout assignment, charger allocation, objective terms, and EVCS bus injections.
* `data/provenance/` — earlier calculation artifacts retained for traceability and version reconciliation.
* `docs/SOURCE_OF_TRUTH_AUDIT.md` — detailed reconciliation of the supplied modeling and data lineages.
* `docs/DATA_DICTIONARY.md` — definitions, units, and interpretation of the released datasets.
* `docs/REPRODUCIBILITY.md` — instructions for reproducing the supplied results and figures.

## Published case study

The article studies 33 charging-demand points, 8 candidate EVCS sites, and a 16-bus, 22 kV distribution network in Phu Quoc, Vietnam. Three layouts are compared: an exact B&C benchmark, BIPSO-GR, and a BIPSO-GR-seeded B&C Hybrid layout.

The grid layer evaluates five operating conditions:

* S1 — base operation;
* S2 — source-side N-1 contingency with SS1 unavailable;
* S3 — source-side N-1 contingency with SS2 unavailable;
* S4 — 1.2× seasonal EVCS-load stress;
* S5 — 1.5× event / accelerated EVCS-load stress.

The published results show that voltage magnitude remains non-discriminating in the studied short underground 22 kV feeder, while thermal headroom becomes the binding grid-acceptability criterion.

Under S2, the maximum branch loadings are:

* B&C: **118.6%**
* BIPSO-GR: **157.3%**
* Hybrid: **116.2%**

Under S5, the corresponding hosting-capacity margins are:

* B&C: **34.8%**
* BIPSO-GR: **5.3%**
* Hybrid: **35.3%**

## Quick start — reproduce the supplied figures

```bash
python -m venv .venv

# Windows
.venv\Scripts\activate

# Linux/macOS
source .venv/bin/activate

python -m pip install -r requirements.txt
python python/validate_published_data.py
python python/run_all_figures.py
```

Generated PDF, SVG, and 600-dpi PNG files are written to:

```text
results/figures/
```

The cleaned scripts reproduce the data-backed figures corresponding to the charger-allocation comparison, voltage profiles, five-scenario maximum-loading comparison, and S2/S3 branch-loading heatmaps.

## PowerWorld cases

The repository includes 15 primary `.PWB` study cases, exposed individually in:

```text
powerworld/cases/
```

Their mapping and provenance are documented in:

```text
powerworld/CASE_INDEX.csv
```

Naming convention:

* `BC` = B&C benchmark
* `BIPSO_GR` = BIPSO-GR heuristic (`HB` in the original supplied filenames)
* `Hybrid` = warm-started exact-refinement layout (`HY` in the original supplied filenames)

PowerWorld Simulator 22 or a compatible installation is required to open and solve the binary case files.

See:

```text
docs/REPRODUCIBILITY.md
powerworld/README.md
```

## Source-of-truth policy

The **published IEEE Access article is the authoritative source for the numerical results reported in the paper**.

The repository therefore distinguishes the canonical publication dataset in `data/published/` from earlier spreadsheets and supplementary audit artifacts retained for provenance and traceability.

Those supporting artifacts reflect earlier calculation conventions or parameterizations and should not be interpreted as replacements for the canonical published dataset.

A complete reconciliation record is provided in:

```text
docs/SOURCE_OF_TRUTH_AUDIT.md
```

Users extending or modifying the computational workflow are encouraged to review that document first.

## Repository map

```text
.
├── data/
│   ├── published/       # canonical publication values
│   ├── provenance/      # provenance and earlier calculation artifacts
│   └── audit/           # supplementary fixed-layout audit data/results
├── docs/                # data dictionary, audit, and reproduction guidance
├── matlab/              # supplementary MATLAB audit workflow
├── powerworld/          # PowerWorld cases and case index
├── python/              # validation and figure-generation scripts
└── results/             # reproduced figures
```

## Citation

Please cite the associated article as:

> Thi-Minh-Chau Le, Tien-Khai Nguyen, and Trong-Nghia Le,  
> “Grid-Impact-Aware Planning of Electric Vehicle Charging Infrastructure for a Tourism-Intensive Island Grid Using Mixed-Integer Optimization and AC Power Flow Assessment,”  
> *IEEE Access*, vol. 14, pp. 119449–119466, 2026.  
> DOI: https://doi.org/10.1109/ACCESS.2026.3718247

Machine-readable citation metadata are provided in `CITATION.cff` and `citation.bib`.

## Licensing

See `LICENSE_NOTICE.md` for the current licensing status of the repository.

A repository-wide software/data license has not yet been adopted. Any future licensing decision should be explicitly documented in the repository and agreed upon by the relevant authors/data owners.

## Reproducibility scope

This package supports traceability and independent verification of:

* the fixed EVCS layouts;
* published EVCS bus injections;
* the 15 PowerWorld operating cases;
* voltage and thermal-security results;
* HCM and CSI results derived from the published operating cases;
* the supplied publication figures.

The supplementary MATLAB workflow is provided to independently audit fixed-layout planning and injection calculations. It is **not intended to reproduce every step of the original optimization-development workflow**.

## Version

Current repository release:

```text
v1.0.0
```

See `CHANGELOG.md` for version history.
