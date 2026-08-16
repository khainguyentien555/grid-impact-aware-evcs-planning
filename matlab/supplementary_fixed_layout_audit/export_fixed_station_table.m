function T = export_fixed_station_table(results, data, cfg)
%EXPORT_FIXED_STATION_TABLE Export charger allocation and P/Q by CS.

rows = {};
for a = 1:numel(results)
    r = results(a);
    for c = 1:numel(cfg.CSNames)
        status = 'Closed';
        if r.status_CS(c)
            status = 'Open';
        end
        rows(end+1,:) = {string(r.algorithm), string(cfg.CSNames{c}), string(cfg.CSStationNames{c}), ...
            cfg.CSConnectedBus(c), string(status), ...
            r.counts3_CS(c,1), r.counts3_CS(c,2), r.counts3_CS(c,3), sum(r.counts3_CS(c,:)), ...
            r.P_by_CS_MW(c), r.Q_by_CS_MVAr(c)}; %#ok<AGROW>
    end
end

T = cell2table(rows, 'VariableNames', {'Algorithm','CS','StationName','ConnectedBus','Status', ...
    'Chargers_11kW','Chargers_60kW','Chargers_150kW','TotalChargers', ...
    'P_EVCS_MW','Q_EVCS_MVAr'});

outPath = fullfile(cfg.outputDir, 'FixedLayout_Station_Allocation.csv');
writetable(T, outPath);
end
