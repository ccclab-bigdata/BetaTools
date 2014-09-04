function filename_array=get_multiple_filenames(current_path, FigureName)
%function filename_array=get_multiple_filenames
%filename_array=get_multiple_filenames()
%A GUI to select multiple input files

%Author: Murat Okatan, 02-11-2003

%version 5. Return filename_array as a cell array not char array.
%version 4. CD only to a valid directory. If the last item in manual entry is a directory
%   update the entry so that the last item is *.*.
%version 3. Make the folder indicator editable.
%version 2. Use extension, which is part of current_path
%version 1. get multiple filenames

%Extract extension information
[pathstr,name,ext,versn] = fileparts(current_path);
ud.file_selector=sprintf('%s%s', name, ext);

%Default return value
ud.filename_array=[];
filename_array=[];

%Create a modal figure
bgcolor=[1 1 1]/4;
W=1/2;
H=1/2;
fg=figure('WindowStyle', 'normal', ...
          'NumberTitle', 'off', ...
          'Name', FigureName, ...
          'Units', 'normalized', ...
          'Position', [(1-W)/2 (1-H)/2 W H], ...
          'Color', bgcolor);

%current_path='.';

%Put a listbox
listbox_x=0.05;
listbox_y=0.1;
listbox_w=1-2*listbox_x;
listbox_h=1-2*listbox_y;
Pos=[listbox_x listbox_y listbox_w listbox_h];
listbox_top=listbox_y+listbox_h;
listbox_right=listbox_x+listbox_w;
ud.file_listbox_title_handle= uicontrol('Parent', fg, ...
                                     'Units', 'normalized', ...
                                     'Position', ...
                                        [listbox_x listbox_top listbox_w min(0.05, listbox_y)], ...
                                     'String', 'Files', ...
                                     'Style', 'edit', ...
                                     'HorizontalAlignment', 'left', ...
                                     'BackgroundColor', bgcolor, ...
                                     'ForegroundColor', [1 0 0], ...
                                     'Callback', {@file_listbox_title_callback});

ud.file_listbox_handle= uicontrol('Parent', fg, ...
                               'Units', 'normalized', ...
                               'Position', Pos, ...
                               'String', '', ...
                               'Style', 'listbox', ...
                               'HorizontalAlignment', 'left', ...
                               'BackgroundColor', bgcolor, ...
                               'ForegroundColor', [1 1 0], ...
                               'Min', 1, ...
                               'Max', 1000, ...
                               'Callback', {@file_listbox_callback});
%Put an OK button                          
button_w=0.1;
button_h=listbox_y*0.7;
button_separation=button_w;

ok_box_x=listbox_right-2*button_w-button_separation;
ok_box_y=(listbox_y-button_h)/2;

Pos=[ok_box_x ok_box_y button_w button_h];

ud.ok_pushbutton_handle= uicontrol(  'Parent', fg, ...
                                     'Units', 'normalized', ...
                                     'Position', Pos, ...
                                     'String', 'OK', ...
                                     'Style', 'pushbutton', ...
                                     'HorizontalAlignment', 'center', ...
                                     'BackgroundColor', bgcolor*2, ...
                                     'ForegroundColor', 'k', ...
                                     'Callback', {@gmf_ok_pushbutton_callback});
                                 
%Put a Cancel button                          
Pos=Pos+[1 0 0 0]*(button_separation+button_w);
ud.cancel_pushbutton_handle=uicontrol('Parent', fg, ...
                                      'Units', 'normalized', ...
                                      'Position', Pos, ...
                                      'String', 'Cancel', ...
                                      'Style', 'pushbutton', ...
                                      'HorizontalAlignment', 'center', ...
                                      'BackgroundColor', bgcolor*2, ...
                                      'ForegroundColor', 'k', ...
                                      'Callback', {@gmf_cancel_pushbutton_callback});

%Populate listbox                                                      
load_listbox(current_path, fg, ud);

%Wait until 
waitfor(ud.file_listbox_handle, 'Tag', 'Done');

if ishandle(fg),
	%At this point, the selection is over. Get it from ud.
	ud=get(fg, 'UserData');
	filename_array=ud.filename_array';
	
	%Close the interface
	close(fg);
