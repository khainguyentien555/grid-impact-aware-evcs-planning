function data = load_fixed_layout_data(dataFile, cfg)
%LOAD_FIXED_LAYOUT_DATA Load evcs_data.mat and prepare the 33-point paper dataset.

if ~isfile(dataFile)
    error('Cannot find %s. Put evcs_data.mat in the same folder as this script.', dataFile);
end

S = load(dataFile);
required = {'D','EVcount','dist','Dmax','maxCharger','powerT','areaT','SCF'};
for r = 1:numel(required)
    if ~isfield(S, required{r})
        error('evcs_data.mat is missing required variable: %s', required{r});
    end
end

data = struct();

data.D = S.D(:);
data.EVcount = S.EVcount;
data.dist = S.dist;
data.Dmax = S.Dmax;
data.maxCharger = S.maxCharger;
data.powerT_original = S.powerT(:).';
data.areaT_original = S.areaT(:).';
data.SCF_original = S.SCF(:).';

if isfield(S, 'POINTS')
    data.POINTS = S.POINTS(:);
else
    data.POINTS = arrayfun(@(i) sprintf('P%d', i), (1:numel(data.D)).', 'UniformOutput', false);
end
if isfield(S, 'STATIONS')
    data.STATIONS = S.STATIONS(:);
else
    data.STATIONS = arrayfun(@(j) sprintf('Station%d', j), (1:size(data.dist,2)).', 'UniformOutput', false);
end
if isfield(S, 'TYPES')
    data.TYPES = S.TYPES(:);
else
    data.TYPES = arrayfun(@(k) sprintf('Type%d', k), (1:size(data.EVcount,2)).', 'UniformOutput', false);
end

% Initial dimensions
[data.nI, data.nK] = size(data.EVcount);
[data.nI_dist, data.nJ] = size(data.dist);
if data.nI ~= data.nI_dist || numel(data.D) ~= data.nI
    error('D, EVcount, and dist have inconsistent demand-point dimensions.');
end
if size(data.maxCharger,1) ~= data.nJ || size(data.maxCharger,2) ~= data.nK
    error('maxCharger size must be nStation x nType.');
end

% Optional 33-point filtering.
if isfield(cfg, 'use33DemandPoints') && cfg.use33DemandPoints
    if data.nI ~= 33
        keep = true(data.nI,1);
        if isfield(cfg, 'autoDropCandidateDemandRows') && cfg.autoDropCandidateDemandRows
            names = string(data.POINTS);
            % Candidate-site rows commonly begin with CC-. The 33-point GTSD/MPCE
            % planning layer uses LK*/BT* demand points and excludes CC-* rows.
            keep = ~startsWith(names, "CC-");
        end
        if sum(keep) == 33
            fprintf('Filtering demand points from %d to 33 by removing candidate-site rows.\n', data.nI);
            data.D = data.D(keep);
            data.EVcount = data.EVcount(keep,:);
            data.dist = data.dist(keep,:);
            data.POINTS = data.POINTS(keep);
        else
            warning(['Requested 33 demand points, but automatic filtering produced %d rows. ', ...
                     'No filtering is applied. Please edit load_fixed_layout_data.m or cfg manually.'], sum(keep));
        end
    end
end

% Update dimensions after filtering
[data.nI, data.nK] = size(data.EVcount);
[data.nI_dist, data.nJ] = size(data.dist);

% Weights
if isfield(S, 'w1'), data.w1 = S.w1; else, data.w1 = 0.3333; end
if isfield(S, 'w2'), data.w2 = S.w2; else, data.w2 = 0.3333; end
if isfield(S, 'w3'), data.w3 = S.w3; else, data.w3 = 0.3333; end
if ~isnan(cfg.w1), data.w1 = cfg.w1; end
if ~isnan(cfg.w2), data.w2 = cfg.w2; end
if ~isnan(cfg.w3), data.w3 = cfg.w3; end

% Original type-specific effective demand.
data.typeDemand6 = data.EVcount .* data.SCF_original;
D_from_types = sum(data.typeDemand6, 2);
if numel(data.D) ~= numel(D_from_types) || norm(data.D - D_from_types, 1) > 1e-4 * max(norm(data.D,1),1)
    warning(['D is not exactly equal to sum(EVcount.*SCF,2). ', ...
             'The code will use D from evcs_data.mat for F1/F2, and EVcount.*SCF for class capacity checks.']);
end

% Collapse original 6 vehicle/charger types into 3 paper charger classes:
% class 1: motorbike / 11 kW -> type 1
% class 2: car + taxi / 60 kW -> types 2-5
% class 3: bus / 150 kW -> type 6
if data.nK < 6
    error('This fixed-layout workflow expects 6 original EV/charger types. Found %d.', data.nK);
end

data.typeDemand3 = zeros(data.nI,3);
data.typeDemand3(:,1) = data.typeDemand6(:,1);
data.typeDemand3(:,2) = sum(data.typeDemand6(:,2:5), 2);
data.typeDemand3(:,3) = data.typeDemand6(:,6);

% SCF3 for grid injections.
if ~isempty(cfg.SCF3_manual)
    data.SCF3 = cfg.SCF3_manual(:).';
else
    weights60 = sum(data.EVcount(:,2:5), 1);
    if sum(weights60) > 0
        scf60 = sum(weights60 .* data.SCF_original(2:5)) / sum(weights60);
    else
        scf60 = mean(data.SCF_original(2:5));
    end
    data.SCF3 = [data.SCF_original(1), scf60, data.SCF_original(6)];
end

% Area3 for F3.
if ~isempty(cfg.area3_manual)
    data.area3 = cfg.area3_manual(:).';
else
    weights60 = sum(data.EVcount(:,2:5), 1);
    if sum(weights60) > 0
        area60 = sum(weights60 .* data.areaT_original(2:5)) / sum(weights60);
    else
        area60 = mean(data.areaT_original(2:5));
    end
    data.area3 = [data.areaT_original(1), area60, data.areaT_original(6)];
end

data.power3 = cfg.power3_kW(:).';
data.totalDemand = sum(data.D);

% Reference values for normalized objective terms.
switch lower(cfg.referenceMode)
    case 'data'
        if isfield(S, 'F1_ref'), data.F1_ref = S.F1_ref; else, data.F1_ref = max(data.totalDemand,1); end
        if isfield(S, 'F2_ref'), data.F2_ref = S.F2_ref; else, data.F2_ref = max(data.totalDemand * nchoosek(data.nJ,2), 1); end
        if isfield(S, 'F3_ref'), data.F3_ref = S.F3_ref; else, data.F3_ref = max(sum(sum(data.maxCharger)) * mean(data.area3),1); end
    otherwise
        data.F1_ref = max(data.totalDemand, 1);
        data.F2_ref = max(data.totalDemand * nchoosek(data.nJ,2), 1);
        % F3 reference: use maximum possible aggregate station capacity in
        % original maxCharger collapsed into 3 classes if possible.
        max3 = zeros(data.nJ,3);
        max3(:,1) = data.maxCharger(:,1);
        max3(:,2) = sum(data.maxCharger(:,2:5), 2);
        max3(:,3) = data.maxCharger(:,6);
        data.F3_ref = max(sum(sum(max3 .* data.area3)), 1);
end

% Build mapping from manuscript CS order to data.STATIONS order.
data.csToDataStationIdx = zeros(numel(cfg.CSStationNames),1);
stationNames = string(data.STATIONS);
for c = 1:numel(cfg.CSStationNames)
    idx = find(strcmpi(strtrim(stationNames), strtrim(string(cfg.CSStationNames{c}))), 1);
    if isempty(idx)
        error('Cannot find station %s from cfg.CSStationNames in data.STATIONS.', cfg.CSStationNames{c});
    end
    data.csToDataStationIdx(c) = idx;
end

data.connectedBusByCS = cfg.CSConnectedBus(:);
end
