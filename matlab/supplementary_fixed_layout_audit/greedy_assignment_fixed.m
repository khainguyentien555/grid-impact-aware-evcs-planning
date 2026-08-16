function [x, info] = greedy_assignment_fixed(data, cfg, counts3_data, y_data)
%GREEDY_ASSIGNMENT_FIXED Fallback nearest feasible assignment under class capacities.

nI = data.nI; nJ = data.nJ;
x = zeros(nI,nJ);
remaining = counts3_data;
[~, order] = sort(data.D, 'descend');

for idx = 1:numel(order)
    i = order(idx);
    candidates = find(y_data(:).' & data.dist(i,:) <= data.Dmax + cfg.tol);
    if isempty(candidates)
        continue;
    end
    [~, sortIdx] = sort(data.dist(i,candidates), 'ascend');
    candidates = candidates(sortIdx);
    req = data.typeDemand3(i,:);
    for jj = 1:numel(candidates)
        j = candidates(jj);
        if all(remaining(j,:) + cfg.tol >= req)
            x(i,j) = 1;
            remaining(j,:) = remaining(j,:) - req;
            break;
        end
    end
end

info = struct();
info.exitflag = 0;
info.output = struct('message','Greedy fallback used');
info.mipGap_percent = NaN;
end
