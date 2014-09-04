% script to make session folders

targetDir = fullfile('/Volumes','dan','sessions');

cd(targetDir)

baseName = 'D12';
startDate = [2009 08 12];
endDate = [2009 9 3];

numDays = datenum(endDate) - datenum(startDate);

for i = 0 : numDays
    i
    
    curDate = datevec(datenum(startDate) + i);
    if curDate(3) < 10
        dayStr = ['0' num2str(curDate(3))];
    else
        dayStr = num2str(curDate(3));
    end
    if curDate(2) < 10
        monthStr = ['0' num2str(curDate(2))];
    else
        monthStr = num2str(curDate(2));
    end
    yearStr = num2str(curDate(1));
    
    dirName = [baseName yearStr monthStr dayStr];

    mkdir(dirName);
    
end    % end for i...