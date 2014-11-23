% NSx = openNSx('read');
plot(NSx.Data(1,:));
disp('Select start/stop points of clean data...');
[x,~]=ginput;
x = round(x);
disp(['data length:',num2str(x(2)-x(1))]);

dataM1=NSx.Data(1:16,x(1):x(2));
dataS1=NSx.Data(end-15:end,x(1):x(2));

usefilter = '13-30Hz_butter_30kHz.mat';
[phasesS1,filtDataS1] = extractBandpassPhase(dataS1,usefilter);
[phasesM1,filtDataM1] = extractBandpassPhase(dataM1,usefilter);

data = zeros(16);
for s1i=1:16
    for m1i=1:16
        [r,p] = corrcoef(phasesS1(s1i,:),phasesM1(m1i,:));
        data(s1i,m1i) = r(1,2);
    end
end

figure;
imagesc(data);
colorbar;
caxis([min(data(:)) max(data(:))]);
xlabel('M1');
ylabel('S1');
title(strcat('20140916-144027-011.ns5,x1=',num2str(x(1)),',x2=',num2str(x(2))));

data_20140916_144027_011_ns5 = data;