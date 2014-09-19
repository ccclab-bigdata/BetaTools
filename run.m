%plot(wavefilter(double(NS5.Data(1,1:100000)),5))
% 
% for i=1:96
%     data = double(NS5.Data(i,1:100000));
%     HPdata = wavefilter(data,5);
%     peaks = findpeaks(abs(HPdata),400);
%     rasterspikes{i}=peaks.loc'*3e-6;
% end

[t,f,Snorm]=betaspec(NS5.Data(i,1:500000));
figure;plot(t,mean(Snorm));