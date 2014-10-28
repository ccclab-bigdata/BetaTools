% % averaged spectrogram (upsampled) 96ch-averaged
% % mean phase + std deviation of phases
% % phase speed
% % PDG(t)
% 
% channels = 5;
% allSpectograms = [];
% allFiltData = [];
% allPhases = [];
% 
% for i=1:channels
%     disp(i);
%     data = NS5.Data(i,1:1e5);
%     [t,f,Snorm] = spectogramData(data,[17 45]);
%     for j=1:size(Snorm,1)
%         allSpectograms(i,j,:) = interp1(1:length(Snorm),Snorm(j,:),linspace(1,length(Snorm),length(data))); %upsample
%     end
%     allFiltData(i,:) = filtfilt(SOS,G,double(data));
%     hx = hilbert(allFiltData(i,:));
%     allPhases(i,:) = atan2(imag(hx),real(hx));
% end
% 
% % channels = 96;
phasecMap = utahChannelMap;
allPhasecMaps = [];
allPgds = [];
allVelocityDirs = [];
allSpeeds = [];
plotRange = 1:5000;
for j=plotRange;%length(allPhases)
    for i=1:channels
        [y,x] = find(utahChannelMap==i);
        phasecMap(x,y) = allPhases(i,j);
    end
    allPhasecMaps(j,:,:) = phasecMap;
    phaseGradient = gradient(phasecMap);
    pgd = abs(nanmean(phaseGradient(:)))/nanmean(abs(phaseGradient(:)));
    allPgds(j) = pgd;
    
    if(j-1>0)
        speed = abs(mean(diffAllPhases(:,j-1)))/nanmean(abs(phaseGradient(:)));
        allSpeeds(j) = speed;
    end
    
%     velocityDir=-nanmean(phaseGradient(:));
%     allVelocityDirs(j)=velocityDir;
end

h1=figure('position',[50,50,900,900]);

hs(1) = subplot(4,1,1);
meanSpectograms = squeeze(mean(allSpectograms));
imagesc(plotRange(1):plotRange(end),f,meanSpectograms(:,plotRange));
title('17-45Hz Power');

hs(2) = subplot(4,1,2);
meanPhases = mean(allPhases);
stdPhases = std(allPhases);
bar(meanPhases(plotRange));
hold on;
errorbar(meanPhases(plotRange),stdPhases(plotRange),'r');
title('Phase (rad)');

hs(3) = subplot(4,1,3);
plot(allSpeeds(plotRange));
title('Speed (arb units)');

hs(4) = subplot(4,1,4);
plot(allPgds(plotRange));
title('PGD(t)');

linkaxes(hs,'x');
xlim([plotRange(1) plotRange(end)]);
