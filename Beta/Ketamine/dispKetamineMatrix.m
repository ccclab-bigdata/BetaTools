function dispKetamineMatrix(allMatrices)
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
end