function [vcdf, varargout] = vincentize(data, quantiles, varargin)
%
% usage:
%
% INPUTS:
%   data - cell array of vectors containing data to be vincentized. Each
%       vector in the cell array is one data set
%   quantiles - vector of quantiles at which to calculate the Vincentized
%      distribution
%
% OUTPUTS:
%   vcdf - the Vincentized cdf
%
% 

numSets = length(data);
numQuantiles = length(quantiles);

quantiles = double(quantiles);

makePlot = false;
h_axes = [];
indWidth = 1;
meanWidth = 2;
for iarg = 1 : 2 : nargin - 2
    switch lower(varargin{iarg})
        case 'makeplot',
            makePlot = varargin{iarg + 1};
        case 'axes',
            h_axes = varargin{iarg + 1};
        case 'indwidth',
            indWidth = varargin{iarg + 1};
        case 'meanwidth',
            meanWidth = varargin{iarg + 1};
    end
end

validData = {};
numValidSets = 0;
for iSet = 1 : numSets
%     iSet
%     if iSet > numSets; break; end
    
    if ~isempty(data{iSet})
        numValidSets = numValidSets + 1;
        validData{numValidSets} = data{iSet};
    end
        
%         if iSet < numSets
%             for new_iSet = iSet : numSets-1
%                 data{new_iSet} = data{new_iSet+1};
%             end
%         end
%         numSets = numSets - 1;
%     end
    
end

interp_cdf = zeros(numValidSets, numQuantiles);

for iSet = 1 : numValidSets
    
    [data_cdf, x_cdf] = ecdf(double(validData{iSet}));
    interp_cdf(iSet, :) = interp1(data_cdf, x_cdf, quantiles);
    
end

vcdf = nanmean(interp_cdf, 1);

if makePlot
    
    if isempty(h_axes)
        figure;
    else
        axes(h_axes);
    end
    
    for iSet = 1 : numValidSets
        
        plot(interp_cdf(iSet, :), quantiles, 'color', 'k', 'linewidth', indWidth);
        hold on
        
    end
    plot(vcdf, quantiles, 'color', 'r', 'linewidth', meanWidth);
    
end

varargout{1} = interp_cdf;