# Paper-to-Code / Data Map

| Paper element | Canonical repository source | Reproduction path |
|---|---|---|
| Table I — study system / EVCS-to-bus mapping | `data/published/station_mapping.csv` | direct data |
| Table II — 22 kV branch data | `data/published/network_branch_data.csv` | direct data |
| Fig. 3 — charger allocation | `data/published/charger_allocation.csv` | `python/plot_fig3_charger_allocation.py` |
| Table V — planning indicators | `data/published/planning_layout_indicators.csv` | direct data |
| Table VI — S2 planning-to-grid comparison | `data/published/planning_to_grid_s2_table_vi.csv` | direct data |
| Table VII — bus EVCS active-power injections | `data/published/bus_evcs_injections_table_vii.csv` | direct publication values |
| Table VIII — Dmax sensitivity | `data/published/dmax_sensitivity_table_viii.csv` | direct data |
| Fig. 5 — voltage profiles | `data/published/voltage_profiles_fig5.csv` | `python/plot_fig5_voltage_profiles.py` |
| Table IX — 15 AC power-flow cases | `data/published/grid_impact_summary_table_ix.csv` + PowerWorld cases | solve `.PWB` cases / compare CSV |
| Fig. 6 — maximum loading S1–S5 | Table IX CSV | `python/plot_fig6_scenario_loading.py` |
| Fig. 7 — S2/S3 branch heatmaps | `data/published/branch_loading_fig7.csv` | `python/plot_fig7_n1_heatmaps.py` |
| Table X — SCF sensitivity | `data/published/scf_sensitivity_table_x_plus_baseline.csv` | direct data; rho=1.0 added from Table IX |

Fig. 1 (feeder drawing), Fig. 2 (method workflow), and Fig. 4 (schematic EVCS-to-bus mapping) are presentation schematics; no original drawing-generation source was supplied in this file set. Their underlying numeric mapping/network data are provided in the CSV files above.
