function [Fs_array, Gain_array]=getdata_eeg_open(filename_array, default)

%version 4. Filename_array is now a cell array.
%version 3. Use an argument to control whether a box is edit or text. If we show
%   Fs and Gain data from a .mat file, we do not want that to be modifiable by the user.
%version 2. USe vectorized defaults.
%version 1. An interface to get the Fs and Gain for input files

%Author: Murat Okatan 02/12/2003

    %How many files?
    num_of_files=size(filename_array, 1);
    ud.num_of_files=num_of_files;
    
    %Save default return values
    ud.Fs_array=default.Fs;
    ud.Gain_array=default.Gain;
    ud.edit_box=default.edit_box;
    
    %Assignment values
    meanFs=mean(default.Fs);
    diffFs=abs(default.Fs-meanFs);
    closest=min(find(diffFs==min(diffFs)));
    assign_Fs=default.Fs(closest);
    
    meanGain=mean(default.Gain);
    diffGain=abs(default.Gain-meanGain);
    closest=min(find(diffGain==min(diffGain)));
    assign_Gain=default.Gain(closest);
    
    %How long is the longest filename
    max_length=max(size(filename_array, 2), length('Assign to all:'));

	%Create a modal figure
	bgcolor=[1 1 1]/4;
    W=0.6;
    H=0.4;
    h_scale=0.9/W;
    v_scale=0.9/H;
    
	FH=figure('WindowStyle', 'normal', ...
              'NumberTitle', 'off', ...
              'Units', 'normalized', ...
              'Position', [(1-W)/2 (1-H)/4 W H], ...
              'Name', 'Enter Sampling Rate and Gain', ...
	   		  'DoubleBuffer', 'on', ...
			  'BackingStore', 'off', ...
              'Color', bgcolor);

	%Put a slider uicontrol
	scroll_x=0.97;
	ud.Scroller=uicontrol('Style', 'slider', ...
                       'Parent', FH, ...
                       'Units', 'normalized', ...
                       'Position', [scroll_x 0 1-scroll_x 1], ...
                       'Min', 0, ...
                       'Max', 1, ...
                       'Value', 1, ...
                       'SliderStep', [0.01, 0.1], ...
                       'Callback', {@ScrollerCallback});                             

          
    %Assume 1 char is 0.007 normalized units wide
    %Create edit boxes
    file_box_w=min(max_length*0.007, 0.8)*h_scale;
    box_h=0.02*v_scale;
    box_separation_h=0.01*h_scale;
    box_separation_v=0.005*v_scale;
    v_margins=0.02*h_scale;
    box_w=min(0.07, (scroll_x-file_box_w-2*box_separation_h-2*v_margins)/2)*h_scale;

    file_box_x=v_margins;
    Fs_box_x=file_box_x+file_box_w+box_separation_h;
    Gain_box_x=Fs_box_x+box_w+box_separation_h;

    %Put column titles
    %Compute the y coords for titles
    box_title_y=(1-box_h);
    
    ud.file_boxes_title=...
        uicontrol('Parent', FH, ...
                  'Units', 'normalized', ...
                  'Position', ...
                      [file_box_x box_title_y file_box_w box_h], ...
                  'String', 'File', ...
                  'Style', 'text', ...
                  'HorizontalAlignment', 'center', ...
                  'BackgroundColor', bgcolor*1.2, ...
                  'ForegroundColor', [1 1 1]);
    
    ud.Fs_boxes_title=...
        uicontrol('Parent', FH, ...
                  'Units', 'normalized', ...
                  'Position', ...
                      [Fs_box_x box_title_y box_w box_h], ...
                  'String', 'Sampling Rate (Hz)', ...
                  'Style', 'text', ...
                  'HorizontalAlignment', 'center', ...
                  'BackgroundColor', bgcolor*1.2, ...
                  'ForegroundColor', [1 1 1]);
              
    ud.Gain_boxes_title=...
        uicontrol('Parent', FH, ...
                  'Units', 'normalized', ...
                  'Position', ...
                      [Gain_box_x box_title_y box_w box_h], ...
                  'String', 'Gain', ...
                  'Style', 'text', ...
                  'HorizontalAlignment', 'center', ...
                  'BackgroundColor', bgcolor*1.2, ...
                  'ForegroundColor', [1 1 1]);

    %Put "Assign to all" edit boxes
    assign_box_y=(1-box_h*2-box_separation_v);
    
    ud.assign_boxes_label=...
        uicontrol('Parent', FH, ...
                  'Units', 'normalized', ...
                  'Position', ...
                      [file_box_x assign_box_y file_box_w box_h], ...
                  'String', 'Assign to all:', ...
                  'Style', 'text', ...
                  'HorizontalAlignment', 'right', ...
                  'BackgroundColor', bgcolor, ...
                  'ForegroundColor', [1 0 0]);
    
    ud.Fs_assign_box=...
        uicontrol('Parent', FH, ...
                  'Units', 'normalized', ...
                  'Position', ...
                      [Fs_box_x assign_box_y box_w box_h], ...
                  'String', num2str(assign_Fs), ...
                  'Style', 'edit', ...
                  'HorizontalAlignment', 'center', ...
                  'BackgroundColor', bgcolor*1.1, ...
                  'ForegroundColor', 'c', ...
                  'Callback', {@assign_Fs_callback});
              
    ud.Gain_assign_box=...
        uicontrol('Parent', FH, ...
                  'Units', 'normalized', ...
                  'Position', ...
                      [Gain_box_x assign_box_y box_w box_h], ...
                  'String', num2str(assign_Gain), ...
                  'Style', 'edit', ...
                  'HorizontalAlignment', 'center', ...
                  'BackgroundColor', bgcolor*1.1, ...
                  'ForegroundColor', 'c', ...
                  'Callback', {@assign_Gain_callback});
    
    %Compute the y coords of boxes              
    box_y=(assign_box_y-box_separation_v-box_h)-[0:num_of_files-1]*(box_separation_v+box_h);              
    
    for i=1:num_of_files,
        ud.file_boxes(i)=...
            uicontrol('Parent', FH, ...
                      'Units', 'normalized', ...
                      'Position', ...
                          [file_box_x box_y(i) file_box_w box_h], ...
                      'String', filename_array{i}, ...
                      'Style', 'text', ...
                      'HorizontalAlignment', 'left', ...
                      'BackgroundColor', bgcolor*1.1, ...
                      'ForegroundColor', [1 1 0]);
        
        ud.Fs_boxes(i)=...
            uicontrol('Parent', FH, ...
                      'Units', 'normalized', ...
                      'Position', ...
                          [Fs_box_x box_y(i) box_w box_h], ...
                      'String', num2str(default.Fs(i)), ...
                      'Style', 'edit', ...
                      'HorizontalAlignment', 'center', ...
                      'BackgroundColor', bgcolor, ...
                      'ForegroundColor', [0 1 0]);
                                    
        ud.Gain_boxes(i)=...
            uicontrol('Parent', FH, ...
                      'Units', 'normalized', ...
                      'Position', ...
                          [Gain_box_x box_y(i) box_w box_h], ...
                      'String', num2str(default.Gain(i)), ...
                      'Style', 'edit', ...
                      'HorizontalAlignment', 'center', ...
                      'BackgroundColor', bgcolor, ...
                      'ForegroundColor', [0 1 0]);
                  
        if ~ud.edit_box(i),
            set([ud.Fs_boxes(i) ud.Gain_boxes(i)], 'Style', 'text');
        end
                  
    end

