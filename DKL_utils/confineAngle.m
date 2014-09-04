function y = confineAngle( x )
%
% usage: newAngle = confineAngle( x )
%
% function to take an angle (in radians) outside of +/- pi and convert it
% to an angle between +/- pi
%
% inputs: x - array of values to move
%
% output: y - array of values where x has been moved to within +/-
%             pi

n = floor(x / (2*pi));
y = x - n*2*pi;

% now have numbers between 0 and 2pi
y_lowerHalf = (y > pi);   % indices of y values between pi and 2pi
y(y_lowerHalf) = y(y_lowerHalf) - 2*pi;