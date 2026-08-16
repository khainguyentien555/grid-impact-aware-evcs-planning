# Data Dictionary

All canonical publication tables are in `data/published/`. Units and field meanings follow the accepted manuscript.

## `station_mapping.csv`
- `CS`: paper EVCS label (CS1–CS8).
- `StationName`: planning-site identifier.
- `ConnectedBus`: fixed 22-kV bus used in the grid model.
- `TBA`: transformer/substation label used in the feeder drawing.

## `network_branch_data.csv`
- `Branch`: feeder-section label.
- `FromBus`, `ToBus`: 16-bus model endpoints.
- `Length_km`: section length.
- `R_pu`, `X_pu`: per-unit series parameters on 100 MVA, 22 kV base.
- `ThermalRating_MVA`: continuous branch rating; the paper uses 10 MVA for all listed sections (262.4 A at 22 kV).

## `charger_allocation.csv`
- `Algorithm`: B&C, BIPSO-GR, or Hybrid.
- `Chargers_11kW`, `Chargers_60kW`, `Chargers_150kW`: integer charger counts.
- `InstalledCapacity_MW`: nameplate capacity from the integer counts.

## `bus_evcs_injections_table_vii.csv`
Published SCF-adjusted active EVCS load per connected bus. Values are reported to the precision shown in Table VII and should be treated as publication values, not recomputed from the legacy workbook.

## `scenario_definitions.csv`
Defines S1–S5 and the EVCS-only multipliers used in S4/S5.

## `grid_impact_summary_table_ix.csv`
- `Vmin_pu`: minimum solved bus voltage.
- `CriticalBranch`: branch with maximum apparent-power loading.
- `Lmax_percent`: maximum apparent-power loading relative to branch MVA rating.
- `HCM_percent`: thermal hosting-capacity margin, `100 - Lmax` for the critical branch under the paper definition.
- `CSI_percent`: contingency severity index, `max(0, Lmax - 100)`.
- `Ploss_kW`: active-power loss from the solved AC power-flow case.

## `voltage_profiles_fig5.csv`
Underlying 16-bus voltage arrays supplied with the final plotting scripts. `OutagedBus=Yes` marks the source bus removed in an N-1 case; its voltage is blank rather than represented as a physical zero.

## `branch_loading_fig7.csv`
Branch-by-branch apparent-power loading for the S2 and S3 heatmaps.

## `scf_sensitivity_table_x_plus_baseline.csv`
The 0.8 and 1.2 rows are from Table X. Baseline rho=1.0 rows are included from Table IX to make the three-level comparison machine-readable.

## `data/provenance/EVCS_Grid_Analysis_v2_legacy.xlsx`
Legacy execution workbook used in the PowerWorld data-entry lineage. It is preserved unchanged and carries version-specific assumptions documented in `SOURCE_OF_TRUTH_AUDIT.md`.

## `data/audit/*`
Outputs and source data for the supplied supplementary fixed-layout audit. These files are intentionally separated because they do not reproduce every final publication parameter/value exactly.
