function [sampleF, permuteF, p] = RMpermuteANOVA(data, varargin)
%
% usage:
%
% INPUTS:
%   data - m x n array, where each row is a set of measurements for a
%       single subject, and each column represents a different condition (a
%       different test session, for example)
%
% OUTPUTS:
%

nPermute = 5000;

for iarg = 1 : 2 : nargin - 1
    switch lower(varargin{iarg})
        case {'nboot','npermute'}
            nPermute = varargin{iarg + 1};
    end
end


m = size(data, 1); n = size(data, 2);
% first, calculate the F-statistic for the data as presented
sampleF = anovaF(data);

permuteF = zeros(nPermute, 1);
permData = zeros(m, n);
for iPermute = 1 : nPermute
    
    for iSubject = 1 : m
        permData(iSubject, :) = data(iSubject, randperm(n));
    end
    permuteF(iPermute) = anovaF(permData);
    
end

numOutliers = length(find(permuteF > sampleF));

p = numOutliers / nPermute;