%Put an OK button                          
button_w=box_w;
button_h=box_h*2;
button_separation=box_separation_h;

ok_button_x=Gain_box_x+box_w-2*button_w-button_separation;
ok_button_y=box_y(end)-button_h*1.5;

Pos=[ok_button_x ok_button_y button_w button_h];

ud.ok_pushbutton_handle=uicontrol(   'Parent', FH, ...
                                     'Units', 'normalized', ...
                                     'Position', Pos, ...
                                     'String', 'OK', ...
                                     'Style', 'pushbutton', ...
                                     'HorizontalAlignment', 'center', ...
                                     'BackgroundColor', bgcolor*2, ...
                                     'ForegroundColor', 'k', ...
                                     'Callback', {@ok_pushbutton_callback});
                                 
%Put a Cancel button                          
Pos=Pos+[1 0 0 0]*(button_separation+button_w);
ud.cancel_pushbutton_handle=uicontrol('Parent', FH, ...
                                      'Units', 'normalized', ...
                                      'Position', Pos, ...
                                      'String', 'Cancel', ...
                                      'Style', 'pushbutton', ...
                                      'HorizontalAlignment', 'center', ...
                                      'BackgroundColor', bgcolor*2, ...
                                      'ForegroundColor', 'k', ...
                                      'Callback', {@cancel_pushbutton_callback});

