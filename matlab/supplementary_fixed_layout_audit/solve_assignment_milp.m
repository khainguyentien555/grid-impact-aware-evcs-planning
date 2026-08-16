function [x, info] = solve_assignment_milp(data, cfg, counts3_data, y_data)
%SOLVE_ASSIGNMENT_MILP Best assignment for fixed y and fixed charger counts.

nI = data.nI; nJ = data.nJ;

% Variable blocks
nx = nI*nJ;
nL = nJ;
pairs = nchoosek(1:nJ,2);
nu = size(pairs,1);

idxX = @(i,j) (j-1)*nI + i;
idxL = @(j) nx + j;
idxU = @(p) nx + nL + p;
nVar = nx + nL + nu;

% Objective: min -w1*F1hat + w2*F2hat + constant F3hat.
f = zeros(nVar,1);
for j = 1:nJ
    for i = 1:nI
        f(idxX(i,j)) = -data.w1 * data.D(i) / data.F1_ref;
    end
end
for p = 1:nu
    f(idxU(p)) = data.w2 / data.F2_ref;
end

% Bounds
lb = zeros(nVar,1);
ub = inf(nVar,1);
ub(1:nx) = 1;
ub(nx+1:nx+nL) = data.totalDemand;
ub(nx+nL+1:end) = data.totalDemand;

% x forced off if station closed or distance exceeds Dmax.
for j = 1:nJ
    for i = 1:nI
        if ~y_data(j) || data.dist(i,j) > data.Dmax + cfg.tol
            ub(idxX(i,j)) = 0;
        end
    end
end

% Integer x
intcon = 1:nx;

% A, b construction with conservative sparse preallocation.
A_rows = {};
b_vals = [];

% Each demand point assigned to at most one station.
for i = 1:nI
    row = sparse(1,nVar);
    for j = 1:nJ
        row(idxX(i,j)) = 1;
    end
    A_rows{end+1,1} = row;
    b_vals(end+1,1) = 1;
end

% Class capacity constraints: sum_i typeDemand3(i,c)*x_ij <= N_jc.
for j = 1:nJ
    for c = 1:3
        row = sparse(1,nVar);
        for i = 1:nI
            row(idxX(i,j)) = data.typeDemand3(i,c);
        end
        A_rows{end+1,1} = row;
        b_vals(end+1,1) = counts3_data(j,c);
    end
end

% Pairwise deviation constraints:
% L_j - L_k - u_jk <= 0
% L_k - L_j - u_jk <= 0
for p = 1:nu
    j = pairs(p,1); k = pairs(p,2);
    row = sparse(1,nVar);
    row(idxL(j)) = 1; row(idxL(k)) = -1; row(idxU(p)) = -1;
    A_rows{end+1,1} = row; b_vals(end+1,1) = 0;

    row = sparse(1,nVar);
    row(idxL(k)) = 1; row(idxL(j)) = -1; row(idxU(p)) = -1;
    A_rows{end+1,1} = row; b_vals(end+1,1) = 0;
end

A = vertcat(A_rows{:});
b = b_vals;

% Equalities: L_j = sum_i D_i*x_ij
Aeq = sparse(nJ,nVar);
beq = zeros(nJ,1);
for j = 1:nJ
    Aeq(j,idxL(j)) = 1;
    for i = 1:nI
        Aeq(j,idxX(i,j)) = -data.D(i);
    end
end

opts = optimoptions('intlinprog', ...
    'Display', cfg.displayMILP, ...
    'MaxTime', cfg.maxTimePerLayout, ...
    'RelativeGapTolerance', cfg.relativeGapTolerance, ...
    'IntegerTolerance', cfg.integerTolerance);

[z,~,exitflag,output] = intlinprog(f, intcon, A, b, Aeq, beq, lb, ub, opts);

if isempty(z)
    error('intlinprog did not return a solution.');
end

xvec = z(1:nx);
x = reshape(xvec, [nI,nJ]);
x = double(x > 0.5);

info = struct();
info.exitflag = exitflag;
info.output = output;
info.mipGap_percent = NaN;
if isfield(output, 'relativegap')
    info.mipGap_percent = output.relativegap;
elseif isfield(output, 'absolutegap')
    info.mipGap_percent = NaN;
end
end
