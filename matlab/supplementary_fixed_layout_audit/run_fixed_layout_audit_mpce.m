%% run_fixed_layout_audit_mpce.m
% One-click workflow for fixed-layout MPCE audit.
% Put evcs_data.mat in this folder, then run:
%   run_fixed_layout_audit_mpce

clear; clc;

fprintf('=== MPCE fixed-layout audit workflow ===\n');

cfg = config_fixed_layout_mpce();
if ~exist(cfg.outputDir, 'dir')
    mkdir(cfg.outputDir);
end

data = load_fixed_layout_data(cfg.dataFile, cfg);

fprintf('\nLoaded data from: %s\n', cfg.dataFile);
fprintf('Demand points used: %d | Candidate stations: %d | Original vehicle classes: %d\n', data.nI, data.nJ, data.nK);
fprintf('Dmax = %.4f\n', data.Dmax);
fprintf('Station order used in paper:\n');
for c = 1:numel(cfg.CSNames)
    if isfield(cfg, 'CSTBA')
        fprintf('  %s -> Bus %d -> %s\n', cfg.CSStationNames{c}, cfg.CSConnectedBus(c), cfg.CSTBA{c});
    else
        fprintf('  %s -> Bus %d\n', cfg.CSStationNames{c}, cfg.CSConnectedBus(c));
    end
end
fprintf('SCF3 used: 11kW=%.4f | 60kW=%.4f | 150kW=%.4f\n', data.SCF3(1), data.SCF3(2), data.SCF3(3));
fprintf('Area3 used: 11kW=%.4f | 60kW=%.4f | 150kW=%.4f\n', data.area3(1), data.area3(2), data.area3(3));

layouts = define_fixed_layouts_mpce(cfg);

results = struct([]);

for a = 1:numel(layouts)
    fprintf('\n--- Evaluating fixed layout: %s ---\n', layouts(a).name);
    res = solve_and_evaluate_fixed_layout(data, cfg, layouts(a));
    if a == 1
        results = res;
    else
        results(a) = res;
    end
    fprintf('%s completed. Z = %.6f | F1 = %.6f | P_EVCS = %.6f MW | Total chargers = %.0f\n', ...
        results(a).algorithm, results(a).Z, results(a).F1_raw, results(a).SCF_P_MW, results(a).totalChargers);
end

fprintf('\n--- Exporting tables ---\n');
AuditTable = export_fixed_audit_table(results, data, cfg);
StationTable = export_fixed_station_table(results, data, cfg);
BusInjectionTable = export_fixed_bus_injection_table(results, data, cfg);

fprintf('\n=== Diagnostic checks ===\n');
fprintf('Range Raw F1 = %.6f\n', max([results.F1_raw]) - min([results.F1_raw]));
fprintf('Range SCF-adjusted P_EVCS = %.6f MW\n', max([results.SCF_P_MW]) - min([results.SCF_P_MW]));
fprintf('SCF-adjusted P_EVCS max/min ratio = %.6f\n', max([results.SCF_P_MW]) / max(min([results.SCF_P_MW]), eps));
fprintf('Total charger counts:\n');
for aa = 1:numel(results)
    fprintf('  %s = %.0f chargers\n', results(aa).algorithm, results(aa).totalChargers);
end

disp(AuditTable);

fprintf('\nSaved outputs in folder: %s\n', cfg.outputDir);
fprintf('Main files:\n');
fprintf('  - FixedLayout_Audit_Table.csv\n');
fprintf('  - FixedLayout_Station_Allocation.csv\n');
fprintf('  - FixedLayout_Bus_Injections_For_PowerWorld.csv\n');
fprintf('=== Done ===\n');