%Store the original coordinates
	ud.file_box_title_pos=get(ud.file_boxes_title, 'Position');
	ud.Fs_box_title_pos=get(ud.Fs_boxes_title, 'Position');
	ud.Gain_box_title_pos=get(ud.Gain_boxes_title, 'Position');
	
	ud.assign_boxes_label_pos=get(ud.assign_boxes_label, 'Position');
	ud.Fs_assign_box_pos=get(ud.Fs_assign_box, 'Position');
	ud.Gain_assign_box_pos=get(ud.Gain_assign_box, 'Position');
	
	ud.file_box_pos=get(ud.file_boxes, 'Position');
	ud.Fs_box_pos=get(ud.Fs_boxes, 'Position');
	ud.Gain_box_pos=get(ud.Gain_boxes, 'Position');
	
	ud.ok_button_pos=get(ud.ok_pushbutton_handle, 'Position');
	ud.cancel_box_pos=get(ud.cancel_pushbutton_handle, 'Position');                                  
	
	ud.ok_button_y=ok_button_y;
                                  
%Save data
set(FH, 'UserData', ud);

%Wait until done
waitfor(ud.ok_pushbutton_handle, 'Tag', 'Done');

if ishandle(FH),
	%At this point, the selection is over. Get it from ud.
	ud=get(FH, 'UserData');
	Fs_array=ud.Fs_array;
	Gain_array=ud.Gain_array;
	
	%Close the interface
	close(FH);
