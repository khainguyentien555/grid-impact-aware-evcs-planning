function cfg = config_fixed_layout_mpce()
%CONFIG_FIXED_LAYOUT_MPCE Configuration for MPCE fixed-layout objective audit.
% This workflow evaluates the three user-approved charger-allocation
% layouts from the thesis/GTSD tables:
%   1) B&C benchmark layout
%   2) BIPSO-GR heuristic layout
%   3) Hybrid layout
%
% The station opening pattern and charger counts are fixed exactly by the
% tables. The code then solves the best demand assignment under each fixed
% layout and exports F1, F2, F3, Z, bus-level P/Q load, runtime, and
% assignment-MIP gap.

cfg = struct();

%% Data and output
cfg.dataFile = 'evcs_data.mat';
cfg.outputDir = 'mpce_fixed_layout_outputs_v3';

%% Use 33 demand points for GTSD/MPCE paper dataset
% If evcs_data.mat contains 35 demand points including candidate-site rows
% such as CC-HH1 and CC-HH2, this option automatically removes demand
% rows whose POINTS name begins with 'CC-' and keeps LK*/BT* demand rows.
cfg.use33DemandPoints = true;
cfg.autoDropCandidateDemandRows = true;

%% Station order used in the new spreadsheet layout
% Row order in the screenshot/table:
%   CC-TM2, CC-TLC, CC-HH2, CC-TT1, CC-TM1, CC-HH1, CC-BDX, CC-TM3
% Connected buses/TBA from the user's table:
%   CC-TM2 Bus 2 T10; CC-TLC Bus 4 T14; CC-HH2 Bus 6 T13;
%   CC-TT1 Bus 8 T9; CC-TM1 Bus 10 T8; CC-HH1 Bus 13 T7;
%   CC-BDX Bus 14 T12; CC-TM3 Bus 15 T11.
cfg.CSNames = {'CC-TM2','CC-TLC','CC-HH2','CC-TT1','CC-TM1','CC-HH1','CC-BDX','CC-TM3'};
cfg.CSStationNames = cfg.CSNames;
cfg.CSConnectedBus = [2, 4, 6, 8, 10, 13, 14, 15];
cfg.CSTBA = {'T10','T14','T13','T9','T8','T7','T12','T11'};

%% Charger classes used in the paper
cfg.power3_kW = [11, 60, 150];
cfg.class3Names = {'11kW','60kW','150kW'};

% If empty, SCF3 is derived from evcs_data.mat:
%  - 11 kW  : SCF of type 1
%  - 60 kW  : EVcount-weighted SCF of types 2-5 (car/taxi)
%  - 150 kW : SCF of type 6
cfg.SCF3_manual = [];

% If empty, area3 is derived from evcs_data.mat:
%  - 11 kW  : areaT of type 1
%  - 60 kW  : EVcount-weighted areaT of types 2-5
%  - 150 kW : areaT of type 6
cfg.area3_manual = [];

%% Power-flow assumption
cfg.powerFactor = 0.98;

%% Objective weights
% If NaN, the weights are loaded from evcs_data.mat; otherwise these values
% override the data file.
cfg.w1 = NaN;
cfg.w2 = NaN;
cfg.w3 = NaN;

%% Reference scaling for normalized objective terms
% Options:
%   'filtered' : F1_ref = total filtered demand; F2/F3 refs recomputed
%   'data'     : use F1_ref, F2_ref, F3_ref from evcs_data.mat
cfg.referenceMode = 'filtered';

%% Fixed-layout assignment MILP settings
cfg.solveAssignmentMILP = true;
cfg.maxTimePerLayout = 120;      % seconds per layout
cfg.relativeGapTolerance = 1e-4; % intlinprog relative gap tolerance
cfg.integerTolerance = 1e-6;
cfg.displayMILP = 'iter';        % 'off', 'final', or 'iter'

%% Fallback greedy assignment if intlinprog is unavailable or fails
cfg.useGreedyFallback = true;

%% Numerical tolerance
cfg.tol = 1e-8;
end
