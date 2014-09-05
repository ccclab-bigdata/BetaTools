function [ z ] = timesyncrmswithexperiment( z,rms_data,time)
%function [ z ] = timesyncrmswithexperiment( z,rms_data,time,samplestocut )
%   This is a simple function that puts the RMS values for MUA
%   activity for each channel into a z struct, based on Cerebus times.
%   Resulting field is nxc, where c is the number of channels (usually 96),
%   and n = .5*length(z(i).ExperimentTime). The MUATime field contains
%   experiment timestamps for each MUA sample.

for i = 1:length(z)
    z(i).MUAActivity = rms_data(((time >= z(i).CerebusTimeStart) & (time <= z(i).CerebusTimeStop)),:);
end

end