else
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% ok_pushbutton_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%
function ok_pushbutton_callback(eventSrc, eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');

    ud.Fs_array=str2num(char(get(ud.Fs_boxes, 'String')));
    ud.Gain_array=str2num(char(get(ud.Gain_boxes, 'String')));
    
    if any(isempty(ud.Fs_array)) | any(isnan(ud.Fs_array)) | ...
       any(isempty(ud.Gain_array)) | any(isnan(ud.Gain_array)),
        %There is a problem
        ud.Fs_array=[];
        ud.Gain_array=[];
    end
    
	%Save data
	set(fg, 'UserData', ud);
    
    %Signal exit
    set(ud.ok_pushbutton_handle, 'Tag', 'Done');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cancel_pushbutton_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cancel_pushbutton_callback(eventSrc, eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');

    ud.Fs_array=[];
    ud.Gain_array=[];
    
	%Save data
	set(fg, 'UserData', ud);

    %Signal exit
    set(ud.ok_pushbutton_handle, 'Tag', 'Done');

%%%%%%%%%%%%%%%%%%%%
% ScrollerCallback %
%%%%%%%%%%%%%%%%%%%%
function ScrollerCallback(eventSrc,eventData)

	%---Change parameter value (eventData = new value)
	ud = get(gcbf,'UserData');
    	
	value=get(gcbo, 'Value');
	
	delta=abs((1-value)*ud.ok_button_y);

    Pos=ud.file_box_title_pos;
    Pos=Pos+[0 1 0 0]*delta;
    ud.file_box_title_pos=Pos;
    
    Pos=ud.Fs_box_title_pos;
    Pos=Pos+[0 1 0 0]*delta;
    ud.Fs_box_title_pos=Pos;
    
    Pos=ud.Gain_box_title_pos;
    Pos=Pos+[0 1 0 0]*delta;
    ud.Gain_box_title_pos=Pos;
    
    Pos=ud.assign_boxes_label_pos;
    Pos=Pos+[0 1 0 0]*delta;
    ud.assign_boxes_label_pos=Pos;
    
    Pos=ud.Fs_assign_box_pos;
    Pos=Pos+[0 1 0 0]*delta;
    ud.Fs_assign_box_pos=Pos;
    
    Pos=ud.Gain_assign_box_pos;
    Pos=Pos+[0 1 0 0]*delta;
    ud.Gain_assign_box_pos=Pos;
    
    if ud.num_of_files>1,
		for i=1:ud.num_of_files,
            Pos=ud.file_box_pos{i};
            Pos=Pos+[0 1 0 0]*delta;
            ud.file_box_pos{i}=Pos;
	
            Pos=ud.Fs_box_pos{i};
            Pos=Pos+[0 1 0 0]*delta;
            ud.Fs_box_pos{i}=Pos;
            
            Pos=ud.Gain_box_pos{i};
            Pos=Pos+[0 1 0 0]*delta;
            ud.Gain_box_pos{i}=Pos;
		end
    else
        Pos=ud.file_box_pos;
        Pos=Pos+[0 1 0 0]*delta;
        ud.file_box_pos=Pos;

        Pos=ud.Fs_box_pos;
        Pos=Pos+[0 1 0 0]*delta;
        ud.Fs_box_pos=Pos;
        
        Pos=ud.Gain_box_pos;
        Pos=Pos+[0 1 0 0]*delta;
        ud.Gain_box_pos=Pos;
   end
    
    Pos=ud.ok_button_pos;
    Pos=Pos+[0 1 0 0]*delta;
    ud.ok_button_pos=Pos;
    
    Pos=ud.cancel_box_pos;
    Pos=Pos+[0 1 0 0]*delta;
    ud.cancel_box_pos=Pos;
    
    
    set(ud.file_boxes_title, 'Position', ud.file_box_title_pos);
    set(ud.Fs_boxes_title, 'Position', ud.Fs_box_title_pos);
    set(ud.Gain_boxes_title, 'Position', ud.Gain_box_title_pos);
    
    set(ud.assign_boxes_label, 'Position', ud.assign_boxes_label_pos);
    set(ud.Fs_assign_box, 'Position', ud.Fs_assign_box_pos);
    set(ud.Gain_assign_box, 'Position', ud.Gain_assign_box_pos);
    
    if ud.num_of_files>1,
        set(ud.file_boxes, {'Position'}, ud.file_box_pos);
        set(ud.Fs_boxes, {'Position'}, ud.Fs_box_pos);
        set(ud.Gain_boxes, {'Position'}, ud.Gain_box_pos);
    else
        set(ud.file_boxes, 'Position', ud.file_box_pos);
        set(ud.Fs_boxes, 'Position', ud.Fs_box_pos);
        set(ud.Gain_boxes, 'Position', ud.Gain_box_pos);
    end
    
    set(ud.ok_pushbutton_handle, 'Position', ud.ok_button_pos);
    set(ud.cancel_pushbutton_handle, 'Position', ud.cancel_box_pos);

    
%%%%%%%%%%%%%%%%%%%%%%
% assign_Fs_callback %
%%%%%%%%%%%%%%%%%%%%%%
function assign_Fs_callback(eventSrc,eventData)

    value=str2num(get(gcbo, 'String'));
    if isempty(value) | isnan(value) | value<=0,
        return;
    end

    fg=gcbf;
    ud=get(fg, 'UserData');
    
    set(ud.Fs_boxes(find(ud.edit_box==1)), 'String', num2str(value));
    
%%%%%%%%%%%%%%%%%%%%%%%%
% assign_Gain_callback %
%%%%%%%%%%%%%%%%%%%%%%%%
function assign_Gain_callback(eventSrc,eventData)

    value=str2num(get(gcbo, 'String'));
    if isempty(value) | isnan(value) | value<=0,
        return;
    end

    fg=gcbf;
    ud=get(fg, 'UserData');
    
    set(ud.Gain_boxes(find(ud.edit_box==1)), 'String', num2str(value));