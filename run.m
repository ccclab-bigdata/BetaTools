sampleStart = zNew(1,1).CerebusTimeStart;
sampleStop = zNew(1,end).CerebusTimeStop;
meanSnorm = [];
for i=1:16:channels %just get representative values
    disp(i);
    data = NS5.Data(i,sampleStart:sampleStop);
    [t,f,Snorm] = spectogramData(data,[13 30]);
    if(i==1)
        meanSnorm = Snorm;
    else
        meanSnorm = (meanSnorm+Snorm)/2;
    end
end
% 
% meanSnormUpsample = [];
% for i=1:size(meanSnorm,1)
%     meanSnormUpsample(i,:) = interp1(1:length(meanSnorm),meanSnorm(i,:),linspace(1,length(meanSnorm),length(fingerVector)));
% end
% imagesc(1:length(meanSnormUpsample),f,meanSnormUpsample)


%zNew=SyncZNEV(z,1,1)
% figure;
% fingerVector = makeFingerVector(zNew);
% fingerVectorD = round(fingerVector);
% hs(1)=subplot(2,1,1);
% plot(fingerVectorD);
% ylim([-.1 1.1])
% 
% hs(2)=subplot(2,1,2);
% imagesc(0:length(fingerVector),f(5:35),meanSnormUpsample(5:35,:));
% linkaxes(hs,'x');

% 
% zTrialStarts = getZTrialStarts(zNew);
% [ppks,plocs] = findpeaks(diff(fingerVectorD));
% [npks,nlocs] = findpeaks(diff(fingerVectorD*-1));
% hs(2)=subplot(2,1,2);
% plot(diff(fingerVectorD),'k');
% hold on;
% plot(plocs,ppks,'o');
% hold on;
% plot(nlocs,npks*-1,'o','color','red');

% for i=1:length(zTrialStarts)
%     hold on;
%     hx = graph2d.constantline(zTrialStarts(i),'Color','m');
%     changedependvar(hx,'x');
% end


