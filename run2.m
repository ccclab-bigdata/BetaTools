for i=1:64
    data = double(NS5.Data(i,:));
    HPdata = wavefilter(data,5);
    allData(i,:) = HPdata/1000;
end

ddt_write_v(fullfile('C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data',...
        'starkDatach1-64.ddt'),64,length(HPdata),3e4,allData);