# Supplementary fixed-layout MATLAB audit

This folder preserves the MATLAB workflow supplied with the repository inputs. It is useful for auditing fixed integer charger layouts, assignment feasibility, objective components, concentration, and SCF-adjusted bus injections under the parameters stored in `evcs_data.mat`.

It is **not labeled as the exact original optimizer/reproducer for the accepted IEEE Access paper** because the supplied `.mat` parameter set differs from the final manuscript in several important respects (Dmax, objective weights, SCF representation), and its exported P_EVCS totals do not equal Table VII.

See `../../docs/SOURCE_OF_TRUTH_AUDIT.md`.

To run in MATLAB, execute `run_fixed_layout_audit_mpce`. A copy of `evcs_data.mat` is included here because the uploaded configuration expects it in the working directory.
