function [m, n] = getAxesIdx(numCols, plotNum)
%
% usage:
%
% INPUTS:
%
% OUTPUTS:
%   m
%   n

m = ceil(plotNum / numCols);
n = rem(plotNum, numCols);

if n == 0; n = numCols; end;