else
    return;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file_listbox_title_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function file_listbox_title_callback(eventSrc, eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');
    
    %What is entered
    entry=get(gcbo, 'String');
    if isempty(entry),
        return;
    end
    
    %Parse it
	[pathstr, name, ext, versn] = fileparts(entry);	
    
    %If the name is not empty, check whether the last item
    %in the entry is actually a folder.
    if ~isempty(name),
        testfolder=fullfile(entry, '*.*');
        if ~isempty(dir(testfolder))
            %Yes, it indeed is a folder, so, use testfolder as the entry
            entry=testfolder;
            %Parse it again
    		[pathstr, name, ext, versn] = fileparts(entry);	
        end
    end
    
	if isempty(pathstr)
        if isunix,
            pathstr='/';
        else
            close(fg);        
            return;
        end
	end
    if ~isempty(dir(pathstr)),
    	cd(pathstr);
    end

    %Extract the file selector
    ud.file_selector=sprintf('%s%s', name, ext);
    if isempty(ud.file_selector),
        ud.file_selector='*.*';        
    end
    
    %Store it
    set(fg, 'UserData', ud);
    
    %Populate listbox                                                      
	load_listbox(entry, fg, ud);
    

%%%%%%%%%%%%%%%%%%%%%%%%%
% file_listbox_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%
function file_listbox_callback(eventSrc, eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');
    
    switch get(fg,'SelectionType')
        case 'open'
			index_selected = get(ud.file_listbox_handle,'Value');
            if length(index_selected)>1,
                return;
            end
			file_list = get(ud.file_listbox_handle,'String');	
			filename = file_list{index_selected};
			if  ud.is_dir(ud.sorted_index(index_selected))
				cd(filename);
				ud=load_listbox(fullfile(pwd, ud.file_selector), fg, ud);
			else
			   [path,name,ext,ver] = fileparts(filename);
               if isunix,
                   ud.filename_array={sprintf('%s/%s', ...
                       pwd, filename)};
               elseif ispc,
                   ud.filename_array={sprintf('%s\\%s', ...
                       pwd, filename)};
               end
               set(fg, 'UserData', ud);
               set(gcbo, 'Tag', 'Done');
		   end	
    end %switch get(fg,'SelectionType')

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gmf_ok_pushbutton_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gmf_ok_pushbutton_callback(eventSrc, eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');
    
	index_selected = get(ud.file_listbox_handle,'Value');
	file_list = get(ud.file_listbox_handle,'String');	

    %Init output
    ud.filename_array={};
    
    counter=1;
    for i=1:length(index_selected),
        j=index_selected(i);
    	filename = file_list{j};
        
		if  ud.is_dir(ud.sorted_index(j))
            continue;
		else
           if isunix,
               ud.filename_array(counter)={sprintf('%s/%s', pwd, filename)};
           elseif ispc,
               ud.filename_array(counter)={sprintf('%s\\%s', pwd, filename)};
           end
           counter=counter+1;
		end	
    end
%    ud.filename_array=char(ud.filename_array);
    set(fg, 'UserData', ud);
    set(ud.file_listbox_handle, 'Tag', 'Done');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gmf_cancel_pushbutton_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gmf_cancel_pushbutton_callback(eventSrc, eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');
    
    ud.filename_array=[];
    set(fg, 'UserData', ud);
    set(ud.file_listbox_handle, 'Tag', 'Done');
    
% ------------------------------------------------------------
% Read the current directory and sort the names
% ------------------------------------------------------------
%%%%%%%%%%%%%%%%
% load_listbox %
%%%%%%%%%%%%%%%%
function ud=load_listbox(dir_path, fg, ud)

[pathstr,name,ext,versn] = fileparts(dir_path);

if isempty(pathstr)
    if isunix,
        pathstr='/';
    else
        close(fg);        
        return;
    end
end

dir_struct = dir(pathstr);
if isempty(dir_struct),
    %This is not a valid path. Show nothing
	set(ud.file_listbox_handle,'String','',...
		'Value',1);
	set(ud.file_listbox_title_handle,'String', 'Invalid path');
	
	%Save stuff and wait for user input
	set(fg, 'UserData', ud);
	return;
end

cd(pathstr);

%Select the directories
dir_indx=find([dir_struct.isdir]==1);
if ~isempty(dir_indx),
    dir_struct_dir = dir_struct(dir_indx);
else
    dir_struct_dir = [];    
end

%Now select the matching files
dir_struct = dir(dir_path);
if ~isempty(dir_struct),
    file_indx=find([dir_struct.isdir]==0);
else
    file_indx=[];
end
if ~isempty(file_indx),
    dir_struct_file = dir_struct(file_indx);
else
    dir_struct_file = [];
end

%Merge them
dir_struct=[dir_struct_dir;dir_struct_file];

[sorted_names,sorted_index] = sortrows(char({dir_struct.name}'));
ud.file_names = cellstr(sorted_names);
ud.is_dir = [dir_struct.isdir];
ud.sorted_index = [sorted_index];
set(ud.file_listbox_handle,'String',ud.file_names,...
	'Value',1);
set(ud.file_listbox_title_handle,'String', fullfile(pwd, ud.file_selector));

%Save stuff and wait for user input
set(fg, 'UserData', ud);


return;

%Show only directories and files with matching extensions
if ~isempty(ud.extension),
    
    num_of_files=length(dir_struct);
    valids=zeros(1, num_of_files);
    for i=1:num_of_files,
        [pathstr,name,ext,versn] = fileparts(dir_struct(i).name);
        if 0,
        end
    end
end
