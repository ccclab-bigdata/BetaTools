function RecreateFile(zfile,nsxfile,window)

if(nargin == 0 || isempty(zfile))
    zfile = 'Z_Iron Man_2013-04-05_Run-001';
end

if(nargin < 2 || isempty(nsxfile))
    nsxfile = 'sensorytasklateral003.ns5';
end

if(nargin < 3 || isempty(window))
    window = [-30000,0];
end



load(zfile);
z = z([z.GoodTrial] & arrayfun(@(x)length(x.ExperimentTime),z)==[z.TrialTimeoutms]); %#ok<NODEF>
for i=1:length(z)
    disp(i)
    timewindow = [z(i).CerebusTimeStart + window(1), z(i).CerebusTimeStop + window(2)];
    for chan1 = 1:8:88
        chan2 = chan1+7;
        disp([chan1,chan2])
        neuraldata = openNSx('read',nsxfile,['c:' num2str(chan1) ':' num2str(chan2)],['t:' num2str(timewindow(1)) ':' num2str(timewindow(2))]);
%         size(neuraldata)
        OutputNeuralData(neuraldata.Data);
        pause(2);
    end
end
    