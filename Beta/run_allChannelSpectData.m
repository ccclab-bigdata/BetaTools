function [allSpect,t,f]=run_allChannelSpectData(NS5,channels,samples,freqRange)
    allSpect = [];
    for i=1:length(channels)
        [t,f,Snorm] = spectogramData(NS5.Data(channels(i),samples),freqRange);
        allSpect(channels(i),:) = mean(Snorm);
    end
    
%     figure;
%     for i=1:length(channels)
%         plot(allSpect(channels(i),:));
%         hold on;
%     end

