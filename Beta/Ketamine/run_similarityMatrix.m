% allData = [];
% allData(1,:,:) = data_20140916_140408_002_ns4;
% allData(2,:,:) = data_20140916_144027_001_ns5;
% allData(3,:,:) = data_20140916_144027_002_ns5;
% allData(4,:,:) = data_20140916_144027_003_ns5;
% allData(5,:,:) = data_20140916_144027_004_ns5;
% allData(6,:,:) = data_20140916_144027_005_ns5;
% allData(7,:,:) = data_20140916_144027_006_ns5;
% allData(8,:,:) = data_20140916_144027_007_ns5;
% allData(9,:,:) = data_20140916_144027_008_ns5;
% allData(10,:,:) = data_20140916_144027_009_ns5;
% allData(11,:,:) = data_20140916_144027_010_ns5;
% allData(12,:,:) = data_20140916_144027_011_ns5;
allData=allMatrices;
ii=size(allData,1);
diffMatrix = zeros(ii);
for i=1:ii
    data1=squeeze(allData(i,:,:));
    for j=1:ii
        data2=squeeze(allData(j,:,:));
        diffMatrix(i,j) = mean(mean(std(data1-data2)));
    end
end

figure;
imagesc(diffMatrix);
colorbar;
colormap(gray);

% figure;
% for i=1:ii
%     data1=squeeze(allData(i,:,:));
%     plot(i,mean(data1(:)),'o');
%     hold on;
% end