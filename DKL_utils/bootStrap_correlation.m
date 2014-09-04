function [rho] = bootStrap_correlation(x, y, numIterations)
%
% function to calculate correlation coefficients between x and y where y
% gets scrambled numIterations times to generate confidence limits to test
% the significance of correlations

if length(x) ~= length(y)
    disp('x and y must be the same length');
    rho = [];
    return;
end

rho = zeros(numIterations, 1);

for i = 1 : numIterations
    y_idx = randperm(length(y));
    
    cc = corrcoef(x, y(y_idx));
    rho(i) = cc(1,2);
end