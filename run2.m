% [B,I]=sort(meanBeta);
% I=fliplr(I');
% scatter(1:length(I),I) %pick all the Y-vals separated, from the left

%peakBeta is spectogram data from ch28 over 9e6 samples
peakBeta = [2902,2376,1801,4625,3377,4235,2138,1583,1064,573];

allSpects = {};
for i=1:length(peakBeta)
    disp(i)
    [p1,p2]=scaleAndRange(peakBeta(i),9e6,5991,3e4*4); %+/-1second
    [allSpects{i},t,f]=run_allChannelSpectData(NS5,[1:96],[p1:p2],[17,40]);
    %now we have 96 channels of beta data +/-1second
end

meanAllSpect=[];
for i=1:length(allSpects)
    if(i==1)
        meanAllSpect = allSpects{1};
    else
        meanAllSpect = (meanAllSpect+allSpects{i})/2;
    end
%     figure;
%     for j=1:size(allSpects{i},1)
%         spect = allSpects{i};
%         plot(spect(j,:));
%         hold on;
%     end
end

figure
for i=1:96
    plot(meanAllSpect(i,:));
    hold on;
end
