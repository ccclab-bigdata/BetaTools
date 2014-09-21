function locs=absPeakDetection(data)
    %data = wavefilter(double(NS5.Data(1,4500:5000)),5);
    [~,locs]=findpeaks(abs(data),'minpeakheight',300,'minpeakdistance',60,'threshold',5);
    
% %     figure;
% %     plot(data);
% %     hold on;
% %     
% %     for i=1:length(locs);
% %         plot(locs(i),data(locs(i)),'o');
% %     end
% %     % plot all the spikes as sanity check
% %     figure;
% %     for i=1:length(locs)
% %         hold on;
% %         plot(data(1,locs(i)-20:locs(i)+20));
% %     end

    disp(strcat('spikes: ',int2str(length(locs))));
end