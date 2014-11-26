function filenames=fileList(dir,files)
    filenames = {};
    for i=1:length(files)
        filenames{i} = fullfile(dir,files(i).name);
    end
end