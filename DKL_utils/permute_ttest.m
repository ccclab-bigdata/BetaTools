function [p] = permute_ttest(x1, x2, varargin)
%
% usage: [p] = permute_ttest(x1, x2, varargin)
%
% INPUTS:
%   x1, x2 - vectors containing values to be compared
%
% OUTPUTS:
%   p - p-value testing the null hypothesis that the means of x1 and x2 are
%       the same
%
% VARARGs:
%   'npermute' - number of permutations to perform

nPermute = 20000;
for iarg = 1 : 2 : nargin - 2
    switch lower(varargin{iarg})
        case 'npermute',
            nPermute = varargin{iarg + 1};
    end
end

% check that x1 and x2 are column vectors
if numel(x1) > size(x1, 1); x1 = x1'; end
if numel(x2) > size(x2, 1); x2 = x2'; end

n1 = length(x1); n2 = length(x2); n = n1 + n2;
x = [x1;x2];
sampleMeanDiff = mean(x1) - mean(x2);
permuteDiffs   = zeros(1, n);
for iPermute = 1 : nPermute
    
    idx1 = randperm(n, n1);
    idx1_vec = false(1, n);
    idx1_vec(idx1) = true;
    idx2_vec = ~idx1_vec;
    
    permuteDiffs(iPermute) = mean(x(idx1_vec)) - mean(x(idx2_vec));
    
end
    
permuteDiffs = sort(permuteDiffs);

% find the percentile in the permutation differences at which the sample
% mean lies
numLessThanSampleMean = length(find(permuteDiffs < sampleMeanDiff));
p = numLessThanSampleMean / nPermute;

if p > 0.5; p = 1 - p; end