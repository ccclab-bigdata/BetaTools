% %ketamine comes in at piece 191, 191/5=38
% max([BIC1(:),BIC2(:),BIC3(:)])
% min([BIC1(:),BIC2(:),BIC3(:)])
% 
% %all length=38
% BIC1=squeeze(mean(BIC(1:38,:,:)));
% BIC2=squeeze(mean(BIC(39:76,:,:)));
% BIC3=squeeze(mean(BIC(77:114,:,:)));
% BIC4=squeeze(mean(BIC(115:152,:,:)));
% 
% h=figure('position',[0 0 400 400]);
% imagesc(f(fIdx),f(fIdx),BIC1);
% colormap(hot);
% colorbar;
% caxis([25 40]);
% xlabel('f1');
% ylabel('f2');
% title('BIC1');


% B1=squeeze(mean(B(120:130,:,:)));
% B2=squeeze(mean(B(39:76,:,:)));
% B3=squeeze(mean(B(77:114,:,:)));
% B4=squeeze(mean(B(115:152,:,:)));

% h=figure('position',[0 0 400 400]);
% imagesc(f(fIdx),f(fIdx),B1);
% colormap(hot);
% colorbar;
% caxis([min(min([B1])) max(max([B1]))]);
% %caxis([min(min([B1 B2 B3 B4])) max(max([B1 B2 B3 B4]))]);
% xlabel('f1');
% ylabel('f2');
% title('B1');

%B
allMean=[];
step=1;
for i=1:step:length(B)-step
    curB = squeeze(B(i:i+step,16,16));
    allMean = [allMean mean(curB(curB~=0))];
end
figure; bar(allMean); ylim([min(allMean)-1 max(allMean)+1]);
figure; plot(medfilt1(allMean,10));


%BIC(y,x)
%TRY ON OTHER CHANNELS
% allMean=[];
% step=1;
% for i=1:step:length(BIC)-step
%     curBIC = squeeze(BIC(i:i+step,:,:));
%     allMean = [allMean mean(curBIC(curBIC~=0))];
% end
% figure; bar(allMean); ylim([min(allMean)-1 max(allMean)+1]);



% meanBeta=[];
% meanGamma=[];
% step=1;
% for i=1:step:length(BIC)-step
%     %12-20 Hz 4:10
%     betaBIC = squeeze(BIC(i:i+step,4:10,:));
%     meanBeta = [meanBeta mean(betaBIC(betaBIC~=0))];
%     %35-60 Hz 23:45
%     gammaBIC = squeeze(BIC(i:i+step,23:45,:));
%     meanGamma = [meanGamma mean(gammaBIC(gammaBIC~=0))];
% end
% betaOnGamma = meanBeta./meanGamma;
% figure;
% bar(betaOnGamma);
% ylim([min(betaOnGamma)-.1 max(betaOnGamma)+.1])
% title('Beta/Gamma Bicoherence');