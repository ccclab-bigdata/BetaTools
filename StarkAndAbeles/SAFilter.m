function [ vector ] = SAFilter( vector, low, high, srate )
%function [ vector ] = SAFilter( vector, low, high, srate )
%   SAFilter does a "Stark and Abeles-style" filtering of the input vector.
%I can't swear how accurate it is to S&A - I'm using a 3rd order (6-pole)
%Butterworth whereas they claim to use a 3-pole (which MATLAB can't make).
%Also, I'm filtfiltering (both directions) for zero phase lag, so
%essentially we're talking a 6th order or 12-pole filter.  Whatever.  It
%filters out everything but frequencies between low and high, which default
%to 600 and 3k.  Also, srate (sample rate) defaults to 30k, but should be
%set if 
if(~isvector(vector))
    throw(MException('SAFilter:NotVector','SAFilter requires a vector input'));
end

%Default values
if(nargin < 2 || isempty(low))
    low = 300;
end
if(nargin < 3 || isempty(high))
    high = 6000;
end
if(nargin < 4 || isempty(srate))
    srate = 30000;
end

% Calculate butterworth passband and corresponding parameters
window = [low high] / (srate/2);
[B, A] = butter(3,window,'bandpass');

% Actually apply the filter
vector = filtfilt(B,A,vector);

end

