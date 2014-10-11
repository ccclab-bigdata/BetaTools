function locs=absPeakDetection(data)
% uses absolute value
[~,locs] = findpeaks(data.*-1,'minpeakheight',200,'minpeakdistance',60,'threshold',5);

%     figure;
%     plot(data);
%     hold on;
%     
%     for i=1:length(locs);
%         plot(locs(i),data(locs(i)),'o');
%     end
%     % plot all the spikes as sanity check
%     figure;
%     all = [];
%     for i=1:length(locs)
%         hold on;
%         plot(data(1,locs(i)-20:locs(i)+20));
%         all(i,:) = data(1,locs(i)-20:locs(i)+20);
%     end

disp(strcat('spikes: ',int2str(length(locs))));