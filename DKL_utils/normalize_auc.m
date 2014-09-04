function data_out = normalize_auc(data_in)
%
% usage: 
%
% function to normalize a set of histograms to have the same area under the
% curve.
%
% INPUTS:
%   data_in - m x n array where each row is a set of histogram values.
%
% OUTPUTS:
%   data_out

m = size(data_in, 1);
n = size(data_in, 2);

rowSums = sum(data_in, 2);

data_out = zeros(size(data_in));
for iRow = 1 : m
    data_out(iRow, :) = data_in(iRow, :) ./ rowSums(iRow);
end