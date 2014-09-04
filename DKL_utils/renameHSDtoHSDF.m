% script to make sure .hsdf files don't also have a .hsd extension

startpath = fullfile('/Volumes', 'dan', 'sessions');

cd( startpath );

subdirs = dir;

isitasubdir = [subdirs.isdir ];
subdirs = subdirs( isitasubdir );
subdirs = subdirs( 3:end );

for i = 1 : size(subdirs, 1)
    currentdir = [startpath filesep subdirs(i).name];
    cd( currentdir );
    
    fileList = dir( '*.hsdf.hsd' );
    
    if ~isempty(fileList)
        [dummy_path, newName, ext, versn] = fileparts(fileList.name);
        movefile(fileList.name, newName);
    end
    
    cd ..
end