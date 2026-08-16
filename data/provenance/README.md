# Provenance files

This directory intentionally contains working/execution artifacts that are **not** treated as the final manuscript method definition.

- `EVCS_Grid_Analysis_v2_legacy.xlsx` — supplied PowerWorld input/output workbook. Its exact MW/Mvar rows were used to create `powerworld_inputs_from_legacy_workbook.csv` for machine-readable provenance.
- `powerworld_inputs_from_legacy_workbook.csv` — long-format extraction of the 15 × 8 bus P/Q entries from the workbook, preserved without methodological reinterpretation.

The workbook’s SCF values and MW formula differ from the final manuscript formulation; see `../../docs/SOURCE_OF_TRUTH_AUDIT.md`.
