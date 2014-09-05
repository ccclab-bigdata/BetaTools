function [ vector ] = SARMS( vector )
% function [ vector ] = SARMS( vector )
%   Stark and Abeles-style RMS: point-by-point square, low-pass to 100Hz,
%   downsample to 500 Hz, point-by-point square root

if(~isvector(vector))
    throw(MException('SARMS:NotVector','SARMS requires a vector input'));
end

% Point-by-point squaring
vector = vector.^2;

% Running average (matched to a 3-dB corner frequency of SA's 100Hz filter,
% counting the "squaring" of the filter response by using filtfilt)
vector = filtfilt(ones(1,49)/49,1,vector);

% Downsample to 500 Hz (30000/500 = 60)
vector = downsample(vector,60,30);

% Point-by-point square root
vector = sqrt(vector);

end

