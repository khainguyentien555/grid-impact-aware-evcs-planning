function result = compute_fixed_metrics(data, cfg, result)
%COMPUTE_FIXED_METRICS Compute F1/F2/F3/Z and grid-injection metrics.

x = double(result.x > 0.5);
counts3_data = result.counts3_data;
counts3_CS = result.counts3_CS;

% F1 served demand.
F1_raw = sum(sum(x .* data.D));

% Station load for F2.
stationLoad = zeros(data.nJ,1);
for j = 1:data.nJ
    stationLoad(j) = sum(data.D .* x(:,j));
end
F2_raw = 0;
for j = 1:data.nJ-1
    for k = j+1:data.nJ
        F2_raw = F2_raw + abs(stationLoad(j) - stationLoad(k));
    end
end

% F3 land/stall area based on fixed 3-class charger counts.
F3_raw = sum(sum(counts3_data .* data.area3));

F1_hat = F1_raw / data.F1_ref;
F2_hat = F2_raw / data.F2_ref;
F3_hat = F3_raw / data.F3_ref;
Z = -data.w1*F1_hat + data.w2*F2_hat + data.w3*F3_hat;

% Charger and installed capacity.
countsByClass = sum(counts3_CS, 1);
totalChargers = sum(countsByClass);
installed_kW_by_CS = counts3_CS * data.power3(:);
installed_MW = sum(installed_kW_by_CS) / 1000;

% SCF-adjusted P/Q by CS.
P_kW_by_CS = counts3_CS * (data.power3(:) .* data.SCF3(:));
P_by_CS_MW = P_kW_by_CS / 1000;
Q_by_CS_MVAr = P_by_CS_MW * tan(acos(cfg.powerFactor));
SCF_P_MW = sum(P_by_CS_MW);
SCF_Q_MVAr = sum(Q_by_CS_MVAr);

% HHI concentration by CS based on P_EVCS.
if SCF_P_MW > 0
    share = P_by_CS_MW / SCF_P_MW;
    HHI = sum(share.^2);
else
    HHI = NaN;
end

% Violations.
assignedClassDemand = zeros(data.nJ,3);
for j = 1:data.nJ
    for c = 1:3
        assignedClassDemand(j,c) = sum(data.typeDemand3(:,c) .* x(:,j));
    end
end
capViolation = max(assignedClassDemand - counts3_data, 0);
maxCapacityViolation = max(capViolation(:));

violDist = 0;
for i = 1:data.nI
    for j = 1:data.nJ
        if x(i,j) > 0.5 && data.dist(i,j) > data.Dmax + cfg.tol
            violDist = violDist + 1;
        end
    end
end

result.stationLoad = stationLoad;
result.assignedClassDemand = assignedClassDemand;
result.F1_raw = F1_raw;
result.F2_raw = F2_raw;
result.F3_raw = F3_raw;
result.F1_hat = F1_hat;
result.F2_hat = F2_hat;
result.F3_hat = F3_hat;
result.Z = Z;
result.servedRatio = F1_raw / max(data.totalDemand, eps);
result.totalChargers = totalChargers;
result.countsByClass = countsByClass;
result.installed_MW = installed_MW;
result.SCF_P_MW = SCF_P_MW;
result.SCF_Q_MVAr = SCF_Q_MVAr;
result.P_by_CS_MW = P_by_CS_MW(:).';
result.Q_by_CS_MVAr = Q_by_CS_MVAr(:).';
result.HHI = HHI;
result.unservedDemand = max(data.totalDemand - F1_raw, 0);
result.distanceViolationCount = violDist;
result.maxCapacityViolation = maxCapacityViolation;
end
