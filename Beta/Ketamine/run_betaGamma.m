% allMeanBeta = [];
% allSnormB = [];
% alltB = [];
% allfB = [];
% 
% allMeanGamma = [];
% allSnormG = [];
% alltG = [];
% allfG = [];
% 
% count = 1;
% step = 1e6;
% for i=1:step:length(allData)-step
%     disp([num2str((i/length(allData))*100),'%']);
%     
%     [tB,fB,SnormB] = spectogramData(allData(i:i+step),[13 30]);
%     meanBeta = mean(SnormB);
%     allMeanBeta = [allMeanBeta meanBeta];
%     allSnormB(count,:,:) = SnormB;
%     alltB = [alltB tB];
%     allfB = [allfB fB];
%     
%     [tG,fG,SnormG] = spectogramData(allData(i:i+step),[40 90]);
%     meanGamma = mean(SnormG);
%     allMeanGamma = [allMeanGamma meanGamma];
%     allSnormG(count,:,:) = SnormG;
%     alltG = [alltG tG];
%     allfG = [allfG fG];
%     
%     count=count+1;
% end
% 
% figure;
% plot(allMeanGamma,'r');
% hold on;
% plot(allMeanBeta,'b');

% figure;
% imagesc(tB,fB,SnormB);
% xlim([0 xend]);
% title('Beta 13-30Hz');
% ylabel('frequency');
% xlabel('Time (s)');

step=5000;
t=[];
%allMeanBetaNorm = normalize(allMeanBeta);
for i=1:step:length(allMeanBeta)-step
    t = [t std(allMeanGamma(i:i+step))];
end
figure;
bar(t);