function [Znew] = getMUAData(Z, datafile, tempdir, lowFreq, hiFreq)

if (~all(isfield(Z, {'CerebusTimeStart', 'CerebusTimeStop'})))
    error('Z Struct must contain CerebusTimeStart/Stop fields.');
end

[filepath, filename, fileext] = fileparts(datafile);
tempfile = fullfile(tempdir, [filename fileext]);
if (exist(tempfile, 'file') ~= 2)
    status = copyfile(datafile, tempfile);
    if (~status)
        error('Couldn''t copy file to the local drive. Check space/permissions.');
    end
end

splitfile(tempfile); %split into separate channels
filterfiles(tempfile, lowFreq, hiFreq); %filter each channel
[data, time] = combinefilteredfiles(lowFreq, hiFreq, tempfile); % get data matrix/cerebus times
z = timesyncrmswithexperiment(Z, data, time);

Znew = z;

save(fullfile(filepath, [filename sprintf('_MUA%d-%d.mat', lowFreq, hiFreq)]), 'z', '-v7.3');

end