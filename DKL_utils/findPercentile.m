function pctl_val = findPercentile(data, percentile)

if ndims(data) > 2
    disp('data should be a vector or 2-dimensional matrix');
    pctl_val = [];
    return;
end

if percentile <= 0 || percentile > 1
    disp('percentile should be between 0 and 1');
end

if numel(data) == size(data, 2)
    data = data';   % if a vector, make 'data' a column vector
end
    
[sortVals] = sort(data);

pctl_idx = ceil(size(data, 1) * percentile);

pctl_val = sortVals(pctl_idx, :);
    