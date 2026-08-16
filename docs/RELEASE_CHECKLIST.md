# Public Release Checklist

Before pushing this package to a public GitHub repository:

- [ ] Obtain co-author agreement on the repository release.
- [ ] Select/approve the final code and data licenses (see `LICENSE_NOTICE.md`).
- [ ] Confirm that the DOI `10.1109/ACCESS.2026.3718247` resolves to the final IEEE Access record and update volume/pages if IEEE later assigns them.
- [ ] Run `python python/validate_published_data.py`.
- [ ] Run `python python/run_all_figures.py` in a clean Python environment.
- [ ] Open at least one PWB case from each scenario family in PowerWorld Simulator and confirm it loads correctly.
- [ ] Review PowerWorld binary metadata before public release; proprietary case formats can retain creator/save metadata.
- [ ] Do not upload the IEEE-formatted article PDF unless the authors have confirmed the applicable redistribution terms; use the DOI link instead.
- [ ] Create a GitHub release/tag `v1.0.0` and archive that exact version (e.g., Zenodo) if a citable dataset/software DOI is desired.
