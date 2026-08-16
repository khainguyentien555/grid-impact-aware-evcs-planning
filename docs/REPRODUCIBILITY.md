# Reproduction Guide

## 1. Reproduce publication figures from frozen canonical data

Requirements: Python 3.10+ (recommended), NumPy, Matplotlib.

```bash
python -m venv .venv
# activate the environment
python -m pip install -r requirements.txt
python python/validate_published_data.py
python python/run_all_figures.py
```

Outputs are written to `results/figures/` in PDF, SVG, and 600-dpi PNG.

This route is deterministic because it reads the frozen publication data in `data/published/`.

## 2. Inspect/re-run the 15 PowerWorld cases

The case matrix is S1–S5 × B&C/BIPSO-GR/Hybrid. Open the corresponding `.PWB` file in `powerworld/cases/<scenario>/` and solve the steady-state AC power flow using the case’s stored topology and loads.

Expected summary values are in `data/published/grid_impact_summary_table_ix.csv`.

Scenario interpretation:

- S1: both sources in service, nominal EVCS demand.
- S2: SS1 unavailable; supply transferred from SS2 through the closed tie path.
- S3: SS2 unavailable; supply transferred from SS1 through the closed tie path.
- S4: normal topology, EVCS-only demand multiplier 1.2.
- S5: normal topology, EVCS-only demand multiplier 1.5.

The original workbook indicates the normally open 3–4 tie is closed for S2/S3. When rebuilding a case manually, verify source status and switch state before comparing results.

Record at minimum:

1. minimum bus voltage;
2. maximum branch apparent-power loading (% of rating);
3. critical branch;
4. active-power losses.

Then compute:

- `HCM = 100 - Lmax` (%);
- `CSI = max(0, Lmax - 100)` (%).

## 3. Supplementary MATLAB fixed-layout audit

The supplied MATLAB workflow is kept in `matlab/supplementary_fixed_layout_audit/`. It requires MATLAB R2023b or compatible MATLAB with Optimization Toolbox (`intlinprog`). The uploaded workflow expects `evcs_data.mat` in the same folder, so a copy is included there.

Run:

```matlab
run_fixed_layout_audit_mpce
```

The expected audit outputs are already frozen in `data/audit/`.

**Do not use this route as a claim that Table VII has been regenerated exactly.** Its Dmax, weights, SCF representation, and P_EVCS totals differ from the final publication lineage; see `docs/SOURCE_OF_TRUTH_AUDIT.md`.

## 4. Extending the repository

For new simulations, create a new data/version namespace rather than overwriting `data/published/`. Example:

```text
data/experiments/v1/
results/experiments/v1/
```

Document new assumptions, PowerWorld case hashes, and any changes to Dmax, SCFs, load multipliers, branch ratings, or EVCS layouts.
