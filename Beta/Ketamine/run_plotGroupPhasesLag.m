figure('position',[0 0 900 500]);
% [acor,lag]=xcorr(groupPhasesS1,groupPhasesM1);
[acor,lag]=xcorr(meanPhasesS1,mean(run001_phasesM1));
plot(lag,acor,'k');
[~,I] = max(abs(acor));
lagDiff = lag(I);
timeDiff = lagDiff/3e4