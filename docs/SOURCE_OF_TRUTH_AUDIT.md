# Source-of-Truth Audit

## Audit policy

For this release, **the numerical values reported in the accepted IEEE Access manuscript are the publication source of truth**. Supplied working files are retained only where their role can be stated accurately. No conflicting file is silently edited to make it appear to be the original generator of a published result.

## Artifact classification

| Artifact | Classification | Key finding | Repository action |
|---|---|---|---|
| Accepted manuscript | **Canonical publication record** | Defines Table I–X values, equations, scenario meanings, and final algorithm terminology. | Converted reported numerical results into `data/published/`. |
| 15 PowerWorld `.PWB` cases | **Canonical simulation artifacts** | Complete S1–S5 × B&C/BIPSO-GR/Hybrid case set is present. Original `HB` and `HY` naming is inconsistent with the paper. | Extracted and renamed consistently; hashes preserved in `powerworld/CASE_INDEX.csv`. |
| `EVCS_Grid_Analysis_.xlsx` | **Legacy execution/provenance workbook** | Its per-bus P values round to the Table VII rows, but its SCF/formula metadata are not identical to the final manuscript formulation; the BIPSO-GR/Hybrid table totals are sums of the displayed three-decimal rows rather than rounded higher-precision workbook totals. | Retained unchanged as `data/provenance/EVCS_Grid_Analysis_v2_legacy.xlsx`; not used as canonical method documentation. |
| `evcs_data.mat` + MATLAB fixed-layout scripts | **Supplementary audit lineage** | Uses a different Dmax/weight/SCF parameterization and produces different P_EVCS totals from Table VII. | Retained under `data/audit/` and `matlab/supplementary_fixed_layout_audit/` with explicit warning. |
| `Fig4.py` / `Fig4(1).py` | Plot-source lineage | Files are byte-identical. Charger counts are integer and match the published installed capacities. | Duplicate removed; data normalized into `charger_allocation.csv`; clean script is `plot_fig3_charger_allocation.py`. |
| `Fig5.py`, `Fig6a.py`, `Fig6b.py` | Plot-source lineage | Voltage arrays are consistent with Table IX minima. Comments still call them placeholders. | Placeholder wording removed in clean data-driven script; arrays stored in `voltage_profiles_fig5.csv`. |
| `Fig8.py` | Plot-source lineage | Values match the published five-scenario maximum-loading figure. | Renamed conceptually to paper Fig. 6 and made data-driven. |
| `Fig9a.py`, `Fig9b.py` | Plot-source lineage | Branch-loading cells match the supplied/published N-1 heatmaps. | Combined into one data-driven paper Fig. 7 script. |
| `Fig7a.py`, `Fig7b.py`, `Image.py`, `Legend outside.py` | Redundant/legacy plotting variants | Standalone N-1 bars and alternate label/axis variants are not needed for the accepted figure set. | Excluded from canonical code to prevent version ambiguity. |

## Critical version differences

### 1. SCF representation

The manuscript states 2040 vehicle-class SCFs of 0.4066 (EM), 0.4528 (EC), 0.3926 (ET), and 0.5911 (EB). The legacy PowerWorld workbook instead uses three charger-class values 0.35, 0.345, and 0.44. The supplied `evcs_data.mat` contains six type-specific values `[0.35, 0.35, 0.35, 0.34, 0.34, 0.44]`; the MATLAB loader collapses the four middle types to a weighted 60-kW SCF.

**Decision:** the manuscript statement is the method-level source of truth; the workbook and `.mat` values are retained as provenance/audit parameters and are not relabeled as the final manuscript SCFs.

### 2. Active-power conversion convention

The manuscript Eq. (12) expresses active EVCS power as the charger allocation multiplied by rated power, SCF, and scenario multiplier, while Eq. (14) obtains reactive power from a 0.98 power factor. The legacy workbook computes its `MW` column as `(charger × rating × SCF) / 0.98 / 1000`.

**Decision:** the workbook is preserved because its values match the PowerWorld run lineage and published Table VII after rounding, but its formula is not presented as an implementation of manuscript Eq. (12).

### 3. Hybrid charger counts

The accepted manuscript reports a Hybrid installed capacity of 6.279 MW. This is exactly consistent with the integer count totals `[99, 79, 3]` for 11/60/150-kW chargers used by the supplied MATLAB/Python layout source. The legacy workbook contains fractional Hybrid row values totaling `[98.25, 77, 3]`, which is a different layout representation.

**Decision:** integer counts are canonical for charger allocation and installed capacity; the fractional workbook layout remains provenance only.

### 4. Dmax mismatch

The paper treats 1.0 km as the baseline service-distance setting and separately reports 0.5/0.8/1.2-km sensitivity cases. `evcs_data.mat` contains `Dmax = 1.674`.

**Decision:** do not use the uploaded `.mat` file to claim reproduction of the paper’s baseline Dmax result.

### 5. Objective weights

The manuscript states `w1 = w2 = w3 = 1/3` for the base case. `evcs_data.mat` contains approximately 0.33557, 0.33221, and 0.33221, and the supplied configuration loads those values when no override is set.

**Decision:** the supplementary audit is not represented as the exact final base-case optimizer.

### 6. Fixed-layout audit service ratio and bus-injection totals

The supplied fixed-layout audit CSV reports served-demand percentages of about 15.5%, 20.9%, and 15.5% and P_EVCS totals 2.41725, 5.52235, and 2.23815 MW. The accepted paper’s Table VII totals are 2.443, 5.561, and 2.215 MW.

**Decision:** both sets are retained, but only the Table VII values are placed in `data/published/`.

### 7. Plot numbering and algorithm naming

The supplied plotting filenames use an earlier internal numbering sequence (`Fig4`–`Fig9`) and sometimes label the heuristic as `BIPSO`, `HB`, or `HBIPSO-GR`. The accepted article uses BIPSO-GR and paper figures 3, 5, 6, and 7 for the corresponding plots.

**Decision:** canonical scripts follow the accepted paper numbering and algorithm name `BIPSO-GR`.

### 8. Stale verification block in the legacy workbook

The workbook states that its `Calc kW` check should agree with an appendix value to within 1%, but the populated `Diff %` cells are roughly 53–63% for the Hybrid rows. This verification note is therefore not a valid consistency check for the final publication package.

**Decision:** retain the workbook unchanged for provenance, but do not use that verification block as evidence of correctness.

### 9. DOI field in the uploaded manuscript PDF

The uploaded manuscript PDF still contains the template-style DOI placeholder, while the publication metadata supplied for this project gives DOI `10.1109/ACCESS.2026.3718247`.

**Decision:** repository citation files use the supplied final DOI; before public release, verify that the DOI resolves to the IEEE Xplore record and add volume/pages later if assigned.

## Release rule

Future edits should never overwrite `data/published/` solely to make the legacy workbook or audit outputs agree. Any substantive numerical correction to the publication record should be handled as a new version with an explicit changelog and, where appropriate, a formal article correction rather than an undocumented repository edit.
