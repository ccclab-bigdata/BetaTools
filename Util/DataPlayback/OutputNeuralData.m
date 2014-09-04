function [  ] = OutputNeuralData( Data )
%UNTITLED Summary of this function goes here
%   Expects Data to be columns of channels

persistent s;

if(size(Data,1)<size(Data,2))
    Data = Data';
end

if(size(Data,2) ~= 8)
    throw(MException('OutputNeuralData:BadInput','I am just a dumb function, and really expect 8 columns in my input'));
end
Data = (20/65536)*double(Data);
Data = [Data, ones(size(Data,1),1)];
Data(end) = 0;


if(isempty(s))
    s = daq.createSession('ni');
    s.Rate = 30000;
    s.addAnalogOutputChannel('Dev1',0:7,'Voltage');
    s.addDigitalChannel('Dev1','port0/line0','OutputOnly');
end

s.queueOutputData(Data);
s.startForeground;

% s.close();


end

