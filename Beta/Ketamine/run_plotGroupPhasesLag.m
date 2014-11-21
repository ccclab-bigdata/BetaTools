figure('position',[0 0 900 500]);
[acor,lag]=xcorr(groupPhases1,groupPhases2);
plot(lag,acor,'k');
[~,I] = max(abs(acor));
lagDiff = lag(I);
timeDiff = lagDiff/3e4;