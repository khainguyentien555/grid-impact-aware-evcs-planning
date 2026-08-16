# PowerWorld Model Package

The supplied `PowerWorld_EV.rar` archive contained five scenario folders and 15 principal PWB cases. They have been extracted and renamed consistently without modifying binary content.

## Canonical names

- `Sx_BC.PWB` — B&C benchmark
- `Sx_BIPSO_GR.PWB` — BIPSO-GR heuristic (original archive tag: `HB`)
- `Sx_Hybrid.PWB` — Hybrid (original archive tag: `HY`)

Each scenario folder also includes the supplied `NewOne7.pwd` one-line/display file renamed as `Sx_oneline.pwd`.

`CASE_INDEX.csv` records the original archive path, canonical path, and SHA-256 hash for every primary PWB case. The identical `With EV(origin).PWB` reference file found in all five original scenario folders is stored once in `support/`.

## Software

The manuscript reports AC power-flow assessment in PowerWorld Simulator 22. A compatible PowerWorld installation is required to open and solve these proprietary-format cases.

## Validation target

Use `../data/published/grid_impact_summary_table_ix.csv` as the frozen comparison target for Vmin, critical branch, maximum loading, HCM, CSI, and Ploss.
