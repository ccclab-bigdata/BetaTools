function [obsMeanDiff, permuteMeanDiff] = paired_permuteTest(data, varargin)
%
% usage:
%
% INPUTS:
%   data - m x 2 array, where each column is a data set. Each row is a set
%          of paired measurements.
%
% VARARGS:
%
% OUTPUTS:
%   obsMeanDiff - mean differences of the actual data
%   permuteMeanDiff - vector containing the permuted differences of the 
%                 data
%

nPermute = 5000;
nSamples = size(data, 1);

for iarg = 1 : 2 : nargin - 1
    switch lower(varargin{iarg})
        case 'npermute',
            nPermute = varargin{iarg + 1};
    end
end

% first calculate the real mean of differences
obsDiff = diff(data, 1, 2);
obsMeanDiff = nanmean(obsDiff);
permuteMeanDiff = zeros(nPermute, 1);
for iPermute = 1 : nPermute
    permuteData = NaN(nSamples, 2);
    
    swapIdx = (rand(nSamples, 1) > 0.5);
    
    for iSample = 1 : nSamples
        if swapIdx(iSample)
            permuteData(iSample, :) = fliplr(data(iSample, :));
        else
            permuteData(iSample, :) = data(iSample, :);
        end
    end
    
    permuteDiff = diff(permuteData,1, 2);
    permuteMeanDiff(iPermute) = nanmean(permuteDiff);
end