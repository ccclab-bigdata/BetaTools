% averaged spectrogram (upsampled) 96ch-averaged
% mean phase + std deviation of phases
% phase speed
% PDG(t)

%--------------------
% load('Filters/betaButterCoeff.mat');
% channels = 96;

% meanSnorm = [];
% for i=1:6:channels %just get representative values
%     disp(i);
%     data = NS5.Data(i,1:1e6);
%     [t,f,Snorm] = spectogramData(data,[17 45]);
%     if(i==1)
%         meanSnorm = Snorm;
%     else
%         meanSnorm = (meanSnorm+Snorm)/2;
%     end
% end

% allFiltData = [];
% allPhases = [];
% for i=1:channels
%     disp(i);
%     data = NS5.Data(i,1:1e6);
%     allFiltData(i,:) = filtfilt(SOS,G,double(data));
%     hx = hilbert(allFiltData(i,:));
%     allPhases(i,:) = atan2(imag(hx),real(hx));
% end

% meanPhases = mean(allPhases);
% diffAllPhases = diff(meanPhases')';
% stdPhases = std(allPhases);
% %--------------------

% %--------------------
% meanSnormUpsample = [];
% for i=1:size(meanSnorm,1)
%     meanSnormUpsample(i,:) = interp1(1:length(meanSnorm),meanSnorm(i,:),linspace(1,length(meanSnorm),length(data)));
% end
% imagesc(1:length(meanSnormUpsample),f,meanSnormUpsample)
% %--------------------
% 
% 
%--------------------


load('utahChannelMap.mat');
phasecMap = utahChannelMap;
allPhasecMaps = [];
allPgds = [];
allVelocityDirs = [];
allSpeeds = [];
plotRange = 1:50000;
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

hs(1) = subplot(5,1,1);
meanSpectograms = squeeze(mean(allSpectograms));
imagesc(plotRange(1):plotRange(end),f,meanSnormUpsample(:,plotRange));
title('17-45Hz Power');

hs(5) = subplot(5,1,2);
plot(allFiltData(i,plotRange));
title('Channel 1 Bandpass Filtered');

hs(2) = subplot(5,1,3);
plot(meanPhases(plotRange));
% hold on;
% errorbar(meanPhases(plotRange),stdPhases(plotRange),'r');
title('Phase (rad)');

hs(3) = subplot(5,1,4);
plot(allSpeeds(plotRange));
title('Speed (arb units)');

hs(4) = subplot(5,1,5);
plot(allPgds(plotRange));
title('PGD(t)');
ylim([0 1]);

linkaxes(hs,'x');
xlim([plotRange(1) plotRange(end)]);
