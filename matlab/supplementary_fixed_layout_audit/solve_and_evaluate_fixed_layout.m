function result = solve_and_evaluate_fixed_layout(data, cfg, layout)
%SOLVE_AND_EVALUATE_FIXED_LAYOUT Solve assignment under a fixed station/charger layout.

result = empty_fixed_result();
result.algorithm = layout.name;
result.shortName = layout.shortName;
result.counts3_CS = layout.counts3_CS;
result.status_CS = layout.status_CS(:);

% Convert CS order to data.STATIONS order.
counts3_data = zeros(data.nJ,3);
y_data = false(data.nJ,1);
for c = 1:numel(data.csToDataStationIdx)
    j = data.csToDataStationIdx(c);
    counts3_data(j,:) = layout.counts3_CS(c,:);
    y_data(j) = layout.status_CS(c);
end
result.counts3_data = counts3_data;
result.y_data = y_data;

% Solve assignment.
tStart = tic;
if cfg.solveAssignmentMILP && exist('intlinprog','file') == 2
    try
        [x, solverInfo] = solve_assignment_milp(data, cfg, counts3_data, y_data);
        result.solverMode = 'fixed-layout assignment MILP';
    catch ME
        warning('Assignment MILP failed for %s: %s', layout.name, ME.message);
        if cfg.useGreedyFallback
            [x, solverInfo] = greedy_assignment_fixed(data, cfg, counts3_data, y_data);
            result.solverMode = 'greedy fallback';
        else
            rethrow(ME);
        end
    end
else
    [x, solverInfo] = greedy_assignment_fixed(data, cfg, counts3_data, y_data);
    result.solverMode = 'greedy fallback';
end
result.runtime_s = toc(tStart);
result.x = x;
result.exitflag = solverInfo.exitflag;
result.output = solverInfo.output;
if isfield(solverInfo, 'mipGap_percent')
    result.mipGap_percent = solverInfo.mipGap_percent;
end

% Evaluate metrics.
result = compute_fixed_metrics(data, cfg, result);
end
