function T = export_fixed_audit_table(results, data, cfg)
%EXPORT_FIXED_AUDIT_TABLE Write summary audit table.

n = numel(results);
Algorithm = strings(n,1);
RawF1 = zeros(n,1); RawF2 = zeros(n,1); RawF3 = zeros(n,1);
F1hat = zeros(n,1); F2hat = zeros(n,1); F3hat = zeros(n,1);
Z = zeros(n,1); ServedDemand_percent = zeros(n,1);
ActiveStations = zeros(n,1); TotalChargers = zeros(n,1);
Total_11kW = zeros(n,1); Total_60kW = zeros(n,1); Total_150kW = zeros(n,1);
InstalledCapacity_MW = zeros(n,1);
SCF_Adjusted_P_EVCS_MW = zeros(n,1);
SCF_Adjusted_Q_EVCS_MVAr = zeros(n,1);
HHI_LoadConcentration = zeros(n,1);
Runtime_s = zeros(n,1); AssignmentMIPGap_percent = zeros(n,1);
UnservedDemand = zeros(n,1); DistanceViolationCount = zeros(n,1); MaxCapacityViolation = zeros(n,1);
SolverMode = strings(n,1);

for a = 1:n
    r = results(a);
    Algorithm(a) = string(r.algorithm);
    RawF1(a) = r.F1_raw;
    RawF2(a) = r.F2_raw;
    RawF3(a) = r.F3_raw;
    F1hat(a) = r.F1_hat;
    F2hat(a) = r.F2_hat;
    F3hat(a) = r.F3_hat;
    Z(a) = r.Z;
    ServedDemand_percent(a) = 100*r.servedRatio;
    ActiveStations(a) = sum(r.status_CS);
    TotalChargers(a) = r.totalChargers;
    Total_11kW(a) = r.countsByClass(1);
    Total_60kW(a) = r.countsByClass(2);
    Total_150kW(a) = r.countsByClass(3);
    InstalledCapacity_MW(a) = r.installed_MW;
    SCF_Adjusted_P_EVCS_MW(a) = r.SCF_P_MW;
    SCF_Adjusted_Q_EVCS_MVAr(a) = r.SCF_Q_MVAr;
    HHI_LoadConcentration(a) = r.HHI;
    Runtime_s(a) = r.runtime_s;
    AssignmentMIPGap_percent(a) = r.mipGap_percent;
    UnservedDemand(a) = r.unservedDemand;
    DistanceViolationCount(a) = r.distanceViolationCount;
    MaxCapacityViolation(a) = r.maxCapacityViolation;
    SolverMode(a) = string(r.solverMode);
end

T = table(Algorithm, RawF1, RawF2, RawF3, F1hat, F2hat, F3hat, Z, ...
    ServedDemand_percent, ActiveStations, TotalChargers, Total_11kW, Total_60kW, Total_150kW, ...
    InstalledCapacity_MW, SCF_Adjusted_P_EVCS_MW, SCF_Adjusted_Q_EVCS_MVAr, ...
    HHI_LoadConcentration, Runtime_s, AssignmentMIPGap_percent, ...
    UnservedDemand, DistanceViolationCount, MaxCapacityViolation, SolverMode);

outPath = fullfile(cfg.outputDir, 'FixedLayout_Audit_Table.csv');
writetable(T, outPath);
end
