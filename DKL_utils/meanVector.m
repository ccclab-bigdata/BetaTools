function [meanVec] = meanVector(theta, rho)
%
% usage: [meanVector] = meanVector(theta, rho)
%
% function to calculate a mean vector given a list of angles and vector
% lengths

[x,y] = pol2cart(theta, rho);
meanVec(1) = mean(x);
meanVec(2) = mean(y);