function diffMatrix=dispKetamineMatrix(allMatrices)
    allMatrices = allMatrices;
    ii=size(allMatrices,1);
    diffMatrix = zeros(ii);
    for i=1:ii
        data1=squeeze(allMatrices(i,:,:));
        for j=1:ii
            data2 = squeeze(allMatrices(j,:,:));
            diffMatrix(i,j) = mean(mean(std(data1-data2)));
        end
    end

    figure;
    imagesc(diffMatrix);
    colorbar;
    colormap(gray);
    
    line(repmat([138],1,1086),1:1086,'color','r','LineWidth',2);
    line(1:1086,repmat([138],1,1086),'color','r','LineWidth',2);
    
%     figure;
%     plot(theta_diffMatrix(end,:),'b');
%     hold on;plot(beta_diffMatrix(end,:),'k');
%     hold on;plot(gamma_diffMatrix(end,:),'m');
%     legend('theta','beta','gamma');
%     hold on;line(repmat([138],1,1086),linspace(0,.45,1086),'color','r','LineWidth',2);
%     xlim([1 1085]);
end