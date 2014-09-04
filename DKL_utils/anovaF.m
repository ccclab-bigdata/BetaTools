function F = anovaF(data)
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

m = size(data, 1);
n = size(data, 2);
numSamps = m * n;

groupMeans = nanmean(data, 1);
overallMean = nanmean(reshape(data, numSamps, 1));

bg_ss = 0;
wg_ss = 0;
totalObs = 0;
for iGroup = 1 : n
    validIdx = find(~isnan(data(:, iGroup)));
    numObs = length(validIdx);
    totalObs = totalObs + numObs;
    bg_ss = bg_ss + numObs * (groupMeans(iGroup) - overallMean)^2;
    for iObs = 1 : numObs
        wg_ss = wg_ss + (data(validIdx(iObs), iGroup) - groupMeans(iGroup))^2;
    end
end

Fnum = bg_ss / (n - 1);
Fden = wg_ss / (totalObs - n);

F = Fnum / Fden;