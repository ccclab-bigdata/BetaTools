function betaIntervals = initBetaIntervals()

intLimits.start_indx = [];
intLimits.end_indx = [];

threshold = initThreshold();

betaIntervals(1).Fs = [];
betaIntervals(1).final = intLimits;
betaIntervals(1).prelim = intLimits;
betaIntervals(1).threshold = threshold;

betaIntervals(1).channel.lfpFile = '';
betaIntervals(1).channel.subject = '';
betaIntervals(1).channel.date = '';
betaIntervals(1).channel.tetrode.name = '';
betaIntervals(1).channel.location.name = '';
betaIntervals(1).channel.location.subclass = '';
betaIntervals(1).channel.location.ml = 0;
betaIntervals(1).channel.location.ap = 0;
betaIntervals(1).channel.location.dv = 0;
betaIntervals(1).channel.repWire = 0;

betaIntervals(1).firstIntervals = intLimits;
betaIntervals(1).noiseIntervals = intLimits;
betaIntervals(1).HVS = intLimits;