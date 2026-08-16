function T = export_fixed_bus_injection_table(results, data, cfg)
%EXPORT_FIXED_BUS_INJECTION_TABLE Export bus-level P/Q injections for PowerWorld.

rows = {};
for a = 1:numel(results)
    r = results(a);
    for c = 1:numel(cfg.CSNames)
        rows(end+1,:) = {string(r.algorithm), string(cfg.CSNames{c}), cfg.CSConnectedBus(c), ...
            r.P_by_CS_MW(c), r.Q_by_CS_MVAr(c)}; %#ok<AGROW>
    end
end

T = cell2table(rows, 'VariableNames', {'Algorithm','CS','Bus','P_EVCS_MW','Q_EVCS_MVAr'});

outPath = fullfile(cfg.outputDir, 'FixedLayout_Bus_Injections_For_PowerWorld.csv');
writetable(T, outPath);
end
