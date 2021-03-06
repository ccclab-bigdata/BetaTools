function eegrhythm
%eegrhythm
%   A GUI to process EEG signals.
%   Author: Murat Okatan 10/01/02

EEG_VERSION=160;
%version 160. Use an interval file with batch computation of PSDs.
%version 159. Replaced doublebackslash with avoidTeX to generalize.
%version 158. Batch computation of PSDs.
%version 157. Average power computation in PSD now accepts multiple non-overlapping ranges.
%version 156. Compute average power within a user-defined freq. range during PSD computation.
%version 155. Loading .eeg or raw .mat now shows eeg signal on screen. PSD can be computed
%   for whole signal, and even when there is no filtered signal.
%version 154. Upper case P/N, advances one screenful of signal to the
%   left/right, lower case p/n goes to the previous/next interval.
%version 153. Improved rtslider handling. Fixed a bug in power screen ranges.
%version 152. Compute and show average coherence within the plotted range.
%version 151. Peak triggered phase analysis for spikes.
%version 150. Added a new parameter to onset/latency computations to check whether
%   the power increases above the threshold level to the left of the onset within
%   a user-specified window.
%version 149. Ability to do operations on intervals.
%version 148. Compute epsiode onset times and show on signals. Compute latencies
%   and plot graph. Augmented the view function, introduced a function to plot
%   data versus channel numbers.
%version 147. INCOMPLETE. Option to find intervals based on waveform feature.
%version 146. get_multiple_filenames now returns a cell array instead of char
%   array.
%version 145. Show significance level in coherence plot.
%version 144. Compute coherence.
%version 143. Added an interval search parameter to fuse close intervals.
%version 142. Variable-scale peak search.
%version 141. View menu option. Show/Hide peaks, interval delimiters, and threshold lines.
%version 140. Interval/Delete menu option. Also, improvements in other interval related
%   functions, such as saving .mat files and inserting intervals...
%version 139. Rtslider edit box entry now updates the sliderstructs.
%version 138. Include peak grouping window into the threshold record in a backward
%   compatible way.
%version 137. Option to select intervals by maximum absolute filtered amplitude.
%version 136. Analysis menu option to compute the histogram of maximum
%   amplitudes in intervals.
%version 135. Option to select intervals by timestamp.
%version 134. Use a single inputdlg for all parameters for batch interval search
%   and eeg->plot.
%version 133. Does not display selected interval number if the number is outside
%   the visible range.
%version 132. Improved set_thresholdstruct/get_threshold_reference.
%version 131. Save selected interval categories instead of all in Save .mat.
%version 130. Called drawnow after each *dlg except errordlg.
%version 129. Improved set_thresholdstruct/get_threshold_reference.
%version 128. Use tags to trigger display buffer update, instead of variables.
%version 127. Changed the way start/stop offset work in spectrogram computation. Now, it is 
%   the same as in video.
%version 126. Removed the Apply PushButton, threshold and min interval duration edit boxes.
%version 125. Use a single inputdlg for all parameters for interval search. Initiate
%   interval search from a menu option. In this version the Apply PushButton, threshold
%   and min interval duration edit boxes are still present. They will be removed later.
%version 124. Peak-to-Peak distances may be larger than 1 cycle of the lowest passband
%   frequency, even though the peaks belong to segments where the passband power is 
%   very large. Let's say 1.2 cycles instead.
%version 123. Use linear instead of cubic interpolation for position data.
%version 122. Perform the backward compatibility updates in a function.
%version 121. Extract rat's motion information as pixels/sec, and export as nex file.
%version 120. Put a toggle button to stop video.
%version 119. Modifications to handle the situation when the user starts using a new filter
%   while a filtered signal is present. Improved file save menu option.
%version 118. Made sure nfft>=nwindow in spectrogram computation.
%version 117. Segment intervals by grouping peaks instead of threshold crossings.
%version 116. Modified peak detection menu callback to selectively detect positive
%   and/or negative peaks.
%version 115. Interval Stats prints power screen data too.
%version 114. Improved peak detection.
%version 113. Get absmaxref in set_thresholdstruct instead of get_threshold_reference.
%   Detect peaks of filtered and raw signals.
%version 112. Use a ratio in conjunction with interval_power_screen_ranges.
%version 111. Finished the spectrogram.
%version 110. Use a batch mode to generate interval power plots all the way from eeg files.
%version 109. Use absmax as ref., optionally., Show spectrogram of selected interval. Unfinished
%version 108. Jump to given interval number. Change labels of intervals. Export the plot
%   data associated with the interval stats plots.
%version 107. Use extensions in calling get_multiple_filenames.
%version 106. Put a save menu item. PSD interface has the option to smooth the output
%   using averaging. Export PSD f and Pxx to workspace.
%version 105. In finding intervals, now detect adjacent points that are above threshold
%   but of opposite sign.
%version 104. Batch eeg->mat without filtering.
%version 103. Ability to deemphasize selected intervals. Ability to batch deemphasize
%version 102. Plot/interval stats now reads signal and interval .mat files and computes the 
%   desired stats on the fly.
%version 101. Ability to insert intervals defined by dragging a rectangle using mouse.
%version 100. Used select multiple input files in place of all uigetfile calls. showMessage()
%   complains about backslashes in filenames on PCs, confusing them with TeX notation. Used
%   doublebackslash function to avoid it.
%version 99. Modified save_loaded_eeg_data to accept 'signals' as input. Started using a 
%   threshold_record struct in 'signals' so that when we load a file, we can use the 
%   previously found references if applicable.
%version 98. Batch filtering of files can now handle .mat files and .eeg files together.
%version 97. Ability to select multiple input files using custom guis.
%version 96. Return empty struct in get_interval_stats if there is no interval
%version 95. Ability to create interval stats as part of batch_find_intervals. Ability to plot
%   stat results from a menu option.
%version 94. Improved the search for the reference threshold.
%version 93. Ability to reject intervals that have more power in a specified stopband range
%   than in the passband range.
%version 92. Modifying batch_find_intervals algorithm to make it use existing functions instead
%   of special adaptations of them. Use nested menu options.
%version 91. Adding a menu item to close file. Modifying batch_eeg_filter algorithm to make it
%   use existing functions instead of special adaptations of them.
%version 90. Modified some functions to accept and return ud.
%version 89. Used the scrollableTextFigure to display text message output.
%version 88. Used the new threshold tools in batch find intervals menu option.
%version 87. Used the new threshold tools in deemphasis menu option.
%version 86. Fixed a bug in IntervalStats. Two nested loops were using the same index i.
%version 85. Used threshold struct and functions in ApplyPushButton.
%version 84. Removed the feature of fixing interval durations to a user-defined number of samples.
%   It was needed as an optional aspect of PSD analysis. It will be handled in another way.
%version 83. Introduced a threshold struct and a function to set threshold related variables. Used
%   it in load_interval menu function.
%version 82. Accelerated the PSD computation. Used set_current_interval at a few overlooked places.
%version 81. Use functions to set rtslider parameters. Introduce a key that the slider_EditBox'es
%   use to activate updateDisplayBuffers.
%version 80. Streamlined KeyPressFcn, introducing some helper functions. 
%version 79. Find the largest absolute voltage below which episodes of desired duration appear. 
%   Use that voltage as threshold reference, instead of the absolute maximum in the entire file.
%version 78. Compute the threshold in volts in a function.
%version 77. Include average power per interval (mean+/-std) in the Interval Stats.
%version 76. Threshold, interval cutoff and fixed num of samples settings are reset
%   when loading intervals.
%version 75. Put an analysis menu item to do motion analysis, to label intervals in
%   which the rat moves or stands still.
%version 74. Put an edit box to enter number of frames to skip, to speed up video.
%   Show "video on" lines around the video axes when video is on. Show the current interval 
%   number.
%version 73. Put a text output to show the current file selection during batch mode input.
%version 72. Batch: open multiple filtered eeg files, use the same threshold and min.
%   duration to find intervals. Save the intervals.
%version 71. Batch: open multiple eeg files, use the same filter, generate the raw and 
% filtered eeg .mat files.
%version 70. Ability to select the entire session as an interval when threshold is 0.
%version 69. Modified the filter frequency response plot range. Also modified the frequency
%   response to reflect the effect of filtfilt: zero phase, squared magnitude response. Added
%   the mean and the standard deviation of interval duration to the IntervalStats.
%version 68. Put hot keys M, F, L, to jump to the interval that contains the 'M'aximum filtered
%   amplitude contained in an interval, the 'F'irst interval, and the 'L'ast interval.
%version 67. Modified the PSD again. Now, the nfft does not have to be the length of the signal
%   container.
%version 66. Use the input number of frequencies for the PSD range as an approximate number, instead
%   of an exact number.
%version 65. Modified the computation of the PSD. Now the average powers match.
%version 64. Allow the user to plot the PSDs in a specific figure with a new color.
%version 63. Save intervals in .mat file such that it can be exchanged between signals. Fixed some
%   scroll slider parameter adjustment problems in updateDisplayBuffers.
%version 62. Exclude some time intervals from the calculation of the threshold by deemphasizing 
%   them.
%version 61. Convert eeg units into volts. Put more info in Interval Stats. Label PSD plots.
%version 60. Compute the PSD for only the selected intervals.
%version 59. Include an analysis sub-menu to compute interval statistics for selected
%   intervals. The summary will include the average power in the filtered and raw signals, 
%   the number of intervals, the total duration, and the start/stop times of each interval.
%version 58. Computing the threshold as ud.threshold=user_defined_threshold*max absolute 
%   filtered amplitude. The user_defined_threshold must be a number between [0 1].
%version 57. Read user inputs for PSD using an input dialog. This version computes the PSD
%   using variable-duration intervals. It windows each signal separately. Uses an nfft
%   that ensures the user-desired frequency resolution. Fixed a bug in export to nex. A
%   for loop was missing counter update.
%version 56. Put an analysis menu option with a sub-menu for PSD. Write the PSD 
%   algorithm.
%version 55. Put controls to specify the number of samples per interval.
%version 54. Streamlined the saving of loaded eeg data, and the deletion of existing
%   interval markers in updateDisplayBuffers.
%version 53. Not using default threshold and intervalCutoff values. Not computing
%   the intervals as soon as a filtered signal is obtained or loaded at the start of
%   the GUI. Fixed a bug in positioning the scrollslider's slider after zoomings.
%version 52. Using writeNexIntervals() instead of int2nex.
%version 51. In computing the interval cutoff, use the period of the LOWEST passband 
%   frequency as unit, not the HIGHEST. 
%version 50. Select the complement of the current interval set.
%version 49. Version 48 debugged. The Apply pushbutton callback had a bug. The function
%   ThresholdEditBoxFunction was modifying ud, but after its completion, the pushbutton
%   callback was using the old ud. Modified ThresholdEditBoxFunction to return ud. This
%   bug was introduced in version 44. The same modification is made to versions 44-48.
%version 48. Call DOS function int2nex.exe as INT2NEX.EXE. Otherwise eegrhythm fails to 
%   call int2nex under Win98.
%version 47. Select or unselect all intervals using a menu item.
%version 46. Handles file deletions and copying differently in PC and UNIX.
%version 45. Created a data_features sub struct in ud to group some related ud fields.
%	Streamlined the representation of handle outputs of rtslider in this code.
%version 44. Put a pushbutton to apply interval threshold and duration settings.
%   Do not find intervals as soon as threshold or duration is changed.
%version 43. Moved the doubling of backslashes to eegread.c, because Matlab on mrbrown
%   failed to handle double backslashes in opening files. Removing double and 
%   singlebackslash functions from here.
%version 42. Removing the second backslash from fnames before showing them as figure
%   name. Specify an offset and duration to work on part of a loaded filtered signal. 
%   This feature disabled until we fix using intervals with these signal parts. Put a 
%   watch when using next/previous/zoom with intervals.
%version 41. Press the keys N and P to go to the next and previous intervals. 
%   (Case insensitive). Modified paintSelectedInterval to return ud, which it modifies.
%   Press Z to position the selected interval to the center, and bring to a zoom level
%   such that it occupies the middle 1/3 of the graph. Put "Help" and "About" menu items.
%version 40. The function pause seems to cause problems in windows .dll form. Replace it 
%   with a custom function 'pauser'.
%version 39. Change showMessage. Instead of passing figure handle, pass text handle.
%version 38. Print message when saving files, designing filter.
%version 37. Using double backslashes in fnames to prevent windows .dlls from confusing them
%   with TeX notations.
%version 36. Substituting strfind by dotfind, system by dos, copyfile by cp.
%version 35. Modified the way data are saved and loaded as .mat files.
%version 34. Edit boxes to control the start and stop times of video, relative to the start and end
%   of the selected interval.
%version 33. Show open datafilenames etc.
%version 32. Uncompress the data file automatically, if needed.
%version 31. Save and load intervals as .mat files.
%version 30. Delete the current selected interval if new intervals are computed.
%   Changed some 'disp's to 'showMessage's
%version 29. Update the threshold level when threshold is changed.
%version 28. Create a message axis on GUI for some messages.
%version 27. loadVideoData in playMovie.
%version 26. Show frequency response of the filter.
%version 25. Ask for a name for the exported interval data.
%version 24. Put an edit box to control the min num. of cycles per interval.
%version 23. Put an edit box to control the threshold.
%version 22. Put interval computation in a function. Drop the output 'intervals', 
%   and the inputs.
%version 21. Add menu items to open, save, close, quit, etc.
%version 20. Draw the figure essentials first, independent of the signal.
%version 19. When the graphs are redrawn, selected boxes remain highlighted.
%version 18. Streamlined the loading of video data
%version 17. Export interval data to XY*.int file.
%version 16. Play the video of the selected interval.
%version 15. A menu button to export intervals to file.
%version 14. Assign the selected interval to a category.
%version 13. Select an interval by clicking on it.
%version 12. Now one can jump to a value entered into the scroll text box even if the value is 
%   outside the slider's current range. Uses rtslider version 5.
%version 11. Now, the buffer is refreshed at each button up also.
%version 10. The XLim was jumping after updateDisplayBuffers. Fixed it for Scroll
%   It still seems to jump under a rare situation. Identify and fix it. Jumps after zooming
%   have not been fixed yet.
%version 9. Stores the signal data in axes userdata. Cleaned up unused variables...
%version 8. Major changes in the display. Now there is a buffer of fixed
%   length, which is updated when the user moves past its limits, or zooms in.
%   Also, updates the scroll slider's parameter when zooming in.
%version 7. Improve zooming by making the Zoom scale logarithmic
%version 6. Reject episodes that are shorter than one period of the highest frequency in the pass
%   band.
%version 5. Downsample the data after bandpass filtering since we do not need a high sampling rate
%version 4. Used the downsample function to downsample.
%version 3. Improve downsampling. Plot only the visible portion of data everytime scroll and zoom 
%   updates.
%version 2. downsample the data before plotting, since the screen resolution does not allow showing
%   all the details anyway.
%   We do not use the built-in decimate function of the Toolbox to speed up the calculations
%version 1. Plots the entire data and allows zooming and scrolling using rtsliders. Too slow if 
%   data vector is large.

%Create the figure
H=0.9; W=0.9;
FH=figure(...
    'Color', [1 1 1]*0, ...
    'Units', 'normalized', ...
    'Position', [(1-W)/2 (1-H)/4 W H], ...
    'Visible', 'off', ...
    'DoubleBuffer', 'on', ...
    'BackingStore', 'off', ...
    'Name', 'eegrhythm ', ...
    'NumberTitle', 'off', ...
    'KeyPressFcn', {@KeyPressFcn}, ...
    'Interruptible', 'off', ...
    'BusyAction', 'cancel');
%    'Position', [49 47 1202 894], ...

%Create the menu
createMenu(FH);
        
%Initialize the structs that will hold various GUI data
[ud signals intervalCategories videoData]=initStructs;
ud.EEG_VERSION=EEG_VERSION;

%construct and show the GUI backbone
ud=guiBackbone(FH, ud, signals, intervalCategories, videoData);

%Show figure
set(FH, 'Visible', 'on');

%%%%%%%%%%%%%%%%%%%%%%
% get_rtsliderstruct %
%%%%%%%%%%%%%%%%%%%%%%
function rtsliderstruct=get_rtsliderstruct(rtslider_handle)

    rtsliderstruct=get(rtslider_handle.Axis, 'UserData');
    if ~isempty(rtsliderstruct),
        return;
    end
    
    %If we reach this point, then no struct was previously stored. Create and init one.

	rtsliderstruct=struct('EditBoxLimits', [], ...
                          'EditBoxValue', [], ...
                          'Range', [], ...
                          'XData', []);

 	edit_ud=get(rtslider_handle.EditBox, 'UserData');
    
    rtsliderstruct.EditBoxLimits=edit_ud.EditBoxLimits;
    rtsliderstruct.EditBoxValue=get(rtslider_handle.EditBox, 'Value');
	rtsliderstruct.Range=get(rtslider_handle.Axis, 'XLim');
	rtsliderstruct.XData=get(rtslider_handle.Slider, 'XData');

    %Store it as the Axis' user data.
    set(rtslider_handle.Axis, 'UserData', rtsliderstruct);
                      
%%%%%%%%%%%%%%%%%%%%%%
% set_rtsliderstruct %
%%%%%%%%%%%%%%%%%%%%%%
function set_rtsliderstruct(rtslider_handle, rtsliderstruct)
    
    existing_rtsliderstruct=get(rtslider_handle.Axis, 'UserData');
    
    plist=fieldnames(rtsliderstruct);
    
    for i=1:length(plist),
        if is_different(getfield(rtsliderstruct, char(plist(i))), ...
                        getfield(existing_rtsliderstruct, char(plist(i)))),
        %new parameter differs from the old. Make the necessary adjustments
            switch(char(plist(i)))
                case 'EditBoxLimits',
                	edit_ud=get(rtslider_handle.EditBox, 'UserData');
                	edit_ud.EditBoxLimits=getfield(rtsliderstruct, char(plist(i)));
                	set(rtslider_handle.EditBox, 'UserData', edit_ud);
                case 'EditBoxValue',
                	set(rtslider_handle.EditBox, 'Value', getfield(rtsliderstruct, char(plist(i))));
                case 'Range',
                    Range=getfield(rtsliderstruct, char(plist(i)));
					set(rtslider_handle.Axis, 'XLim', Range);
					set(rtslider_handle.Line, 'XData', ...
                      [Range NaN Range(1) Range(1) NaN Range(2) Range(2)]);
					if ~isempty(rtslider_handle.RangeText1),
                      set(rtslider_handle.RangeText1, 'String',num2str(Range(1)), ...
                          'Position',[Range(1) -1.5]);
                      set(rtslider_handle.RangeText2, 'String',num2str(Range(2)), ...
                          'Position',[Range(2) -1.5]);
					end
                case 'XData',
                    XData=getfield(rtsliderstruct, char(plist(i)));
					set(rtslider_handle.Slider, 'XData', XData);
                    set(rtslider_handle.EditBox, 'String', num2str(XData));
            end%switch
        end %if
    end %for
    
    %Store it as the Axis' user data.
    set(rtslider_handle.Axis, 'UserData', rtsliderstruct);

    
%%%%%%%%%%%%%%%%%%%%%%%
% set_thresholdstruct %
%%%%%%%%%%%%%%%%%%%%%%%
function ud=set_thresholdstruct(ud, newstruct)
    
    fg=gcbf;
       
    %Default values
    threshold_line_YData=NaN;
    
    %ask whether we'll use the abs max as ref. threshold
    cbtag=get(gcbo, 'Tag');
    if (~isempty(newstruct.users) & ...
        ~strcmp(cbtag, 'menu_batch_find_intervals') &...
        ~strcmp(cbtag, 'menu_batch_eeg_to_plot') & ...
        ~strcmp(cbtag, 'menu_interval_find')),
        
        %Ask whether we use absmax as ref.
		button = questdlg('Use absolute max as threshold reference?',...
		'Reference Threshold?','Yes','No','Yes');
    
        drawnow;
		if strcmp(button,'Yes')
            newstruct.absmaxref=1;
        elseif strcmp(button,'No')
            newstruct.absmaxref=0;
        end
    end    

    %If signal changed, note this
    newstruct.signal_change=ud.signal_change;
    ud.signal_change=0;    
    
    oldstruct=ud.threshold;
    ud.threshold=newstruct;
    set(fg, 'UserData', ud);
    %At this point, ud.threshold contains the newstruct and is stored as UserData.
    
    %Find out what changed since last threshold struct
    plist=fieldnames(newstruct);
    item_changed=zeros(1, length(plist));
    for i=1:length(plist),
        if is_different(getfield(newstruct, char(plist(i))), ...
                        getfield(oldstruct, char(plist(i)))),
            item_changed(i)=1;
        end %if
        %Find out the index of users
        if strcmp(char(plist(i)), 'users'),
            users_indx=i;
        end
    end %for
    
    %Is the user's threshold the only change?
    mask=item_changed.*0+1; mask(users_indx)=0;
    if item_changed(users_indx) & ~any(mask.*item_changed),
        %Then, just return the new in_volts
        newstruct.in_volts=newstruct.users*newstruct.reference;
        if ~isempty(newstruct.in_volts),
            threshold_line_YData=newstruct.in_volts;
        end
    elseif ~isempty(newstruct.users)
        %If other items changed as well, get new reference
        [ud, newstruct]=get_threshold_reference(ud, oldstruct);
        newstruct.in_volts=newstruct.users*newstruct.reference;
        threshold_line_YData=newstruct.in_volts;
        
        %Turn off the signal_change flag
        newstruct.signal_change=0;
    end

    %Trigger update display buffers
    ud.DisplayBuffers.threshold_change=1;
    
    %Update threshold lines
    if ~isempty(newstruct.lines),
        set(newstruct.lines(1), 'YData',  [1 1]*threshold_line_YData);
        set(newstruct.lines(2), 'YData', -[1 1]*threshold_line_YData);
    end

    %Store it to its place
    ud.threshold=newstruct;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_threshold_reference %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ud, threshold]=get_threshold_reference(ud, old_threshold)

    %The default is ud.threshold
    threshold=ud.threshold;
    
    %Get our signals
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    absolute_max=abs(max(signals.y));
        
    fg=gcbf;

    %If there was a signal change, reset threshold_records
    if threshold.signal_change,
        signals.threshold_record.intervalCutoff=[];
        signals.threshold_record.interval_power_screen_ranges={};
        signals.threshold_record.interval_power_screen_ratio=[];
        signals.threshold_record.reference=[];
        signals.threshold_record.peak_grouping_window=[];
        signals.threshold_record.interval_fusion_window=[];
        set(ud.Handles.Axes.Raw, 'UserData', signals);
        ud=save_filtered_data('', ud);
    end
    
    %If the user's threshold is zero, don't bother computing a reference
    if threshold.users==0,
        threshold.reference=0;
        return;
    end
    
    %If we use the abs max as the threshold reference, return it.
    if threshold.absmaxref,
        threshold.reference=absolute_max;
        return;
    end
    
    %If a previously computed reference is available, use it.
    if ~isempty(signals.threshold_record) & ~isempty(signals.threshold_record.intervalCutoff),
        indx=find(...
            signals.threshold_record.intervalCutoff==threshold.intervalCutoff & ...
            signals.threshold_record.interval_power_screen_ratio==...
                threshold.interval_power_screen_ratio & ...
            signals.threshold_record.peak_grouping_window==...
                threshold.peak_grouping_window & ...
            signals.threshold_record.interval_fusion_window==...
                threshold.interval_fusion_window);
        if ~isempty(indx),
            match=0;
            for i=1:length(indx),
                if ~is_different(signals.threshold_record.interval_power_screen_ranges{indx(i)},...
                            threshold.interval_power_screen_ranges),
                        match=i;
                end
            end
                
            if match,
            %We found a previously computed reference that we can use
                threshold.reference=signals.threshold_record.reference(indx(match));
                return;
            end
        end %if ~isempty(indx)
    end
            
    %Specify the search control parameters
    current_threshold=0.5;
    last_threshold_up=1;
    last_threshold_down=0;
    last_successful_threshold=0;
    
    old_ptr=get(fg, 'Pointer');    
    set(fg, 'Pointer', 'watch');
    
    %unlock is for the optional plotting of the progress of threshold search.
	unlock=1;
    step_counter=1;
    while 1,        

        msg=sprintf('Searching for reference threshold: Step %d of %d', ...
            step_counter, ceil(-log(threshold.epsilon)/log(2)));
        step_counter=step_counter+1;
		showMessage(ud.Handles.Texts.Message, ...
            msg, 0);
        
        
        %Allow gui to redraw window
        drawnow;
        
		%Activate these lines to see a plot of the search for the threshold            
		if 0,
			if unlock,
               pctr=0;
               W=0.4375; H=0.4102;
               HF=figure('Units', 'normalized', 'Position', [(1-W)/2 (1-H)/2 W H]);
			end
            figure(HF);
			plot(pctr, current_threshold, 'go', pctr, last_threshold_up, 'ro', ...
                 pctr, last_threshold_down, 'bo');
            legend('current best', 'too high', 'lower bound');
            str=sprintf('Difference: %f. Must be no larger than: %f', ...
                last_threshold_up-current_threshold, ud.threshold.epsilon);
            set(get(gca, 'Title'), 'String', str);
			hold on;
			pctr=pctr+1;
			unlock=0;
		end
                
        %Use current threshold to see whether it results in episodes
        ud.threshold.in_volts=absolute_max*current_threshold;
        
        %Does this find intervals?
        [ud, signals]=findIntervals(ud);
        
        if isempty(signals.start_indx),
            %No intervals found. Are we at the lowest allowed threshold?
            if current_threshold <= ud.threshold.lowerbound,
                %We are already at the bottom. Abort
            	showMessage(ud.Handles.Texts.Message, ...
                    'No intervals even at lowest possible threshold. Using zero threshold', 0);
                threshold.reference=0;
                threshold.users=0;
                set(fg, 'Pointer', old_ptr);
                return;
            else
                %Decrease the threshold.
                last_threshold_up=current_threshold;
                current_threshold=(current_threshold+last_threshold_down)/2;
                %Stop if the last_threshold_up came close enough to 
                %last_successful_threshold
                if last_threshold_up-last_successful_threshold<=ud.threshold.epsilon,
                    break;
                end
                %Continue search
            end
        else
            %Intervals found. 
            %Stop if we are satisfied with this threshold
            last_successful_threshold=current_threshold;
            if last_threshold_up-current_threshold<=ud.threshold.epsilon,
                break;
            else
                %Or continue the search by incrementing it.
                last_threshold_down=current_threshold;
                current_threshold=(current_threshold+last_threshold_up)/2;
                %Continue search
            end
        end
        
    end %Infinite loop while 1

    %If we reached this point, then last_successful_threshold is the largest threshold 
    %at which intervals appear. Use it as the reference threshold.
    threshold.reference=last_successful_threshold*absolute_max;
    
    %Save the new reference into record and file
    if isempty(signals.threshold_record) | isempty(signals.threshold_record.intervalCutoff),
        dummy_struct.intervalCutoff=threshold.intervalCutoff;
        dummy_struct.interval_power_screen_ranges=...
            {threshold.interval_power_screen_ranges};
        dummy_struct.reference=threshold.reference;
        dummy_struct.interval_power_screen_ratio=...
            threshold.interval_power_screen_ratio;
        dummy_struct.peak_grouping_window=threshold.peak_grouping_window;
        dummy_struct.interval_fusion_window=threshold.interval_fusion_window;
        
        signals.threshold_record=dummy_struct;
    else
        signals.threshold_record.intervalCutoff=...
            [signals.threshold_record.intervalCutoff threshold.intervalCutoff];
        signals.threshold_record.interval_power_screen_ranges=...
            {signals.threshold_record.interval_power_screen_ranges{:}, ...
                threshold.interval_power_screen_ranges};
        signals.threshold_record.reference=[signals.threshold_record.reference ...
                threshold.reference];
        signals.threshold_record.interval_power_screen_ratio=...
            [signals.threshold_record.interval_power_screen_ratio ...
                threshold.interval_power_screen_ratio];
        signals.threshold_record.peak_grouping_window=...
            [signals.threshold_record.peak_grouping_window threshold.peak_grouping_window];
        signals.threshold_record.interval_fusion_window=...
            [signals.threshold_record.interval_fusion_window threshold.interval_fusion_window];
    end
    set(ud.Handles.Axes.Raw, 'UserData', signals);
    ud=save_filtered_data(ud.DataFileName, ud);

    set(fg, 'Pointer', old_ptr);

	showMessage(ud.Handles.Texts.Message, ...
        'DONE: Searching for reference threshold', 1);
    
%%%%%%%%%%%%%%%
% KeyPressFcn %
%%%%%%%%%%%%%%%
function KeyPressFcn(eventSrc,eventData)

  fg=gcbf;
  ud=get(fg, 'UserData');

  CurrentChar=get(fg, 'CurrentCharacter');
  if isempty(CurrentChar),
      return;
  end
  
  %Are there any intervals?
  signals=get(ud.Handles.Axes.Raw, 'UserData');
  if isempty(signals.start_indx) & isempty(find(CurrentChar=='NP')),
      showMessage(ud.Handles.Texts.Message, 'There are no intervals', 1);
      return;
  end
  
  %Show watch
  old_ptr=get(fg, 'Pointer');
  set(fg, 'Pointer', 'watch');
  
  switch CurrentChar,
      case {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}
          if ~isempty(ud.current_interval)
              labelCurrentInterval(ud, CurrentChar);
          end%if ~isempty(ud.current_interval)
      case {'f', 'F', 'l', 'L'}
          %We want to go to the first or the last interval

          switch CurrentChar,
              case {'f', 'F'}
                  ud=set_current_interval(ud, 1);
              case {'l', 'L'}
                  ud=set_current_interval(ud, length(signals.start_indx));
          end

          %At this point, we have the desired interval selected. Bring its 
          %center to the center of the screen. The interval is highlighted in updateGraphs 
          %called by reposition_interval
          ud=reposition_interval(ud);
          
      case {'m', 'M'}
          %We want to go to the interval that contains the maximum, intra-interval filtered signal 
          %amplitude.
          
          %Find the index of the largest intra-interval absolute amplitude in filtered signal
          NotNaNs=find(1-isnan(signals.supraeeg)==1);
          max_indx=find(abs(signals.y(NotNaNs))==max(abs(signals.y(NotNaNs))));
          max_indx=min(NotNaNs(max_indx));
          
          %Find the index of the interval that contains it and set current interval to it
          ud=set_current_interval(ud, max(find(signals.start_indx<=max_indx)));

          %At this point, we have the desired interval selected. Bring its 
          %center to the center of the screen. The interval is highlighted in updateGraphs 
          %called by reposition_interval
          ud=reposition_interval(ud);
          
      case {'n'}
          %We want to go to the next interval, closest to the Aperture.Start
          %from the right. If there is a current interval, the next interval 
          %is to the right of it.
          
          %If there is a current interval, go to the next interval
          if ~isempty(ud.current_interval),
            if ud.current_interval==length(signals.start_indx),
              showMessage(ud.Handles.Texts.Message, 'This is the last interval', 1);
              %Restore pointer
              set(fg, 'Pointer', old_ptr);
              return;
            else
              ud=set_current_interval(ud, ud.current_interval+1);
            end
          else
            %If there is no current interval, search one to the right of the following
            %time point
            reftime=ud.Aperture.Start;
            interval_start_times=signals.t(signals.start_indx);
            next_indx=min(find(interval_start_times>reftime));
            if isempty(next_indx),
              showMessage(ud.Handles.Texts.Message, 'No further intervals to the right', 1);
              %Restore pointer
              set(fg, 'Pointer', old_ptr);
              return;
            else
              ud=set_current_interval(ud, next_indx);
            end
          end
          
          %At this point, we have the desired interval selected. Bring its 
          %center to the center of the screen. The interval is highlighted in updateGraphs 
          %called by reposition_interval
          ud=reposition_interval(ud);
          
      case {'N'}
          %We want to advance by Aperture.Width to the right
          ud.Aperture.Start = ud.Aperture.Start+ud.Aperture.Width;
                   
          ud=updateGraphs(ud);
          
      case {'p'}
          %We want to go to the previous interval, closest to the Aperture.Start
          %from the left. If there is a current interval, the next interval 
          %is to the left of it.
          
          %If there is a current interval, go to the previous interval
          if ~isempty(ud.current_interval),
            if ud.current_interval==1,
              showMessage(ud.Handles.Texts.Message, 'This is the first interval', 1);
              %Restore pointer
              set(fg, 'Pointer', old_ptr);
              return;
            else
              ud=set_current_interval(ud, ud.current_interval-1);
            end
          else
            %If there is no current interval, search one to the left of the following
            %time point
            reftime=ud.Aperture.Start;
            interval_start_times=signals.t(signals.start_indx);
            prev_indx=max(find(interval_start_times<reftime));
            if isempty(prev_indx),
              showMessage(ud.Handles.Texts.Message, 'No further intervals to the left', 1);
              %Restore pointer
              set(fg, 'Pointer', old_ptr);
              return;
            else
              ud=set_current_interval(ud, prev_indx);
            end
          end
          
          %At this point, we have the desired interval selected. Bring its 
          %center to the center of the screen. The interval is highlighted in updateGraphs 
          %called by reposition_interval
          ud=reposition_interval(ud);
          
      case {'P'}
          %We want to advance by Aperture.Width to the left
          ud.Aperture.Start = ud.Aperture.Start-ud.Aperture.Width;
                   
          ud=updateGraphs(ud);
      case {'z', 'Z'}
          
          %Zoom to selected interval if there is one
          if isempty(ud.current_interval),
              %Restore pointer
              set(fg, 'Pointer', old_ptr);
              return;
          end
          
          %If there is a current interval, bring it to center, and set zoom level
          %such that the interval occupies the middle 1/3 of the graph.
          %reposition_interval senses the CurrentCharacter and zooms if needed
          ud=reposition_interval(ud);
                     
  end %  switch CurrentChar,

  %Restore pointer
  set(fg, 'Pointer', old_ptr);

  %Save data
  set(fg, 'UserData', ud);


%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_open_eeg_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_open_eeg_callback(eventSrc,eventData)
  
	%Get user data
	open_handle=get(gcbo, 'Parent');
	fg = gcbf;
	ud = get(fg,'UserData');
	
	%If data exist, ask user to close file.
	if ~isempty(ud.data_features.Fs),
      showMessage(ud.Handles.Texts.Message, 'File Open Error: Please close current file first', 1);
      return;
	end
	
    %Get filename
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.eeg'), 'Select the input .eeg file');
    end
    if isempty(fnames),
        return;
    end
    
    default.Fs=1024;
    default.Gain=2500;
    default.edit_box=1;
    [Fs, Gain]=getdata_eeg_open(fnames, default);
    if isempty(Fs) | isempty(Gain),
        return;
    end
    
	%Refresh GUI
	drawnow;

    %Read and save eeg data
    ud=read_save_eeg_data(fnames{1}, Fs, Gain, ud);

    %Using the data, adjust the GUI
    ud=dataAdjustGUI(ud);

    %show signal
    ud=updateGraphs(ud);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_load_raw_eeg_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_load_raw_eeg_callback(eventSrc,eventData)
    
	open_handle=get(gcbo, 'Parent');
	fg = gcbf;
	ud = get(fg,'UserData');
    
	%If data exist, ask user to close file.
	if ~isempty(ud.data_features.Fs),
      showMessage(ud.Handles.Texts.Message, 'File Load Error: Please close current file first', 1);
      return;
	end
  
    %Get filename
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the raw eeg matfile');
    end
    if isempty(fnames),
        return;
    end
    fname=fnames{1};
    drawnow;

    %Save fname
    ud.DataFileName=fname;
    
    %Show watch
	old_ptr=get(fg, 'Pointer');
	set(fg, 'Pointer', 'watch');   
    	    
    load(fname);
    [package status]=make_backward_compatible(fname, package);
    if status,
        %Restore pointer
       	set(fg, 'Pointer', 'watch');   
        return;
    end    
    
	%Save loaded eeg data
    signals=get(ud.Handles.Axes.Raw, 'UserData');
	signals.t=package.t;
	signals.eeg=package.eeg;
	signals.y=package.eeg*NaN;
	ud=save_loaded_eeg_data(package.Fs, package.Gain, signals, fname, ud.filter, ud);     

    %Using the data, adjust the GUI
    ud=dataAdjustGUI(ud);
    
    %show signal
    ud=updateGraphs(ud);
    
    %Restore pointer
	set(fg, 'Pointer', old_ptr);   
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_load_filtered_eeg_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_load_filtered_eeg_callback(eventSrc,eventData)
    
	fg = gcbf;
	ud = get(fg,'UserData');
    
	%If data exist, ask user to close file.
	if ~isempty(ud.data_features.Fs),
      showMessage(ud.Handles.Texts.Message, 'File Load Error: Please close current file first', 1);
      return;
	end

    %Get filename
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the filtered eeg matfile');
    end
    if isempty(fnames),
        return;
    end
    fname=fnames{1};
    drawnow;

    %Save fname
    ud.DataFileName=fname;

    %This loads Fs, saved_filter and saved_signals
    showMessage(ud.Handles.Texts.Message, 'Loading filtered signal from file', 0);
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    drawnow;
    load(fname);

%
%
%THIS PART IS DISABLED UNTIL WE SAVE AND LOAD FINAL THRESHOLD VALUES IN .MAT FILES.
%%%%%%%%%
if 0,
    %What is the entire signal duration
    sigduration=package.saved_signals.t(end)-package.saved_signals.t(1);
    
	%Option to work on part of the signal
	prompt  = {'Offset (s):', 'Duration (s):'};
	title   = sprintf('Work on part of the signal?');
	lines= 1;
	def     = {'0', num2str(sigduration)};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer)
        showMessage(ud.Handles.Texts.Message, 'Showing the entire signal.', 1);
    end
	if ~isempty(answer(1, :)),
      start_offset=abs(str2num(answer(1, :)));
      if start_offset>=sigduration,
        showMessage(ud.Handles.Texts.Message, ...
            'Offset larger than signal duration. Assuming zero offset.', 1);
        start_offset=0;
      end
    else
      start_offset=0;
	end
	if ~isempty(answer(2, :)),
      selected_duration=abs(str2num(answer(2, :)));
      if selected_duration+start_offset>sigduration,
          selected_duration=sigduration-start_offset;
      end
    else
      selected_duration=sigduration-start_offset;
	end
    
    %User-selected portion index
    usindex=find(...
package.saved_signals.t>=package.saved_signals.t(1)+start_offset & ...
package.saved_signals.t<=package.saved_signals.t(1)+start_offset+selected_duration);
    
    %Modify the loaded variables to contain the selected part
    package.saved_signals.t=package.saved_signals.t(usindex);
    package.saved_signals.eeg=package.saved_signals.eeg(usindex);
    package.saved_signals.y=package.saved_signals.y(usindex);

end    
%%%%%%%%%
%
%
%
    %Backward compatibility
    [package status]=make_backward_compatible(fname, package);
    if status,
        %Restore pointer
        set(fg, 'Pointer', old_ptr);
        return;
    end

	%Save loaded eeg data
	ud=save_loaded_eeg_data(package.Fs, package.Gain, package.saved_signals, fname, package.saved_filter, ud); 

    %Using the data, adjust the GUI
    ud=dataAdjustGUI(ud);
            
	%Finally, plot the traces and intervals
	ud=updateGraphs(ud);

    %Restore pointer
    set(fg, 'Pointer', old_ptr);

    %Update status info
    showMessage(ud.Handles.Texts.Message, 'DONE: Loading filtered signal from file', 1);
    
%%%%%%%%%%%%%%%%%%%%%%%%
% save_loaded_eeg_data %
%%%%%%%%%%%%%%%%%%%%%%%%
function ud=save_loaded_eeg_data(Fs, Gain, signals, fname, filter, ud)
  
  fg=gcbf;

  ud.data_features.Fs=Fs;
  ud.data_features.Gain=Gain;
  ud.data_features.first_tstamp=signals.t(1);
  ud.data_features.last_tstamp=signals.t(end);
  ud.YLimRaw=[min(signals.eeg) max(signals.eeg)]*1.01;
  %Store filter
  ud.filter=filter;
  
  %Save user data
  set(ud.Handles.Axes.Raw, 'UserData', signals);
  set(fg,'UserData', ud);  

%%%%%%%%%%%
% askGain %
%%%%%%%%%%%
function Gain=askGain()

	%Get gain from user
	prompt  = {'Please enter the gain for this channel'};
	title   = sprintf('Updating old data format');
	lines= 1;
	def     = {'2500'};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
	
	if isempty(answer)
        return;
    else
        Gain=str2num(answer);
        if isempty(Gain),
            return;
        end
	end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_filter_design_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_filter_design_callback(eventSrc,eventData)

	fg=gcbf;
	ud = get(fg,'UserData');

    %If no signal exists, return
    if isempty(ud.data_features.Fs),
      showMessage(ud.Handles.Texts.Message, 'Filter Design Error: Please load a signal first', 1);
      return;
    end
    
	%Get filter passband from user
	prompt  = {'Lowest passband frequency (Hz):', 'Highest passband frequency (Hz):'};
	title   = sprintf('Enter the passband limits');
	lines= 1;
	def     = {'', ''};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer)
        showMessage(ud.Handles.Texts.Message, 'Filter Design Error: Aborting filter design.', 1);
        return;
    end
	if ~isempty(answer(1, :)),
      low=str2num(answer(1, :));
    else
      low=[];
	end
	if ~isempty(answer(2, :)),
      high=str2num(answer(2, :));
    else
      low=[];
	end
	
	if isempty(low) | isempty(high),
      showMessage(ud.Handles.Texts.Message, 'Filter Design Error: Passband limits needed to design filter', 1);
      return;
	end
    
    if low>=high,
      showMessage(ud.Handles.Texts.Message, 'Filter Design Error: Lower limit should be smaller than the upper limit', 1);
      return;
    end

    if high>ud.data_features.Fs/2,
      showMessage(ud.Handles.Texts.Message, 'Filter Design Error: Upper limit should not be larger than half the sampling rate', 1);
      return;
    end

    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    showMessage(ud.Handles.Texts.Message, 'Designing Filter', 0);
    drawnow;
	ud.filter.F=[low-1 low high high+1];
    ud.filter.Fs=ud.data_features.Fs;
	M=[0 1 0];
	[n,fo,mo,w] = remezord(ud.filter.F, M, [1 1 1]*0.01, ud.data_features.Fs);
	ud.filter.b = remez(n,fo,mo,w);
    ud.filter.a=1;
    set(fg, 'Pointer', old_ptr);
    
    showMessage(ud.Handles.Texts.Message, 'DONE: Designing Filter', 0);

    %Filter signal
    ud=filter_signal(ud);

    %Note that signal changed
    ud.signal_change=1;
    ud.DisplayBuffers.signal_change=1;
    
    %Save results to file
%    ud=save_filtered_data('', ud);
    
    %Using the data, adjust the GUI
    ud=dataAdjustGUI(ud);
            
	%Finally, plot the traces and intervals
	ud=updateGraphs(ud);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_filter_load_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_filter_load_callback(eventSrc,eventData)
  
	fg=gcbf;
	ud = get(fg,'UserData');

    %If no signal exists, return
    if isempty(ud.data_features.Fs),
      showMessage(ud.Handles.Texts.Message, 'Filter Load Error: Please load a signal first', 1);
      return;
    end

    %Get filename
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the filter matfile');
    end
    if isempty(fnames),
        return;
    end
    fname=fnames{1};
    drawnow;
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    load(fname);
    saved_filter=package.saved_filter;
    
    %If the filter's Fs is different than the signal's, return
    if ud.data_features.Fs~=saved_filter.Fs,
      showMessage(ud.Handles.Texts.Message, ...
          'Filter Load Error: The filter and the signal differ in sampling rate. Redesign filter.', ...
          1);
      return;
    end
    
	ud.filter=saved_filter;
    
    %Filter signal
    ud=filter_signal(ud);
    
    %Note that signal changed
    ud.signal_change=1;
    ud.DisplayBuffers.signal_change=1;
    
    %Save results to file
%    ud=save_filtered_data('', ud);

    %Using the data, adjust the GUI
    ud=dataAdjustGUI(ud);
            
	%Finally, plot the traces and intervals
	ud=updateGraphs(ud);

    %Restore pointer
    set(fg, 'Pointer', old_ptr);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_filter_save_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_filter_save_callback(eventSrc,eventData)

	fg=gcbf;
	ud = get(fg,'UserData');
    
    %If no filter is specified, return
    if isempty(ud.filter.F),
      showMessage(ud.Handles.Texts.Message, 'Filter Save Error: No filter to save', 1);
      return;
    end

	%Get filename from user
	[fname,pname] = uiputfile('*.mat','Save filter as');
	if fname==0 & pname==0,
      showMessage(ud.Handles.Texts.Message, 'Filter Save Error: Filter not saved', 1);
      return;
	end
	fname=sprintf('%s%s', pname, fname);
    
	%Refresh GUI
	drawnow;
    
    package=[];
    package.saved_filter=ud.filter;
    showMessage(ud.Handles.Texts.Message, 'Saving file', 0);
    save(fname, 'package');
    showMessage(ud.Handles.Texts.Message, 'DONE: Saving file', 1);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_filter_fresponse_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_filter_fresponse_callback(eventSrc,eventData)

	fg=gcbf;
	ud = get(fg,'UserData');
    
    %If no filter is specified, return
    if isempty(ud.filter),
      showMessage(ud.Handles.Texts.Message, 'Filter Frequency Response Error: No filter to show', 1);
      return;
    end
    
	showMessage(ud.Handles.Texts.Message, 'Computing Frequency Response', 0);
	ff=0:0.1:ud.filter.Fs/2;
	hh=freqz(ud.filter.b, ud.filter.a, ff/ud.filter.Fs*2*pi);
    
    %Since we use filtfilt, the effective filter magnitude response is the square of the original, 
    %and the phase response is zero everywhere.
    hh=abs(hh).^2;
    
    s.xunits='Hz';
    s.yunits='dB';
    s.plot='both';
    figure;freqzplot(hh, ff, s);
	showMessage(ud.Handles.Texts.Message, 'DONE: Computing Frequency Response', 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_find_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_find_callback(eventSrc,eventData)

    fg=gcbf;
	ud = get(fg,'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    %Return if no signals
    if isempty(signals.t),
        return;
    end

    threshold=ud.threshold;
    
    params=get_interval_search_params(ud);
    if isempty(params),
        return;
    end
            
    %Check whether any change occurred, including signal change
    if ~is_different(threshold.peak_grouping_window, params.users_peak_grouping_window) & ...
       ~is_different(threshold.users, params.users_threshold) & ...
       ~is_different(threshold.intervalCutoff, params.users_intervalCutoff) & ...
       ~is_different(threshold.interval_power_screen_ranges, params.users_R) & ...
       ~is_different(threshold.interval_power_screen_ratio, params.users_K) & ...
       ~is_different(threshold.absmaxref, params.users_absmaxref) & ...
       ~is_different(threshold.interval_fusion_window, params.interval_fusion_window) & ...
       ~ud.signal_change,
        %Nothing changed
            showMessage(ud.Handles.Texts.Message, 'Current settings in effect', 1);
            return;
    end
    
    if isempty(params.users_R),
        msg=sprintf('Ignoring power comparison');
        showMessage(ud.Handles.Texts.Message, msg, 1);
    else
        msg=sprintf('Using the following ranges: ');
        for i=1:length(params.users_R)/2,
            msg=sprintf('%s%f %f, ', msg, params.users_R(2*i-1), params.users_R(2*i));
        end
        msg=msg(1:end-2);
        showMessage(ud.Handles.Texts.Message, msg, 1);
    end
    
    %Now, store them into structs    
    new_threshold=threshold;
    new_threshold.users=params.users_threshold;
    new_threshold.intervalCutoff=params.users_intervalCutoff;
    new_threshold.interval_power_screen_ranges=params.users_R;
    new_threshold.interval_power_screen_ratio=params.users_K;
    new_threshold.absmaxref=params.users_absmaxref;
    new_threshold.peak_grouping_window=params.users_peak_grouping_window;
    new_threshold.interval_fusion_window=params.users_interval_fusion_window;
    ud=set_thresholdstruct(ud, new_threshold);
        
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    drawnow;
        
    %Find intervals
    [ud signals]=findIntervals(ud);
    
	%At this point, the n'th interval is defined by [signals.start_indx(n) signals.end_indx(n)]
	%where the indeces are the entry numbers in flags, and thus in signals.y and my.
	%Create a copy of the eeg vector such that it contains NaN in the supra regions.
	%Create another copy that has NaNs in the complementing regions.
    ud=mark_supra_infra_eeg(ud);
    
    %Initialize the intervalCategories
    initIntervalCategories(ud, length(signals.start_indx));

	%plot the traces and intervals
	ud=updateGraphs(ud);
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);

    %Save ud
    set(fg, 'UserData', ud);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_find_feature_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_find_feature_callback(eventSrc,eventData)

    return;

    fg=gcbf;
    ud=get(fg, 'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    %Return if no signal
    if isempty(signals.eeg),
        return;
    end
    drawnow;
    
    peak_features.dtl=round(0.01*ud.data_features.Fs);
    peak_features.dtr=round(0.02*ud.data_features.Fs);
    peak_features.dvl=-0.7e-3/2;
    peak_features.dvr= 1e-3/2;
    
    peaks=get_peaks(signals.eeg, 1, 'neg');
    peaks=test_waveform_feature(peaks, signals.eeg, peak_features, ud);
    if isempty(peaks),
        return;
    end
                
    %Plot markers
    fns=fieldnames(ud.Handles.Lines);
    peak_markers_pos_exist=0;
    peak_markers_neg_exist=0;
    for i=1:length(fns),
        peak_markers_pos_exist=...
            peak_markers_pos_exist|strcmp(char(fns{i}), 'PeakMarkersPos');    
        peak_markers_neg_exist=...
            peak_markers_neg_exist|strcmp(char(fns{i}), 'PeakMarkersNeg');    
    end
    
    
    posnegcontrol=[0 1];
    peaks=[peaks;peaks];
    
    if posnegcontrol(1) & any(peaks(1,:)),
        XS=signals.t(find(peaks(1,:)==1));
        YS=signals.eeg(find(peaks(1,:)==1));
        if peak_markers_pos_exist & ~isempty(ud.Handles.Lines.PeakMarkersPos),
            set(ud.Handles.Lines.PeakMarkersPos, 'XData', XS, 'YData', YS);
        else
            ud.Handles.Lines.PeakMarkersPos=line(XS, YS, 'Parent', ud.Handles.Axes.Raw, ...
                'Marker', '*', 'LineStyle', 'none', 'Color', 'y');
        end
    end
    if posnegcontrol(2) & any(peaks(2,:)),
        XS=signals.t(find(peaks(2,:)==1));
        YS=signals.eeg(find(peaks(2,:)==1));
        if peak_markers_neg_exist & ~isempty(ud.Handles.Lines.PeakMarkersNeg),
            set(ud.Handles.Lines.PeakMarkersNeg, 'XData', XS, 'YData', YS);
        else
            ud.Handles.Lines.PeakMarkersNeg=line(XS, YS, 'Parent', ud.Handles.Axes.Raw, ...
                'Marker', '*', 'LineStyle', 'none', 'Color', 'b');
        end
    end
    
    %Store data
    set(fg, 'UserData', ud);
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_interval_search_params %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function params=get_interval_search_params(ud)

    params=[];

    threshold=ud.threshold;
    
    %Get search parameters
	Rmsg  = sprintf('Find intervals that have "K" times more power in the passband\n');
	Rmsg  = sprintf('%s([%.3f Hz %.3f Hz]) than in the following bands.\n', Rmsg, ...
                   ud.filter.F(2), ud.filter.F(3));
	Rmsg  = sprintf('%sThe frequencies you enter must be outside the passband.\n', Rmsg);
	Rmsg  = sprintf('%sLeave it blank to ignore this criterion in selecting intervals.\n', Rmsg);
	Rmsg  = sprintf('%sFormat: F1min F1max, F2min F2max, ...', Rmsg);
    
    Mmsg  = sprintf('Minimum duration (in cycles. 1 cycle=1/%.3f=%.3f s):', ...
        ud.filter.F(2), 1/ud.filter.F(2));
    
    if isempty(threshold.interval_power_screen_ranges),
    	Kdef='1';
        Rdef='';
    else
        Rdef=' ';
        for i=1:length(threshold.interval_power_screen_ranges)/2,
            Rdef=sprintf('%s, %f %f', ...
                Rdef, threshold.interval_power_screen_ranges(2*i-1), ...
                threshold.interval_power_screen_ranges(2*i));
        end
        Rdef=Rdef(4:end);
        
        Kdef=num2str(threshold.interval_power_screen_ratio);
    end
    if threshold.absmaxref,
        Adef='Y';
    else
        Adef='N';
    end
    
    prompt  = {'Threshold [0-1]:', ...
               Mmsg, ...
               'Power comparison ratio K (>0):', ...
               Rmsg, ...
               'Use absolute maximum as reference (Y/N):', ...
               'Peak grouping window (in cycles):', ...
               'Interval fusion window (in cycles):'};
	title   = sprintf('Interval Search Parameters');
	lines= 1;
	def     = {num2str(threshold.users), ...
               num2str(threshold.intervalCutoff), ...
               Kdef, ...
               Rdef, ...
               Adef, ...
               sprintf('%.3f', threshold.peak_grouping_window), ...
               sprintf('%.3f', threshold.interval_fusion_window)};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer),
        return;
    end
    
    users_threshold=str2num(answer(1,:));
    if isempty(users_threshold),
    	showMessage(ud.Handles.Texts.Message, 'Threshold needed', 1);
        return;
    else
        if users_threshold<0,
        	showMessage(ud.Handles.Texts.Message, 'Threshold negative', 1);
            return;
        end
    end
        
    users_intervalCutoff=str2num(answer(2,:));
    if isempty(users_intervalCutoff),
    	showMessage(ud.Handles.Texts.Message, 'Minimum duration needed', 1);
        return;
    end

    %Get K. Check validity after ranges
    users_K=str2num(answer(3,:));
    
    %Get ranges
    range_text=answer(4,:);   
    if ~isempty(range_text),
        %First put a comma to the end so there is at least one delimiter.
        range_text=sprintf('%s,', range_text);
        commaplaces=charfind(range_text, ',');
        start_indx=1;
        range_counter=1;
        for i=1:length(commaplaces),
            current_segment=range_text(start_indx:commaplaces(i)-1);
            start_indx=commaplaces(i)+1;      
            
            if isempty(current_segment),
                continue;
            end
            
            current_range=sscanf(current_segment, '%f');
            if length(current_range)~=2,
                continue;
            end
            
            %make sure the values are ascending
            if current_range(2)<current_range(1),
                %They are descending. Can't accept
                showMessage(ud.Handles.Texts.Message, ...
                    'Upper cutoff cannot be smaller than lower cutoff', 1);
                continue;
            end
            
            %Do they overlap with the passband?
            if any(current_range>=ud.filter.F(2) & current_range<=ud.filter.F(3)) | ...
               any(ud.filter.F(2:3)>=current_range(1) & ud.filter.F(2:3)<=current_range(2)),
                %Yes. Can't accept
                showMessage(ud.Handles.Texts.Message, ...
                    'Overlaps with passband not accepted', 1);
                continue;
            end
            
            %The lower bound should not be larger than Fs/2.
            if current_range(1)>ud.filter.Fs/2,
                continue;
            end
            
            %If the upper bound is larger than Fs/2, set it to Fs/2
            current_range(2)=min(ud.filter.Fs/2, current_range(2));
            
            ranges(2*range_counter*[1 1]-[1 0])=current_range;
            range_counter=range_counter+1;
        end
        
        %If some ranges were found, make sure they are in ascending order
        if range_counter~=1,
            starts=ranges(1:2:end-1);
            ends  =ranges(2:2:end);
            
            [starts, indx]=sort(starts);
            ends=ends(indx);
            %At this point, the start of the intervals are in increasing order
            %If the sub-ranges overlap, then ask the user to re-enter
            overlap=0;
            for i=2:length(starts),
                overlap=any(ends(i-1)>=starts(i:end))|overlap;
            end
            if overlap,
                showMessage(ud.Handles.Texts.Message, ...
                    'There are overlapping intervals. Please re-enter.', 1);
                return;
            end
        end
        
        %If no valid ranges were found reset ranges
        if range_counter==1,
            ranges=[];
        end
    end
    users_R=ranges;
    
    if ~isempty(users_R) & isempty(users_K),
    	showMessage(ud.Handles.Texts.Message, 'Power ratio K needed', 1);
        return;
    end

    %Get absmaxref choice
    users_absmaxref=lower(answer(5,:));
    if isempty(users_absmaxref),
    	showMessage(ud.Handles.Texts.Message, 'Specify reference threshold computation method', 1);
        return;
    else
        %Find the first nonspace character
        nonspace_indx=min(find(isspace(users_absmaxref)==0));
        users_absmaxref=users_absmaxref(nonspace_indx);
        if users_absmaxref~='y' & users_absmaxref~='n',
        	showMessage(ud.Handles.Texts.Message, 'Specify reference threshold computation method', 1);
            return;
        end
    end
    
    %Get the grouping duration
    users_peak_grouping_window=str2num(answer(6,:));
    if isempty(users_peak_grouping_window),
    	showMessage(ud.Handles.Texts.Message, 'Peak grouping window duration needed', 1);
        return;
    elseif users_peak_grouping_window<=0,
       	showMessage(ud.Handles.Texts.Message, ...
            'Peak grouping window duration should be positive', 1);
        return;
    end
    
    %Get the interval fusion duration
    users_interval_fusion_window=str2num(answer(7,:));
    if isempty(users_interval_fusion_window),
    	showMessage(ud.Handles.Texts.Message, 'Interval fusion window duration needed', 1);
        return;
    elseif users_interval_fusion_window<0,
       	showMessage(ud.Handles.Texts.Message, ...
            'Interval fusion window duration should be positive or zero', 1);
        return;
    end
    
    params.users_interval_fusion_window=users_interval_fusion_window;
    params.users_peak_grouping_window=users_peak_grouping_window;
    params.users_threshold=users_threshold;
    params.users_intervalCutoff=users_intervalCutoff;
    params.users_R=users_R;
    params.users_K=users_K;
    params.users_absmaxref=users_absmaxref=='y';
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_insert_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_insert_callback(eventSrc,eventData)

	fg=gcbf;
	ud = get(fg,'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    %Return if no signals
    if isempty(signals.t),
        return;
    end
    
    %This is to avoid the highlighting of intervals during selection within an interval
    ud.inserting_interval=1;
    set(fg, 'UserData', ud);
    
    showMessage(ud.Handles.Texts.Message, ...
        'Drag a rectangle over the signal. Or press any key to cancel.', 0);
    
	w = waitforbuttonpress;
	if w,
        return;
	end    
    showMessage(ud.Handles.Texts.Message, ...
        '', 1);
 
    %Get the points
    pt1=get(ud.Handles.Axes.Raw, 'CurrentPoint');
    rbbox;
    ud=erase_intervals(ud);
    drawnow;
    pt2=get(ud.Handles.Axes.Raw, 'CurrentPoint');
        
    %Make sure that pt1 is to the left of pt2
    if pt2(1)<pt1(1),
        temp=pt1;
        pt1=pt2;
        pt2=temp;
    end
    
    %Is the selection  valid?
    if pt2(1)<=ud.data_features.first_tstamp | ...
       pt1(1)>=ud.data_features.last_tstamp,    
           showMessage(ud.Handles.Texts.Message, ...
                'Invalid Selection', 1);
            return;
    end
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    if pt1(1)<ud.data_features.first_tstamp,
        pt1(1)=ud.data_features.first_tstamp;
    end
    if pt2(1)>ud.data_features.last_tstamp,
        pt2(1)=ud.data_features.last_tstamp;
    end
            
    %Get the indeces of the time points
    diff=abs(signals.t-pt1(1));
    t1_indx=min(find(diff==min(diff)));
    diff=abs(signals.t-pt2(1));
    t2_indx=min(find(diff==min(diff)));
    
    %Find all existing intervals that are contained in the selection
    enclosed=find(signals.start_indx>=t1_indx & signals.end_indx<=t2_indx);
    
    %Does the beginning overlap with an interval?
    start_overlap=find(signals.start_indx<=t1_indx & ...
                       signals.end_indx>=t1_indx & ...
                       signals.end_indx<=t2_indx);
    
    %Does the end overlap with an interval?
    end_overlap=find(signals.start_indx>=t1_indx & ...
                     signals.start_indx<=t2_indx & ...
                     signals.end_indx>=t2_indx);
    
    %Is the selection included in an interval?
    surrounding=find(signals.start_indx<=t1_indx & signals.end_indx>=t2_indx);
    
    %Mark and delete all these
    marked=[enclosed start_overlap end_overlap surrounding];
    if ~isempty(marked),
        
        %erase intervals
        ud=erase_intervals(ud);
        drawnow;
        
        signals.start_indx(marked)=signals.start_indx(marked).*0-1;
        survivors=find(signals.start_indx~=-1);
        signals.start_indx=signals.start_indx(survivors);
        signals.end_indx=signals.end_indx(survivors);
    end
    
    %Now insert it
    signals.start_indx=sort([signals.start_indx t1_indx]);
    signals.end_indx=sort([signals.end_indx t2_indx]);
    
    %Save
    set(ud.Handles.Axes.Raw, 'UserData', signals);
    
    %At this point we have the new intervals ready.
    %Color the raw eeg segments based on interval inclusion.
    ud=mark_supra_infra_eeg(ud);
    
    %Initialize the intervalCategories
    initIntervalCategories(ud, length(signals.start_indx));

    %Allow the highlighting of intervals
    ud.inserting_interval=0;
    
    %plot the traces and intervals
	ud=updateGraphs(ud);
        
    %Restore pointer
    set(fg, 'Pointer', old_ptr);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_delete_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_delete_callback(eventSrc,eventData)

	fg=gcbf;
    
	ud = get(fg,'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, []);
        if returnflag,
            return;
        end
    end

    %are there any intervals?
    if isempty(signals.start_indx),
      showMessage(ud.Handles.Texts.Message, 'No interval to select', 1);
      return;        
    end
    
    %What categories do we want to delete?
    prompt  = {'Categories to delete. Enter * to delete all.'};
	title   = sprintf('Select interval categories');
	lines= 1;
	def     = {'*'};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer),
        return;
    end
    nonspace_indx=find(isspace(answer)==0);
    if length(nonspace_indx)==1,
        if answer(nonspace_indx)=='*',
            to_be_deleted='*';
        else
            to_be_deleted=str2num(answer);
        end
    else
        to_be_deleted=str2num(answer);
    end
    
    if isempty(to_be_deleted),
        return;
    end
    
    %Get the interval categories
    intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');

    %Check whether the selected categories exist
    if to_be_deleted=='*',
        labeled=ones(1, length(intervalCategories.categories));
    else
        labeled=zeros(1, length(intervalCategories.categories));
        for i=1:length(to_be_deleted),
            labeled=labeled|intervalCategories.categories==to_be_deleted(i);
        end
    end
    if all(labeled==0),
        showMessage(ud.Handles.Texts.Message, ...
            'No such category', 1);
        return;
    end    

    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    %Erase the labels of those to be deleted and deselect the current interval
    ud=erase_intervals(ud, to_be_deleted);

    %Now reduce the arrays
    survivors=find(labeled==0);
    intervalCategories.categories=intervalCategories.categories(survivors);
    intervalCategories.label_text_handles=...
        intervalCategories.label_text_handles(:,survivors);
    %Store the updated interval categories
    set(ud.Handles.Axes.Filtered, 'UserData', intervalCategories);
    
    
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    signals.start_indx=signals.start_indx(survivors);
    signals.end_indx=signals.end_indx(survivors);
    set(ud.Handles.Axes.Raw, 'UserData', signals);    
    
    %Unmark supraeeg in deleted intervals
    ud=mark_supra_infra_eeg(ud);
    
    %Update Graphs
    ud=updateGraphs(ud);

    %Restore pointer
    set(fg, 'Pointer', old_ptr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_selectall_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_selectall_callback(eventSrc,eventData)
	fg=gcbf;
	ud = get(fg,'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');

    %are there any intervals?
    if isempty(signals.start_indx),
      showMessage(ud.Handles.Texts.Message, 'No interval to select', 1);
      return;        
    end

    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, signals);
        if returnflag,
            return;
        end
    end
    
    %What is the category label?
	prompt  = {'Category label:'};
	title   = sprintf('Enter category label');
	lines= 1;
	def     = {'8'};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer),
      showMessage(ud.Handles.Texts.Message, 'Can''t select intervals without a label', 1);
      return;        
    end

    drawnow;
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    for i=1:length(signals.start_indx),
        ud=set_current_interval(ud, i);
        labelCurrentInterval(ud, answer);
    end
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);
   
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_unselectall_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_unselectall_callback(eventSrc,eventData)
	fg=gcbf;
	ud = get(fg,'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');

    %are there any intervals?
    if isempty(signals.start_indx),
      showMessage(ud.Handles.Texts.Message, 'No interval to select', 1);
      return;        
    end

    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, signals);
        if returnflag,
            return;
        end
    end
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    %Category label is 0
    for i=1:length(signals.start_indx),
        ud=set_current_interval(ud, i);
        labelCurrentInterval(ud, '0');
    end
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_complement_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_complement_callback(eventSrc,eventData)
	fg=gcbf;
	ud = get(fg,'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');

    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, signals);
        if returnflag,
            return;
        end
    end
        
    %are there any intervals?
    if isempty(signals.start_indx),
      showMessage(ud.Handles.Texts.Message, 'No interval to select', 1);
      return;        
    end

    %What is the category label?
	prompt  = {'Category label:'};
	title   = sprintf('Enter category label');
	lines= 1;
	def     = {'9'};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer),
      showMessage(ud.Handles.Texts.Message, 'Can''t select intervals without a label', 1);
      return;        
    end

    showMessage(ud.Handles.Texts.Message, 'Selecting complement', 0);
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    %Reset current interval settings
    ud=erase_intervals(ud);
    
    last_indx=length(signals.y);

    %are there any intervals?
    if isempty(signals.start_indx),
        complement_starts=1;
        complement_ends=last_indx;
    elseif length(signals.start_indx)==1,
        complement_starts=signals.end_indx;
        complement_ends=signals.start_indx;
        
        if (signals.start_indx(1)~=1),
            complement_starts=[1 complement_starts];
        else
            complement_ends=[];
        end
        if (signals.end_indx(end)==last_indx),
            complement_starts=[];
        else
            complement_ends=[complement_ends last_indx];
        end
    else
        complement_starts=signals.end_indx;
        complement_ends=signals.start_indx;
        
        if (signals.start_indx(1)~=1),
            complement_starts=[1 complement_starts];
        else
            complement_ends=complement_ends(2:end);
        end
        if (signals.end_indx(end)==last_indx),
            complement_starts=complement_starts(1:end-1);
        else
            complement_ends=[complement_ends last_indx];
        end        
    end
    
    signals.start_indx=complement_starts;
    signals.end_indx=complement_ends;
        
    %Save data
    set(ud.Handles.Axes.Raw, 'UserData', signals);
    set(fg, 'UserData', ud);    
    
    %Mark the intervals in red
    ud=mark_supra_infra_eeg(ud);

    %Initialize the intervalCategories
    initIntervalCategories(ud, length(signals.start_indx));
        
    %Update graphs
    ud=updateGraphs(ud);
    
    %Label all intervals
    for i=1:length(signals.start_indx),
        ud=set_current_interval(ud, i);
        labelCurrentInterval(ud, answer);
    end
    
    showMessage(ud.Handles.Texts.Message, 'DONE: Selecting complement', 1);
    set(fg, 'Pointer', old_ptr);

    %Save data
    set(fg, 'UserData', ud);    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_select_tstamp_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_select_tstamp_callback(eventSrc,eventData)

	fg=gcbf;
	ud = get(fg,'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');

    %are there any intervals?
    if isempty(signals.start_indx),
      showMessage(ud.Handles.Texts.Message, 'No interval to select', 1);
      return;        
    end

    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, signals);
        if returnflag,
            return;
        end
    end
    
    %What is the category label and time ranges?
	prompt  = {'Time ranges (s). Format: t1min t1max, t2min t2max, ...', ...
               'Label:'};
	title   = sprintf('Enter selection data');
	lines= 1;
	def     = {'', ''};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;

    if isempty(answer),
        return;
    end
    
    label=str2num(answer(2,:));
    if isempty(label),
        return;
    end
    label=num2str(label);
    
    %Get ranges
    range_text=answer(1, :);
    if isempty(range_text),
        return;
    else
        %First put a comma to the end so there is at least one delimiter.
        range_text=sprintf('%s,', range_text);
        commaplaces=charfind(range_text, ',');
        start_indx=1;
        range_counter=1;
        for i=1:length(commaplaces),
            current_segment=range_text(start_indx:commaplaces(i)-1);
            start_indx=commaplaces(i)+1;      
            
            if isempty(current_segment),
                continue;
            end
            
            current_range=sscanf(current_segment, '%f');
            if length(current_range)~=2,
                continue;
            end
            
            %make sure the values are ascending
            if current_range(2)<current_range(1),
                %They are descending. Can't accept
                showMessage(ud.Handles.Texts.Message, ...
                    'Upper time limit cannot be smaller than lower time limit', 1);
                continue;
            end
                        
            %The lower bound should not be larger than the last tstamp.
            if current_range(1)>ud.data_features.last_tstamp,
                continue;
            end
            
            ranges(2*range_counter*[1 1]-[1 0])=current_range;
            range_counter=range_counter+1;
        end
        
        %If some ranges were found, make sure they are in ascending order
        if range_counter~=1,
            starts=ranges(1:2:end-1);
            ends  =ranges(2:2:end);
            
            [starts, indx]=sort(starts);
            ends=ends(indx);
            %At this point, the start of the intervals are in increasing order
            %If the sub-ranges overlap, then ask the user to re-enter
            overlap=0;
            for i=2:length(starts),
                overlap=any(ends(i-1)>=starts(i:end))|overlap;
            end
            if overlap,
                showMessage(ud.Handles.Texts.Message, ...
                    'There are overlapping intervals. Please re-enter.', 1);
                ranges=[];
            end
        end
        
        %If no valid ranges were found reset ranges
        if range_counter==1,
            ranges=[];
        elseif ~overlap,
            %Some or all ranges were understood.
        end
    end
    users_R=ranges;
        
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    for i=1:length(signals.start_indx),
        
        start_outside=0;
        end_outside=0;

        %Inclusion based on interval start tstamp
        range_start_indx=max(find(users_R<=signals.t(signals.start_indx(i))));
        if isempty(range_start_indx),
            start_outside=1;
        else
            if ~is_different(rem(range_start_indx,2), 0) & ...
               is_different(users_R(range_start_indx), signals.t(signals.start_indx(i))),
                start_outside=1;
            end
        end
        range_end_indx=min(find(users_R>=signals.t(signals.start_indx(i))));
        if isempty(range_end_indx),
            start_outside=1;
        else
            if rem(range_end_indx,2)==1 & ...
               is_different(users_R(range_end_indx), signals.t(signals.start_indx(i))),
                start_outside=1;
            end
        end
        if is_different(range_start_indx, range_end_indx) & ...
           is_different(range_start_indx+1, range_end_indx),
            start_outside=1;
        end
        
        %Inclusion based on interval end tstamp
        range_start_indx=max(find(users_R<=signals.t(signals.end_indx(i))));
        if isempty(range_start_indx),
            end_outside=1;
        else
            if ~is_different(rem(range_start_indx,2), 0) & ...
               is_different(users_R(range_start_indx), signals.t(signals.end_indx(i))),
                end_outside=1;
            end
        end
        range_end_indx=min(find(users_R>=signals.t(signals.end_indx(i))));
        if isempty(range_end_indx),
            end_outside=1;
        else
            if rem(range_end_indx,2)==1 & ...
               is_different(users_R(range_end_indx), signals.t(signals.end_indx(i))),
                end_outside=1;
            end
        end
        if is_different(range_start_indx, range_end_indx) & ...
           is_different(range_start_indx+1, range_end_indx),
            end_outside=1;
        end
        
        if start_outside & end_outside,
            continue;
        end
        
        ud=set_current_interval(ud, i);
        labelCurrentInterval(ud, label);
    end
        
    %Restore pointer
    set(fg, 'Pointer', old_ptr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_select_maxvolt_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_select_maxvolt_callback(eventSrc,eventData)

	fg=gcbf;
	ud = get(fg,'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');

    %are there any intervals?
    if isempty(signals.start_indx),
      showMessage(ud.Handles.Texts.Message, 'No interval to select', 1);
      return;        
    end

    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, signals);
        if returnflag,
            return;
        end
    end

    %Obtain the max amplitude values
    maxes=zeros(1, length(signals.start_indx));
    for i=1:length(signals.start_indx),
        maxes(i)=...
            max(abs(signals.y(signals.start_indx(i):signals.end_indx(i))));
    end    
    
    %What is the category label and time ranges?
    pmsg=sprintf('Select in the range %.3f - %.3f microvolts.\n', ...
        min(maxes)*1e6, max(maxes)*1e6);
    pmsg=sprintf('%sFormat (in microvolts): v1min v1max, v2min v2max, ...', pmsg);
	prompt  = {pmsg, ...
               'Label:'};
	title   = sprintf('Select intervals by\nmaximum absolute filtered amplitude');
	lines= 1;
	def     = {'', ''};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;

    if isempty(answer),
        return;
    end
    
    label=str2num(answer(2,:));
    if isempty(label),
        return;
    end
    label=num2str(label);
    
    %Get ranges
    range_text=answer(1, :);
    if isempty(range_text),
        return;
    else
        %First put a comma to the end so there is at least one delimiter.
        range_text=sprintf('%s,', range_text);
        commaplaces=charfind(range_text, ',');
        start_indx=1;
        range_counter=1;
        for i=1:length(commaplaces),
            current_segment=range_text(start_indx:commaplaces(i)-1);
            start_indx=commaplaces(i)+1;      
            
            if isempty(current_segment),
                continue;
            end
            
            current_range=sscanf(current_segment, '%f');
            if length(current_range)~=2,
                continue;
            end
            
            %make sure the values are ascending
            if current_range(2)<current_range(1),
                %They are descending. Can't accept
                showMessage(ud.Handles.Texts.Message, ...
                    'Upper range limit cannot be smaller than lower range limit', 1);
                continue;
            end
                        
            ranges(2*range_counter*[1 1]-[1 0])=current_range;
            range_counter=range_counter+1;
        end
        
        %If some ranges were found, make sure they are in ascending order
        if range_counter~=1,
            starts=ranges(1:2:end-1);
            ends  =ranges(2:2:end);
            
            [starts, indx]=sort(starts);
            ends=ends(indx);
            %At this point, the start of the intervals are in increasing order
            %If the sub-ranges overlap, then ask the user to re-enter
            overlap=0;
            for i=2:length(starts),
                overlap=any(ends(i-1)>=starts(i:end))|overlap;
            end
            if overlap,
                showMessage(ud.Handles.Texts.Message, ...
                    'There are overlapping ranges. Please re-enter.', 1);
                ranges=[];
            end
        end
        
        %If no valid ranges were found reset ranges
        if range_counter==1,
            ranges=[];
        elseif ~overlap,
            %Some or all ranges were understood.
        end
    end
    users_R=ranges/1e6;
        
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    for i=1:length(maxes),

        range_start_indx=max(find(users_R<=maxes(i)));
        if isempty(range_start_indx),
            continue;
        end
        if rem(range_start_indx,2)==0 & ...
           users_R(range_start_indx)~=maxes(i),
            continue;
        end
        range_end_indx=min(find(users_R>=maxes(i)));
        if isempty(range_end_indx),
            continue;
        end
        if rem(range_end_indx,2)==1 & ...
           users_R(range_end_indx)~=maxes(i),
            continue;
        end
        if range_start_indx~=range_end_indx & range_start_indx+1~=range_end_indx,
            continue;
        end
        
        ud=set_current_interval(ud, i);
        labelCurrentInterval(ud, label);
    end
        
    %Restore pointer
    set(fg, 'Pointer', old_ptr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_export_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_export_callback(eventSrc,eventData)
	fg=gcbf;
	ud = get(fg,'UserData');
  
    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, []);
        if returnflag,
            return;
        end
    end
        
	intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
	if ~isempty(intervalCategories.categories)
      labels=find(intervalCategories.categories~=0);
	else
      labels=[];
	end
	if isempty(labels)
      %No labeled intervals
      showMessage(ud.Handles.Texts.Message, 'Export error: No labeled interval', 1);
      return;
	end
	
	%Get filename from user
	[fname,pname] = uiputfile('*.nex','Save intervals as');
	if fname==0 & pname==0,
      return;
	end
	nexfname=sprintf('%s%s', pname, fname);
	
	%Refresh GUI
	drawnow;
	
	signals=get(ud.Handles.Axes.Raw, 'UserData');
	labels=intervalCategories.categories(labels);

    showMessage(ud.Handles.Texts.Message, 'Saving file', 0);
    
    counter=1;
	for i=min(labels):max(labels),
      index=find(intervalCategories.categories==i);
      if isempty(index),
          continue;
      end
      
      interval_struct(counter).label=i;
      
      starts=signals.t(signals.start_indx(index))*1e4;
      starts=reshape(starts, 1, max(size(starts)));
      ends=signals.t(signals.end_indx(index))*1e4;
      ends=reshape(ends, 1, max(size(ends)));
      
      interval_struct(counter).data=[starts ends];
      counter=counter+1;
      
	end %i=min(labels):max(labels)
	
    %Convert to nex
    if(writeNexIntervals(nexfname, 10000, interval_struct))
        showMessage(ud.Handles.Texts.Message, 'Error exporting to nex', 0);
    end
    showMessage(ud.Handles.Texts.Message, 'DONE: Saving file', 1);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_save_callback     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_save_callback(eventSrc,eventData)
	fg=gcbf;
    
	ud = get(fg,'UserData');
    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, []);
        if returnflag,
            return;
        end
    end

    %Are there any intervals
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    if isempty(signals.start_indx),
        return;
    end
    
    %What categories do we want to save?
    prompt  = {'Categories to save. Enter * to save all.'};
	title   = sprintf('Select interval categories');
	lines= 1;
	def     = {'*'};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer),
        return;
    end
    nonspace_indx=find(isspace(answer)==0);
    if length(nonspace_indx)==1,
        if answer(nonspace_indx)=='*',
            to_be_saved='*';
        else
            to_be_saved=str2num(answer);
        end
    else
        to_be_saved=str2num(answer);
    end
    
    if isempty(to_be_saved),
        return;
    end
    
    %Do these categories exist?
    if to_be_saved~='*',
        intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
        present=0;
        for i=length(to_be_saved),
            present=present|...
                ~isempty(find(intervalCategories.categories==to_be_saved(i)));
        end
        if ~present,
            showMessage(ud.Handles.Texts.Message, 'No such category', 1);
            return;
        end
    end
    
	%Get filename from user
	[fname,pname] = uiputfile('*.mat','Save intervals as');
	if fname==0 & pname==0,
      return;
	end
	fname=sprintf('%s%s', pname, fname);
	
	%Refresh GUI
	drawnow;

    %Save it
    save_interval_matfile(fname, [], [], to_be_saved);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_load_callback     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_load_callback(eventSrc,eventData)
	fg=gcbf;
	ud = get(fg,'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    %If there is no filtered signal, return
    if isempty(signals.y),
        showMessage(ud.Handles.Texts.Message, ...
            'Interval Load Error: A filtered signal must be present', 1);
        return;
    end
    
    %Get filename
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the interval matfile to load');
    end
    if isempty(fnames),
        return;
    end
    fname=fnames{1};
    drawnow;

    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    load(fname);
    
    %Check whether the time stamps match
    local_start_times=signals.t(package.start_indx);
    local_end_times=signals.t(package.end_indx);
    starts_are_same=local_start_times==package.start_times;
    ends_are_same=local_end_times==package.end_times;
    if any(starts_are_same==0) | any(ends_are_same==0),
        showMessage(ud.Handles.Texts.Message, ...
            'Interval Load Error: Interval tstamps do not match current file', 1);
        return;
    end
    
    %Reset current interval settings
    ud=erase_intervals(ud);
    
    %No threshold or interval cutoff is defined when loading intervals.
    threshold=ud.threshold;
    threshold.users=[];
    threshold.intervalCutoff=[];
    ud=set_thresholdstruct(ud, threshold);    

    %Store the new intervals
    signals.start_indx=package.start_indx;
    signals.end_indx  =package.end_indx;
    set(ud.Handles.Axes.Raw, 'UserData', signals);
    
    %Color the eeg segments depending on interval inclusion
    ud=mark_supra_infra_eeg(ud);
                
    %Initialize the intervalCategories
    initIntervalCategories(ud, length(signals.start_indx));
    
    %Update graphs
	ud=updateGraphs(ud);

    %Now store the saved interval categories, and label the intervals    
	intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
    intervalCategories.categories=package.categories;
    categories=package.categories;
	set(ud.Handles.Axes.Filtered, 'UserData', intervalCategories);
    
    %Print labels for nonzero categories
    index=find(categories~=0);
    for i=1:length(index),
        %Print new label
        label=num2str(categories(index(i)));
        
        ud=set_current_interval(ud, i);
        labelCurrentInterval(ud, label);
    end
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);

    %Save data
    set(fg, 'UserData', ud);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_deemp_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_deemp_callback(eventSrc,eventData)
	fg = gcbf;
	ud = get(fg,'UserData');
    
	intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
	if isempty(intervalCategories.categories)
      showMessage(ud.Handles.Texts.Message, 'No interval category', 1);
      return;
	end

    %Get the category label for the intervals to be deemphasized
	prompt  = {'Category label:'};
	title   = sprintf('Deemphasize which interval category?');
	lines= 1;
	def     = {'0'};
	answer  = str2num(char(inputdlg(prompt,title,lines,def)));
    
    if isempty(answer),
      showMessage(ud.Handles.Texts.Message, 'Can''t select intervals without a label', 1);
      return;        
    end
    drawnow;
    
    button = questdlg('Data will be irreversibly modified in the current session',...
	'Confirm','Yes','No','No');
	if strcmp(button,'No')
        return;
	end
    drawnow;

    %This procedure will modify the data. Do not overwrite the original using the
    %original file name.
    ud.DataFileName=[];
	ud.FigureName=sprintf('eegrhythm %s (%.3f Hz)', ud.DataFileName, ud.filter.Fs);
    set(fg, 'Name', ud.FigureName);
    
    %Get signals
    signals = get(ud.Handles.Axes.Raw, 'UserData');
   
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    %Start processing the intervals
    targets=find(intervalCategories.categories==answer);
    for i=1:length(targets),
        current_interval=targets(i);
        %How long is this interval?
        range=signals.start_indx(current_interval):signals.end_indx(current_interval);
        interval_length=length(range);
            
        %Zero the amplitude
        window=zeros(1, interval_length);
        
        %Deemphasize the segment of the raw and filtered eeg.
        signals.eeg(range)=signals.eeg(range).*window;
        signals.y(range)=signals.y(range).*window;
    end
    
    %Store the new signals.
    set(ud.Handles.Axes.Raw, 'UserData', signals);
    
    %Note that signal changed
    ud.signal_change=1;
    ud.DisplayBuffers.signal_change=1;
        
    %Refresh raw eeg
    ud=mark_supra_infra_eeg(ud);
    
	%plot the traces and intervals
	ud=updateGraphs(ud);

    %Restore pointer
    set(fg, 'Pointer', old_ptr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_jumpto_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_jumpto_callback(eventSrc,eventData)
    
	fg=gcbf;
	ud = get(fg,'UserData');
    signals = get(ud.Handles.Axes.Raw, 'UserData');
    
    %If there are no intervals, return
    if isempty(signals.start_indx),
        showMessage(ud.Handles.Texts.Message, 'No interval', 1);
        return;
    end

    %Ask where to jump
    pmt=sprintf('Jump to (1-%d)', length(signals.start_indx));
	prompt  = {pmt};
	title   = sprintf('Enter interval number to jump to');
	lines= 1;
	def     = {''};
	answer  = str2num(char(inputdlg(prompt,title,lines,def)));
    drawnow;
    
    if isempty(answer)
        showMessage(ud.Handles.Texts.Message, 'Unresolved number', 1);
        return;
    end

    jump_number=min(ceil(round(abs(answer))), length(signals.start_indx));
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    ud=set_current_interval(ud, jump_number);
    
	%At this point, we have the desired interval selected. Bring its 
	%center to the center of the screen. The interval is highlighted in updateGraphs 
	%called by reposition_interval
	ud=reposition_interval(ud);

    %Restore pointer    
    set(fg, 'Pointer', old_ptr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_change_label_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_change_label_callback(eventSrc,eventData)
    
	fg=gcbf;
	ud = get(fg,'UserData');
    signals = get(ud.Handles.Axes.Raw, 'UserData');
    
    %If there are no intervals, return
    if isempty(signals.start_indx),
        showMessage(ud.Handles.Texts.Message, 'No interval', 1);
        return;
    end
    
    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, signals);
        if returnflag,
            return;
        end
    end
    
    %Get label change data
    prompt  = {'From', 'To'};
	title   = sprintf('Change interval labels');
	lines= 1;
	def     = {'', ''};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer),
        return;
    end
    
    for i=1:2,
        empty_field(i)=isempty(str2num(answer(i,:)));
    end
    if any(empty_field==1),
        return;
    end

    for i=1:2,
        params(i)=ceil(abs(str2num(answer(i, :))));
    end
    
    %Find the intervals whose label is params(1)
    intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
    indx=find(intervalCategories.categories==params(1));
    
    if isempty(indx),
        msg=sprintf('No interval with label %d', params(1));
        showMessage(ud.Handles.Texts.Message, msg, 1);
        return;
    end

    %Change the label of those intervals
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    for i=1:length(indx),
        ud=set_current_interval(ud, indx(i));
        labelCurrentInterval(ud, num2str(params(2)));
    end
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_interval_operation_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_interval_operation_callback(eventSrc,eventData)
	fg=gcbf;
	ud = get(fg,'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    %If there is no filtered signal, return
    if isempty(signals.y),
        showMessage(ud.Handles.Texts.Message, ...
            'Interval Load Error: A filtered signal must be present', 1);
        return;
    end

    %Who called?
    switch get(eventSrc, 'Label'),
        case {'Logical AND', 'Absent there'}
            %If there is no interval, the result will be the current state
            if isempty(signals.start_indx),
                showMessage(ud.Handles.Texts.Message, ...
                    'Done', 1);
                return;
            end
        case 'Logical OR'
            %If there is a single interval that covers the entire signal, 
            %the result will be the current state
            if length(signals.start_indx)==1 & ...
               signals.start_indx==1 & ...
               signals.end_indx==length(signals.t),
                showMessage(ud.Handles.Texts.Message, ...
                    'Done', 1);
                return;
            end
    end    
    
    %Get filename
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select an interval matfile for this operation.');
    end
    if isempty(fnames),
        return;
    end
    fname=fnames{1};
    drawnow;
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    load(fname);
    
    %Check whether the time stamps match
    local_start_times=signals.t(package.start_indx);
    local_end_times=signals.t(package.end_indx);
    starts_are_same=local_start_times==package.start_times;
    ends_are_same=local_end_times==package.end_times;
    if any(starts_are_same==0) | any(ends_are_same==0),
        showMessage(ud.Handles.Texts.Message, ...
            'Interval Load Error: Interval tstamps do not match current file', 1);
        set(fg, 'Pointer', old_ptr);
        return;
    end

    %Get current interval bitfield
    current_bit_field=get_interval_bitfield(length(signals.t), ...
                                            signals.start_indx, ...
                                            signals.end_indx);
    %Get loaded interval bitfield
    loaded_bit_field=get_interval_bitfield(length(signals.t), ...
                                            package.start_indx, ...
                                            package.end_indx);
    
    %Who called?
    switch get(eventSrc, 'Label'),
        case 'Logical AND'
            result_bit_field=current_bit_field & loaded_bit_field;
        case 'Logical OR'
            result_bit_field=current_bit_field | loaded_bit_field;
        case 'Absent here'
            result_bit_field=current_bit_field.*0;
            
            for i=1:length(package.start_indx),
                range=package.start_indx(i):package.end_indx(i);
                if all(current_bit_field(range)==0),
                    result_bit_field(range)=result_bit_field(range)|1;
                end
            end
        case 'Absent there'
            result_bit_field=current_bit_field.*0;
            
            for i=1:length(signals.start_indx),
                range=signals.start_indx(i):signals.end_indx(i);
                if all(loaded_bit_field(range)==0),
                    result_bit_field(range)=result_bit_field(range)|1;
                end
            end
    end
    
    result_bit_field=[0 result_bit_field 0];            
    %differentiate
    result_int=diff(result_bit_field);

    result.start_indx=find(result_int==1);
    result.end_indx=find(result_int==-1)-1;
            
    %Reset current interval settings
    ud=erase_intervals(ud);
    
    %No threshold or interval cutoff is defined when modifying intervals.
    threshold=ud.threshold;
    threshold.users=[];
    threshold.intervalCutoff=[];
    ud=set_thresholdstruct(ud, threshold);    

    %Store the new intervals
    signals.start_indx=result.start_indx;
    signals.end_indx  =result.end_indx;
    set(ud.Handles.Axes.Raw, 'UserData', signals);
    
    %Color the eeg segments depending on interval inclusion
    ud=mark_supra_infra_eeg(ud);
                
    %Initialize the intervalCategories
    initIntervalCategories(ud, length(signals.start_indx));
    
    %Update graphs
	ud=updateGraphs(ud);
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);

    %Save data
    set(fg, 'UserData', ud);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_PSD_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_PSD_callback(eventSrc,eventData)
	fg=gcbf;
	ud = get(fg,'UserData');
    signals = get(ud.Handles.Axes.Raw, 'UserData');
        
    if isempty(signals.eeg),
        return;
    end
    
    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, []);
        if returnflag,
            return;
        end
    end

    users_data=get_PSD_params(ud);
    if isempty(users_data),
        return;
    end
    
    %Show watch
	old_ptr=get(fg, 'Pointer');
	set(fg, 'Pointer', 'watch');
                
    %Get the signals and interval categories
    intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');

    showMessage(ud.Handles.Texts.Message, 'Computing PSDs', 0);

    %Do the computation and plotting
    PSD_struct=PSD_function(signals, intervalCategories, users_data, ud);
        
    showMessage(ud.Handles.Texts.Message, 'DONE: Computing PSDs', 1);
    
    %Restore pointer
	set(fg, 'Pointer', old_ptr);
    
    if isempty(PSD_struct),
        return;
    end

    %Export to workspace
    for i=1:length(PSD_struct),
        if isempty(PSD_struct(i).f_plot),
            continue;
        end
        var_name=sprintf('category_%d_integ_start', PSD_struct(i).label);
        assignin('base', var_name, PSD_struct(i).integ_start);
        var_name=sprintf('category_%d_integ_end', PSD_struct(i).label);
        assignin('base', var_name, PSD_struct(i).integ_end);
        var_name=sprintf('category_%d_integrated_power', PSD_struct(i).label);
        assignin('base', var_name, PSD_struct(i).integrated_power);
        var_name=sprintf('category_%d_f_PSD', PSD_struct(i).label);
        assignin('base', var_name, PSD_struct(i).f_plot);
        var_name=sprintf('category_%d_P_PSD', PSD_struct(i).label);
        assignin('base', var_name, PSD_struct(i).Pxx_plot);
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_batch_PSD_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_batch_PSD_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');

    if ~isempty(ud.data_features.Fs),
        %A file is currently loaded
        button = questdlg('This operation will close current file.',...
		'Proceed?','Yes','No','No');
        drawnow;
		if strcmp(button,'Yes')
            ud=perform_close_sequence;
        else
            return;
		end
    end

    %Get data
    [signal_fnames, int_fname, users_data, ud, return_flag]=menu_batch_PSD_prep(ud);
    if return_flag,
        return;
    end
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    showMessage(ud.Handles.Texts.Message, 'Computing PSDs', 0);

    %Do the batch process
    [ud, return_flag]=menu_batch_PSD_function(signal_fnames, int_fname, users_data, ud);
    if return_flag,
        return;
    end
        
    showMessage(ud.Handles.Texts.Message, 'DONE: Computing PSDs', 1);
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);

    %Clean up the residue of the last processed file
    perform_close_sequence;    
    
%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_PSD_prep %
%%%%%%%%%%%%%%%%%%%%%%%
function [signal_fnames, int_fname, users_data, ud, return_flag]=menu_batch_PSD_prep(ud)

    return_flag=0;
    users_data=[];

    %Get signal filenames
    fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the raw or filtered .mat files');
    if isempty(fnames),
        return_flag=1;
        return;
    end
    signal_fnames=fnames;
    drawnow;
    
    %Get interval filename
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select an interval matfile for this operation.');
    end
    if isempty(fnames),
        int_fname=[];
    else
        int_fname=fnames{1};
    end
    drawnow;
    
    
    users_data=get_PSD_params(ud);
    if isempty(users_data),
        return_flag=1;
        return;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_PSD_function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ud, return_flag]=menu_batch_PSD_function(signal_fnames, int_fname, users_data, ud)
    
    return_flag=0;
    
    num_of_files=size(signal_fnames, 1);
    
    %Load the interval file
    if isempty(int_fname),
        int_package=[];
    else
        load(int_fname);
        int_package=package;    
    end

    %Read interval categories
    intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
    
    for filenum=1:num_of_files,
    
        msg=sprintf('Computing PSDs: File %d of %d', filenum, num_of_files);
        showMessage(ud.Handles.Texts.Message, msg, 0);
        
        load(signal_fnames{filenum});
           
        ud.data_features.Fs=package.Fs;
        
        fldnames=fieldnames(package);
        for fieldnum=1:length(fldnames),
            switch fldnames{fieldnum},
                case 'eeg'
                    signals=get(ud.Handles.Axes.Raw, 'UserData');
                    signals.t=package.t;
                    signals.eeg=package.eeg;
                    break;
                case 'saved_signals'
                    signals=package.saved_signals;
                    break;
            end
        end
        
        if ~isempty(int_package),
            %Check whether the interval time stamps match the current file
            local_start_times=signals.t(int_package.start_indx);
            local_end_times=signals.t(int_package.end_indx);
            starts_are_same=local_start_times==int_package.start_times;
            ends_are_same=local_end_times==int_package.end_times;
            if any(starts_are_same==0) | any(ends_are_same==0),
                msg=sprintf('Interval Load Error: Interval tstamps do not match file %d', filenum);
                showMessage(ud.Handles.Texts.Message, msg, 1);
                return_flag=1;
                return;
            end
            
            intervalCategories.categories=int_package.categories;
            signals.start_indx=int_package.start_indx;
            signals.end_indx=int_package.end_indx;
        end
                
        %Do the computation and plotting
        users_data.figure_name_str=signal_fnames{filenum};
        users_data.figure_counter=filenum;
        PSD_struct=PSD_function(signals, intervalCategories, users_data, ud);
        
    end

%%%%%%%%%%%%%%%%%%
% get_PSD_params %
%%%%%%%%%%%%%%%%%%
function users_data=get_PSD_params(ud)

    users_data=[];
    
    %Whos is calling
    cbtag=get(gcbo, 'Tag');

    %Read user input for PSD
    prompt  = {'Range from:', ...
               'Range to:', ...
               'Approximate number of frequencies:', ...
               'Smooth using N-point average', ...
               'Report average power in ranges F1min F1max, F2min F2max, ...:', ...
               'Base figure number', ...
               'Color'};
	title   = sprintf('PSD parameters');
	lines= 1;
	def     = {'', '', '', '0', '', 'new figure', 'b'};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;

    if isempty(answer),
        return;
    end
    
    for i=1:4,
        empty_field(i)=isempty(str2num(answer(i,:)));
    end
    if any(empty_field==1),
        return;
    end

    for i=1:4,
        params(i)=str2num(answer(i, :));
    end
    
    %Make sure parameters are acceptable
    if any(params<0) | any(params([2 3])==0) | ...
           params(1)>=params(2) | params(1)>=ud.data_features.Fs,
        return;
    end
    
    %Extract integration range
    range_text=answer(5,:);   
    if ~isempty(range_text),
        %First put a comma to the end so there is at least one delimiter.
        range_text=sprintf('%s,', range_text);
        commaplaces=charfind(range_text, ',');
        start_indx=1;
        range_counter=1;
        for i=1:length(commaplaces),
            current_segment=range_text(start_indx:commaplaces(i)-1);
            start_indx=commaplaces(i)+1;      
            
            if isempty(current_segment),
                continue;
            end
            
            current_range=sscanf(current_segment, '%f');
            if length(current_range)~=2,
                continue;
            end
            
            %make sure the values are ascending
            if current_range(2)<current_range(1),
                %They are descending. Can't accept
                showMessage(ud.Handles.Texts.Message, ...
                    'Upper cutoff cannot be smaller than lower cutoff', 1);
                continue;
            end

            if strcmp(cbtag, 'menu_analysis_PSD'),
                %The lower bound should not be larger than Fs/2.
                if current_range(1)>ud.data_features.Fs/2,
                    continue;
                end
            end
            
            ranges(2*range_counter*[1 1]-[1 0])=current_range;
            range_counter=range_counter+1;
        end
        
        %If some ranges were found, make sure they are in ascending order
        if range_counter~=1,
            starts=ranges(1:2:end-1);
            ends  =ranges(2:2:end);
            
            [starts, indx]=sort(starts);
            ends=ends(indx);
            %At this point, the start of the intervals are in increasing order
            %If the sub-ranges overlap, then ask the user to re-enter
            overlap=0;
            for i=2:length(starts),
                overlap=any(ends(i-1)>=starts(i:end))|overlap;
            end
            if overlap,
                showMessage(ud.Handles.Texts.Message, ...
                    'There are overlapping intervals. Please re-enter.', 1);
                return;
            end
        end
        
        %If no valid ranges were found reset ranges
        if range_counter==1,
            ranges=[];
        end
    end %~isempty(range_text),
    integration_ranges=ranges;

    %Plot parameters
    figure_number=str2num(answer(6,:));
    allowable=['r','g','b','y','m','c','k'];
    if ~isempty(answer(7, :)),
        desired_color=find(allowable==answer(7, 1));
        if isempty(desired_color),
            color_str='b';
        else
            color_str=allowable(desired_color);
        end
    else
        color_str='b';
    end
        
    %Construct the output struct
    users_data.Rfr=params(1);
    users_data.Rto=params(2);
    users_data.Nf=max(params(3), 2);
    users_data.nMA=params(4);
    users_data.integration_ranges=integration_ranges;
    users_data.figure_number=figure_number;
    users_data.color_str=color_str;        
    users_data.figure_name_str='';        
    
%%%%%%%%%%%%%%%%
% PSD_function %
%%%%%%%%%%%%%%%%
function PSD_struct=PSD_function(signals, intervalCategories, users_data, ud)

    PSD_struct=[];
    
    %Use shorter names
    Rfr  = users_data.Rfr;
    Rto  = users_data.Rto;
    Nf   = users_data.Nf;
    nMA  = users_data.nMA;
    integration_ranges = users_data.integration_ranges;
    figure_number = users_data.figure_number;
    color_str = users_data.color_str;
    figure_name_str = users_data.figure_name_str;
    figure_counter = users_data.figure_counter;

    %Clean lower bounds that are not less than Fs/2
    if length(integration_ranges)>2,
        indx=find(integration_ranges(1:2:end-1)>=ud.data_features.Fs/2);
        if ~isempty(indx),
            integration_ranges([2*indx-1 2*indx])=integration_ranges([2*indx-1 2*indx]).*-1;
            indx=find(integration_ranges~=-1);
            if isempty(indx),
                integration_ranges=[];
            else
                integration_ranges=integration_ranges(indx);
            end
        end
    elseif ~isempty(integration_ranges),
        if integration_ranges(1)>=ud.data_features.Fs/2,
            integration_ranges=[];
        end
    end
    
    %Desired resolution
    alpha = (Rto-Rfr)/(Nf-1);
    
    %min nfft to achieve this resolution
    min_nfft=max(2, ud.data_features.Fs/alpha);
    %Set nfft to the smallest power of two that is larger than or equal to min_nfft.
    nfft=2^(ceil(log(min_nfft)/log(2)));
    
    %If there are no intervals, process the entire signal
    if isempty(signals.start_indx),
        no_intervals=1;
        labels=0;
        intervalCategories.categories=0;
        signals.start_indx=1;
        signals.end_indx=length(signals.t);
    else
        no_intervals=0;
        labels=intervalCategories.categories;
    end
        
    counter=figure_counter;
	for i=min(labels):max(labels),
		index=find(intervalCategories.categories==i);
		if isempty(index),
          continue;
		end
        
		%Interval label
		PSD_struct(counter).label=i;
        
		%Form the input vector for pwelch
		num_of_intervals=length(index);
		samps_per_interval=signals.end_indx(index)-signals.start_indx(index)+1;
        
        %Put each interval in a container whose length is the smallest integer multiple of nfft
        %that is not smaller than the interval length.
        container_lengths=ceil(samps_per_interval/nfft)*nfft;
        
		pwelch_input=zeros(1, sum(container_lengths));
		start=1;
		for j=1:num_of_intervals,
            pwelch_input(start+[0:samps_per_interval(j)-1])=...
                signals.eeg([signals.start_indx(index(j)):signals.end_indx(index(j))]);
            start=start+container_lengths(j);
		end
	
		%Now that our input is ready, lets compute the PSD
		window=rectwin(nfft); %we do not window
		noverlap=0; %We do not want overlap
		[Pxx,f] = pwelch(pwelch_input,window,noverlap,nfft,ud.data_features.Fs);
        
        %Correct for variable durations by dividing the total power by the actual total signal
        %duration
        Pxx=Pxx*sum(container_lengths)/sum(samps_per_interval);
        %At this point, sum(Pxx)*ud.data_features.Fs/nfft*1e6 will give the correct average power 
        %sum(Pxx)*ud.data_features.Fs/nfft*1e6
        %reported in the Interval statistics (raw eeg).
        %For filtered eeg, 
        %fil_range=find(f>=ud.filter.F(2) & f<=ud.filter.F(3));
        %sum(Pxx(fil_range))*ud.data_features.Fs/nfft*1e6
        %should give the average power in the filtered signal, as reported in the Interval statistics.

        %Integrated power
        if isempty(integration_ranges),
            PSD_struct(counter).integ_start=[];
            PSD_struct(counter).integ_end  =[];        
            PSD_struct(counter).integrated_power=[];
        else
            PSD_struct(counter).integrated_power=0;
            for integ_range_ctr=1:length(integration_ranges)/2,
                integ_start_indx=min(find(f>=integration_ranges(2*integ_range_ctr-1)));
                integ_end_indx  =max(find(f<=integration_ranges(2*integ_range_ctr)));
                PSD_struct(counter).integ_start(integ_range_ctr)=f(integ_start_indx);
                PSD_struct(counter).integ_end(integ_range_ctr)  =f(integ_end_indx);        
                PSD_struct(counter).integrated_power=PSD_struct(counter).integrated_power+...
                    sum(Pxx(integ_start_indx:integ_end_indx))*diff(f(1:2));        
            end
        end
        
        %to be plotted
        current_alpha=f(2)-f(1);
        f_plot=0:current_alpha:max(ud.data_features.Fs/2, Rto+current_alpha);
        Pxx_plot=zeros(1, length(f_plot));
        Pxx_plot(1:length(f))=Pxx;
        plot_range=max(find(f_plot<=Rfr)):min(find(f_plot>=Rto));
        f_plot=f_plot(plot_range);
        Pxx_plot=Pxx_plot(plot_range);
        
        %Smooth the plot
        if nMA>=2,
            nMA=floor(min(nMA, length(Pxx_plot)/3));
            %Generate a new vector for padding the start and end
            LPxx=length(Pxx_plot);
            Pxx_holder=zeros(1, LPxx+2*nMA);
            Pxx_holder(1:nMA)=Pxx_holder(1:nMA)+Pxx_plot(1);
            Pxx_holder(nMA+[1:LPxx])=Pxx_plot;
            Pxx_holder(LPxx+nMA+1:end)=Pxx_holder(LPxx+nMA+1:end)+Pxx_plot(end);
            Pxx_holder=filtfilt(ones(1, nMA)/nMA, 1, Pxx_holder);
            
            %Take the part of interest
            Pxx_plot=Pxx_holder(nMA+[1:LPxx]);
        end
        
        %Build the structure    
        PSD_struct(counter).f_plot=f_plot;
        PSD_struct(counter).Pxx_plot=Pxx_plot;
        
        %Plot the result
        Name=figure_name_str;
        if no_intervals,
            Title=sprintf('Whole file PSD');
        else
            Title=sprintf('PSD for Interval Set %d', i);
        end

        Xlabel=sprintf('Frequency (Hz). Resolution: %.3f (Hz)', ud.data_features.Fs/nfft);
        if ~isempty(integration_ranges),
            
            range_text=sprintf('%.3f - %.3f', ...
                PSD_struct(counter).integ_start(1), ...
                PSD_struct(counter).integ_end(1));
            if length(PSD_struct(counter).integ_start)>1,
                for txt_ctr=2:length(PSD_struct(counter).integ_start),
                    range_text=sprintf('%s, %.3f - %.3f', range_text, ...
                        PSD_struct(counter).integ_start(txt_ctr), ...
                        PSD_struct(counter).integ_end(txt_ctr));
                end
            end
            Xlabel=sprintf('%s\nAverage power in %s Hz: %.3e (V^{2})', Xlabel, ...
                range_text, ...
                PSD_struct(counter).integrated_power);
        end
        
        if isempty(figure_number),
            figure('Name', Name, 'Units', 'Normalized', 'Position', [1/4 1/4 1/2 1/2]);
            [xx, yy]=stairs(f_plot, Pxx_plot);
            plot(xx, yy, 'Color', color_str);
            axis([min(f_plot)*0.9 max(f_plot)*1.1 0 max(Pxx_plot)*1.1]);            
        else
            h=figure(figure_number+counter-1);hold on;

            %Get the current axis limits
            XLim=get(findobj(h, 'Type', 'axes'), 'XLim');
            YLim=get(findobj(h, 'Type', 'axes'), 'YLim');
            
            set(h, 'Name', Name);
            [xx, yy]=stairs(f_plot, Pxx_plot);
            plot(xx, yy, 'Color', color_str);
            axis([min([XLim(1) min(f_plot)*0.9]) ...
                  max([XLim(2) max(f_plot)*1.1]) ...
                  min([YLim(1) 0]) ...
                  max([YLim(2) max(Pxx_plot)*1.1])]);
            hold off;
        end
        set(gca,'Xlabel',text('String', Xlabel));
        ylabel('V^{2}/Hz');
        set(gca,'Title',text('String',Title));
                
        counter=counter+1;
	end %i=min(labels):max(labels)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_spectrogram_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_spectrogram_callback(eventSrc,eventData)

	fg=gcbf;
	ud = get(fg,'UserData');
    signals = get(ud.Handles.Axes.Raw, 'UserData');
    
    %If there is no current interval, return
    if isempty(ud.current_interval),
        showMessage(ud.Handles.Texts.Message, 'Select an interval', 1);
        return;
    end
    
    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, []);
        if returnflag,
            return;
        end
    end

    %Read user input for spectrogram
    prompt  = {'Range from:', ...
               'Range to:', ...
               'Approximate number of frequencies:', ...
               'Approximate number of time points per second:', ...
               'Start offset', ...
               'Stop offset'};
	title   = sprintf('Spectrogram parameters');
	lines= 1;
	def     = {'', '', '', '', '0', '0'};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;

    if isempty(answer),
        return;
    end
    
    for i=1:6,
        empty_field(i)=isempty(str2num(answer(i,:)));
    end
    if any(empty_field==1),
        return;
    end

    for i=1:6,
        params(i)=str2num(answer(i, :));
    end
    
    %Make sure parameters are acceptable
    if any(params([1:4])<0) | any(params([2 3 4])==0) | ...
           params(1)>=params(2) | params(1)>=ud.data_features.Fs,
        return;
    end

    %Show watch
	old_ptr=get(fg, 'Pointer');
	set(fg, 'Pointer', 'watch');
        
    %Use better names
    Rfr  = params(1);
    Rto  = params(2);
    Nf   = max(params(3), 2);
    Nt   = max(params(4), 2);
    StartOffset = params(5)*ud.data_features.Fs;
    StopOffset  = params(6)*ud.data_features.Fs;
    
    %Desired resolution
    alpha = (Rto-Rfr)/(Nf-1);
    
    %min nfft to achieve this resolution
    min_nfft=max(2, ud.data_features.Fs/alpha);
    %Set nfft to the smallest power of two that is larger than or equal to min_nfft.
    nfft=2^(ceil(log(min_nfft)/log(2)));    
    
    %Get the signals
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    start_indx=round(max(1, signals.start_indx(ud.current_interval)+StartOffset));
    end_indx=round(min(length(signals.t), signals.end_indx(ud.current_interval)+StopOffset));
    if start_indx>=end_indx,
        showMessage(ud.Handles.Texts.Message, 'Effective spectrogram duration is negative or zero', 1);
        return;
    end
    target_segment=signals.eeg(start_indx:end_indx);
    Nx=length(target_segment);
    
    %How many time points does the user want in this interval?
    Nt=max(round(Nt*Nx/ud.data_features.Fs), 1);
    
    %Compute the time separation between time points
    Dt=(signals.t(end_indx)-signals.t(start_indx))/(Nt-1);
    %Dt cannot be smaller than 1/Fs
    Dt=max(Dt, 1/ud.data_features.Fs);
    
    %The difference between nwindow and noverlap is Dt*ud.data_features.Fs
    noverlap=Nx-Nt*Dt*ud.data_features.Fs;
    %Make sure noverlap is positive
    noverlap=max(0, noverlap);
    %Then compute nwindow
    nwindow=noverlap+max(1, round(Dt*ud.data_features.Fs));
    %Make sure nfft is not smaller than nwindow
    min_nfft=max(nwindow, nfft);
    nfft=2^(ceil(log(min_nfft)/log(2)));   

    showMessage(ud.Handles.Texts.Message, 'Computing Spectrogram of Raw EEG', 0);

    [B F T]=specgram(target_segment, nfft, ud.data_features.Fs, nwindow, noverlap);
    %Adjust T. The power that we computed is shown at the time point that corresponds
    %to the onset of a window. By adding nwindow/2/ud.data_features.Fs to that
    %timestamp, we can place it at the center of the window. That would be a better
    %representation of the distribution of power over time.
    T=T+signals.t(start_indx)+nwindow/2/ud.data_features.Fs;
    sfg=figure;
    ax=gca;   
    image_handle=imagesc(T, F, 20*log10(abs(B)));
    set(image_handle, 'Parent', ax);
    axis xy;
    colormap(ax, 'jet');
    set(get(ax, 'Title'), 'String', ...
        sprintf('Spectrogram around interval %d', ud.current_interval));
    set(get(ax, 'XLabel'), 'String', 'Time(s)');
    set(get(ax, 'YLabel'), 'String', 'Frequency (Hz)');
    set(ax, 'YLim', [Rfr Rto]);

    %What intervals fall in this time range?
    indx=find(signals.t(signals.end_indx) >= T(1) & signals.t(signals.start_indx)<=T(end));
    
    %Plot lines that show the start and end of these intervals
    
    XS=signals.t(signals.start_indx(indx));
    XE=signals.t(signals.end_indx(indx));
    YSE=[Rfr Rto]';YSE=YSE(:, ones(1, length(XS)));
    
    line([XS;XS], YSE, 'LineStyle', '-', 'Color', [0 0.2 1], 'LineWidth', 2);
    line([XE;XE], YSE, 'LineStyle', '-', 'Color', 'k', 'LineWidth', 2);
    
    %Plot lines that show the passband range
    XF=[min(T) max(T)]'; XF=XF(:,ones(1, 2));
    YF=ud.filter.F(2:3);
    line(XF, [YF;YF], 'LineStyle', '-.', 'Color', 'k', 'LineWidth', 1);    
    
    showMessage(ud.Handles.Texts.Message, 'DONE: Computing Spectrogram of Raw EEG', 1);

    %Restore pointer
	set(fg, 'Pointer', old_ptr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_coherence_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_coherence_callback(eventSrc,eventData)
	fg=gcbf;
	ud = get(fg,'UserData');
    signals = get(ud.Handles.Axes.Raw, 'UserData');
    
    %If there are no intervals, return
    if isempty(signals.start_indx),
        showMessage(ud.Handles.Texts.Message, 'No interval', 1);
        return;
    end
    
    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, []);
        if returnflag,
            return;
        end
    end

    %Get the names of filtered eeg files and the interval files
    fileegfnames=get_multiple_filenames(fullfile(pwd, '*.mat'), ...
        'Select the filtered .mat files');
    if isempty(fileegfnames),
        return;
    end
    intfnames=get_multiple_filenames(fullfile(pwd, '*.mat'), ...
        'Select the corresponding interval .mat files');
    if isempty(intfnames),
        return;
    end
    
    num_of_files=size(fileegfnames, 1);
    if num_of_files~=size(intfnames, 1),
        showMessage(ud.Handles.Texts.Message, 'Unmatching number of files', 0);
        return;
    end    
    
    %Read user input for coherence
    prompt  = {'Range from:', ...
               'Range to:', ...
               'Approximate number of frequencies:', ...
               'Confidence', ...
               'Smooth using N-point average', ...
               'Base figure number', ...
               'Color'};
	title   = sprintf('Coherence parameters');
	lines= 1;
	def     = {'', '', '', '0.95', '0', 'new figure', 'b'};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;

    if isempty(answer),
        return;
    end
    
    for i=1:5,
        empty_field(i)=isempty(str2num(answer(i,:)));
    end
    if any(empty_field==1),
        return;
    end

    for i=1:5,
        params(i)=str2num(answer(i, :));
    end
    
    %Make sure parameters are acceptable
    if any(params<0) | any(params(2:4)==0) | params(4)>=1 | ...
           params(1)>=params(2) | params(1)>=ud.data_features.Fs,
        return;
    end

    %Show watch
	old_ptr=get(fg, 'Pointer');
	set(fg, 'Pointer', 'watch');
        
    %Use better names
    Rfr  = params(1);
    Rto  = params(2);
    Nf   = max(params(3), 2);
    confidence = params(4);
    nMA  = params(5);
    
    %Desired resolution
    alpha = (Rto-Rfr)/(Nf-1);
    
    %min nfft to achieve this resolution
    min_nfft=max(2, ud.data_features.Fs/alpha);
    %Set nfft to the smallest power of two that is larger than or equal to min_nfft.
    nfft=2^(ceil(log(min_nfft)/log(2)));
        
    %Get the interval categories
    intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');

	labels=intervalCategories.categories;
    showMessage(ud.Handles.Texts.Message, 'Computing Coherence', 0);
    
    %Compute coherence for each file
    for filenum=1:num_of_files,
        load(fileegfnames{filenum});
        [package status]=make_backward_compatible(fileegfnames{filenum}, package);
        if status,
            %Restore pointer
           	set(fg, 'Pointer', 'watch');   
            return;
        end    
 
        %If the target Fs is different, continue
        if package.Fs~=ud.data_features.Fs,
            msg=sprintf('Unmatching sampling rate for file %d', filenum);
            disp(msg);
            continue;
        end
        %If the target signal length is different, continue
        if length(package.saved_signals.y)~=length(signals.y),
            msg=sprintf('Signals of different duration for file %d', filenum);
            disp(msg);
            continue;
        end
        
        target_signals=package.saved_signals;

        %Load intervals
        load(intfnames{filenum});
        target_ints=package;
        
        counter=1;
		for i=min(labels):max(labels),
            
            %Store filenum
        	coh_struct(filenum, counter).filenum=filenum;
            
			index_ref=find(intervalCategories.categories==i);
			if isempty(index_ref),
              continue;
			end
            
			index_tar=find(target_ints.categories==i);
			if isempty(index_tar),
              continue;
			end
            
            %Create the interval bit fields
            int_ref=get_interval_bitfield(length(signals.y), ...
                                          signals.start_indx(index_ref), ...
                                          signals.end_indx(index_ref));
            int_tar=get_interval_bitfield(length(signals.y), ...
                                          target_ints.start_indx(index_tar), ...
                                          target_ints.end_indx(index_tar));
            %Get AND                                      
            int_and=int_ref&int_ref;
            int_and=[0 int_and 0];
            if all(int_and==0),
                %The intersection is empty. 
                continue;
            end
                    
            %differentiate
            int_new=diff(int_and);
        
            and.start_indx=find(int_new==1);
            and.end_indx=find(int_new==-1)-1;
            
            %Reject zero duration intervals.
            unwanted_indx=find(and.start_indx==and.end_indx);
            
            if ~isempty(unwanted_indx),
                and.start_indx(unwanted_indx)=and.start_indx(unwanted_indx).*0-1;
                valids=find(and.start_indx~=-1);
                if isempty(valids),
                    continue;
                end
                and.start_indx=and.start_indx(valids);
                and.end_indx=and.end_indx(valids);
            end
                           
			%Interval label
			coh_struct(filenum, counter).label=i;
            
			%Form the input vector for cohere
			num_of_intervals=length(and.start_indx);
			samps_per_interval=and.end_indx-and.start_indx+1;
            
            %Put each interval in a container whose length is the smallest integer multiple of nfft
            %that is not smaller than the interval length.
            container_lengths=ceil(samps_per_interval/nfft)*nfft;
            
            %If there is only one segment, continue. It will give coherence=1
            %everywhere and significance cannot be computed.
            if sum(container_lengths)/nfft==1,
                continue;
            end
            
			cohere_input_ref=zeros(1, sum(container_lengths));
			cohere_input_tar=zeros(1, sum(container_lengths));
			start=1;
			for j=1:num_of_intervals,
                cohere_input_ref(start+[0:samps_per_interval(j)-1])=...
                    signals.eeg([and.start_indx(j):and.end_indx(j)]);
                cohere_input_tar(start+[0:samps_per_interval(j)-1])=...
                    target_signals.eeg([and.start_indx(j):and.end_indx(j)]);
                start=start+container_lengths(j);
			end
		
			%Now that our input is ready, lets compute the coherence
			window=rectwin(nfft); %we do not window
			noverlap=0; %We do not want overlap
			[Cxy,f] = cohere(cohere_input_ref, ...
                             cohere_input_tar, ...
                             nfft, ud.data_features.Fs, window, noverlap);
            
            %to be plotted
            current_alpha=f(2)-f(1);
            f_plot=0:current_alpha:max(ud.data_features.Fs/2, Rto+current_alpha);
            Cxy_plot=zeros(1, length(f_plot));
            Cxy_plot(1:length(f))=Cxy;
            plot_range=max(find(f_plot<=Rfr)):min(find(f_plot>=Rto));
            f_plot=f_plot(plot_range);
            Cxy_plot=Cxy_plot(plot_range);
            
            %Add to structure    
            coh_struct(filenum, counter).avg_Cxy=mean(Cxy_plot);
            
            %Smooth the plot
            if nMA>=2,
                nMA=floor(min(nMA, length(Cxy_plot)/3));
                %Generate a new vector for padding the start and end
                LCxy=length(Cxy_plot);
                Cxy_holder=zeros(1, LCxy+2*nMA);
                Cxy_holder(1:nMA)=Cxy_holder(1:nMA)+Cxy_plot(1);
                Cxy_holder(nMA+[1:LCxy])=Cxy_plot;
                Cxy_holder(LCxy+nMA+1:end)=Cxy_holder(LCxy+nMA+1:end)+Cxy_plot(end);
                Cxy_holder=filtfilt(ones(1, nMA)/nMA, 1, Cxy_holder);
                
                %Take the part of interest
                Cxy_plot=Cxy_holder(nMA+[1:LCxy]);
            end
            
            %Add to structure    
            coh_struct(filenum, counter).f_plot=f_plot;
            coh_struct(filenum, counter).Cxy_plot=Cxy_plot;
            
            %Compute confidence level
            conf_level=1-power(1-confidence, 1/(sum(container_lengths)/nfft-1));
            
            %Plot the result
            figure_number=str2num(answer(6,:));
            allowable=['r','g','b','y','m','c','k'];
            if ~isempty(answer(7, :)),
                desired_color=find(allowable==answer(7, 1));
                if isempty(desired_color),
                    color_str='b';
                else
                    color_str=allowable(desired_color);
                end
            else
                color_str='b';
            end
            if isempty(figure_number),
                Name=sprintf('Coherence for Interval Set %d for file %d', i, filenum);
                figure('Name', Name);
                [xx, yy]=stairs(f_plot, Cxy_plot);
                plot(xx, yy, 'Color', color_str);
                axis([min(f_plot)*0.9 max(f_plot)*1.1 0 max(Cxy_plot)*1.1]);
                Xlabel=sprintf('Frequency (Hz). Resolution: %.3f (Hz)', ud.data_features.Fs/nfft);
                set(gca,'Xlabel',text('String', Xlabel));
                ylabel_text=sprintf('Coherence. Average: %.3f', coh_struct(filenum, counter).avg_Cxy);
                ylabel(ylabel_text);
                set(gca,'Title',text('String',Name));
            else
                Name=sprintf('Coherence for Interval Set %d for file %d', i, filenum);
                h=figure(figure_number+counter-1);hold on;
	
                %Get the current axis limits
                XLim=get(findobj(h, 'Type', 'axes'), 'XLim');
                YLim=get(findobj(h, 'Type', 'axes'), 'YLim');
                
                set(h, 'Name', Name);
                [xx, yy]=stairs(f_plot, Cxy_plot);
                plot(xx, yy, 'Color', color_str);
                axis([min([XLim(1) min(f_plot)*0.9]) ...
                      max([XLim(2) max(f_plot)*1.1]) ...
                      min([YLim(1) 0]) ...
                      max([YLim(2) max(Cxy_plot)*1.1])]);
                Xlabel=sprintf('Frequency (Hz). Resolution: %.3f (Hz)', ud.data_features.Fs/nfft);
                set(gca,'Xlabel',text('String', Xlabel));
                ylabel_text=sprintf('Coherence. Average: %.3f', coh_struct(filenum, counter).avg_Cxy);
                ylabel(ylabel_text);
                set(gca,'Title',text('String', Name));
                hold off;
            end
            %Plot the significance level
            %Get the current axis limits
            XLim=get(gca, 'XLim');
            line(XLim, [1 1]*conf_level);
            
            counter=counter+1;
		end %i=min(labels):max(labels)
    end %filenum=1:num_of_files,
    
    showMessage(ud.Handles.Texts.Message, 'DONE: Computing Coherence', 1);
    
    %Restore pointer
	set(fg, 'Pointer', old_ptr);

    %Export to workspace
    for i=1:size(coh_struct, 1),
        for j=1:size(coh_struct, 2),
            if isempty(coh_struct(i, j).f_plot),
                continue;
            end
            var_name=sprintf('File_%d_Category_%d_f_coh', ...
                coh_struct(i, j).filenum, coh_struct(i, j).label);
            assignin('base', var_name, coh_struct(i, j).f_plot);
            var_name=sprintf('File_%d_Category_%d_C_coh', ...
                coh_struct(i, j).filenum, coh_struct(i, j).label);
            assignin('base', var_name, coh_struct(i, j).Cxy_plot);
            var_name=sprintf('File_%d_Category_%d_Average_coh', ...
                coh_struct(i, j).filenum, coh_struct(i, j).label);
            assignin('base', var_name, coh_struct(i, j).avg_Cxy);
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_interval_stats_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_interval_stats_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');

    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, []);
        if returnflag,
            return;
        end
    end

    %If intervalCategories not initialized, return
	intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
	if isempty(intervalCategories.categories)
        return;
	end
    
    showMessage(ud.Handles.Texts.Message, 'Computing statistics', 0);
    
	signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    interval_stats_struct=get_interval_stats(intervalCategories, signals);
    printIntervalStats(interval_stats_struct);

    showMessage(ud.Handles.Texts.Message, 'DONE: Computing statistics', 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_maxamphist_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_maxamphist_callback(eventSrc,eventData)

	fg=gcbf;
	ud = get(fg,'UserData');
    signals = get(ud.Handles.Axes.Raw, 'UserData');
    
    %If there are no intervals, return
    if isempty(signals.start_indx),
        showMessage(ud.Handles.Texts.Message, 'No intervals', 1);
        return;
    end
    
    %Does the user need to refresh threshold?
    if ud.signal_change,
        [ud, returnflag, signals]=refresh_threshold(ud, []);
        if returnflag,
            return;
        end
    end

    %Obtain the max amplitude values
    maxes=zeros(1, length(signals.start_indx));
    for i=1:length(signals.start_indx),
        maxes(i)=...
            max(abs(signals.y(signals.start_indx(i):signals.end_indx(i))));
    end
    
    %Read user input for spectrogram
    pmsg=sprintf(...
        '%d values range from %.3f to %.3f microvolts.\nEnter number of bins:', ...
        length(signals.start_indx), min(maxes)*1e6, max(maxes)*1e6);
    prompt  = {pmsg};
	title   = sprintf('Histogram parameters');
	lines= 1;
	def     = {''};
	answer  = str2num(char(inputdlg(prompt,title,lines,def)));
    drawnow;

    if isempty(answer),
        return;
    end
    if answer<=0,
        return;
    end
    answer=round(answer);
    
    %Compute histogram
    
    [n,xout] = hist(maxes, answer);
    
    FH=figure;
    AH=axes('Parent', FH);
    BH=bar(xout, n);
    set(BH, 'Parent', AH);
    set(get(AH, 'XLabel'), 'String', 'Volts');
    set(get(AH, 'YLabel'), 'String', 'Counts per bin');
    set(get(AH, 'Title'), ...
        'String', ...
        'Histogram of maximum absolute filtered amplitudes in intervals');    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_mot_asint_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_mot_asint_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    %If there are no intervals, return
    if isempty(signals.start_indx),
        showMessage(ud.Handles.Texts.Message, ...
            'There are no intervals', 1);
        return;
    end
    
	%Get thresholds from user
	prompt  = {'Motion threshold (pixels):', 'Still threshold (pixels):'};
	title   = sprintf('Maximum displacements within intervals');
	lines= 1;
	def     = {num2str(ud.motion_threshold), num2str(ud.still_threshold)};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer)
        return;
    end
	if ~isempty(answer(1, :)),
      motion_threshold=str2num(answer(1, :));
    else
      motion_threshold=[];
	end
	if ~isempty(answer(2, :)),
      still_threshold=str2num(answer(2, :));
    else
      still_threshold=[];
	end
	
	if isempty(motion_threshold) | isempty(still_threshold),
      return;
	end
    
    if still_threshold>=motion_threshold,
      showMessage(ud.Handles.Texts.Message, 'Still threshold should be smaller than Motion threshold', 1);
      return;
    end
    
    %Store thresholds
    ud.motion_threshold=motion_threshold;
    ud.still_threshold =still_threshold;
    
	%Get labels from user
	prompt  = {'Motion label (1-9):', 'Still label (1-9):'};
	title   = sprintf('Labels for intervals');
	lines= 1;
	def     = {ud.motion_label, ud.still_label};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer)
        return;
    end
	if ~isempty(answer(1, :)),
      motion_label=round(str2num(answer(1, :)));
    else
      motion_label=[];
	end
	if ~isempty(answer(2, :)),
      still_label=round(str2num(answer(2, :)));
    else
      still_label=[];
	end
	
	if isempty(motion_label) | isempty(still_label),
      return;
	end
    
    if still_label<1 | still_label>9 | motion_label<1 | motion_label>9,
      showMessage(ud.Handles.Texts.Message, 'Labels should be integers between 1 and 9 inclusive', 1);
      return;
    end
        
    if still_label==motion_label,
      showMessage(ud.Handles.Texts.Message, 'Labels should be different', 1);
      return;
    end

    %Store labels
    ud.motion_label=num2str(motion_label);
    ud.still_label =num2str(still_label);
    
    %Now, get the position data.
    videoData=get(ud.Handles.Axes.Video, 'UserData');
    if isempty(videoData.positionNavigationTable),
        %Video data not loaded yet
        videoData=loadVideoData(fg);
        
        %If the user did not load data, return
        if isempty(videoData.fname),
            return;
        end
    end

    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    %For each interval, compute the maximum displacement
    %within the interval, and label the interval accordingly.
    start_times=signals.t(signals.start_indx)*1e4;
    end_times  =signals.t(signals.end_indx)*1e4;
    for i=1:length(start_times),
        %Find the frame closest to interval start
        start_frame_index=min(find(videoData.positionNavigationTable(:,1)>=start_times(i)));
        if isempty(start_frame_index)
            continue;
        end
        %Find the frame closest to interval end
        end_frame_index=max(find(videoData.positionNavigationTable(:,1)<=end_times(i)));
        if isempty(end_frame_index)
            continue;
        end
        
        %The position data at interval start
        init_x=videoData.positionNavigationTable(start_frame_index,3);
        init_y=videoData.positionNavigationTable(start_frame_index,4);

        %Maximum displacement vector magnitude during the interval
        disp_x=videoData.positionNavigationTable(start_frame_index:end_frame_index,3)-init_x;
        disp_y=videoData.positionNavigationTable(start_frame_index:end_frame_index,4)-init_y;
        max_disp_mag=max(sqrt(disp_x.^2+disp_y.^2));
        
        %Is the position ever lost during this interval?
        x_border=find(...
        videoData.positionNavigationTable(start_frame_index:end_frame_index,3)==1);
        y_border=find(...
            videoData.positionNavigationTable(start_frame_index:end_frame_index,4)==...
            videoData.imagedimensions(1));
        if ~isempty(x_border) & ~isempty(y_border),
            position_lost=sum(x_border==y_border);
        else
            position_lost=0;
        end

        %If undetermined, or position extraction fails, or a false static bright point
        %is detected, label interval with 0. Position extraction fails when there is no 
        %suprathreshold pixels. False static bright point causes one of the coordinates to 
        %remain the same throughout the interval.
        if (max_disp_mag>still_threshold & max_disp_mag<motion_threshold) | ...
           sum(abs(disp_x))==0 | sum(abs(disp_y))==0 | position_lost,
            ud=set_current_interval(ud, i);
            labelCurrentInterval(ud, '0');
            continue;
        end
        
        %If the maximum is above motion_threshold, label interval accordingly
        if max_disp_mag>=motion_threshold,
            ud=set_current_interval(ud, i);
            labelCurrentInterval(ud, num2str(motion_label));
            continue;
        end
        
        %If the maximum is below still_threshold, label interval accordingly
        if max_disp_mag<=still_threshold,
            ud=set_current_interval(ud, i);
            labelCurrentInterval(ud, num2str(still_label));
            continue;
        end
                
    end %i=1:length(start_times)

    %Restore pointer
    set(fg, 'Pointer', old_ptr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_mot_nex_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_mot_nex_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');
    
    %Read user input for smoothing
    prompt  = {'Smooth using a temporal window (s)'};
	title   = sprintf('Position processing parameter');
	lines= 1;
	def     = {'0'};
	answer  = str2num(char(inputdlg(prompt,title,lines,def)));
    
    drawnow;
    
    if isempty(answer),
        return;
    end
    twindow=answer;
    
    %Now, get the position data.
    videoData=get(ud.Handles.Axes.Video, 'UserData');
    if isempty(videoData.positionNavigationTable),
        %Video data not loaded yet
        videoData=loadVideoData(fg);
        
        %If the user did not load data, return
        if isempty(videoData.fname),
            return;
        end
    end
    
    %Tell what data file you use
    msg=sprintf('Using data from file %s', avoidTeX(videoData.fname, '\_'));
    showMessage(ud.Handles.Texts.Message, msg, 0);    

    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');

    %Rename data    
    t=videoData.positionNavigationTable(:,1)/1e4;
    x=videoData.positionNavigationTable(:,3);
    y=videoData.positionNavigationTable(:,4);

    %What is the minimum inter-frame-interval
    IFImin=min(diff(t));
    
    %Quantize time
    tq=round((t-t(1))/IFImin)+1;
    t_container_length=max(tq);
    t_container=[0:t_container_length-1]*IFImin;
    
    %Put x and y in containers
    x_container=zeros(1, t_container_length);
    y_container=zeros(1, t_container_length);
    x_container(tq)=x;
    y_container(tq)=y;
        
    %Clean up the missing position cases and zeros
    x_border=x_container==1 | x_container==0;
    y_border=y_container==videoData.imagedimensions(1)|y_container==0;
    position_lost=x_border&y_border;
    position_lost_indx=find(position_lost==1);
    
    %If the position is lost in the first frame, assume that the position in the 
    %first frame is the same as the first valid position.
    if position_lost(1),
        first_valid_indx=min(find(position_lost==0));
        x_container(1)=x_container(first_valid_indx);
        y_container(1)=y_container(first_valid_indx);
        position_lost(1)=0;
        position_lost_indx=position_lost_indx(2:end);
    end
    %If the position is lost in the last frame, assume that the position in the 
    %last frame is the same as the last valid position.
    if position_lost(end),
        last_valid_indx=max(find(position_lost==0));
        x_container(end)=x_container(last_valid_indx);
        y_container(end)=y_container(last_valid_indx);
        position_lost(end)=0;
        position_lost_indx=position_lost_indx(1:end-1);
    end
    
    %Interpolate
    if ~isempty(position_lost_indx),
        dummy=zeros(1, length(x_container));
        dummy(position_lost_indx)=dummy(position_lost_indx)+1;
        valids_indx=find(dummy==0);
        
        x_container(position_lost_indx)=...
            interp1(t_container(valids_indx), x_container(valids_indx), ...
                   t_container(position_lost_indx));
        y_container(position_lost_indx)=...
            interp1(t_container(valids_indx), y_container(valids_indx), ...
                   t_container(position_lost_indx));
    end

    %Sampling rate
    video_sr=1/IFImin;
    %Average using a window
    nwindow=max(1, round(video_sr*twindow));
    if ~rem(nwindow, 2),
        nwindow=nwindow+1;
    end
    if nwindow>1,
        x_container=filtfilt(ones(1, nwindow)/nwindow, 1, x_container);
        y_container=filtfilt(ones(1, nwindow)/nwindow, 1, y_container);
    end

    %Return to t, x, and y
    t=t_container+t(1);
    x=x_container;
    y=y_container;
    
    %Compute the position differentials    
    dt=diff(t);
    dx=diff(x);
    dy=diff(y);

    ds=sqrt(dx.^2+dy.^2);
    speed=ds./dt; %Pixels per second
        
    figure;
    plot(t(1)+[0:length(t)-2]/video_sr, uint16(speed));
    xlabel('Time (s)');
    ylabel('Speed (pixel/s)');
    set(get(gca, 'Title'), 'String', ...
        sprintf('%.3f second moving-averaged motion of the rat', nwindow*IFImin));

    %Write nex file
	%Get filename from user
	[fname,pname] = uiputfile('*.nex','Save position data as');
	if fname==0 & pname==0,
      showMessage(ud.Handles.Texts.Message, 'Data not saved', 1);
      return;
	end
	fname=sprintf('%s%s', pname, fname);
    %Prepare data
    pos_data_struct.start_time=round(t(1)*1e4);
    pos_data_struct.end_time=round((t(1)+(length(t)-2)/video_sr)*1e4);
    pos_data_struct.sampling_rate=video_sr;
    pos_data_struct.data_vector=speed;
    
    status=writeNexPosition(fname, 10000, pos_data_struct);
    if status,
      showMessage(ud.Handles.Texts.Message, 'Error saving NEX file', 1);
    else
      showMessage(ud.Handles.Texts.Message, 'DONE: saving NEX file', 1);
    end
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_peak_detect_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_peak_detect_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    %Return if no signal
    if isempty(signals.eeg),
        return;
    end
    drawnow;
    
    %Read user input for peak detection
    msgpos=sprintf('Expected number of positive peaks per second.\n');
    msgpos=sprintf('%sEnter a single frequency F, or a range Fmin Fmax:', msgpos);
    msgneg=sprintf('Expected number of negative peaks per second.\n');
    msgneg=sprintf('%sEnter a single frequency F, or a range Fmin Fmax:', msgneg);
    prompt  = {msgpos, ...
               msgneg};
	title   = sprintf('Peak detection parameters');
	lines= 1;
	def     = {num2str(ud.filter.F(2:3)), num2str(ud.filter.F(2:3))};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;

    if isempty(answer),
        return;
    end
    
    posnegcontrol=[0 0];
    posnegflag=['pos';'neg'];
    %What is the input for the positive peaks?
    pos_peak_freq_range=str2num(answer(1,:));
    if isempty(pos_peak_freq_range),
        posnegcontrol(1)=0;
    elseif length(pos_peak_freq_range)>2,
        posnegcontrol(1)=0;
    else
        posnegcontrol(1)=1;
    end
        
    %What is the input for the negative peaks?
    neg_peak_freq_range=str2num(answer(2,:));
    if isempty(neg_peak_freq_range),
        posnegcontrol(2)=0;
    elseif length(neg_peak_freq_range)>2,
        posnegcontrol(2)=0;
    else
        posnegcontrol(2)=1;
    end
    
    %Valid entries?
    if all(posnegcontrol==0),
        showMessage(ud.Handles.Texts.Message, 'Unresolved entry', 0);    
        return;
    end
    if any([pos_peak_freq_range neg_peak_freq_range]<=0),
        showMessage(ud.Handles.Texts.Message, 'Invalid frequency', 0);    
        return;
    end
    if length(pos_peak_freq_range)>1 & ...
       pos_peak_freq_range(2)<=pos_peak_freq_range(1),
        showMessage(ud.Handles.Texts.Message, 'Invalid range', 0);    
        return;
    end
    if length(neg_peak_freq_range)>1 & ...
       neg_peak_freq_range(2)<=neg_peak_freq_range(1),
        showMessage(ud.Handles.Texts.Message, 'Invalid range', 0);    
        return;
    end
    
    %Put ranges in cell array
    peak_freq_range=[{pos_peak_freq_range}, {neg_peak_freq_range}];
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');

    showMessage(ud.Handles.Texts.Message, 'Detecting Peaks', 0);

    %Initialize the peak indicators
    peaks=zeros(2, length(signals.t));
    
    %Do the following for pos and neg
    for pn=1:2,
        if isempty(signals.start_indx),
        %If there are no intervals, process the entire signal.
            if posnegcontrol(pn),
                if length(peak_freq_range{pn})==1,
                    signal_segment=signals.eeg;
                    peaks(pn,:)=...
                        get_peaks(signal_segment, ud.data_features.Fs/peak_freq_range{pn}/2, posnegflag(pn,:));
                else
                    signal_segment=signals.eeg;
                    [Pxx, fxx]=periodogram(signal_segment, [], length(signal_segment), ud.data_features.Fs);
                    tfrange=find(fxx>=peak_freq_range{pn}(1) & ...
                                 fxx<=peak_freq_range{pn}(2));
                    if isempty(tfrange),
                        tfrange=1:length(fxx);
                    end
                    max_indx=find(Pxx(tfrange)==max(Pxx(tfrange)))+tfrange(1)-1;
                    f_max=min(peak_freq_range{pn}(2), ...
                              max(peak_freq_range{pn}(1), fxx(max_indx)));
                    my_duration=min((length(signal_segment)-1)/ud.data_features.Fs, 1/2/f_max);
                    peaks(pn, :)=...
                        get_peaks(signal_segment, ud.data_features.Fs*my_duration, posnegflag(pn, :));
                end
            end %posnegcontrol
        else
        %There are intervals, process each interval.
            if posnegcontrol(pn),
                if length(peak_freq_range{pn})==1,
                %Single peak frequency
                    for i=1:length(signals.start_indx),
                        range=signals.start_indx(i):signals.end_indx(i);
                        signal_segment=detrend(signals.eeg(range));
                        tpeaks=...
                            get_peaks(signal_segment, ud.data_features.Fs/peak_freq_range{pn}/2, posnegflag(pn,:));
                        peaks(pn,range)=peaks(pn,range)|tpeaks;
                    end
                else
                %Range of peak frequency
                    for i=1:length(signals.start_indx),
                        range=signals.start_indx(i):signals.end_indx(i);
                        signal_segment=detrend(signals.eeg(range));
                        [Pxx, fxx]=periodogram(signal_segment, [], length(signal_segment), ud.data_features.Fs);
                        tfrange=find(fxx>=peak_freq_range{pn}(1) & ...
                                     fxx<=peak_freq_range{pn}(2));
                        if isempty(tfrange),
                            tfrange=1:length(fxx);
                        end
                        max_indx=find(Pxx(tfrange)==max(Pxx(tfrange)))+tfrange(1)-1;
                        f_max=min(peak_freq_range{pn}(2), ...
                                  max(peak_freq_range{pn}(1), fxx(max_indx)));
                        my_duration=min((length(signal_segment)-1)/ud.data_features.Fs, 1/2/f_max);
                        tpeaks=...
                            get_peaks(signal_segment, ud.data_features.Fs*my_duration, posnegflag(pn,:));
                        peaks(pn,range)=peaks(pn,range)|tpeaks;
                    end
                end
            end %posnegcontrol                        
        end %Interval presence test
    end %for pn

    %Merge the peaks
    if all(posnegcontrol)
        all_peaks=peaks(1,:)|peaks(2,:);
    else
        all_peaks=[];
    end
            
    %Plot markers
    fns=fieldnames(ud.Handles.Lines);
    peak_markers_pos_exist=0;
    peak_markers_neg_exist=0;
    for i=1:length(fns),
        peak_markers_pos_exist=...
            peak_markers_pos_exist|strcmp(char(fns{i}), 'PeakMarkersPos');    
        peak_markers_neg_exist=...
            peak_markers_neg_exist|strcmp(char(fns{i}), 'PeakMarkersNeg');    
    end
    if posnegcontrol(1) & any(peaks(1,:)),
        XS=signals.t(find(peaks(1,:)==1));
        YS=signals.eeg(find(peaks(1,:)==1));
        if peak_markers_pos_exist & ~isempty(ud.Handles.Lines.PeakMarkersPos),
            set(ud.Handles.Lines.PeakMarkersPos, 'XData', XS, 'YData', YS);
        else
            ud.Handles.Lines.PeakMarkersPos=line(XS, YS, 'Parent', ud.Handles.Axes.Raw, ...
                'Marker', '*', 'LineStyle', 'none', 'Color', 'y');
        end
    end
    if posnegcontrol(2) & any(peaks(2,:)),
        XS=signals.t(find(peaks(2,:)==1));
        YS=signals.eeg(find(peaks(2,:)==1));
        if peak_markers_neg_exist & ~isempty(ud.Handles.Lines.PeakMarkersNeg),
            set(ud.Handles.Lines.PeakMarkersNeg, 'XData', XS, 'YData', YS);
        else
            ud.Handles.Lines.PeakMarkersNeg=line(XS, YS, 'Parent', ud.Handles.Axes.Raw, ...
                'Marker', '*', 'LineStyle', 'none', 'Color', 'b');
        end
    end
    
    %Store data
    set(fg, 'UserData', ud);
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);
    
    showMessage(ud.Handles.Texts.Message, 'DONE: Detecting Peaks', 1);    
    
    %Export to workspace the timestamps
    if posnegcontrol(1) & any(peaks(1,:)),
        assignin('base', 'positive_peak_times', signals.t(find(peaks(1,:)==1)));
    end
    if posnegcontrol(2) & any(peaks(2,:)),
        assignin('base', 'negative_peak_times', signals.t(find(peaks(2,:)==1)));
    end
    if ~isempty(all_peaks),
        assignin('base', 'all_peak_times', signals.t(find(all_peaks==1)));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_onset_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_onset_callback(eventSrc,eventData)
    
    fg=gcbf;
    ud=get(fg, 'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    %Return if no intervals
    if isempty(signals.start_indx),
        return;
    end
    drawnow;
    
    %Read user input for onset detection
    params=get_onset_latency_params(ud);
    if isempty(params),
        return;
    end
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');

    showMessage(ud.Handles.Texts.Message, 'Detecting Onset Times', 0);

    package.saved_signals=signals;
    package.Fs=ud.data_features.Fs;
    package.saved_filter=ud.filter;
    onset_indx_array=get_onset(package, params);
    if isempty(onset_indx_array),
        showMessage(ud.Handles.Texts.Message, 'Could not detect any onsets', 1);    
        return;
    end
    
    %Plot markers
    fns=fieldnames(ud.Handles.Lines);
    onset_markers_exist=0;
    for i=1:length(fns),
        onset_markers_exist=...
            onset_markers_exist|strcmp(char(fns{i}), 'OnsetMarkers');    
    end
    
    XS=signals.t(onset_indx_array);
    YE=signals.eeg(onset_indx_array);
    YY=signals.y(onset_indx_array);
    if onset_markers_exist & ~isempty(ud.Handles.Lines.OnsetMarkers),
        set(ud.Handles.Lines.OnsetMarkers(1, :), 'XData', XS, 'YData', YE);
        set(ud.Handles.Lines.OnsetMarkers(2, :), 'XData', XS, 'YData', YY);
    else
        ud.Handles.Lines.OnsetMarkers(1, :)=line(XS, YE, 'Parent', ud.Handles.Axes.Raw, ...
            'Marker', 'o', 'LineStyle', 'none', 'Color', 'r');
        ud.Handles.Lines.OnsetMarkers(2, :)=line(XS, YY, 'Parent', ud.Handles.Axes.Filtered, ...
            'Marker', 'o', 'LineStyle', 'none', 'Color', 'r');
    end
    
    %Store data
    set(fg, 'UserData', ud);
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);
    
    showMessage(ud.Handles.Texts.Message, 'DONE: Detecting Onsets', 1);    
    
    %Export to workspace the timestamps
    assignin('base', 'onset_times', XS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_latency_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_latency_callback(eventSrc,eventData)
    
    fg=gcbf;
    ud=get(fg, 'UserData');
    
    if ~isempty(ud.data_features.Fs),
        %A file is currently loaded
        button = questdlg('This operation will close current file.',...
		'Proceed?','Yes','No','No');
        drawnow;
		if strcmp(button,'Yes')
            ud=perform_close_sequence;
        else
            return;
		end
    end
    
    %Get reference signal filename
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the reference filtered .mat file');
    end
    if isempty(fnames),
        return;
    end
    ref_sig_fname=fnames;
    
    %Get reference interval filename
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the reference interval .mat file');
    end
    if isempty(fnames),
        return;
    end
    ref_int_fname=fnames;
    
    %Get target signal and interval filenames, and plot parameters
    [tar_sig_fnames, tar_int_fnames, channel_numbers, channel_order, ud, return_flag]=...
        menu_plot_int_stats_prep(ud);    
    if return_flag,
        return;
    end
    
    %Read user input for onset detection
    params=get_onset_latency_params(ud);
    if isempty(params),
        return;
    end
        
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');

    showMessage(ud.Handles.Texts.Message, 'Computing Latencies', 0);
    
    %Load the reference sig and int files
    load(ref_sig_fname{1});
    %Backward compatibility
    [package status]=make_backward_compatible(ref_sig_fname{1}, package);
    if status,
        return;
    end
    ref_package=package;
    load(ref_int_fname{1});
    ref_package.saved_signals.start_indx=package.start_indx;
    ref_package.saved_signals.end_indx=package.end_indx;
    
    %Process each file
    counter=1;
    collision_msg=sprintf('More than one onset comparison per event in:\n\n');
    ref_col_done=0;
    col_flag=0;
    for filecounter=1:size(tar_sig_fnames, 1),
        
        %Is this channel to be plotted?
        if isempty(find(channel_order==channel_numbers(filecounter))),
            continue;
        end
        
        %Status report
        msg=sprintf('Computing Latencies: File %d of %d', counter, length(channel_order));
        counter=counter+1;
        showMessage(ud.Handles.Texts.Message, msg, 0);
        
        load(tar_sig_fnames{filecounter});
        %Backward compatibility
        [package status]=make_backward_compatible(tar_sig_fnames{filecounter}, package);
        if status,
            return;
        end
        tar_package=package;
        load(tar_int_fnames{filecounter});
        tar_package.saved_signals.start_indx=package.start_indx;
        tar_package.saved_signals.end_indx=package.end_indx;
        
        latency_data=get_latency(ref_package, tar_package, params);
        if isempty(latency_data),
            latency_mean(filecounter)=NaN;
            latency_std(filecounter)=NaN;
            latency_num(filecounter)=NaN;
            onset_tstamps{filecounter, 1}=NaN;
            onset_tstamps{filecounter, 2}=NaN;
            interval_numbers{filecounter, 1}=NaN;
            interval_numbers{filecounter, 2}=NaN;
            interval_package{filecounter, 1}=NaN;
            interval_package{filecounter, 2}=NaN;
        else
            latency_mean(filecounter)=latency_data.mean;
            latency_std(filecounter)=latency_data.std;
            latency_num(filecounter)=latency_data.num;
            if latency_data.flag,
                col_flag=1;
                if latency_data.flag~=2 & ~ref_col_done,
                    collision_msg=sprintf('%sreference file\n', collision_msg);
                    ref_col_done=1;
                end
                if latency_data.flag>1,
                    collision_msg=sprintf('%schannel %d\n', ...
                        collision_msg, channel_numbers(filecounter));
                end
            end
            onset_tstamps{filecounter, 1}=latency_data.ref_onset_times;
            onset_tstamps{filecounter, 2}=latency_data.tar_onset_times;
            interval_numbers{filecounter, 1}=latency_data.ref_int_nums;
            interval_numbers{filecounter, 2}=latency_data.tar_int_nums;
            interval_package{filecounter, 1}=latency_data.ref_int_pack;
            interval_package{filecounter, 2}=latency_data.tar_int_pack;
        end
    end    

    if col_flag,
        %There were onset collisions
        msgbox(collision_msg, 'Fuse Intervals?', 'warn');
    end
    
    %Plot    
    input_struct.channel_order=channel_order;
    input_struct.channel_numbers=channel_numbers;
    input_struct.num_data=latency_num;
    input_struct.y_data=latency_mean;
    input_struct.e_data=latency_std;    
    [FH, x, y, e]=plot_data_vs_channels(input_struct);
    ax=findobj(FH, 'Type', 'axes');
    set(get(ax, 'YLabel'), 'String', 's');
	set(get(ax, 'Title'), 'String', 'Average Latency');
    
    %Store data
    set(fg, 'UserData', ud);
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);
    
    showMessage(ud.Handles.Texts.Message, 'DONE: Computing Latencies', 1);    

    %Close current file
    ud=perform_close_sequence;    

    %Save intervals
    for filecounter=1:size(tar_sig_fnames, 1),
        %Was this channel to be plotted?
        if isempty(find(channel_order==channel_numbers(filecounter))),
            continue;
        end
        if all(isnan(onset_tstamps{filecounter, 1})),
            continue;
        end
        file_name=sprintf('ch_%d_ref_int.mat', channel_numbers(filecounter));
        package=interval_package{filecounter, 1};
        save(file_name, 'package');
        file_name=sprintf('ch_%d_tar_int.mat', channel_numbers(filecounter));
        package=interval_package{filecounter, 2};
        save(file_name, 'package');
    end
    
    %Export plot data to workspace
    assignin('base', 'Channels', channel_order);
    assignin('base', 'latency_mean', y);
    assignin('base', 'latency_stderr', e);
    
    %Export onset time data to workspace
    for filecounter=1:size(tar_sig_fnames, 1),
        %Was this channel to be plotted?
        if isempty(find(channel_order==channel_numbers(filecounter))),
            continue;
        end
        if all(isnan(onset_tstamps{filecounter, 1})),
            continue;
        end
        var_name=sprintf('ch_%d_ref', channel_numbers(filecounter));
        assignin('base', var_name, onset_tstamps{filecounter, 1});
        var_name=sprintf('ch_%d_tar', channel_numbers(filecounter));
        assignin('base', var_name, onset_tstamps{filecounter, 2});
        var_name=sprintf('ch_%d_ref_int', channel_numbers(filecounter));
        assignin('base', var_name, interval_numbers{filecounter, 1});
        var_name=sprintf('ch_%d_tar_int', channel_numbers(filecounter));
        assignin('base', var_name, interval_numbers{filecounter, 2});
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_analysis_phase_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_analysis_phase_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');
    
    %Are there any peaks?
    fns=fieldnames(ud.Handles.Lines);
    peak_markers_pos_exist=0;
    peak_markers_neg_exist=0;
    for i=1:length(fns),
        peak_markers_pos_exist=...
            peak_markers_pos_exist|strcmp(char(fns{i}), 'PeakMarkersPos');    
        peak_markers_neg_exist=...
            peak_markers_neg_exist|strcmp(char(fns{i}), 'PeakMarkersNeg');    
    end
    if ~peak_markers_pos_exist & ~peak_markers_neg_exist,
        showMessage(ud.Handles.Texts.Message, 'No peaks', 1);    
        return;
    end

    %Read user input
    pmsg=sprintf('Maximum allowable peak-to-peak interval (in cycles of %.3f Hz):', ...
        ud.filter.F(2));
    prompt  = {pmsg, ...
               'Bin angle (deg):'};
	title   = sprintf('Phase estimation parameters');
	lines= 1;
	def     = {'1.2', '20'};
    if peak_markers_pos_exist & peak_markers_neg_exist,
        prompt={prompt{:}, 'What peak type to use? Positive (P), Negative (N):'};
        def={def{:}, ''};
    end
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
    
    if isempty(answer),
        return;
    end
    
    %Extract input
    max_p2p=str2num(answer(1,:));
    if isempty(max_p2p),
        return;
    end
    if max_p2p<=0,
        return;
    end
    
    bin_angle=str2num(answer(2,:));
    if isempty(bin_angle),
        return;    
    end
    bin_angle=rem(bin_angle, 360);
    if bin_angle<=0,
        return;
    end
    
    if peak_markers_pos_exist & peak_markers_neg_exist,
        peak_type=lower(answer(3, :));
        if isempty(peak_type),
            return;
        end
        peak_type=peak_type(1);
        if peak_type~='p' & peak_type~='n',
            return;
        end
    else
        if peak_markers_pos_exist,
            peak_type='p';
        else
            peak_type='n';
        end
    end
    
    %Get desired peak time stamps
    if peak_type=='p',
        if isempty(ud.Handles.Lines.PeakMarkersPos),
            peak_tstamps=[];
        else
            peak_tstamps=...
                get(ud.Handles.Lines.PeakMarkersPos, 'XData');
        end
    else
        if isempty(ud.Handles.Lines.PeakMarkersNeg),
            peak_tstamps=[];
        else
            peak_tstamps=...
                get(ud.Handles.Lines.PeakMarkersNeg, 'XData');
        end
    end
    
    if isempty(peak_tstamps),
        showMessage(ud.Handles.Texts.Message, 'No peaks', 1);    
        return;
    end
       
    %Now get the filenames of the spike time stamps
    fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the spike timestamps .mat file');
    if isempty(fnames),
        return;
    end
    spike_tstamp_fnames=fnames;
    
    %For each file generate the phase estimate
    num_of_files=size(spike_tstamp_fnames, 1);
    for file_counter=1:num_of_files,
        load(spike_tstamp_fnames{file_counter});
        spike_tstamps=package.tstamps;
        if isempty(spike_tstamps),
            msg=sprintf('No spikes in file %s', spike_tstamp_fnames{file_counter});
            errordlg(msg);
            continue;
        end
                
        phase_estimator(spike_tstamps, peak_tstamps, max_p2p, bin_angle, spike_tstamp_fnames{file_counter});
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_onset_latency_params %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function params=get_onset_latency_params(ud);

    params=[];

    %Who is calling
    cbtag=get(gcbo, 'Tag');
    
    %Read user input for onset detection
    prompt  = {'Power ratio (0<K<1). K:', ...
               'Compute average power in N>0 cycles. N:', ...
               'Search onset within C>=N cycles before interval start. C:', ...
               'Check M>=N cycles to the left of onset. M:'};
	title   = sprintf('Onset detection parameters');
	lines= 1;
	def     = {'0.25', '1', '10', '5'};
    if strcmp(cbtag, 'menu_analysis_latency'),
        prompt={prompt{:}, ...
               'Absolute latencies no more than X>0 s. X:'};
        def={def{:}, '2'};
    end
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;

    if isempty(answer),
        return;
    end
    
    power_ratio=str2num(answer(1, :));
    if isempty(power_ratio),
        return;
    end
    
    power_window=str2num(answer(2, :));
    if isempty(power_window),
        return;
    end
    
    search_window=str2num(answer(3, :));
    if isempty(search_window),
        return;
    end
    
    check_window=str2num(answer(4, :));
    if isempty(check_window),
        return;
    end
    
    if strcmp(cbtag, 'menu_analysis_latency'),
        max_latency=str2num(answer(5, :));
        if isempty(max_latency),
            return;
        end
        if max_latency<=0,
            return;
        end
    end

    if power_ratio<=0 | power_ratio>=1,
        return;
    end
    if power_window<=0,
        return;
    end
    if search_window<power_window,
        showMessage(ud.Handles.Texts.Message, 'Set C>=N', 0);
        return;
    end
    if check_window<power_window,
        showMessage(ud.Handles.Texts.Message, 'Set C>=N', 0);
        return;
    end
        
    params=[power_ratio, power_window, search_window, check_window];    
    if strcmp(cbtag, 'menu_analysis_latency'),
        params=[params max_latency];
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_eeg_to_mat_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_batch_eeg_to_mat_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');

    if ~isempty(ud.data_features.Fs),
        %A file is currently loaded
        button = questdlg('This operation will close current file.',...
		'Proceed?','Yes','No','No');
        drawnow;
		if strcmp(button,'Yes')
            ud=perform_close_sequence;
        else
            return;
		end
    end

    %Get filenames
    fnames=get_multiple_filenames(fullfile(pwd, '*.eeg'), 'Select input .eeg files');
    if isempty(fnames),
        return;
    end
    drawnow;
    for i=1:size(fnames, 1),
        %What is the extension of the input file?
        fname=fnames{i};
        extensiondot=max(charfind(fname, '.'));
        if ~strcmp(fname(extensiondot+1:end), 'eeg'),
            showMessage(ud.Handles.Texts.Message, 'File extension is not .eeg', 0);
            return;
        end
    end
    
    %Set default parameters
    num_of_files=size(fnames, 1);
    default.Fs=1024*ones(1, num_of_files);
    default.Gain=2500*ones(1, num_of_files);
    default.edit_box=ones(1, num_of_files);

    %Get user's Fs and Gain
    [Fs_array, Gain_array]=getdata_eeg_open(fnames, default);
    if isempty(Fs_array) | isempty(Gain_array),
        return;
    end
    
    for i=1:size(fnames, 1),
        data_array(i).fname=fnames{i};
        data_array(i).Fs=Fs_array(i);
        data_array(i).Gain=Gain_array(i);
    end

    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    %Start processing
    for i=1:length(data_array),
        
        %Show the current file's name as the Figure Name
         set(fg, 'Name', sprintf('eegrhythm %s (%.3f Hz)', data_array(i).fname, ...
                                                           data_array(i).Fs));
        drawnow;

        %Read and save eeg data
        ud=read_save_eeg_data(data_array(i).fname, data_array(i).Fs, data_array(i).Gain, ud);

        message=sprintf('Finished work on %s', avoidTeX(data_array(i).fname, '\_'));
        showMessage(ud.Handles.Texts.Message, message, 1);
       
        %Close current file
        ud=perform_close_sequence;
        
    end %for i=1:length(data_array)

    %Restore pointer
    set(fg, 'Pointer', old_ptr);

    %Clean up the residue of the last processed file
    perform_close_sequence;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_eeg_filter_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_batch_eeg_filter_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');

    if ~isempty(ud.data_features.Fs),
        %A file is currently loaded
        button = questdlg('This operation will close current file.',...
		'Proceed?','Yes','No','No');
        drawnow;
		if strcmp(button,'Yes')
            ud=perform_close_sequence;
        else
            return;
		end
    end

    %Get data
    [fnames, data_array, loaded_filter, ud, return_flag]=menu_batch_eeg_filter_prep(ud);
    if return_flag,
        return;
    end
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    %Do the batch process
    [ud, return_flag]=menu_batch_eeg_filter_function(fnames, data_array, loaded_filter, ud);
    if return_flag,
        return;
    end
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);

    %Clean up the residue of the last processed file
    perform_close_sequence;

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_eeg_filter_prep %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [signal_fnames, data_array, loaded_filter, ud, return_flag]=menu_batch_eeg_filter_prep(ud)

    return_flag=0;

    %Get filenames
    fnames=get_multiple_filenames(fullfile(pwd, '*.*'), 'Select input .eeg files, or their .mat versions');
    if isempty(fnames),
        return_flag=1;
        return;
    end    
    signal_fnames=fnames;
    
    drawnow;
    
    %If some of the input files are .mat files, use their stored Fs and Gain
    num_of_files=size(fnames, 1);
    default.Fs=1024*ones(1, num_of_files);
    default.Gain=2500*ones(1, num_of_files);
    default.edit_box=ones(1, num_of_files);
    for i=1:num_of_files,
        %What is the extension of the input file? .eeg or .mat?
        matfile=0;
        eegfile=0;
        fname=fnames{i};
        extensiondot=max(charfind(fname, '.'));
        if strcmp(fname(extensiondot+1:end), 'mat'),
            matfile=1;
        elseif strcmp(fname(extensiondot+1:end), 'eeg'),
            eegfile=1;
        else
            errordlg('Not a .eeg or .mat file.');
        end
        
        %If a .mat file, load it and use its Fs and Gain
        if matfile,
            load(fname);
            default.Fs(i)=package.Fs;
            default.Gain(i)=package.Gain;
            default.edit_box(i)=0;
        end
    end

    %Get user's Fs and Gain
    [Fs_array, Gain_array]=getdata_eeg_open(fnames, default);
    if isempty(Fs_array) | isempty(Gain_array),
        return_flag=1;
        return;
    end
    
    for i=1:size(fnames, 1),
        data_array(i).fname=fnames{i};
        data_array(i).Fs=Fs_array(i);
        data_array(i).Gain=Gain_array(i);
    end

    %Get filter filename from user
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the filter .mat file');
    end
    drawnow;
    if isempty(fnames),
        return_flag=1;
        return;
    end
    filter_fname=fnames{1};

    load(filter_fname);
    loaded_filter=package.saved_filter;

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_eeg_filter_function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ud, return_flag]=menu_batch_eeg_filter_function(fnames, data_array, loaded_filter, ud)

    return_flag=0;

    fg=gcbf;

    %Start processing
    for i=1:length(data_array),
        
        %Show the current file's name as the Figure Name
         set(fg, 'Name', sprintf('eegrhythm %s (%.3f Hz)', data_array(i).fname, ...
                                                           data_array(i).Fs));
        drawnow;

        %Read and save eeg data
        ud=read_save_eeg_data(data_array(i).fname, data_array(i).Fs, data_array(i).Gain, ud);
        
        %Store filter to its place
        ud.filter=loaded_filter;

        %If the filter's Fs is different than the signal's, return
        if is_different(data_array(i).Fs, ud.filter.Fs),
            message=sprintf('Filtering error for %s. ', avoidTeX(data_array(i).fname, '\_')); 
            message=sprintf('%sThe filter and the signal differ in ', message);
            message=sprintf('%ssampling rate. Redesign filter.', message);
            showMessage(ud.Handles.Texts.Message, message, 0);
            return_flag=1;
            return;
        end

        %Filter
        ud=filter_signal(ud);        

		%Save results to file
        lastdotplace=get_lastdotplace(data_array(i).fname);
        filmatfname=sprintf('%s-%d-%d.mat', data_array(i).fname(1:lastdotplace-1), ...
            ud.filter.F(2), ud.filter.F(3));
		save_filtered_data(filmatfname, ud);
        
        message=sprintf('Finished work on %s', avoidTeX(data_array(i).fname, '\_'));
        showMessage(ud.Handles.Texts.Message, message, 1);
       
        %Close current file
        ud=perform_close_sequence;
        
    end %for i=1:length(data_array)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_find_intervals_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_batch_find_intervals_callback(eventSrc,eventData)
    
    fg=gcbf;
    ud=get(fg, 'UserData');

    if ~isempty(ud.data_features.Fs),
        %A file is currently loaded
        button = questdlg('This operation will close current file.',...
		'Proceed?','Yes','No','No');
        drawnow;
		if strcmp(button,'Yes')
            ud=perform_close_sequence;
        else
            return;
		end
    end
            
    %Get data
    [fnames, users_data, ud, return_flag]=menu_batch_find_interv_prep(ud);
    if return_flag,
        return;
    end
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    %Do the batch processing
    [ud return_flag]=menu_batch_find_intervals_function(fnames, users_data, ud);
    if return_flag,
        return;
    end
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);
    
    %Clean up the residue of the last processed file
    perform_close_sequence;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_find_interv_prep %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fnames, users_data, ud, return_flag]=menu_batch_find_interv_prep(ud, varargin)

    return_flag=0;
    users_data=[];

    if nargin==1,
        %Get filenames
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the filtered .mat files');
        if isempty(fnames),
            return_flag=1;
            return;
        end
    else
        fnames=varargin{1};
    end

    if nargin==1,
        %Load a file to get the filter characteristics
        load(fnames{1}); 
        ud.filter=package.saved_filter;
    else
        ud.filter=varargin{2};
    end
    
    users_data=get_interval_search_params(ud);
    if isempty(users_data),
        return_flag=1;
        return;
    end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_find_intervals_function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ud, return_flag]=menu_batch_find_intervals_function(fnames, params, ud)

    return_flag=0;

    fg=gcbf;

    users_threshold=params.users_threshold;
    users_intervalCutoff=params.users_intervalCutoff;
    users_absmaxref_choice=params.users_absmaxref;
    users_interval_power_screen_ranges=params.users_R;
    users_interval_power_screen_ratio=params.users_K;
    users_peak_grouping_window=params.users_peak_grouping_window;
    users_interval_fusion_window=params.users_interval_fusion_window;

    %Start processing
    for i=1:size(fnames,1),

        %Load file
        load(fnames{i});        
        
        %Backward compatibility
        [package status]=make_backward_compatible(fnames{i}, package);
        if status,
            return_flag=1;
            return;
        end
        
        %Show the current file's name as the Figure Name
        set(fg, 'Name', sprintf('eegrhythm %s (%.3f Hz)', fnames{i}, ...
                                                           package.Fs));
        drawnow;                                                       
        ud.DataFileName=fnames{i};
        ud.FigureName=fnames{i};
        
		%Save loaded eeg data
		ud=save_loaded_eeg_data(package.Fs, package.Gain, package.saved_signals, ...
                                fnames{i}, package.saved_filter, ud); 
        
        %Set the threshold
        threshold=ud.threshold;
        threshold.users=users_threshold;
        threshold.intervalCutoff=users_intervalCutoff;
        threshold.interval_power_screen_ranges=users_interval_power_screen_ranges;
        threshold.interval_power_screen_ratio=users_interval_power_screen_ratio;
        threshold.absmaxref=users_absmaxref_choice;
        threshold.peak_grouping_window=users_peak_grouping_window;
        threshold.interval_fusion_window=users_interval_fusion_window;
        ud=set_thresholdstruct(ud, threshold);
        
        %Get interval starts and ends
        [ud signals]=findIntervals(ud);

        %Initialize interval categories 
        intervalCategories=initIntervalCategories(ud, length(signals.start_indx));

        %Construct the interval fname
        lastdotplace=get_lastdotplace(fnames{i});
        intfname=sprintf('%s-int-%.2f-%.2f.mat', fnames{i}(1:lastdotplace-1), ...
                                             threshold.users, threshold.intervalCutoff);
        %Save the interval data
        save_interval_matfile(intfname, signals, intervalCategories);
        
        message=sprintf('Finished work on %s', avoidTeX(fnames{i}, '\_'));
        showMessage(ud.Handles.Texts.Message, message, 0);
        
        %Close current file
        ud=perform_close_sequence;
    end %for i=1:size(fnames, 1)

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_eeg_to_plot_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_batch_eeg_to_plot_callback(eventSrc,eventData)
    
    fg=gcbf;
    ud=get(fg, 'UserData');

    if ~isempty(ud.data_features.Fs),
        %A file is currently loaded
        button = questdlg('This operation will close current file.',...
		'Proceed?','Yes','No','No');
        drawnow;
		if strcmp(button,'Yes')
            ud=perform_close_sequence;
        else
            return;
		end
    end

    %Get data about eeg/mat files and filter
    [fnames, data_array, loaded_filter, ud, return_flag]=menu_batch_eeg_filter_prep(ud);
    if return_flag,
        return;
    end
    
    %TO Deemphasize
    %Generate filtered mat fnames
    for i=1:length(data_array),
        lastdotplace=get_lastdotplace(data_array(i).fname);
        filmatfnames(i)={sprintf('%s-%d-%d.mat', data_array(i).fname(1:lastdotplace-1), ...
                loaded_filter.F(2), loaded_filter.F(3))};
    end
    
    %Get data
    [filmatfnames, int_package, int_data, filetype, ud, return_flag]=...
        menu_batch_deem_interv_prep(ud, filmatfnames);
    if return_flag,
        return;
    end

    %TO Find intervals
    %Generate deemphasized fnames
    for i=1:length(data_array),
        lastdotplace=get_lastdotplace(filmatfnames{i});
        fildeematfnames(i)={sprintf('%s-deem%s', filmatfnames{i}(1:lastdotplace-1), ...
             filmatfnames{i}(min(lastdotplace, length(filmatfnames(i, :))):end))};
    end
    
    %Get data
    [fildeematfnames, users_data, ud, return_flag]=...
        menu_batch_find_interv_prep(ud, fildeematfnames, loaded_filter);
    if return_flag,
        return;
    end
    
    %TO Plot
    %Generate input interval fnames
    for i=1:length(data_array),
        lastdotplace=get_lastdotplace(fildeematfnames{i});
        int_fnames(i)={sprintf('%s-int-%.2f-%.2f.mat', ...
            fildeematfnames{i}(1:lastdotplace-1), users_data.users_threshold, ...
            users_data.users_intervalCutoff)};
    end
    
    %Get data    
    [fildeematfnames, int_fnames, channel_numbers, channel_order, ud, return_flag]=...
        menu_plot_int_stats_prep(ud, fildeematfnames, int_fnames);    
    if return_flag,
        return;
    end

    %Now do the processings
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    
    %Do the batch eeg->filtered
    [ud, return_flag]=menu_batch_eeg_filter_function(fnames, data_array, loaded_filter, ud);
    if return_flag,                                        
        return;
    end
    
    %Perform batch deem
    [ud return_flag]=menu_batch_deem_intervals_function(filmatfnames, int_package, ...
        int_data, filetype, ud);
    if return_flag,     
        return;
    end
    
    %Do the batch find intervs
    [ud return_flag]=menu_batch_find_intervals_function(fildeematfnames, users_data, ud);
    if return_flag,
        return;
    end
        
    %Do the plotting
    [ud return_flag]=menu_plot_int_stats_function(fildeematfnames, int_fnames, ...
        channel_numbers, channel_order, ud);
    if return_flag,
        return;
    end
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_deemphasize_intervals_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_batch_deemphasize_intervals_callback(eventSrc,eventData)
    
    fg=gcbf;
    ud=get(fg, 'UserData');

    if ~isempty(ud.data_features.Fs),
        %A file is currently loaded
        button = questdlg('This operation will close current file.',...
		'Proceed?','Yes','No','No');
        drawnow;
		if strcmp(button,'Yes')
            ud=perform_close_sequence;
        else
            return;
		end
    end

    %Get data
    [signal_fnames int_package int_data filetype ud return_flag]=...
        menu_batch_deem_interv_prep(ud);
    if return_flag,
        return;
    end
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');

    %Perform batch process
    [ud return_flag]=menu_batch_deem_intervals_function(signal_fnames, int_package, ...
        int_data, filetype, ud);
    if return_flag,
        return;
    end
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);

    %Clean up the residue of the last processed file
    perform_close_sequence;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_deem_interv_prep %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [signal_fnames, int_package, int_data, filetype, ud, return_flag]=...
    menu_batch_deem_interv_prep(ud, varargin)

    return_flag=0;

    if nargin==1,
        %Get filenames
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the filtered .mat files to be modified');
        if isempty(fnames),
            return_flag=1;
            return;
        end
        signal_fnames=fnames;
    else
        signal_fnames=varargin{1};
    end
    
    %Get the deemphasis interval file
    fnames=zeros(2);
    while ~isempty(fnames) & size(fnames, 1)~=1,
        fnames=get_multiple_filenames(fullfile(pwd, '*.*'), 'Select the deemphasis interval file (*.txt; *.mat)');
    end
    if isempty(fnames),
        return_flag=1;
        return;
    end
    int_fname=fnames{1};
    drawnow;
    
    %Is the interval file a text file?
    lastdotplace=max(charfind(int_fname, '.'));
    if isempty(lastdotplace) | length(int_fname)-lastdotplace~=3,
        showMessage(ud.Handles.Texts.Message, ...
            'Interval file name should have .txt or .mat extension', 1);
        return_flag=1;
        return;
    end
    switch (int_fname(lastdotplace+1:end))
        case 'txt'
            filetype='txt';
            %This is a text file. The interval starts and ends begin after a line that
            %starts with the word start
            int_file=fopen(int_fname, 'rt');
            
            %Skip to data
            while 1,
                aline=fgetl(int_file);
                if strcmp(aline(1:5), 'start'),
                    break;
                end
            end
            
            %Now read data
			int_data = fscanf(int_file,'%f %f',[2 inf]); % It has two rows now.
            int_package=[];
			fclose(int_file);
            
            %Check ordering
            [dummy start_order]=sort(int_data(1, :));
            [dummy end_order]=sort(int_data(2, :));
            if any(start_order~=end_order) | any(start_order~=[1:length(start_order)]),
                showMessage(ud.Handles.Texts.Message, ...
                    'Interval time stamps are not in ascending order', 1);
                return_flag=1;
                return;
            end
            
            %Check end>start
            if any((int_data(2,:)-int_data(1,:))<=0),
                showMessage(ud.Handles.Texts.Message, ...
                    'Interval durations should be positive', 1);
                return_flag=1;
                return;
            end
            
        case 'mat'
            filetype='mat';
            
            load(int_fname);
            int_package=package;
            int_data=[];
        otherwise
            showMessage(ud.Handles.Texts.Message, ...
                'Interval file name should have .txt or .mat extension', 1);
            return_flag=1;
            return;
    end %switch
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_batch_deem_intervals_function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ud, return_flag]=menu_batch_deem_intervals_function(signal_fnames, int_package, int_data, filetype, ud)

    return_flag=0;

    fg=gcbf;
    
    %Start processing
    for i=1:size(signal_fnames,1),

        %Construct a filename to save the modified data
        lastdotplace=get_lastdotplace(signal_fnames{i});
        outfname=sprintf('%s-deem%s', signal_fnames{i}(1:lastdotplace-1), ...
               signal_fnames{i}(min(lastdotplace, length(signal_fnames{i})):end));
                
        %Load signal file
        load(signal_fnames{i});        

        %Backward compatibility
        [package status]=make_backward_compatible(signal_fnames{i}, package);
        if status,
            return_flag=1;
            return;
        end
        
        drawnow;                                                       
        
		%Save loaded eeg data
		ud=save_loaded_eeg_data(package.Fs, package.Gain, package.saved_signals, ...
                                signal_fnames{i}, package.saved_filter, ud); 
        
        %Get data in signals
        signals=get(ud.Handles.Axes.Raw, 'UserData');
		ud.FigureName=sprintf('eegrhythm %s (%.3f Hz)', outfname, ud.filter.Fs);
        set(fg, 'Name', ud.FigureName);
        drawnow;
        %Store intervals
        switch filetype,
            case 'txt'
                %The interval start and end times in seconds are stored in data.
                %Check whether the time stamps match
                min_start_time=min(int_data(1, :));
                max_stop_time=max(int_data(2, :));
                
                if min(signals.t)>min_start_time | max(signals.t)<max_stop_time,
                    msg=...
                        sprintf(...
                        'Interval Load Error: Interval tstamps in the deemphasis interval file exceed those in %s', ...
                        avoidTeX(signal_fnames{i}, '\_'));
                    showMessage(ud.Handles.Texts.Message, msg, 1);
                    return_flag=1;
                    return;
                end

                %Convert times to indices
                delta=(signals.t(end)-signals.t(1))/(length(signals.t)-1);
                signals.start_indx=1+floor((int_data(1, :)-signals.t(1))/delta);
                signals.end_indx  =1+floor((int_data(2, :)-signals.t(1))/delta);
                
                %Store the new intervals
                set(ud.Handles.Axes.Raw, 'UserData', signals);
                
           case 'mat'
                %Check whether the time stamps match
                local_start_times=signals.t(int_package.start_indx);
                local_end_times=signals.t(int_package.end_indx);
                starts_are_same=local_start_times==int_package.start_times;
                ends_are_same=local_end_times==int_package.end_times;
                if any(starts_are_same==0) | any(ends_are_same==0),
                    msg=...
                        sprintf(...
                        'Interval Load Error: Interval tstamps in the deemphasis interval file exceed those in %s', ...
                        avoidTeX(signal_fnames{i}, '\_'));
                    showMessage(ud.Handles.Texts.Message, msg, 1);
                    return_flag=1;
                    return;
                end
                
                %Store the new intervals
                signals.start_indx=int_package.start_indx;
                signals.end_indx  =int_package.end_indx;
                set(ud.Handles.Axes.Raw, 'UserData', signals);
                
                %Initialize the intervalCategories
                initIntervalCategories(ud, length(signals.start_indx));
                
        end%switch filetype

        %Now deemphasize
        for j=1:length(signals.start_indx),            
            %How long is this interval?
            range=signals.start_indx(j):signals.end_indx(j);
            interval_length=length(range);
                
            %Zero the amplitude
            window=zeros(1, interval_length);
            
            %Deemphasize the segment of the raw and filtered eeg.
            signals.eeg(range)=signals.eeg(range).*window;
            signals.y(range)=signals.y(range).*window;
        end
        set(ud.Handles.Axes.Raw, 'UserData', signals);

        %Save to file
        ud=save_filtered_data(outfname, ud);
        
        message=sprintf('Finished work on %s', avoidTeX(signal_fnames{i}, '\_'));
        showMessage(ud.Handles.Texts.Message, message, 0);
        
        %Close current file
        ud=perform_close_sequence;
    end %for i=1:size(fnames, 1)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_plot_interval_stats_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_plot_interval_stats_callback(eventSrc,eventData)
    
    fg=gcbf;
    ud=get(fg, 'UserData');

    if ~isempty(ud.data_features.Fs),
        %A file is currently loaded
        button = questdlg('This operation will close current file.',...
		'Proceed?','Yes','No','No');
        drawnow;
		if strcmp(button,'Yes')
            ud=perform_close_sequence;
        else
            return;
		end
    end

    %Get data
    [signal_fnames int_fnames channel_numbers channel_order ud return_flag]=...
        menu_plot_int_stats_prep(ud);
    if return_flag,
        return;
    end                                 
    
    %Show watch
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');

    %Do the plotting
    [ud return_flag]=menu_plot_int_stats_function(signal_fnames, int_fnames, ...
        channel_numbers, channel_order, ud);
    if return_flag,
        return;
    end                             
    
    %Restore pointer
    set(fg, 'Pointer', old_ptr);

    showMessage(ud.Handles.Texts.Message, 'DONE: Interval Stats', 1);
    
    %Close current file
    ud=perform_close_sequence;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_plot_int_stats_prep %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [signal_fnames, int_fnames, channel_numbers, channel_order, ud, return_flag]=...
        menu_plot_int_stats_prep(ud, varargin)
    
    return_flag=0;
    signal_fnames=[];
    int_fnames=[];
    channel_numbers=[];
    channel_order=[];
    
    if nargin==1,
        %Get signal filenames from user
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the filtered .mat files');
        if isempty(fnames),
            return_flag=1;
            return;
        end
        signal_fnames=fnames;
        
		%Get interval filenames from user
        fnames=get_multiple_filenames(fullfile(pwd, '*.mat'), 'Select the corresponding interval .mat files');
        if isempty(fnames),
            return_flag=1;
            return;
        end
        int_fnames=fnames;        
    else
        signal_fnames=varargin{1};
        int_fnames=varargin{2};        
    end
        
    %Consistency check 
    if size(signal_fnames, 1)~=size(int_fnames, 1),
        showMessage(ud.Handles.Texts.Message, 'Different number of signal and interval files.', 1);
        return_flag=1;
        return;
    end
    
    %Get channel numbers
    channel_numbers=get_channel_numbers(signal_fnames, ud);
    if isempty(channel_numbers),
        return_flag=1;
        return;
    end
    
    %Read user input for plot
    prompt  = {'Channel Order'};
	title   = sprintf('Plot parameters');
	lines= 1;
	def     = {num2str(channel_numbers)};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;

    if isempty(answer),
        return_flag=1;
        return;
    end
    for i=1:1,
        empty_field(i)=isempty(str2num(answer(i,:)));
    end
    if any(empty_field==1),
        return_flag=1;
        return;
    end
    drawnow;
    
    %Channel order
    channel_order=str2num(answer(1,:));
    
    %Check whether the desired channels exist
    ok=1;
    for i=1:length(channel_order),
        indx=find(channel_numbers==channel_order(i));
        ok=ok&~isempty(indx);
        break;
    end
    if ~ok,
        msg=sprintf('Invalid channel number %d', i);
        showMessage(ud.Handles.Texts.Message, msg, 1);
        return_flag=1;
        return;
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_plot_int_stats_function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ud, return_flag]=menu_plot_int_stats_function(signal_fnames, int_fnames, channel_numbers, ...
                                 channel_order, ud);

    return_flag=0;                                
                             
    fg=gcbf;                             
                             
    %Process input files
    counter=1;
    for i=1:size(signal_fnames, 1),

        %Is this channel to be plotted?
        if isempty(find(channel_order==channel_numbers(i))),
            continue;
        end
        
        %Status report
        msg=sprintf('File %d of %d', counter, length(channel_order));
        counter=counter+1;
        showMessage(ud.Handles.Texts.Message, msg, 0);
        
		%Load data
		load(signal_fnames{i});
        
        %Backward compatibility
        [package status]=make_backward_compatible(signal_fnames{i}, package);
        if status,
            return_flag=1;
            return;
        end

		%Save loaded eeg data
		ud=save_loaded_eeg_data(package.Fs, package.Gain, package.saved_signals, ...
                                signal_fnames{i}, package.saved_filter, ud);
        signals=get(ud.Handles.Axes.Raw, 'UserData');

        %Now intervals
        load(int_fnames{i});
        
        %Check whether the time stamps match
        local_start_times=signals.t(package.start_indx);
        local_end_times=signals.t(package.end_indx);
        starts_are_same=local_start_times==package.start_times;
        ends_are_same=local_end_times==package.end_times;
        if any(starts_are_same==0) | any(ends_are_same==0),
            msg=...
                sprintf(...
                'Interval Load Error: Interval tstamps in %s do not match file %s', ...
                avoidTeX(int_fnames{i}, '\_'), ...
                avoidTeX(signal_fnames{i}, '\_'));
            showMessage(ud.Handles.Texts.Message, msg, 1);
            return_flag=1;
            return;
        end
        
        %Store the new intervals
        signals.start_indx=package.start_indx;
        signals.end_indx  =package.end_indx;
        set(ud.Handles.Axes.Raw, 'UserData', signals);
        
        %Initialize the intervalCategories
        initIntervalCategories(ud, length(signals.start_indx));
        
        %Now store the saved interval categories, and label the intervals    
		intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
        intervalCategories.categories=package.categories;
        categories=package.categories;
		set(ud.Handles.Axes.Filtered, 'UserData', intervalCategories);
        
        %Now compute interval stats
        interval_stats_array(i)=get_interval_stats(intervalCategories, signals);        
        num_data(i)=interval_stats_array(i).num_of_intervals;
        y_data(i)=mean(interval_stats_array(i).avg_fil_power_perinterval);
        e_data(i)=std(interval_stats_array(i).avg_fil_power_perinterval);

        %Close current file
        ud=perform_close_sequence;
    end %i=1:size(signal_fnames, 1)
      
    %Number of structs
    num_of_structs=size(signal_fnames, 1);

    input_struct.channel_order=channel_order;
    input_struct.channel_numbers=channel_numbers;
    input_struct.num_data=num_data;
    input_struct.y_data=y_data*1e6; %Convert to mV^2
    input_struct.e_data=e_data*1e6;    
    [FH, x, y, e]=plot_data_vs_channels(input_struct);
    ax=findobj(FH, 'Type', 'axes');
    set(get(ax, 'YLabel'), 'String', 'mV^{2}');
	set(get(ax, 'Title'), 'String', 'Average Filtered Power per Episode');
    
    %Export plot data to workspace
    assignin('base', 'Channels', channel_order);
    assignin('base', 'Avg_fil_pwr_per_episode', y);
    assignin('base', 'Std_err_of_mean', e);
    
%%%%%%%%%%%%%%%%%%
% menu_file_save %
%%%%%%%%%%%%%%%%%%
function menu_file_save_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    %If there is no filtered signal, return;
    if isempty(signals.y),
        return;
    end

	%Get filename from user
	[fname,pname] = uiputfile('*.mat','Save filtered eeg data as');
	fname=sprintf('%s%s', pname, fname);
    
    if isempty(fname),
        return;
    end
    
    %Save results to file
    ud=save_filtered_data(fname, ud);

    set(fg, 'UserData', ud);
    
%%%%%%%%%%%%%%%%%%%%%%%
% menu_close_callback %
%%%%%%%%%%%%%%%%%%%%%%%
function menu_close_callback(eventSrc,eventData)

    button = questdlg('Close?',...
	'Confirm','Yes','No','No');
    drawnow;
	if strcmp(button,'Yes')
        perform_close_sequence;
	end
    
%%%%%%%%%%%%%%%%%%%%%%
% menu_quit_callback %
%%%%%%%%%%%%%%%%%%%%%%
function menu_quit_callback(eventSrc,eventData)

    button = questdlg('Quit?',...
	'Confirm','Yes','No','No');
    drawnow;
	if strcmp(button,'Yes')
        close(gcbf);
	end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% menu_view_callback %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function menu_view_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');

    %What is the name of this menu function?
    label=get(gcbo, 'Label');
    
    switch label,
        case {'Show Positive', 'Hide Positive', 'Show Negative', 'Hide Negative', ...
              'Delete Positive', 'Delete Negative'}
            %Do peaks exist?
            fns=fieldnames(ud.Handles.Lines);
            peak_markers_pos_exist=0;
            peak_markers_neg_exist=0;
            for i=1:length(fns),
                peak_markers_pos_exist=...
                    peak_markers_pos_exist|strcmp(char(fns{i}), 'PeakMarkersPos');    
                peak_markers_neg_exist=...
                    peak_markers_neg_exist|strcmp(char(fns{i}), 'PeakMarkersNeg');    
            end
        case {'Show Onsets', 'Hide Onsets', 'Delete Onsets'}
            %Do onsets exist?
            fns=fieldnames(ud.Handles.Lines);
            onset_markers_exist=0;
            for i=1:length(fns),
                onset_markers_exist=...
                    onset_markers_exist|strcmp(char(fns{i}), 'OnsetMarkers');    
            end
        case {'Show Interval Delimiters', 'Hide Interval Delimiters'}
            %Do intervals exist?
            signals=get(ud.Handles.Axes.Raw, 'UserData');
            if isempty(signals.start_indx),
                showMessage(ud.Handles.Texts.Message, 'No Intervals', 1);
                return;
            end
			interval_lines=[ud.Handles.Lines.RawStarts, ...
                            ud.Handles.Lines.RawEnds, ...
                            ud.Handles.Lines.FilteredStarts, ...
                            ud.Handles.Lines.FilteredEnds];
        case {'Show Threshold Lines', 'Hide Threshold Lines'}
            %Do these lines exist?
            if isempty(ud.threshold.lines),
                showMessage(ud.Handles.Texts.Message, 'No Threshold Lines', 1);
                return;
            else
                ydata=get(ud.threshold.lines, 'YData');
                if all(isnan([ydata{1}, ydata{2}])),
                    showMessage(ud.Handles.Texts.Message, 'No Threshold Lines', 1);
                    return;
                end
            end
    end %switch label
            
    
    switch label,
        case 'Show Positive'
            if ~peak_markers_pos_exist,
                showMessage(ud.Handles.Texts.Message, 'No Positive Peaks', 1);
                return;
            end            
            set(ud.Handles.Lines.PeakMarkersPos, 'Visible', 'on');
            
            %Toggle label
            set(gcbo, 'Label', 'Hide Positive');
        case 'Hide Positive'
            if ~peak_markers_pos_exist,
                showMessage(ud.Handles.Texts.Message, 'No Positive Peaks', 1);
                return;
            end
            set(ud.Handles.Lines.PeakMarkersPos, 'Visible', 'off');
            %Toggle label
            set(gcbo, 'Label', 'Show Positive');
        case 'Delete Positive'
            if ~peak_markers_pos_exist,
                showMessage(ud.Handles.Texts.Message, 'No Positive Peaks', 1);
                return;
            end
            delete(ud.Handles.Lines.PeakMarkersPos);
            ud.Handles.Lines=rmfield(ud.Handles.Lines, 'PeakMarkersPos');
            other_handle=findobj(0, 'Label', 'Show Positive');
            if ~isempty(other_handle),
                set(other_handle, 'Label', 'Hide Positive');
            end
            set(fg, 'UserData', ud);
        case 'Show Negative'
            if ~peak_markers_neg_exist,
                showMessage(ud.Handles.Texts.Message, 'No Negative Peaks', 1);
                return;
            end            
            set(ud.Handles.Lines.PeakMarkersNeg, 'Visible', 'on');
            
            %Toggle label
            set(gcbo, 'Label', 'Hide Negative');
        case 'Hide Negative'
            if ~peak_markers_neg_exist,
                showMessage(ud.Handles.Texts.Message, 'No Negative Peaks', 1);
                return;
            end
            set(ud.Handles.Lines.PeakMarkersNeg, 'Visible', 'off');
            %Toggle label
            set(gcbo, 'Label', 'Show Negative');
        case 'Delete Negative'
            if ~peak_markers_neg_exist,
                showMessage(ud.Handles.Texts.Message, 'No Negative Peaks', 1);
                return;
            end
            delete(ud.Handles.Lines.PeakMarkersNeg);
            ud.Handles.Lines=rmfield(ud.Handles.Lines, 'PeakMarkersNeg');
            other_handle=findobj(0, 'Label', 'Show Negative');
            if ~isempty(other_handle),
                set(other_handle, 'Label', 'Hide Negative');
            end
            set(fg, 'UserData', ud);
        case 'Show Onsets'
            if ~onset_markers_exist,
                showMessage(ud.Handles.Texts.Message, 'No Onsets', 1);
                return;
            end            
            set(ud.Handles.Lines.OnsetMarkers, 'Visible', 'on');
            
            %Toggle label
            set(gcbo, 'Label', 'Hide Onsets');
        case 'Hide Onsets'
            if ~onset_markers_exist,
                showMessage(ud.Handles.Texts.Message, 'No Onsets', 1);
                return;
            end
            set(ud.Handles.Lines.OnsetMarkers, 'Visible', 'off');
            %Toggle label
            set(gcbo, 'Label', 'Show Onsets');
        case 'Delete Onsets'
            if ~onset_markers_exist,
                showMessage(ud.Handles.Texts.Message, 'No Onsets', 1);
                return;
            end
            delete(ud.Handles.Lines.OnsetMarkers);
            ud.Handles.Lines=rmfield(ud.Handles.Lines, 'OnsetMarkers');
            other_handle=findobj(0, 'Label', 'Show Onsets');
            if ~isempty(other_handle),
                set(other_handle, 'Label', 'Hide Onsets');
            end
            set(fg, 'UserData', ud);
        case 'Show Interval Delimiters'
            
            set(interval_lines, 'Visible', 'on');

            %Toggle label
            set(gcbo, 'Label', 'Hide Interval Delimiters');
        case 'Hide Interval Delimiters'
            
            set(interval_lines, 'Visible', 'off');
            
            %Toggle label
            set(gcbo, 'Label', 'Show Interval Delimiters');
        case 'Show Threshold Lines'
            
            set(ud.threshold.lines, 'Visible', 'on');

            %Toggle label
            set(gcbo, 'Label', 'Hide Threshold Lines');
        case 'Hide Threshold Lines'
            
            set(ud.threshold.lines, 'Visible', 'off');
            
            %Toggle label
            set(gcbo, 'Label', 'Show Threshold Lines');
    end %switch label

%%%%%%%%%%%%%%%%%%%%%%
% menu_help_callback %
%%%%%%%%%%%%%%%%%%%%%%
function menu_help_callback(eventSrc,eventData)

    msg=sprintf('Hot Keys:\n');
    msg=sprintf('%s---1, 2, ..., 9 to label intervals.\n', msg);
    msg=sprintf('%s---0 to unlabel an interval.\n', msg);
    msg=sprintf('%s---F or f to jump to the first interval.\n', msg);
    msg=sprintf('%s---L or l to jump to the last interval.\n', msg);
    msg=sprintf('%s---M or m to jump to the interval that contains the largest filtered absolute amplitude.\n', msg);
    msg=sprintf('%s---N or n to jump to the next interval.\n', msg);
    msg=sprintf('%s---P or p to jump to the previous interval.\n', msg);
    msg=sprintf('%s---Z or z to zoom in/out the selected interval.\n', msg);
    msg=sprintf('%s\nText Boxes:\n', msg);
    msg=sprintf('%s---Threshold: The fraction of a reference amplitude.\n', msg);
    msg=sprintf('%s0 selects entire session.\n', msg);
    msg=sprintf('%s---Min. number of cycles per interval: Intervals must contain\n', msg);
    msg=sprintf('%sat least this many cycles of the lowest bandpass frequency to\n', msg);
    msg=sprintf('%sbe detected\n', msg);
    msg=sprintf('%s---Start/Stop offset: Video play start/stop time in seconds relative\n', msg);
    msg=sprintf('%sto interval start/end.\n', msg);
    msg=sprintf('%s\nApply button:\n', msg);
    msg=sprintf('%s---Apply the current settings of threshold and Min. number\n', msg);
    msg=sprintf('%s    of cycles per interval\n', msg);    
    msg=sprintf('%s\nMenus:\n', msg);
    msg=sprintf('%s-Interval:\n', msg);
    msg=sprintf('%s--Deemphasize current:\n', msg);
    msg=sprintf('%s---Deemphasize current interval using a 20 dB-attenuated hamming window.\n', msg);
    msg=sprintf('%s-Analysis:\n', msg);
    msg=sprintf('%s--PSD:\n', msg);
    msg=sprintf('%s---Compute PSD for selected intervals. Enter the min/max frequency values\n', msg);
    msg=sprintf('%sin the PSD and the approximate number of frequencies between them.\n', msg);
    msg=sprintf('%sPSD from each interval category is plotted in a separate figure.\n', msg);
    msg=sprintf('%sTo overlay plots from different files, enter the base figure number,\n', msg);
    msg=sprintf('%sand each interval category''s PSD will be overlaid in the respective\n', msg);
    msg=sprintf('%sfigure. Specify the color of the plot line entering one of the\n', msg);
    msg=sprintf('%sfollowing single letters as the first character in the appropriate box:\n', msg);
    msg=sprintf('%s\tr g b y m c k\n', msg);
    msg=sprintf('%s--Interval Statistics:\n', msg);
    msg=sprintf('%s---Compute statistics for selected intervals.\n', msg);
    msg=sprintf('%sAverage power, interval duration, start/end times, ...\n', msg);
    msg=sprintf('%s--Motion:\n', msg);
    msg=sprintf('%s---Find intervals in which the rat moves more or less than a threshold.\n', msg);
    msg=sprintf('%snumber of pixels.\n', msg);
    msg=sprintf('%s-Batch:\n', msg);
    msg=sprintf('%s--Read .eeg and Filter.\n', msg);
    msg=sprintf('%s---Read multiple raw .eeg or .mat files and filter them using a filter.\n', msg);
    msg=sprintf('%sSaves the filtered files using an automatically generated name that reflects\n', msg);
    msg=sprintf('%sthe filter passband.\n', msg);
    msg=sprintf('%s--Find Intervals\n', msg);
    msg=sprintf('%s---Read multiple filtered eeg .mat files, and find intervals in them using\n', msg);
    msg=sprintf('%sthe same thresholding parameters. Saves the results in a .mat file.\n', msg);
    msg=sprintf('%s-Plot:\n', msg);
    msg=sprintf('%s--Interval Statistics.\n', msg);
    msg=sprintf('%s---Reads the .mat file generated by Batch/Find Intervals menu option\n', msg);
    msg=sprintf('%sand plots results.\n', msg);
    scrollableTextFigure('Eegrhythm Help', msg);
    
%%%%%%%%%%%%%%%%%%%%%%%
% menu_about_callback %
%%%%%%%%%%%%%%%%%%%%%%%
function menu_about_callback(eventSrc,eventData)

    fg=gcbf;
    ud=get(fg, 'UserData');

    msg=sprintf('EEGRHYTHM: An interactive application to process EEG data.\n\n');
    msg=sprintf('%sAuthor: Murat Okatan, Ph.D., okatan@bu.edu\n\n', msg);
    msg=sprintf('%sDeveloped as an analysis tool for the research project of:\n\n', msg);
    msg=sprintf('%sJoshua D. Berke, Murat Okatan, Jennifer Skurski, and Howard Eichenbaum.\n', msg);
    msg=sprintf('%sLaboratory of Cognitive Neurobiology, Boston University, 2003.\n\n', msg);
    msg=sprintf('%sVersion %d\n', msg, ud.EEG_VERSION);
    msgbox(msg, 'About eegrhythm');

%%%%%%%%%%%%%%%%%%%%%%%%
% set_current_interval %
%%%%%%%%%%%%%%%%%%%%%%%%
function ud=set_current_interval(ud, interval_number)

    signals=get(ud.Handles.Axes.Raw, 'UserData');

	ud.current_interval=interval_number;
    
	%Extract properties
	ud.current_interval_start=signals.t(signals.start_indx(ud.current_interval));
	ud.current_interval_end=  signals.t(  signals.end_indx(ud.current_interval));    
    
%%%%%%%%%%%%%%%%%%%%%%%
% reposition_interval %
%%%%%%%%%%%%%%%%%%%%%%%
function ud=reposition_interval(ud)
    
    fg=gcbf;

    %If zooming set zoom level such that the interval occupies the middle 1/3 of the graph.
    CurrentChar=get(fg, 'CurrentCharacter');
    if ~is_different(lower(CurrentChar), 'z'),
          ud.Aperture.Width=3*(ud.current_interval_end-ud.current_interval_start);
    end
    
	interval_center=(ud.current_interval_start+ud.current_interval_end)/2;
	graph_center=ud.Aperture.Start+ud.Aperture.Width/2;
	translation=interval_center-graph_center;
	
	%Set new aperture start, and scroll slider values.
	ud.Aperture.Start=ud.Aperture.Start+translation;
	
    %Adjust scroll slider parameters
	Range=ud.Aperture.Start+[0 ud.Aperture.Width];
    Range(1)=min(Range(1), ud.DisplayBuffers.first_tstamp);
    Range(2)=max(Range(2), ud.DisplayBuffers.last_tstamp);
    %Read existing struct
    sliderstruct=get_rtsliderstruct(ud.Handles.Controls.ScrollSlider);
    sliderstruct.Range=Range;
    sliderstruct.XData=ud.Aperture.Start;
    %Write updated
    set_rtsliderstruct(ud.Handles.Controls.ScrollSlider, sliderstruct);

    %Adjust zoom slider parameters if zooming
    if ~is_different(lower(CurrentChar), 'z'),
        %Read existing struct
        sliderstruct=get_rtsliderstruct(ud.Handles.Controls.ZoomSlider);
        sliderstruct.XData=ud.Aperture.Width;
        %Write updated
        set_rtsliderstruct(ud.Handles.Controls.ZoomSlider, sliderstruct);
        %Keep track of the last zoomer value
		ud.LastZoomerValue=ud.Aperture.Width;
    end

	%Force updating of graphs only if we exceed buffer limits
    if ud.Aperture.Start<=ud.DisplayBuffers.first_tstamp | ...
       ud.Aperture.Start+ud.Aperture.Width>=ud.DisplayBuffers.last_tstamp,
    	ud.DisplayBuffers.KeyPressEvent=1;
    end
	%update Graphs
	ud=updateGraphs(ud);
        
%%%%%%%%%%%%%%%%%%%%
% get_eeg_in_volts %
%%%%%%%%%%%%%%%%%%%%
function [t, eeg]=get_eeg_in_volts(fname, Fs, Gain)
    
	%Read data
	[t eeg]=eegread(fname, Fs);
	t=reshape(t, 1, prod(size(t)));
	eeg=reshape(eeg, 1, prod(size(eeg)));
	
	%Convert to volts
	voltage_range=5-(-5);
	eeg=eeg*voltage_range/65536/Gain;       
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getdata_batchfind_interval %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [threshold, intervalCutoff]=getdata_batchfind_interval

    threshold=[];
    intervalCutoff=[];

    %Get threshold and intervalCutoff from user
	prompt  = {'Threshold', 'Minimum Interval Duration'};
	title   = sprintf('Data needed');
	lines= 1;
	def     = {'0.3', '3.5'};
	answer  = char(inputdlg(prompt,title,lines,def));
    drawnow;
	
	if isempty(answer)
        return;
	end
	if isempty(answer(1, :)),
        return;
    else
        threshold=str2num(answer(1, :));
        if isempty(threshold),
            return;
        end
	end
	if isempty(answer(2, :)),
        return;
    else
        intervalCutoff=str2num(answer(2, :));
        if isempty(intervalCutoff),
            return;
        end
	end

%%%%%%%%%%%%%%%%%%%%%%
% printIntervalStats %
%%%%%%%%%%%%%%%%%%%%%%
function printIntervalStats(interval_stats_struct)
    
    fg=gcbf;
    ud=get(fg, 'UserData');
    
    msg=sprintf(' \n');
	%File and setting info
	msg=sprintf('%s%s\n\n', msg, avoidTeX(ud.FigureName, '\_'));
    if isempty(ud.threshold.in_volts),
		msg=sprintf('%sThreshold: not registered\n', msg);
    else
		msg=sprintf('%sThreshold: %0.3f microvolts (%.3f of Reference filtered EEG amplitude of %.3f microvolts)\n', ...
          msg, ud.threshold.in_volts*1e6, ud.threshold.users, ud.threshold.reference*1e6);
    end
    
    if isempty(ud.threshold.intervalCutoff),
		msg=sprintf('%sMin. Interval Duration: not registered\n', msg);
    else
		msg=sprintf('%sMin. Interval Duration: %0.3f cycles at %0.3f Hz', msg, ...
          ud.threshold.intervalCutoff, ...
          ud.filter.F(2));
		msg=sprintf('%s (%0.3f s)\n', msg, ud.threshold.intervalCutoff/ud.filter.F(2));
    end
    
    if isempty(ud.threshold.peak_grouping_window),
		msg=sprintf('%sPeak grouping window: not registered\n', msg);
    else
		msg=sprintf('%sPeak grouping window: %0.3f cycles at %0.3f Hz', msg, ...
          ud.threshold.peak_grouping_window, ...
          ud.filter.F(2));
		msg=sprintf('%s (%0.3f s)\n', msg, ...
                                      ud.threshold.peak_grouping_window/ud.filter.F(2));
    end

    if isempty(ud.threshold.interval_fusion_window),
		msg=sprintf('%sInterval fusion window: not registered\n', msg);
    else
		msg=sprintf('%sInterval fusion window: %0.3f cycles at %0.3f Hz', msg, ...
          ud.threshold.interval_fusion_window, ...
          ud.filter.F(2));
		msg=sprintf('%s (%0.3f s)\n', msg, ...
                                      ud.threshold.interval_fusion_window/ud.filter.F(2));
    end

    if isempty(ud.threshold.interval_power_screen_ratio),
		msg=sprintf('%sInterval Power Comparison Ratio: not registered\n', msg);
		msg=sprintf('%sInterval Power Comparison Ranges: not registered\n\n', msg);
    else
		msg=sprintf('%sInterval Power Comparison Ratio: %0.3f\n', msg, ...
          ud.threshold.interval_power_screen_ratio);
        ranges=ud.threshold.interval_power_screen_ranges;
        if isempty(ranges),
			msg=sprintf('%sInterval Power Comparison Ranges (Hz): empty ', msg);
        else
			msg=sprintf('%sInterval Power Comparison Ranges (Hz): Passband versus ', msg);
            for i=1:length(ranges)/2,
                msg=sprintf('%s%f-%f, ', msg, ranges(2*i-1), ranges(2*i));
            end
            msg=msg(1:end-2);
        end
        msg=sprintf('%s\n\n', msg);
    end

    L=length(interval_stats_struct);

	for i=1:L,
        
      root=interval_stats_struct(i);
  
      %Interval label
      msg=sprintf('%sInterval Set %d\n', msg, root.label);

      if isunix,
          %Number of intervals
          msg=sprintf('%s\tNumber of intervals:\t\t\t\t%d\n', msg, root.num_of_intervals);
          
          %Total duration
          msg=sprintf('%s\tTotal duration:\t\t\t\t%.3f s\n', msg, root.total_duration);
	
          %Mean duration
          msg=sprintf('%s\tMean duration:\t\t\t\t%.3f s\n', msg, root.mean_duration);
	
          %Standard deviation of duration
          msg=sprintf('%s\tStandard dev. of duration:\t\t\t%.3f s\n', msg, root.std_of_duration);
          
          %Average power
          msg=sprintf('%s\tAverage raw power (mV)^{2}:\t\t\t%.6f\n', msg, root.avg_raw_power*1e6);
          msg=sprintf('%s\tAverage filtered power (mV)^{2}:\t\t%.6f\n', msg, root.avg_fil_power*1e6);
	
          %Filtered to raw power ratio
          msg=sprintf('%s\tFiltered to raw power ratio:\t\t\t%.3f\n', msg, root.fil_to_raw_ratio);
	
          %Average power per interval
          msg=sprintf('%s\tAverage power per interval (mV)^{2}:\n', msg);
          msg=sprintf('%s\t\tRaw\t\tmean: %.6f standard dev.: %.6f\n', ...
                msg, mean(root.avg_raw_power_perinterval)*1e6, std(root.avg_raw_power_perinterval)*1e6);
          msg=sprintf('%s\t\tFiltered\t\tmean: %.6f standard dev.: %.6f\n', ...
                msg, mean(root.avg_fil_power_perinterval)*1e6, std(root.avg_fil_power_perinterval)*1e6);
          
          %Start times
          msg=sprintf('%s\tInterval start/end times and durations (s):\n\n', msg);
          msg=sprintf('%s\tInterval\t\tStart\t\tEnd\t\tDuration\n', msg);
          for j=1:length(root.starts),
              msg=sprintf('%s\t%d\t\t%.3f\t\t%.3f\t\t%.3f\n', msg, root.interval_numbers(j), ...
                                                              root.starts(j), root.ends(j), ...
                                                              root.ends(j)-root.starts(j));
          end
      else %if isunix else
          %Number of intervals
          msg=sprintf('%s   Number of intervals:         %d\n', msg, root.num_of_intervals);
          
          %Total duration
          msg=sprintf('%s   Total duration:            %.3f s\n', msg, root.total_duration);
	
          %Mean duration
          msg=sprintf('%s   Mean duration:            %.3f s\n', msg, root.mean_duration);
	
          %Standard deviation of duration
          msg=sprintf('%s   Standard dev. of duration:         %.3f s\n', msg, root.std_of_duration);
          
          %Average power
          msg=sprintf('%s   Average raw power (mV)^{2}:      %.6f\n', msg, root.avg_raw_power*1e6);
          msg=sprintf('%s   Average filtered power (mV)^{2}:      %.6f\n', msg, root.avg_fil_power*1e6);
	
          %Filtered to raw power ratio
          msg=sprintf('%s   Filtered to raw power ratio:      %.3f\n', msg, root.fil_to_raw_ratio);
	
          %Average power per interval
          msg=sprintf('%s   Average power per interval (mV)^{2}:\n', msg);
          msg=sprintf('%s      Raw      mean: %.6f standard dev.: %.6f\n', ...
                msg, mean(root.avg_raw_power_perinterval)*1e6, std(root.avg_raw_power_perinterval)*1e6);
          msg=sprintf('%s      Filtered      mean: %.6f standard dev.: %.6f\n', ...
                msg, mean(root.avg_fil_power_perinterval)*1e6, std(root.avg_fil_power_perinterval)*1e6);
          
          %Start times
          msg=sprintf('%s   Interval start/end times and durations (s):\n\n', msg);
          msg=sprintf('%s   Interval      Start      End      Duration\n', msg);
          for j=1:length(root.starts),
              msg=sprintf('%s   %d      %.3f      %.3f      %.3f\n', msg, root.interval_numbers(j), ...
                                                              root.starts(j), root.ends(j), ...
                                                              root.ends(j)-root.starts(j));
          end
      end %if isunix else
          
      msg=sprintf('%s\n\n', msg);
	end %i=1:L
    
    %Show in scrollable text figure   
    scrollableTextFigure('Interval Statistics', msg);
    
    
%%%%%%%%%%%%%%%%
% is_different %
%%%%%%%%%%%%%%%%
function flag=is_different(a,b)

    %Check for differences in length
    if length(a)~=length(b),
        flag=1;
        return;
    end

    a_empty=isempty(a);
    b_empty=isempty(b);
    
    if a_empty | b_empty,
        flag=a_empty~=b_empty;
    else
        flag=any(a~=b);
    end
    
%%%%%%%%%%%%%%%%%
% VideoImageBDF %
%%%%%%%%%%%%%%%%%
function VideoImageBDF(eventSrc,eventData,fg)
  ud=get(fg, 'UserData');
  
  %If there is a selected interval, show its movie
  if ~isempty(ud.current_interval),

      playMovie(fg);

  end
  
  
%%%%%%%%%%%%%%%%%%
% RawFilteredBDF %
%%%%%%%%%%%%%%%%%%
function RawFilteredBDF(eventSrc,eventData,fg)

	%Return if inserting intervals
	ud=get(fg, 'UserData');
	if ud.inserting_interval,
		ud.inserting_interval=0;
		set(fg, 'UserData', ud);
		return;
	end
	
	%Select the interval that contains the currentPt
	selectInterval(fg);

%%%%%%%%%%%%%%%%%%%
% ScrollSliderBDF %
%%%%%%%%%%%%%%%%%%%
function ScrollSliderBDF(eventSrc,eventData,fg)
  ud = get(fg,'UserData');
  if ud.DisplayBuffers.empty,
      return;
  end
  
  ud.ScrollBUP=0;

  set(fg, 'UserData', ud);

%%%%%%%%%%%%%%%%%%%
% ScrollSliderBUF %
%%%%%%%%%%%%%%%%%%%
function ScrollSliderBUF(eventSrc,eventData,fg)
  ud = get(fg,'UserData');
  if ud.DisplayBuffers.empty,
      return;
  end
  
  ud.ScrollBUP=1;

 %updateGraphs
  ud=updateGraphs(ud);

%%%%%%%%%%%%%%%%%%%
% ZoomSliderBDF %
%%%%%%%%%%%%%%%%%%%
function ZoomSliderBDF(eventSrc,eventData,fg)
  ud = get(fg,'UserData');
  if ud.DisplayBuffers.empty,
      return;
  end
  
  ud.ZoomBUP=0;

  set(fg, 'UserData', ud);

%%%%%%%%%%%%%%%%%%%
% ZoomSliderBUF %
%%%%%%%%%%%%%%%%%%%
function ZoomSliderBUF(eventSrc,eventData,fg)
  ud = get(fg,'UserData');
  if ud.DisplayBuffers.empty,
      return;
  end
  
  ud.ZoomBUP=1;

 %updateGraphs
  ud=updateGraphs(ud);

%%%%%%%%%%%%%%%%%
% localSetParam %
%%%%%%%%%%%%%%%%%
function localSetParam(eventSrc,eventData,fg,param)
 %---Change parameter value (eventData = new value)
  ud = get(fg,'UserData');
  if ud.DisplayBuffers.empty,
      return;
  end
  switch param
  case 'S', 
      ud.Aperture.Start = eventData;
      if eventData~=ud.LastScrollerValue,
          %Update the flags only if the user did not maxed or minned out the slider range
          ud.Scrollright=ud.LastScrollerValue<eventData;
          ud.LastScrollerValue=eventData;
      end
  case 'Z', 
      ud.Aperture.Width = eventData;
      if eventData~=ud.LastZoomerValue,
          %Update the flags only if the user did not maxed or minned out the slider range
          ud.Zoomout=ud.LastZoomerValue<eventData;
          ud.LastZoomerValue=eventData;
      end
  end
  
  %Did we come here because of an entry to the slider edit box?
  if ~is_different(get(gcbo, 'Type'), 'uicontrol') & ~is_different(get(gcbo, 'Style'), 'edit'),
      %If so, turn on the key to activate updateDisplayBuffers
      ud.DisplayBuffers.slider_EditBox=1;
    
      %Also, adjust scroll slider parameters
 	  Range=ud.Aperture.Start+[0 ud.Aperture.Width];
	  Range(1)=min(Range(1), ud.DisplayBuffers.first_tstamp);
	  Range(2)=max(Range(2), ud.DisplayBuffers.last_tstamp);
      %Read existing struct
      sliderstruct=get_rtsliderstruct(ud.Handles.Controls.ScrollSlider);
      sliderstruct.Range=Range;
      sliderstruct.XData=ud.Aperture.Start;
      %Write updated
      set_rtsliderstruct(ud.Handles.Controls.ScrollSlider, sliderstruct);
      
      %And zoom slider parameters
      if param=='Z',
      	  %Read existing struct
		  sliderstruct=get_rtsliderstruct(ud.Handles.Controls.ZoomSlider);
		  sliderstruct.XData=ud.Aperture.Width;
		  %Write updated
		  set_rtsliderstruct(ud.Handles.Controls.ZoomSlider, sliderstruct);
          %Keep track of the last zoomer value
		  ud.LastZoomerValue=ud.Aperture.Width;
      end      
  end
  
 %updateGraphs
  ud=updateGraphs(ud);

  
%%%%%%%%%%%%%%%%%%%%%%%%
%    selectInterval    %
%%%%%%%%%%%%%%%%%%%%%%%%
function ud=selectInterval(fg)

  ud = get(fg,'UserData');
  signals = get(ud.Handles.Axes.Raw, 'UserData');

  %Get current point
  currentPt=get(ud.Handles.Axes.Raw, 'CurrentPoint');

  %Get intervals
  starts=signals.t(signals.start_indx)';
  ends=signals.t(signals.end_indx)';
  
  interval_index=max(find(starts<=currentPt(1)));
  if ~isempty(interval_index) & ends(interval_index)>=currentPt(1),
      ud=set_current_interval(ud, interval_index);
  else
      ud=set_current_interval(ud, []);
  end

  ud=paintSelectedInterval(ud);
  set(fg,'UserData', ud);

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    paintSelectedInterval    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ud=paintSelectedInterval(ud)

    fg=gcbf;

  %Unmark old selection, if any.
  if ~isempty(ud.selected_interval_box)
     delete(ud.selected_interval_box(:));
     ud.selected_interval_box=[];
     
     %delete the interval number
     delete(ud.selected_interval_number_text);
     ud.selected_interval_number_text=[];
  end

  if ~isempty(ud.current_interval),
    
    left=ud.current_interval_start;
    right=ud.current_interval_end;
    
    %In Raw
    ud.selected_interval_box(1)=line('Parent', ud.Handles.Axes.Raw, ...
          'XData', left*[1 1],  'YData', ud.YLimRaw, 'Color', 'y');
    ud.selected_interval_box(2)=line('Parent', ud.Handles.Axes.Raw, ...
          'XData', right*[1 1],  'YData', ud.YLimRaw, 'Color', 'y');
    ud.selected_interval_box(3)=line('Parent', ud.Handles.Axes.Raw, ...
          'XData', [left right],  'YData', ud.YLimRaw(2)*[1 1], 'Color', 'y');
    ud.selected_interval_box(4)=line('Parent', ud.Handles.Axes.Raw, ...
          'XData', [left right],  'YData', ud.YLimRaw(1)*[1 1], 'Color', 'y');
    
    %Show interval number only if it is in the visible range
    if (left+right)/2>ud.Aperture.Start & ...
       (left+right)/2<ud.Aperture.Start+ud.Aperture.Width,
        ud.selected_interval_number_text=text('Parent', ud.Handles.Axes.Raw, ..., 
                              'Position', [(left+right)/2 13/12*ud.YLimRaw(1)-1/12*ud.YLimRaw(2)], ...
                              'String', num2str(ud.current_interval), ...
                              'Color', 'y', ...
                              'HorizontalAlignment', 'center');
    end
                      
    %In Filtered
    ud.selected_interval_box(5)=line('Parent', ud.Handles.Axes.Filtered, ...
          'XData', left*[1 1],  'YData', ud.YLimFiltered, 'Color', 'y');
    ud.selected_interval_box(6)=line('Parent', ud.Handles.Axes.Filtered, ...
          'XData', right*[1 1],  'YData', ud.YLimFiltered, 'Color', 'y');
    ud.selected_interval_box(7)=line('Parent', ud.Handles.Axes.Filtered, ...
          'XData', [left right],  'YData', ud.YLimFiltered(2)*[1 1], 'Color', 'y');
    ud.selected_interval_box(8)=line('Parent', ud.Handles.Axes.Filtered, ...
          'XData', [left right],  'YData', ud.YLimFiltered(1)*[1 1], 'Color', 'y');
  end

  %Save data
  set(fg,'UserData', ud);
  
%%%%%%%%%%%%%%%%%%%%%%
%    updateGraphs    %
%%%%%%%%%%%%%%%%%%%%%%
function ud=updateGraphs(ud)
    
      fg=gcbf;

      root=ud.DisplayBuffers;

      %Who is calling
	  cbtag=get(gcbo, 'Tag');
      
      %Determine whether we need to update the DisplayBuffers
      root.underflow=0;
      root.overflow=0;
      root.zoomin=0;
      if ~root.empty,
          root.zoomin=root.zoomlevel>ud.Aperture.Width;
          root.underflow=ud.Aperture.Start<root.first_tstamp & ud.Aperture.Start > ud.data_features.first_tstamp;
          root.overflow=ud.Aperture.Width+ud.Aperture.Start>...
              root.last_tstamp & ud.Aperture.Width+ud.Aperture.Start<ud.data_features.last_tstamp;
          
          %Some scroller button UP?
          root.slider_BUP=ud.ScrollBUP | ud.ZoomBUP;
          %No need to create a new buffer if we are scrolling right and the last tstamp 
          %is already visible.
          if ud.Scrollright & ud.Aperture.Width+ud.Aperture.Start>=ud.data_features.last_tstamp,
              root.slider_BUP=0; 
          end
          %No need to create a new buffer if we are scrolling left and the first tstamp 
          %is already in the buffer.
          if ~ud.Scrollright & root.first_tstamp==ud.data_features.first_tstamp,
              root.slider_BUP=0; 
          end
          %Reset BUP flags
          ud.ScrollBUP=0;
          ud.ZoomBUP=0;
      end
      if root.empty | root.underflow | root.overflow | root.zoomin | root.slider_BUP |...
         root.threshold_change | root.KeyPressEvent | root.slider_EditBox | ...
         root.signal_change | ...
         strcmp(cbtag, 'menu_interval_insert') | ...
         strcmp(cbtag, 'menu_interval_delete') | ...
         strcmp(cbtag, 'menu_interval_load') | ...
         strcmp(cbtag, 'menu_interval_complement') | ...
         strcmp(cbtag, 'menu_interval_find'),
     
          ud.DisplayBuffers=root;
          ud=updateDisplayBuffers(ud);
          root=ud.DisplayBuffers;
          %At this point, we should have DisplayBuffers that contain data
          %that are visible in the current aperture.
      end

      %Update the X axis limits
      XLim=ud.Aperture.Start+[0 ud.Aperture.Width];
      set([ud.Handles.Axes.Raw ud.Handles.Axes.Filtered], 'XLim', XLim);

      %Store root to its place
      ud.DisplayBuffers=root;
      
      %paint selected interval
      ud=paintSelectedInterval(ud);      
      
      %Make sure the scroller is properly set up.
      %Adjust scroll slider parameters
 	  Range=ud.Aperture.Start+[0 ud.Aperture.Width];
      Range(1)=min(Range(1), ud.DisplayBuffers.first_tstamp);
      Range(2)=max(Range(2), ud.DisplayBuffers.last_tstamp);
      %Read existing struct
      sliderstruct=get_rtsliderstruct(ud.Handles.Controls.ScrollSlider);
      sliderstruct.Range=Range;
      sliderstruct.XData=ud.Aperture.Start;
      %Write updated
      set_rtsliderstruct(ud.Handles.Controls.ScrollSlider, sliderstruct);
            
      %Save user data
      set(fg, 'UserData', ud);
      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    updateDisplayBuffers    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ud=updateDisplayBuffers(ud)

    fg=gcbf;

    signals=get(ud.Handles.Axes.Raw, 'UserData');
	
	root=ud.DisplayBuffers;
    aperture=ud.Aperture;
	
	%We need to create buffers that are centered around a point that is 
	%determined by the type of violation that brought us here
	if root.overflow | ( root.slider_BUP & (ud.Scrollright | ud.Zoomout) ),
      center=ud.Aperture.Start+ud.Aperture.Width;
	else
      center=ud.Aperture.Start;
	end
    
    %Save the zoomlevel at which the buffer is being computed
    root.zoomlevel=aperture.Width;
      
    %What data interval do we need to show?
	I=find(signals.t>=aperture.Start & signals.t<=aperture.Start+aperture.Width);
    
	%We do not need to show all the data points due to the resolution limit of the
	%screen. Show at most as many pixels as there are in the axis. For this, 
	%downsample the data.
	downsampleRate=max(1, round(length(I)/ud.WidthInPixels));
    
	buffer_t=downsample(signals.t, downsampleRate);
	buffer_infraeeg=downsample(signals.infraeeg, downsampleRate);
	buffer_supraeeg=downsample(signals.supraeeg, downsampleRate);
	buffer_y=downsample(signals.y, downsampleRate);
    
    %Find the index of the center
    diff=abs(buffer_t-center);
    ind=min(find(diff==min(diff))); %the outermost min to resolve race condition
    
    %Store our fixed number of samples in buffers
    if root.length<ud.WidthInPixels*3,
        root.length=ud.WidthInPixels*3;
    end
    range=round(max(1, ind-root.length/2):min(length(buffer_t), ind+root.length/2));
    
    buffer_t=buffer_t(range);
    buffer_infraeeg=buffer_infraeeg(range);
    buffer_supraeeg=buffer_supraeeg(range);
    buffer_y=buffer_y(range);
    
    %At this point we have the buffer signals ready. Extract important parameters
    root.first_tstamp=buffer_t(1);
    root.last_tstamp=buffer_t(end);
    
    if root.empty,
    %Create lines
		ud.Handles.Lines.Infra=line('Parent', ud.Handles.Axes.Raw, ...
          'XData', buffer_t,  'YData', buffer_infraeeg, 'Color', 'g');
		ud.Handles.Lines.Supra=line('Parent', ud.Handles.Axes.Raw, ...
          'XData', buffer_t,  'YData', buffer_supraeeg, 'Color', 'r');
		ud.Handles.Lines.Filtered=line('Parent', ud.Handles.Axes.Filtered, ...
          'XData', buffer_t,  'YData', buffer_y, 'Color', 'y');
    else
	%Update line data
        set(ud.Handles.Lines.Infra, 'XData', buffer_t, 'YData', buffer_infraeeg);
        set(ud.Handles.Lines.Supra, 'XData', buffer_t, 'YData', buffer_supraeeg);
        set(ud.Handles.Lines.Filtered, 'XData', buffer_t, 'YData', buffer_y);
    end
    
    %Plot markers for intervals in the Aperture.
	%The tstamps of the starts and ends of visible intervals
    %If there are existing intervals delete them.
    if root.interval_marker_handles_exist,
		delete([ud.Handles.Lines.RawStarts ...
                ud.Handles.Lines.RawEnds ...
                ud.Handles.Lines.FilteredStarts ...
                ud.Handles.Lines.FilteredEnds]);
        %They do not exist now.
        root.interval_marker_handles_exist=0;
    end    
    if ~isempty(signals.start_indx)
		starts=signals.t(signals.start_indx)';
		ends=signals.t(signals.end_indx)';
		
		%At the current zoom level, the interpixel duration is
		ipxdur=ud.Aperture.Width/(ud.WidthInPixels-1);
		%Do not try to show more than one interval between two pixels
        %Quantize the times and select the distinct subset
        qstart=floor(starts/ipxdur)+1;
        distincts=filter([1 -1], 1, qstart);
        selector=find(distincts~=0);
		
        starts=starts(selector);
        ends=ends(selector);
                
        %Plot only those within the span of the buffer	
		Imin=max(find(starts<=root.first_tstamp));
		if isempty(Imin),
        	Imin=min(find(starts<root.last_tstamp & starts>=root.first_tstamp));
		end
		Imax=max(find(starts<root.last_tstamp));
		if ~isempty(Imin) & ~isempty(Imax),
			I=Imin:Imax;
			
			intervals=[starts(I) ends(I)];
			
			%Plot vertical bars at the interval starts and ends
			XS=intervals(:,1)';
			XE=intervals(:,2)';
			YLimRaw=ud.YLimRaw;
			YlimFiltered=ud.YLimFiltered;
			YLimRaw=YLimRaw';YLimRaw=YLimRaw(:,ones(1, length(XS)));
			YLimFiltered=ud.YLimFiltered';YLimFiltered=YLimFiltered(:,ones(1, length(XS)));
            
            %What is the visibility of interval delimiters?
            menu_item=findobj(0, 'Label', 'Hide Interval Delimiters');
            %If the menu_item is not empty, then the interval delimiters need to be
            %shown so that they can be hidden by choosing that menu option.
            if isempty(menu_item),
                visibility='off';
            else
                visibility='on';
            end
            
			ud.Handles.Lines.RawStarts=...
                line([XS; XS], YLimRaw, 'Color', 'c', ...
                                        'LineWidth', 2, ...
                                        'Parent', ud.Handles.Axes.Raw, ...
                                        'Visible', visibility);
			ud.Handles.Lines.RawEnds=...
                line([XE; XE], YLimRaw, 'Color', 'm', ...
                                        'LineWidth', 2, ...
                                        'Parent', ud.Handles.Axes.Raw, ...
                                        'Visible', visibility);
			ud.Handles.Lines.FilteredStarts=...
                line([XS; XS], YLimFiltered, 'Color', 'c', ...
                                             'LineWidth', 2, ...
                                             'Parent', ud.Handles.Axes.Filtered, ...
                                             'Visible', visibility);
			ud.Handles.Lines.FilteredEnds=...
                line([XE; XE], YLimFiltered, 'Color', 'm', ...
                                             'LineWidth', 2, ...
                                             'Parent', ud.Handles.Axes.Filtered, ...
                                             'Visible', visibility);

            %interval_marker_handles_exist now.
            root.interval_marker_handles_exist=1;

		end %if ~isempty(Imin) & ~isempty(Imax)
    else
        %There is no interval to plot at this threshold.        
		ud.Handles.Lines.RawStarts=[];
		ud.Handles.Lines.RawEnds=[];
		ud.Handles.Lines.FilteredStarts=[];
		ud.Handles.Lines.FilteredEnds=[];
    end%if ~isempty(signals.start_indx)
    
    %Update the Raw and Filtered axes properties
    ax=ud.Handles.Axes.Raw;
    set([ax, get(ax, 'Children')'], 'ButtonDownFcn', {@RawFilteredBDF, fg});
    ax=ud.Handles.Axes.Filtered;
    set([ax, get(ax, 'Children')'], 'ButtonDownFcn', {@RawFilteredBDF, fg});
    
    %Update the scroll slider's parameters, which will be used to navigate through the
    %new buffer
    %If the window is wider than the entire signal, then allow scrolling beyond the last
    %tstamp. Otherwise don't.
    if aperture.Start+aperture.Width>=ud.data_features.last_tstamp,
        Range=[min(aperture.Start, root.first_tstamp) max(root.last_tstamp, aperture.Start+aperture.Width)];
    else
        Range=[min(aperture.Start, root.first_tstamp) max(root.last_tstamp-aperture.Width, aperture.Start+aperture.Width)];
        if Range(2)<Range(1),
            %The Width is too wide, allow the scroller to jump automatically when it reaches the right
            %bound.
            Range=[min(aperture.Start, root.first_tstamp) max(root.last_tstamp, aperture.Start+aperture.Width)];
        end
        %Here aperture.Start may be smaller than root.first_tstamp if we zoomed into an interval.
    end

    %Adjust scroll slider parameters
    %Read existing struct
    sliderstruct=get_rtsliderstruct(ud.Handles.Controls.ScrollSlider);
    sliderstruct.Range=Range;
    sliderstruct.XData=aperture.Start;
    %Write updated
    set_rtsliderstruct(ud.Handles.Controls.ScrollSlider, sliderstruct);

    
    %The buffer is filled in and ready
    root.empty=0;
    %The threshold change has been effected
    root.threshold_change=0;
    %KeyPressEvent handled
    root.KeyPressEvent=0;
    %slider_EditBox handled
    root.slider_EditBox=0;
    %signal_change handled
    root.signal_change=0;

    %Save data
	ud.DisplayBuffers=root;
    ud.Aperture=aperture;
    
   	set(fg, 'UserData', ud);

% --end updateDisplayBuffers

%%%%%%%%%%%%%%%%%%%%%%%
%    loadVideoData    %
%%%%%%%%%%%%%%%%%%%%%%%
function videoData=loadVideoData(fg)

    ud = get(fg, 'UserData');
    videoData = get(ud.Handles.Axes.Video, 'UserData');

	videoData.imagedimensions=[240 320];
	
    [fname,pname] = uigetfile(...
        {'*.mst;*.mst.unc',    '(*.mst, *.mst.unc)';
         '*.mst',              'Original data file (*.mst)';
         '*.mst.unc',          'Uncompressed data file (*.mst.unc)'}, 'Select the video file');
    if fname==0,
        %Save video data
        set(ud.Handles.Axes.Video, 'UserData', videoData);
        %Save figure data
        set(fg, 'UserData', ud);
        return;
    end
    
    if ~isempty(pname),
        cd(pname);
    end
    
	%Refresh GUI
	drawnow;

    videoData.fname=sprintf('%s%s', pname, fname);

    %If it is not uncompressed, ask the user a pathname where to save the uncompressed file
    dots=charfind(fname, '.');
    if ~isempty(dots),
        if ~strcmp(fname(dots(end):end), '.unc')
            [ufname, upname]=uiputfile('*.mst.unc', 'Save the uncompressed file as');
            
			%Refresh GUI
			drawnow;
            
            if upname==0,
                return;
            else
                %Show watch pointer
                old_ptr=get(fg, 'Pointer');
                set(fg, 'Pointer', 'watch');
                
                %Construct fnames
                uncfname=sprintf('%s%s', upname, ufname);
                zipfname=sprintf('%s.gz', uncfname);
                origfname=sprintf('%s%s', pname, fname);

                %Delete the destination file, if any.
                if isunix,
                    command=sprintf('rm -f %s', uncfname);
                elseif ispc,
                    command=sprintf('del %s', uncfname);
                else
                    showMessage(ud.Handles.Texts.Message, 'System not Unix or PC. Exiting.', 1);
                    close(fg);
                end
				c_status=dos(command);
                if c_status,
                    showMessage(ud.Handles.Texts.Message, ...
                        'Error deleting existing uncompressed file', 0);
                    return;
                end

                %Copy the original file to the destination, as a gz file
                showMessage(ud.Handles.Texts.Message, 'Copying file', 0);
                if isunix,
                    command=sprintf('cp %s %s', origfname, zipfname);
                elseif ispc,
                    command=sprintf('copy %s %s', origfname, zipfname);
                else
                    showMessage(ud.Handles.Texts.Message, 'System not Unix or PC. Exiting.', 1);
                    close(fg);
                end
				c_status=dos(command);
                if c_status,
                    showMessage(ud.Handles.Texts.Message, 'Error copying file', 0);
                    return;
                end
                %Unzip it
                showMessage(ud.Handles.Texts.Message, 'Uncompressing file', 0);
                if isunix,
                    command=sprintf('gunzip %s', zipfname);
                else
                    showMessage(ud.Handles.Texts.Message, 'System not Unix. Exiting.', 1);
                    close(fg);
                end
				c_status=dos(command);
                if c_status,
                    showMessage(ud.Handles.Texts.Message, 'Error uncompressing file', 0);
                    return;
                end

                videoData.fname=uncfname;
                %Restore pointer
                set(fg, 'Pointer', old_ptr);
            end
        end
    end

    %Show video fname under the video frame
    info=sprintf('VIDEO\n%s', avoidTeX(videoData.fname, '\_'));
	ax=ud.Handles.Axes.Video;
	set(get(ax, 'XLabel'), 'String', info);
    
    showMessage(ud.Handles.Texts.Message, 'LoadingNavigationTables', 0);    
	videoData.infile=fopen(videoData.fname, 'rb');
	
	while(~feof(videoData.infile))
        line=fgetl(videoData.infile);
        if (strncmp(line, 'buffersamp', 10))
            line=line(11:length(line));
            buffersamp=sscanf(line, '%d');
        end
        if (strncmp(line, '%%ENDCONFIG', 11))
            break;
        end
	end
	
	data_offset=ftell(videoData.infile);

    %If the tables were not saved before, load them now
    navigation_tables_fname=sprintf('%s%s-navTable.mat', pname, fname(1:dots(1)-1));
    navigation_tables_file=fopen(navigation_tables_fname, 'rb');
    
    if navigation_tables_file==-1,
		command=sprintf('extract_tables %s %d %d %d %d %d', ...
            videoData.fname, buffersamp, data_offset, 10, ...
            videoData.imagedimensions(1), videoData.imagedimensions(2));
		c_status=dos(command);
        if c_status,
            showMessage(ud.Handles.Texts.Message, 'Error executing system command', 1);
            return;
        end
		
		%Now load the mat file that contains the extracted tables
		load MegaEdit_Tables.mat
        
        %Save MegaEdit_Tables.mat as a file that contains the name of the master file
        if isunix,
            command=sprintf('cp %s %s', 'MegaEdit_Tables.mat', navigation_tables_fname);
        elseif ispc,
            command=sprintf('copy %s %s', 'MegaEdit_Tables.mat', navigation_tables_fname);
        else
            showMessage(ud.Handles.Texts.Message, 'System not Unix nor PC. Exiting.', 1);
            close(fg);
        end
		c_status=dos(command);
        if c_status,
            showMessage(ud.Handles.Texts.Message, 'Error saving navigation tables', 0);
            return;
        end
        
        %cleanup
		delete('MegaEdit_Tables.mat');
    else %navigation_tables_file==-1,
        
        %Close the file
        fclose(navigation_tables_file);
                
		%Now load the mat file that contains the extracted tables
		load(navigation_tables_fname);        
    end
	
	%Transpose relevant tables
	videoData.positionNavigationTable=positionNavigationTable';
    videoData.positionFullImageOffsets=positionFullImageOffsets;
	showMessage(ud.Handles.Texts.Message, 'DONE: LoadingNavigationTables', 1);
	
	%Delete unneeded tables
    clear global behaviorFlagTable positionTooManyBrightPixelsIndex
    
    %Save video data
    set(ud.Handles.Axes.Video, 'UserData', videoData);
    %Save figure data
    set(fg, 'UserData', ud);
    
%%%%%%%%%%%%%%%%%%%
%    playMovie    %
%%%%%%%%%%%%%%%%%%%
function playMovie(fg)
    
    ud = get(fg, 'UserData');
    
    videoData=get(ud.Handles.Axes.Video, 'UserData');
    if isempty(videoData.fname),
        %No file was specified to read videodata
        %Load video data
        videoData=loadVideoData(fg);
        %If the user did not load data, return
        if isempty(videoData.fname),
            return;
        end
    end
    
    %If there is no current interval, return
    if isempty(ud.current_interval),
        return;
    end
    
    %We got the data. Erase the message
    if ~isempty(ud.Handles.Texts.VideoClickMessage)
        delete(ud.Handles.Texts.VideoClickMessage);
        ud.Handles.Texts.VideoClickMessage=[];
        set(fg, 'UserData', ud);
    end
    
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
    timerange=[signals.t(signals.start_indx(ud.current_interval)) ...
              signals.t(signals.end_indx(ud.current_interval))]*1e4;

    %Adjust timerange using the start-stop offsets
    start_offset=str2num(get(ud.Handles.Controls.VideoStartEditBox, 'String'));
    stop_offset =str2num(get(ud.Handles.Controls.VideoStopEditBox, 'String'));
    if isempty(start_offset) | isempty(stop_offset)
        showMessage(ud.Handles.Texts.Message, 'Unusable video start/stop offset', 1);
        return;
    end
    timerange=timerange+[start_offset stop_offset]*1e4;
    
    %If the end is earlier than the start, return;
    if timerange(2)<timerange(1),
        return;
    end
      
    %timerange(1) contains the start timestamp
    %Find the frame closest to start
    start_frame_index=min(find(videoData.positionNavigationTable(:,1)>=timerange(1)));
    if isempty(start_frame_index)
        showMessage(ud.Handles.Texts.Message, 'No video frames in this interval', 1);
        return;
%        end_frame_index=length(videoData.positionNavigationTable(:,1));
    end
    %timerange(2) contains the end timestamp
    %Find the frame closest to end
    end_frame_index=max(find(videoData.positionNavigationTable(:,1)<=timerange(2)));
    if isempty(end_frame_index)
        showMessage(ud.Handles.Texts.Message, 'No video frames in this interval', 1);
        return;
%        start_frame_index=1;
    end
    
    %find the full image closest to start
    closest_fullimage_index=start_frame_index;
    start_frame_offset=videoData.positionNavigationTable(start_frame_index, 2);
    if ~isempty(videoData.positionFullImageOffsets),
        closest_fullimage_index=...
            max(find(videoData.positionFullImageOffsets<=start_frame_offset));
        closest_fullimage_offset=videoData.positionFullImageOffsets(closest_fullimage_index);
        closest_fullimage_index=...
            find(videoData.positionNavigationTable(:, 2)==closest_fullimage_offset);
    end
    
    %Construct the start image
	I=zeros(videoData.imagedimensions);
    
	currentFrameIndex=closest_fullimage_index;
	while currentFrameIndex<=start_frame_index,
        drawnow;
        stop_flag=get(ud.Handles.Controls.VideoStopToggleButton, 'Value');
        if stop_flag,
            %Movie stopped, hide video on lines
            set(ud.Handles.Lines.video_on_lines, 'Visible', 'off');
            %Reset stop flag
            set(ud.Handles.Controls.VideoStopToggleButton, 'Value', 0);
            return;
        end
                
        currentFrameOffset=videoData.positionNavigationTable(currentFrameIndex,2);
	
        fseek(videoData.infile, currentFrameOffset,'bof');
		[bufferinfo, count]=fread(videoData.infile, 5, 'uint32');
		checkcount(count, 5, 'Error reading bufferinfo for position data');
		pixelnums=getpixelnums(videoData.infile, bufferinfo, videoData.imagedimensions);
		pixelcolors=fread(videoData.infile, bufferinfo(4), 'uchar');
		I=constructimage(I, pixelnums, pixelcolors);
        currentFrameIndex=currentFrameIndex+1;
	end
    %Back currentFrameIndex by 1
    currentFrameIndex=currentFrameIndex-1;
	%at this point we have the desired frame I reconstructed from a sequence of
	%recent past frames

    %Now, play the movie
    skip=abs(str2num(get(ud.Handles.Controls.VideoSkipEditBox, 'String')));
    if isempty(skip),
        skip=1;
    end
    skip=round(skip)+1;
    
    %Show the video on lines.
    set(ud.Handles.Lines.video_on_lines, 'Visible', 'on');
    drawnow;
    
    while currentFrameIndex<=end_frame_index,
        drawnow;
        stop_flag=get(ud.Handles.Controls.VideoStopToggleButton, 'Value');
        if stop_flag,
            %Movie stopped, hide video on lines
            set(ud.Handles.Lines.video_on_lines, 'Visible', 'off');
            %Reset stop flag
            set(ud.Handles.Controls.VideoStopToggleButton, 'Value', 0);
            return;
        end
        
        if (mod(end_frame_index-currentFrameIndex, skip)==0),
            %Show the frame indicator on Raw Axis
            marker=line('Parent', ud.Handles.Axes.Raw, ...
                        'XData', [1 1]*videoData.positionNavigationTable(currentFrameIndex,1)/1e4, ...
                        'YData', ud.YLimRaw, ...
                        'Color', 'b', ...
                        'LineStyle', '-.');
            pauser(1e-10);
            delete(marker);
            
            set(ud.Handles.Images.Video, 'CData', flipud(I)/255);
        end

        currentFrameIndex=currentFrameIndex+1;
                
        currentFrameOffset=videoData.positionNavigationTable(currentFrameIndex,2);
	
        fseek(videoData.infile, currentFrameOffset,'bof');
		[bufferinfo, count]=fread(videoData.infile, 5, 'uint32');
		checkcount(count, 5, 'Error reading bufferinfo for position data');
		pixelnums=getpixelnums(videoData.infile, bufferinfo, videoData.imagedimensions);
		pixelcolors=fread(videoData.infile, bufferinfo(4), 'uchar');
		I=constructimage(I, pixelnums, pixelcolors);
	end
    
    %Movie stopped, hide video on lines
    set(ud.Handles.Lines.video_on_lines, 'Visible', 'off');
    
%%%%%%%%%%%%%%%%%%%%%%%
%    filter_signal    %
%%%%%%%%%%%%%%%%%%%%%%%
function ud=filter_signal(ud)

    fg=gcbf;
    
    signals=get(ud.Handles.Axes.Raw, 'UserData');
    
	showMessage(ud.Handles.Texts.Message, 'Status: Filtering EEG', 0);
    old_ptr=get(fg, 'Pointer');
    set(fg, 'Pointer', 'watch');
    drawnow;
	signals.y=filtfilt(ud.filter.b, ud.filter.a, signals.eeg);
	showMessage(ud.Handles.Texts.Message, 'Status: Done Filtering EEG', 1);
    set(fg, 'Pointer', old_ptr);
            
    %Save signal data
    set(ud.Handles.Axes.Raw, 'UserData', signals);
        
%%%%%%%%%%%%%%%%%%%%%%%
%    findIntervals    %
%%%%%%%%%%%%%%%%%%%%%%%
function [ud, signals]=findIntervals(ud)

    fg=gcbf;
    
    signals=get(ud.Handles.Axes.Raw, 'UserData');

    %Show message
%    showMessage(ud.Handles.Texts.Message, 'Finding Intervals', 0, 0.1);

    %Reset current interval settings
    ud=erase_intervals(ud);
    
    signals=get_interval_starts_ends(ud);

    %For gamma, throw away intervals in which the power in 7-30 Hz is larger than that in 30-100 Hz. 
    signals=interval_power_screen(signals, ud);
    
    %Save data
    set(ud.Handles.Axes.Raw, 'UserData', signals);
    
	%At this point, the n'th interval is defined by [signals.start_indx(n) signals.end_indx(n)]
	%where the indeces are the entry numbers in flags, and thus in signals.y and my.

%showMeanStdPlot(signals);    
    
    %Show message
%    showMessage(ud.Handles.Texts.Message, 'DONE: Finding Intervals', 1, 0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%
%    erase_intervals    %
%%%%%%%%%%%%%%%%%%%%%%%%%
function ud=erase_intervals(ud, varargin)

    if nargin==1,
        to_be_erased='*';
    else
        to_be_erased=varargin{1};
    end

    fg=gcbf;

    intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
    
    %Unselect current selected interval
    ud=set_current_interval(ud, []);
    %Remove highlights
    ud=paintSelectedInterval(ud);
    
    %Delete current interval labels
    category_index=[];
    if ~isempty(intervalCategories.label_text_handles),
        if to_be_erased=='*',
            category_index=find(intervalCategories.categories~=0);
        else
            for i=1:length(to_be_erased),
                if to_be_erased==0,
                    continue;
                end
				category_index=...
                  [category_index ...
                   find(intervalCategories.categories==to_be_erased(i))];
            end
        end
    end
    if ~isempty(category_index),
        delete(intervalCategories.label_text_handles(1, category_index));    
        delete(intervalCategories.label_text_handles(2, category_index));
        intervalCategories.label_text_handles(1, category_index)=...
            intervalCategories.label_text_handles(1, category_index).*0;
        intervalCategories.label_text_handles(2, category_index)=...
            intervalCategories.label_text_handles(2, category_index).*0;
    end        

    %Save data
    set(ud.Handles.Axes.Filtered, 'UserData', intervalCategories);
    set(fg, 'UserData', ud);    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    mark_supra_infra_eeg    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ud=mark_supra_infra_eeg(ud)

    fg=gcbf;

    signals=get(ud.Handles.Axes.Raw, 'UserData');

    signals.infraeeg=signals.eeg;
	signals.supraeeg=signals.eeg;
	for i=1:length(signals.start_indx),
		I=signals.start_indx(i):signals.end_indx(i);
        signals.infraeeg(I)=signals.infraeeg(I).*NaN;
	end
	nans=isnan(signals.infraeeg);
	infra=find(nans==0);
	signals.supraeeg(infra)=signals.supraeeg(infra).*NaN;
	
	%At this point, signals.infraeeg and signals.supraeeg are vectors that contain the eeg 
    %segments where the filtered signal is below or above ud.threshold.in_volts, resp.
    %Or, if the intervals were obtained in another signal, the infra and supra show the
    %segments that fall out of or inside the intervals.
	    
    %Save data
    set(ud.Handles.Axes.Raw, 'UserData', signals);
    set(fg, 'UserData', ud);    

%%%%%%%%%%%%%%%%%%%%%%%
%    dataAdjustGUI    %
%%%%%%%%%%%%%%%%%%%%%%%
function ud=dataAdjustGUI(ud)
    
    fg=gcbf;

    signals=get(ud.Handles.Axes.Raw, 'UserData');

    %Show open datafilename and sampling rate
	ud.FigureName=sprintf('eegrhythm %s (%.3f Hz)', ud.DataFileName, ud.data_features.Fs);
    set(fg, 'Name', ud.FigureName);
    
    %We are looking at the data through what aperture?
	%If Aperture variables are empty, initially, cover the entire data.
    if isempty(ud.Aperture.Start) & isempty(ud.Aperture.Width),
		ud.Aperture.Start=ud.data_features.first_tstamp;
		ud.Aperture.Width=ud.data_features.last_tstamp-ud.data_features.first_tstamp;
    end
	oldUnit=get(ud.Handles.Axes.Raw, 'Unit');
	set(ud.Handles.Axes.Raw, 'Unit', 'Pixel');
	ud.WidthInPixels=get(ud.Handles.Axes.Raw, 'Position');
	ud.WidthInPixels=ud.WidthInPixels(3);
	set(ud.Handles.Axes.Raw, 'Unit', oldUnit);

    %Set infraeeg to the raw eeg, supraeeg to NaN by default
  	signals.infraeeg=signals.eeg;
  	signals.supraeeg=signals.eeg.*NaN;
    %No intervals by default
    ud=erase_intervals(ud);
    signals.start_indx=[];
    signals.end_indx=[];
    initIntervalCategories(ud, 0);
    
	%Set limits.
    ud.YLimFiltered=[min(signals.y) max(signals.y)]*1.01;
    if all(isnan(ud.YLimFiltered)),
        ud.YLimFiltered=[-1 1];
    end
	XLim=ud.Aperture.Start+[0 ud.Aperture.Width];
	
	%Finish axes
	ax=ud.Handles.Axes.Raw;
	set(ax, 'XLim', XLim, 'Ylim', ud.YLimRaw);
	
	ax=ud.Handles.Axes.Filtered;
  	set(ax, 'XLim', XLim, 'YLim', ud.YLimFiltered);
	
	%adjust rtsliders
	%Scroll
	Range=ud.Aperture.Start+[0 ud.Aperture.Width];

    %Read existing struct
    sliderstruct=get_rtsliderstruct(ud.Handles.Controls.ScrollSlider);
    sliderstruct.EditBoxLimits=Range;
    sliderstruct.EditBoxValue=ud.Aperture.Start;
    sliderstruct.Range=Range;
    sliderstruct.XData=ud.Aperture.Start;
    %Write updated
    set_rtsliderstruct(ud.Handles.Controls.ScrollSlider, sliderstruct);
    
	%Zoom
    if isempty(ud.filter.F),
    	Range=[1/ud.data_features.Fs ud.data_features.last_tstamp-ud.data_features.first_tstamp];
    else
    	Range=[1/max(ud.filter.F) ud.data_features.last_tstamp-ud.data_features.first_tstamp];
    end

    %Read existing struct
    sliderstruct=get_rtsliderstruct(ud.Handles.Controls.ZoomSlider);
    sliderstruct.EditBoxLimits=Range;
    sliderstruct.Range=Range;
    sliderstruct.XData=ud.Aperture.Width;
    %Write updated
    set_rtsliderstruct(ud.Handles.Controls.ZoomSlider, sliderstruct);
    %Keep track of last zoomer value    
	ud.LastZoomerValue=ud.Aperture.Width;
    
    %Initialize threshold lines, if empty
    if isempty(ud.threshold.lines),
        %What is the visibility preference of the user?
        menu_item=findobj(0, 'Label', 'Hide Threshold Lines');
        %If menu_item is not empty, then we need to show the lines so the user can
        %hide them by selecting this menu option
        if isempty(menu_item),
            visibility='off';
        else
            visibility='on';
        end
        
		ud.threshold.lines=...
            line([signals.t([1 end])',signals.t([1 end])'], ...
                 NaN*[1 -1;1 -1], ...
                 'Parent', ud.Handles.Axes.Filtered, 'Color', 'r', ...
                 'Visible', visibility);
    else
		set(ud.threshold.lines, 'YData', NaN*[1 1]);
    end

   	%Store the data with the figure
    set(ud.Handles.Axes.Raw, 'UserData', signals);
	set(fg, 'UserData', ud);
    
%%%%%%%%%%%%%%%%%%%%%
%    showMessage    %
%%%%%%%%%%%%%%%%%%%%%
function showMessage(text_handle, message, erase, varargin)

    %By default, pause for 1 sec.
    pause_duration=1;
	if nargin==4
        pause_duration=varargin{1};
	end

    color=[1 0 1]*0.7;

    %Show new message
    set(text_handle, ...
        'String', message);
    
    %Flash
    for i=1:5,
        set(text_handle, ...
            'Color', color*rem(i,2));
        if pause_duration>0,
            pauser(1e-2);
        end
    end
    
    if erase,
        %Keep for a while, and erase
        if pause_duration>0,
            pauser(pause_duration);
        end
        set(text_handle, ...
            'String', '');
    end
    
%%%%%%%%%%%%%%%%%%
%    charfind    %
%%%%%%%%%%%%%%%%%%
function charplaces=charfind(source, char)

    flags=(source==char);
    charplaces=find(flags==1);
    
%%%%%%%%%%%%%%%%
%    pauser    %
%%%%%%%%%%%%%%%%
function pauser(duration)
    
    drawnow;
    t0=clock;
    elapsed=0;
    
    while elapsed < duration,
        elapsed=etime(clock, t0);
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    labelCurrentInterval    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function labelCurrentInterval(ud, label)

    intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
    %Delete the old category label
    if intervalCategories.label_text_handles(1, ud.current_interval),
        delete(intervalCategories.label_text_handles(:, ud.current_interval));
        intervalCategories.label_text_handles(:, ud.current_interval)=zeros(2,1);
    end

    %Print new label unless it is 0
    if str2num(label)~=0,
        time=(ud.current_interval_start+ud.current_interval_end)/2;
        intervalCategories.label_text_handles(1, ud.current_interval)=...
            text('Parent', ud.Handles.Axes.Raw, ...
                 'Position', [time, ud.YLimRaw(2)*0.8], ...
                 'HorizontalAlignment', 'center', ...
                 'Color', 'k', 'String', label, 'FontSize', 20);
         
        intervalCategories.label_text_handles(2, ud.current_interval)=...
            text('Parent', ud.Handles.Axes.Filtered, ...
                 'Position', [time, ud.YLimFiltered(2)*0.8], ...
                 'HorizontalAlignment', 'center', ...
                 'Color', 'k', 'String', label, 'FontSize', 20);
    end

    %Save the category
    intervalCategories.categories(ud.current_interval)=str2num(label);
    
    %Save the struct
    set(ud.Handles.Axes.Filtered, 'UserData', intervalCategories);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    get_interval_starts_ends    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function signals=get_interval_starts_ends(ud)

    signals=get(ud.Handles.Axes.Raw, 'UserData');

    if isempty(ud.threshold.in_volts),
        %Threshold in volts is not available. Return no intervals
        signals.end_indx=[];
		signals.start_indx=[];
        return;
    end
        
    %Get positive and negative peaks in the filtered signal
    pos_peaks=get_peaks(signals.y, 1, 'pos');
    neg_peaks=get_peaks(signals.y, 1, 'neg');
    %Select only those that are above threshold
    test_y=signals.y.*pos_peaks;
    infraindx=find(test_y<ud.threshold.in_volts);
    pos_peaks(infraindx)=pos_peaks(infraindx)*0;
    
    test_y=signals.y.*neg_peaks;
    infraindx=find(abs(test_y)<ud.threshold.in_volts);
    neg_peaks(infraindx)=neg_peaks(infraindx)*0;

    %Find interval starts and ends for both peak types
    for type=1:2,
        %Rename
        if type==1,
            flags=pos_peaks;
        else
            flags=neg_peaks;
        end
	
        %Find threshold crossings
        %if the threshold is 0, just select the entire session
        if ud.threshold.in_volts==0,
			start_indx(type)={1};
			end_indx(type)={length(signals.y)};
        else%If threshold not zero
			
		%At this point, flags is 1 at places where signals.y has suprathreshold peaks
		%and zero elsewhere. Now, we need to process flags to remove intermediate lines
			ticks=find(flags==1);
			LT=length(ticks);
            
            if LT,
				diffs=ticks(2:LT)-ticks(1:LT-1);
				largest_prd=ud.threshold.peak_grouping_window/ud.filter.F(2);
				merge_width=ud.data_features.Fs*largest_prd;
				indx=find(diffs>=merge_width);
				
				end_indx(type)={ticks([indx LT])};
				start_indx(type)={ticks([1 indx+1])};
				
				%Reject intervals shorter than P periods of the lowest frequency in the passband
				intervalCutoffDuration=ud.threshold.intervalCutoff/ud.filter.F(2);
				durations=signals.t(end_indx{type})-signals.t(start_indx{type});
				valids=find(durations>=intervalCutoffDuration);
				end_indx(type)={end_indx{type}(valids)};
				start_indx(type)={start_indx{type}(valids)};
	
	if 0,
	%The implementation of this will be completed later by introducing an edit box.    
                %Bridge intervals that are separated by a duration shorter than one cycle of the 
                %lowest passband frequency
                separations=signals.start_indx(2:end)-signals.end_indx(1:end-1);
                shorts_index=find(separations<=ud.filter.Fs/ud.filter.F(2));
                signals.start_indx(shorts_index+1)=signals.start_indx(shorts_index+1)*0-1;
                signals.end_indx(shorts_index)=signals.end_indx(shorts_index)*0-1;
                valids=signals.start_indx~=-1;
                signals.start_indx=signals.start_indx(valids);
                valids=signals.end_indx~=-1;
                signals.end_indx=signals.end_indx(valids);
	end
	
            else
				end_indx(type)={[]};
				start_indx(type)={[]};
            end%if LT,
            
        end %If threshold not zero
    end %for type=1:2,
    
    %Now we have the starts and ends computed using the positive and negative peaks
    %Take the logical OR of them.
    int_pos=get_interval_bitfield(length(signals.y), start_indx{1}, end_indx{1});
    int_neg=get_interval_bitfield(length(signals.y), start_indx{2}, end_indx{2});
    
    %OR
    int_all=int_pos|int_neg;
    int_all=[0 int_all 0];
    
    %differentiate
    int_new=diff(int_all);
    
    signals.start_indx=find(int_new==1);
    signals.end_indx=find(int_new==-1)-1;
    
    %At this point signals.start_indx and signals.end_indx contain the start and end
    %indeces of the intervals. Now, fuse those that are too close to each other
    signals=fuse_intervals(ud, signals);

%%%%%%%%%%%%%%%%%%%%%%%%%
%    showMeanStdPlot    %
%%%%%%%%%%%%%%%%%%%%%%%%%
function showMeanStdPlot(signals)
    
    fg=gcbf;
    ud=get(fg, 'UserData');

    if isempty(signals.start_indx),
        return;
    end

    num_of_ints=length(signals.start_indx);
    durations=signals.end_indx-signals.start_indx;

    nfft_dummy1=ceil(log(max(durations))/log(2));
    nfft=2^nfft_dummy1;
    
    mean_f=zeros(1, num_of_ints);
    stde_f=zeros(1, num_of_ints);
    for i=1:num_of_ints,
        [Pxx,f] = periodogram(detrend(signals.eeg(signals.start_indx(i):signals.end_indx(i))), ...
                              [],nfft,ud.data_features.Fs);
        passband=find(f>=ud.filter.F(2) & f<=ud.filter.F(3));
        Pxxpb=Pxx(passband);
        fpb=f(passband);
        Pxxpb=Pxxpb/sum(Pxxpb);
        mean_f(i)=sum(Pxxpb.*fpb);
        stde_f(i)=sqrt(sum(Pxxpb.*((fpb-mean_f(i)).^2)));
    end
       
    %Now cluster
    clustnum=2;
%    T=clusterdata([mean_f', stde_f'], clustnum)
    T=clusterdata(stde_f', clustnum);

    %Now plot 
    figure;
    marker='rogobomocokor+g+b+m+c+k+r*g*b*m*c*k*r.g.b.m.c.k.';
    for i=1:50,
        range=find(T==i);
        if isempty(range),
            continue;
        end
        plot(mean_f(range), stde_f(range), marker(2*i-1:2*i));hold on;
    end
    hold off;

    %Find the cluster that has the lowest stdev
    min_std_indx=find(stde_f==min(stde_f));
    gamma_cluster=T(min_std_indx);
    
    %Label these intervals by 1, the rest by 2
    for i=1:length(signals.start_indx),
        ud=set_current_interval(ud, i);
        if T(i)==gamma_cluster,
            labelCurrentInterval(ud, '1');
        else
            labelCurrentInterval(ud, '2');
        end
    end

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    interval_power_screen    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function signals=interval_power_screen(signals, ud)

    %If no range or ratio to use, or no intervals, return.
    ranges=ud.threshold.interval_power_screen_ranges;
    ratio=ud.threshold.interval_power_screen_ratio;
    if isempty(ranges) | isempty(signals.start_indx) | isempty(ratio),
        return;
    end

    fg=gcbf;
    
    num_of_ints=length(signals.start_indx);
    durations=signals.end_indx-signals.start_indx;

    nfft_dummy1=ceil(log(max(durations))/log(2));
    nfft=2^nfft_dummy1;


    for i=1:num_of_ints,
        [Pxx,f] = periodogram(detrend(signals.eeg(signals.start_indx(i):signals.end_indx(i))), ...
                              [],nfft,ud.data_features.Fs);
        
        stopbandranges=[];
        for j=1:length(ranges)/2,
            stopbandranges=[stopbandranges find(f'>=ranges(2*j-1) & f'<=ranges(2*j))];
        end
        passband=find(f>=ud.filter.F(2) & f<=ud.filter.F(3));

        %Check whether the bands overlap. This may happen in batch mode if files that have different
        %passbands are somehow processed using the same stopband
        testfield=ones(1, length(Pxx));
        testfield(stopbandranges)=testfield(stopbandranges).*0;
        if any(testfield(passband)==0),
            errmsg='The stopband for interval power screen overlaps with passband!';
            showMessage(ud.Handles.Texts.Message, errmsg, 0, 0.1);
            errordlg(errmsg);
        end
        
        if ratio*sum(Pxx(stopbandranges))>sum(Pxx(passband)),
           signals.start_indx(i)=-1; 
        end
    end
    
    valids=signals.start_indx~=-1;
    signals.start_indx=signals.start_indx(valids);    
    signals.end_indx=signals.end_indx(valids);        

    set(ud.Handles.Axes.Raw, 'UserData', signals);
     
%%%%%%%%%%%%%%%%%%%%%
%    initStructs    %
%%%%%%%%%%%%%%%%%%%%%
function [ud, signals, intervalCategories, videoData]=initStructs()
    
%Create user data
ud = struct(...
    'EEG_VERSION', [], ...
    'filter', struct('F', [], 'b', [], 'a', 1, 'Fs', []), ...
    'data_features', struct('Fs', [], 'Gain', [], 'first_tstamp', [], 'last_tstamp', []), ...
    'DisplayBuffers', struct('empty', 1, 'underflow', 0, 'overflow', 0, 'zoomin', 0, ...
                             'zoomout', 0, 'threshold_change', 0, 'slider_BUP', 0, 'KeyPressEvent', 0, ...
                             'slider_EditBox', 0, 'signal_change', 0, 'length', 1e4, ...
                             'zoomlevel', [], 'first_tstamp', [], 'last_tstamp', [], ...
                             'interval_marker_handles_exist', 0), ...
    'threshold', struct('in_volts', [], ...
                        'users', [], ...
                        'signal_change', 0, ...
                        'reference', [], ...
                        'absmaxref', 0, ...
                        'epsilon', 1e-6, ...
						'lowerbound', 1e-6, ...
						'intervalCutoff', [], ...
                        'interval_power_screen_ranges', [], ...
                        'interval_power_screen_ratio', [], ...
                        'peak_grouping_window', 1, ...
                        'interval_fusion_window', 0, ...
                        'lines', []), ...
    'Aperture', struct('Start', [], 'Width', []), ...
    'Handles',struct('Axes',[],'Lines',[],'Controls',[], 'Texts', [], 'Images', []), ...    
    'FigureName', [], ...
    'DataFileName', [], ...
    'current_interval', [], ...
    'selected_interval_box', [], ...
    'selected_interval_number_text', [], ...
    'interval_power_screen_ranges', [], ...
    'interval_power_screen_ratio', [], ...
    'inserting_interval', 0, ...
    'signal_change', 0, ...
    'WidthInPixels', [], ...
    'YLimRaw', [], ...
    'YLimFiltered', [], ...
    'Scrollright', 0, ...
    'Zoomout', 0, ... 
    'LastScrollerValue', [], ...
    'LastZoomerValue', [],...
    'ScrollBUP', 0, ...
    'ZoomBUP', 0, ...
    'motion_threshold', [], ...
    'motion_label', '', ...
    'still_threshold', [], ...
    'still_label', '');

%Store signals as a struct
signals = struct(...
    't', [], ...
    'eeg', [], ...
    'infraeeg', [], ...
    'supraeeg', [], ...
    'y', [],...
    'start_indx', [], ...
    'end_indx', [], ...
    'threshold_record', struct('intervalCutoff', [], ...
                               'interval_power_screen_ranges', {}, ...
                               'interval_power_screen_ratio', [], ...
                               'peak_grouping_window', [], ...
                               'interval_fusion_window', [], ...
                               'reference', []));

%Store data about interval labeling as a struct
intervalCategories = struct(...
    'categories', [], ...
    'label_text_handles', []);

%Store video information as a struct
videoData = struct(...
    'positionFullImageOffsets', [], ...
    'positionNavigationTable', [], ...
    'fname', [], ...
    'infile', [], ...
    'imagedimensions', []);


%%%%%%%%%%%%%%%%%%%%%
%    guiBackbone    %
%%%%%%%%%%%%%%%%%%%%%
function ud=guiBackbone(FH, ud, signals, intervalCategories, videoData)

	%Create plot axes
    Pos1=[0.1300 0.6671 0.7750 0.2579];
	ud.Handles.Axes.Raw=axes('Parent', FH, ...
                             'Units', 'normalized', ...
                             'Position', Pos1);
    
	Pos2=[0.1300 0.3679 0.7750 0.2579];
	ud.Handles.Axes.Filtered=axes('Parent', FH, ...
                                  'Units', 'normalized', ...
                                  'Position', Pos2);

    %Reference measures                              
    Pos=Pos2;
	fr=3/4;
	Ht=Pos(4)/fr;
                              
	%Create video axis and image
	right_end=Pos(1)+Pos(3);
	width=320*Pos(4)/240*0.8;
	VideoPOS=[right_end-width Pos(2)-Pos(4)-0.06 width Pos(4)];
	ud.Handles.Axes.Video=axes(...
        'Parent', FH, ...
        'Position', VideoPOS);
	
	%%%%%%%%%%
	axes(ud.Handles.Axes.Video);
	[IX, IY]=meshgrid(linspace(-160, 160, 320*4)/120, linspace(-120, 120, 240*4)/120);
	I=exp(-(IX.^2+IY.^2)/0.25);
	ud.Handles.Images.Video=imshow(I);
	set(ud.Handles.Images.Video, 'Parent', ud.Handles.Axes.Video,...
                                 'ButtonDownFcn', {@VideoImageBDF, FH});
	ud.Handles.Texts.VideoClickMessage=text('Parent', ud.Handles.Axes.Video, ...
         'String', 'Select an Interval and Click Here', ...
         'FontSize', 8, ...
         'Units', 'normalized', ...
         'Position', [0.5 0.5], ...
         'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'middle', ...
         'Color', 'r', ...
         'ButtonDownFcn', {@VideoImageBDF, FH});                         
	%%%%%%%%%%
	
	%show lines around the video axis. They will be turned on when the movie plays.
	Xlim=get(ud.Handles.Axes.Video, 'Xlim');
	Ylim=get(ud.Handles.Axes.Video, 'Ylim');
	ud.Handles.Lines.video_on_lines(1)=line('Parent', ud.Handles.Axes.Video, ...
                                         'XData', Xlim, ...
                                         'YData', Ylim(1)*[1 1]);
	ud.Handles.Lines.video_on_lines(2)=line('Parent', ud.Handles.Axes.Video, ...
                                         'XData', Xlim, ...
                                         'YData', Ylim(2)*[1 1]);
	ud.Handles.Lines.video_on_lines(3)=line('Parent', ud.Handles.Axes.Video, ...
                                         'XData', Xlim(1)*[1 1], ...
                                         'YData', Ylim);
	ud.Handles.Lines.video_on_lines(4)=line('Parent', ud.Handles.Axes.Video, ...
                                         'XData', Xlim(2)*[1 1], ...
                                         'YData', Ylim);
	set(ud.Handles.Lines.video_on_lines, 'Visible', 'off', ... 
                                         'Color', [0 1 0]/4);
	
	
	%Create a message box. Init message
	ud.Handles.Axes.Messages=axes(...
        'Position', Pos1.*[1 1 1 0.2]+[0 Pos1(4)+0.03 0 0], ...
        'Parent', FH, ...
        'Units', 'normalized');
	ud.Handles.Texts.Message=text(...
            'Parent', ud.Handles.Axes.Messages, ...
            'String', '', ...
            'Position', [0.5 0.5], ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'Color', [1 0 1]*0.7, ...
            'FontSize', 15, ...
            'FontName', 'Times');
	
	%Finish axes
	ax=ud.Handles.Axes.Raw;
	set(ax, 'Position', Pos1);
	set(get(ax, 'YLabel'), 'String', 'Raw EEG (V)');
	set(ax, 'Color', [1 1 1]/2, 'XColor', 'w', 'YColor', 'w', 'XTickLabel', '');
	
	ax=ud.Handles.Axes.Filtered;
	set(ax, 'Position', Pos2);
	set(get(ax, 'XLabel'), 'String', 'Time (s)');
	set(get(ax, 'YLabel'), 'String', 'Filtered EEG (V)');
	set(ax, 'Color', [1 1 1]/2, 'XColor', 'w', 'YColor', 'w');
	
	ax=ud.Handles.Axes.Video;
	set(get(ax, 'XLabel'), 'String', 'VIDEO', 'Color', 'y', 'FontWeight', 'bold');
	set(ax, 'Color', [1 1 1]/5, 'XTick', [], 'YTick', []);
	
	ax=ud.Handles.Axes.Messages;
	set(ax, 'Color', 'k', 'XColor', 'k', 'YColor', 'k', ...
            'XTick', [], 'YTick', []);
       
	%put scroll rtslider
	ud.Handles.Controls.ScrollSlider=rtslider('Parent',FH,'Position',(Pos-[0 Ht*(1-fr)*3 0 0]).*[1 1 0.4 0.1], ...
        'Label','Scroll', 'Callback',{@localSetParam,FH,'S'}, ...
        'MarkerColor', 'r', ...
        'ButtonDownFcn', {@ScrollSliderBDF, FH}, ...
        'ButtonUpFcn', {@ScrollSliderBUF, FH});
	
	%put zoom rtslider
	ud.Handles.Controls.ZoomSlider=rtslider('Parent',FH,'Position',(Pos-[0 Ht*(1-fr)*3+0.05 0 0]).*[1 1 0.4 0.1],...
        'Label','Zoom', 'Callback',{@localSetParam,FH,'Z'}, ...
        'MarkerColor', 'r', 'Scale', 'log', 'Range', [0.1 1], ...
        'ButtonDownFcn', {@ZoomSliderBDF, FH}, ...
        'ButtonUpFcn', {@ZoomSliderBUF, FH});
		
	%Put video start time edit box
	VSEBPos=VideoPOS.*[1 1 0 0]+[VideoPOS(3)+0.01 VideoPOS(4)/2 0.04 0.02]+[0 0.0375 0 0];
	ud.Handles.Controls.VideoStartEditBox=...
        uicontrol('Parent', FH, ...
                  'Style', 'edit', ...
                  'BackgroundColor', [1 1 1]*0, ...
                  'ForegroundColor', 'r', ...
                  'String', '0', ...
                  'Units', 'normalized', ...
                  'HorizontalAlignment', 'center', ...
                  'Position', VSEBPos);
	ud.Handles.Axes.VideoStartEditBoxLabel=...
        axes('Parent', FH, ...
             'Units', 'normalized', ...
             'Position', VSEBPos+[0 0.02 0 0], ...
             'Color', 'k');
	ud.Handles.Texts.VideoStartEditBoxLabel=...
        text('Parent', ud.Handles.Axes.VideoStartEditBoxLabel, ...
             'String', 'Start offset (s)', ...
             'FontWeight', 'bold', ...
             'VerticalAlignment', 'middle', ...
             'Units', 'normalized', ...
             'Position', [0 0.5], ...
             'Color', 'y');
              
	%Put video stop time edit box
	VSoEBPos=VSEBPos-[0 0.05 0 0];
	ud.Handles.Controls.VideoStopEditBox=...
        uicontrol('Parent', FH, ...
                  'Style', 'edit', ...
                  'BackgroundColor', [1 1 1]*0, ...
                  'ForegroundColor', 'r', ...
                  'String', '0', ...
                  'Units', 'normalized', ...
                  'HorizontalAlignment', 'center', ...
                  'Position', VSoEBPos);
	ud.Handles.Axes.VideoStopEditBoxLabel=...
        axes('Parent', FH, ...
             'Units', 'normalized', ...
             'Position', VSoEBPos+[0 0.02 0 0], ...
             'Color', 'k');
	ud.Handles.Texts.VideoStopEditBoxLabel=...
        text('Parent', ud.Handles.Axes.VideoStopEditBoxLabel, ...
             'String', 'Stop offset (s)', ...
             'FontWeight', 'bold', ...
             'VerticalAlignment', 'middle', ...
             'Units', 'normalized', ...
             'Position', [0 0.5], ...
             'Color', 'y');
         	
	%Put video frame skip edit box
	VSkEBPos=VSoEBPos-[0 0.05 0 0];
	ud.Handles.Controls.VideoSkipEditBox=...
        uicontrol('Parent', FH, ...
                  'Style', 'edit', ...
                  'BackgroundColor', [1 1 1]*0, ...
                  'ForegroundColor', 'r', ...
                  'String', '0', ...
                  'Units', 'normalized', ...
                  'HorizontalAlignment', 'center', ...
                  'Position', VSkEBPos);
	ud.Handles.Axes.VideoSkipEditBoxLabel=...
        axes('Parent', FH, ...
             'Units', 'normalized', ...
             'Position', VSkEBPos+[0 0.02 0 0], ...
             'Color', 'k');
	ud.Handles.Texts.VideoSkipEditBoxLabel=...
        text('Parent', ud.Handles.Axes.VideoSkipEditBoxLabel, ...
             'String', 'Skip frames', ...
             'FontWeight', 'bold', ...
             'VerticalAlignment', 'middle', ...
             'Units', 'normalized', ...
             'Position', [0 0.5], ...
             'Color', 'y');
         
	%Put a togglebutton to stop video
	VStTBPos=VSkEBPos-[0 0.05 0 0];
	ud.Handles.Controls.VideoStopToggleButton=...
        uicontrol('Parent', FH, ...
                  'Style', 'togglebutton', ...
                  'BackgroundColor', [1 0 1]*0.2, ...
                  'ForegroundColor', 'r', ...
                  'String', 'STOP', ...
                  'Units', 'normalized', ...
                  'HorizontalAlignment', 'center', ...
                  'Tag', 'videostop_togglebutton', ...
                  'Position', VStTBPos+[0 0 0 0.01]);
         
	%Save data
	%Store signals as Raw axis' user data
	set(ud.Handles.Axes.Raw, 'UserData', signals);
	%Store intervalCategories as Filtered axis' user data
	set(ud.Handles.Axes.Filtered, 'UserData', intervalCategories);
	%Store videoData as video axis' user data
	set(ud.Handles.Axes.Video, 'UserData', videoData);
	%Store the user data with the figure
	set(FH, 'UserData', ud);

    
%%%%%%%%%%%%%%%%%%%%
%    createMenu    %
%%%%%%%%%%%%%%%%%%%%
function createMenu(FH)

%Delete existing menu
set(FH, 'MenuBar', 'none');

%Create menu items
%File operations
file_handle=uimenu(FH, ...
    'Label', 'File');
file_open_handle=uimenu(file_handle, ...
    'Label', 'Open');
uimenu(file_open_handle, ...
    'Label', 'Open .eeg',... 
        'Callback', {@menu_open_eeg_callback});
uimenu(file_open_handle, ...
    'Label', 'Load raw eeg',... 
    'Tag', 'menu_load_raw_eeg', ...
        'Callback', {@menu_load_raw_eeg_callback});
uimenu(file_open_handle, ...
    'Label', 'Load filtered eeg',... 
        'Callback', {@menu_load_filtered_eeg_callback});
file_save_handle=uimenu(file_handle, ...
    'Label', 'Save', ...
    'Tag', 'menu_file_save', ...
    'Callback', {@menu_file_save_callback});
uimenu(file_handle, ...
    'Label', 'Close',... 
    'Separator', 'on', ...
        'Callback', {@menu_close_callback});
uimenu(file_handle, ...
    'Label', 'Quit',... 
    'Separator', 'on', ...
        'Callback', {@menu_quit_callback});
    
%Get filter characteristics    
filter_handle=uimenu(FH, ...
    'Label', 'Filter');
filter_file_handle=uimenu(filter_handle, ...
    'Label', 'File');
uimenu(filter_file_handle, ...
    'Label', 'Load Filter',... 
        'Tag', 'menu_filter_load', ...
        'Callback', {@menu_filter_load_callback});
uimenu(filter_file_handle, ...
    'Label', 'Save Filter',... 
        'Callback', {@menu_filter_save_callback});
uimenu(filter_handle, ...
    'Label', 'Design',... 
        'Tag', 'menu_filter_design', ...
        'Callback', {@menu_filter_design_callback});
uimenu(filter_handle, ...
    'Label', 'Show Frequency Response',... 
    'Separator', 'on', ...
        'Callback', {@menu_filter_fresponse_callback});
    
%Export Interval data    
interval_handle=uimenu(FH, ...
    'Label', 'Interval');
interval_file_handle=uimenu(interval_handle, ...
    'Label', 'File');
uimenu(interval_file_handle, ...
    'Label', 'Export .nex',... 
        'Callback', {@menu_interval_export_callback});
uimenu(interval_file_handle, ...
    'Label', 'Save .mat',... 
    'Tag', 'menu_interval_save', ...
        'Callback', {@menu_interval_save_callback});
uimenu(interval_file_handle, ...
    'Label', 'Load .mat',... 
    'Tag', 'menu_interval_load', ...
        'Callback', {@menu_interval_load_callback});

interval_select_handle=uimenu(interval_handle, ...
    'Label', 'Select');
uimenu(interval_select_handle, ...
    'Label', 'Select all',... 
        'Callback', {@menu_interval_selectall_callback});
uimenu(interval_select_handle, ...
    'Label', 'Unselect all',... 
        'Callback', {@menu_interval_unselectall_callback});
uimenu(interval_select_handle, ...
    'Label', 'Select complement',... 
        'Tag', 'menu_interval_complement', ...
        'Callback', {@menu_interval_complement_callback});
uimenu(interval_select_handle, ...
    'Label', 'Select by timestamp',... 
        'Tag', 'menu_interval_select_tstamp', ...
        'Callback', {@menu_interval_select_tstamp_callback});
uimenu(interval_select_handle, ...
    'Label', 'Select by max voltage',... 
        'Tag', 'menu_interval_select_maxvolt', ...
        'Callback', {@menu_interval_select_maxvolt_callback});

interval_operation_handle=uimenu(interval_handle, ...
    'Label', 'Operation');
uimenu(interval_operation_handle, ...
    'Label', 'Logical AND',... 
        'Callback', {@menu_interval_operation_callback});
uimenu(interval_operation_handle, ...
    'Label', 'Logical OR',... 
        'Callback', {@menu_interval_operation_callback});
uimenu(interval_operation_handle, ...
    'Label', 'Absent here',... 
        'Callback', {@menu_interval_operation_callback});
uimenu(interval_operation_handle, ...
    'Label', 'Absent there',... 
        'Callback', {@menu_interval_operation_callback});
    
interval_find_handle=uimenu(interval_handle, ...
    'Label', 'Find', ...
        'Tag', 'menu_interval_find', ...
        'Callback', {@menu_interval_find_callback});
%uimenu(interval_handle, ...
%    'Label', 'Find by feature', ...
%        'Tag', 'menu_interval_find_feature', ...
%        'Callback', {@menu_interval_find_feature_callback});
interval_select_handle=uimenu(interval_handle, ...
    'Label', 'Insert', ...
        'Tag', 'menu_interval_insert', ...
        'Callback', {@menu_interval_insert_callback});
interval_select_handle=uimenu(interval_handle, ...
    'Label', 'Delete', ...
        'Tag', 'menu_interval_delete', ...
        'Callback', {@menu_interval_delete_callback});
uimenu(interval_handle, ...
    'Label', 'Deemphasize',... 
        'Tag', 'menu_interval_deemp', ...
        'Callback', {@menu_interval_deemp_callback});
uimenu(interval_handle, ...
    'Label', 'Jump to',... 
        'Tag', 'menu_interval_jumpto', ...
        'Callback', {@menu_interval_jumpto_callback});
uimenu(interval_handle, ...
    'Label', 'Change label',... 
        'Tag', 'menu_interval_change_label', ...
        'Callback', {@menu_interval_change_label_callback});

%Analysis
analysis_handle=uimenu(FH, ...
    'Label', 'Analysis');

analysis_PSD_handle=uimenu(analysis_handle, ...
    'Label', 'PSD');
uimenu(analysis_PSD_handle, ...
    'Label', 'Current file',... 
    'Tag', 'menu_analysis_PSD', ...
        'Callback', {@menu_analysis_PSD_callback});
uimenu(analysis_PSD_handle, ...
    'Label', 'Batch',... 
    'Tag', 'menu_analysis_batch_PSD', ...
        'Callback', {@menu_analysis_batch_PSD_callback});

uimenu(analysis_handle, ...
    'Label', 'Spectrogram',... 
        'Callback', {@menu_analysis_spectrogram_callback});
uimenu(analysis_handle, ...
    'Label', 'Coherence',... 
        'Callback', {@menu_analysis_coherence_callback});
uimenu(analysis_handle, ...
    'Label', 'Interval statistics',...
    'Separator', 'on', ...
        'Callback', {@menu_analysis_interval_stats_callback});
uimenu(analysis_handle, ...
    'Label', 'Max amplitude histogram',...
        'Callback', {@menu_analysis_maxamphist_callback});
    
analysis_motion_handle=uimenu(analysis_handle, ...
    'Label', 'Motion',... 
    'Separator', 'on');
uimenu(analysis_motion_handle, ...
    'Label', 'Active/Still Intervals',... 
        'Callback', {@menu_analysis_mot_asint_callback});
uimenu(analysis_motion_handle, ...
    'Label', 'Export .nex',... 
        'Callback', {@menu_analysis_mot_nex_callback});
    
uimenu(analysis_handle, ...
    'Label', 'Peak Detect',... 
    'Separator', 'on', ...
        'Callback', {@menu_analysis_peak_detect_callback});
uimenu(analysis_handle, ...
    'Label', 'Onset Times',... 
    'Separator', 'on', ...
        'Callback', {@menu_analysis_onset_callback});
uimenu(analysis_handle, ...
    'Label', 'Latency',... 
    'Tag', 'menu_analysis_latency', ...
        'Callback', {@menu_analysis_latency_callback});

uimenu(analysis_handle, ...
    'Label', 'Phase',... 
    'Separator', 'on', ...
    'Tag', 'menu_analysis_phase', ...
        'Callback', {@menu_analysis_phase_callback});

    
%Batch mode
batch_handle=uimenu(FH, ...
    'Label', 'Batch');
uimenu(batch_handle, ...
    'Label', 'Convert .eeg to .mat',... 
    'Tag', 'menu_batch_eeg_to_mat', ...
        'Callback', {@menu_batch_eeg_to_mat_callback});
uimenu(batch_handle, ...
    'Label', 'Read .eeg and filter',... 
    'Tag', 'menu_batch_eeg_filter', ...
        'Callback', {@menu_batch_eeg_filter_callback});
uimenu(batch_handle, ...
    'Label', 'Find intervals',... 
    'Tag', 'menu_batch_find_intervals', ...
        'Callback', {@menu_batch_find_intervals_callback});
uimenu(batch_handle, ...
    'Label', '.eeg to plot results',... 
    'Tag', 'menu_batch_eeg_to_plot', ...
        'Callback', {@menu_batch_eeg_to_plot_callback});
uimenu(batch_handle, ...
    'Label', 'Deemphasize',... 
    'Tag', 'menu_batch_deemphasize_intervals', ...
        'Callback', {@menu_batch_deemphasize_intervals_callback});

%Plot stat results
plot_handle=uimenu(FH, ...
    'Label', 'Plot');
uimenu(plot_handle, ...
    'Label', 'Interval Statistics',... 
    'Tag', 'menu_plot_interval_stats', ...
        'Callback', {@menu_plot_interval_stats_callback});

%View
view_handle=uimenu(FH, ...
    'Label', 'View');
view_peaks_handle=uimenu(view_handle, ...
    'Label', 'Peaks');
uimenu(view_peaks_handle, ...
    'Label', 'Hide Positive',... 
    'Tag', 'menu_view_peaks_pos', ...
        'Callback', {@menu_view_callback});
uimenu(view_peaks_handle, ...
    'Label', 'Hide Negative',... 
    'Tag', 'menu_view_peaks_neg', ...
        'Callback', {@menu_view_callback});
uimenu(view_peaks_handle, ...
    'Label', 'Delete Positive',... 
    'Tag', 'menu_view_peaks_pos_delete', ...
        'Callback', {@menu_view_callback});
uimenu(view_peaks_handle, ...
    'Label', 'Delete Negative',... 
    'Tag', 'menu_view_peaks_neg_delete', ...
        'Callback', {@menu_view_callback});
    
view_onsets_handle=uimenu(view_handle, ...
    'Label', 'Onsets');
uimenu(view_onsets_handle, ...
    'Label', 'Hide Onsets',... 
    'Tag', 'menu_view_onsets', ...
        'Callback', {@menu_view_callback});
uimenu(view_onsets_handle, ...
    'Label', 'Delete Onsets',... 
    'Tag', 'menu_view_onsets_delete', ...
        'Callback', {@menu_view_callback});
    
uimenu(view_handle, ...
    'Label', 'Hide Interval Delimiters',... 
    'Tag', 'menu_view_intervals', ...
        'Callback', {@menu_view_callback});

uimenu(view_handle, ...
    'Label', 'Hide Threshold Lines',... 
    'Tag', 'menu_view_threshold', ...
        'Callback', {@menu_view_callback});
    
%Print Help
uimenu(FH, ...
    'Label', 'Help',... 
        'Callback', {@menu_help_callback});
%About this program
uimenu(FH, ...
    'Label', 'About',... 
        'Callback', {@menu_about_callback});

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    read_save_eeg_data    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ud=read_save_eeg_data(fname, Fs, Gain, ud)

    fg=gcbf;

    %Save filename
    ud.DataFileName=fname;
    
    %What is the extension of the input file? .eeg or .mat?
    matfile=0;
    eegfile=0;
    extensiondot=max(charfind(fname, '.'));
    if strcmp(fname(extensiondot+1:end), 'mat'),
        matfile=1;
    elseif strcmp(fname(extensiondot+1:end), 'eeg'),
        eegfile=1;
    else
        errordlg('Not a .eeg or .mat file.');
    end
    
	%Read data if .eeg
    if eegfile,
        [t, eeg]=get_eeg_in_volts(fname, Fs, Gain);
    else
    %Just load it.
        load(fname);
        t=package.t;
        eeg=package.eeg;
        Fs=package.Fs;
        Gain=package.Gain;
    end
    	
	%Save loaded eeg data
    signals=get(ud.Handles.Axes.Raw, 'UserData');
	signals.t=t;
	signals.eeg=eeg;
	signals.y=eeg.*NaN;
	ud=save_loaded_eeg_data(Fs, Gain, signals, fname, ud.filter, ud); 

    if ~matfile,
        %Prepare package to be saved
		package=[];
		package.t=t;
		package.eeg=eeg;
		package.Fs=Fs;
		package.Gain=Gain;
        
		%If not batch mode, suggest to user to save the raw eeg data
        cbtag=get(gcbo, 'Tag');
        if ~(strcmp(cbtag, 'menu_batch_eeg_filter') | ...
             strcmp(cbtag, 'menu_batch_find_intervals') | ...
             strcmp(cbtag, 'menu_batch_eeg_to_mat') | ...
             strcmp(cbtag, 'menu_batch_eeg_to_plot')),
			button = questdlg('Would you like to save the raw eeg data in a .mat file for faster reload?',...
			'Save Raw EEG?','Yes','No','Yes');
            drawnow;
			if strcmp(button,'Yes')
              %Get filename from user
              [fname,pname] = uiputfile('*.mat','Save raw eeg data as');
              if fname==0 & pname==0,
                  return;
              end
              fname=sprintf('%s%s', pname, fname);
              
	  		  %Save filename
			  ud.DataFileName=fname;
              
              %Refresh GUI
              drawnow;
			      
              showMessage(ud.Handles.Texts.Message, 'Saving file', 0);
              save(fname, 'package');
              showMessage(ud.Handles.Texts.Message, 'DONE: Saving file', 1);
			end
        else
            %Save raw mat file
            lastdotplace=get_lastdotplace(fname);
            matfname=sprintf('%smat', fname(1:lastdotplace));
            save(matfname, 'package');
       end
    end %if ~matfile,

   %Save data
   set(fg, 'UserData', ud);
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    save_filtered_data    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ud=save_filtered_data(fname, ud)

    fg=gcbf;

	%Save filename
	ud.DataFileName=fname;
    
    %Prepare package to be saved
	package=[];
	package.Fs=ud.data_features.Fs;
	package.saved_filter=ud.filter;
	package.saved_signals=get(ud.Handles.Axes.Raw, 'UserData');
	package.Gain=ud.data_features.Gain;
    
    %Currently, we do not save interval data to filtered data file. Make sure
    %Nothing shows up in there
    package.saved_signals.start_indx=[];
    package.saved_signals.end_indx=[];
    package.saved_signals.infraeeg=[];
    package.saved_signals.supraeeg=[];    
    
	%If we arrived here automatically after selecting a filtering menu option, or if
    %the filename is empty, ask user a filename to save stuff.
    cbtag=get(gcbo, 'Tag');
    if (strcmp(cbtag, 'menu_filter_design') | ...
         strcmp(cbtag, 'menu_filter_load') | ...
         isempty(ud.DataFileName)),
     
        %No need to ask the following question if we came here from menu_file_save
        if ~strcmp(cbtag, 'menu_file_save'),
			button = questdlg('Would you like to save the modified data in a .mat file?',...
			'Save Modified File?','Yes','No','Yes');
            drawnow;
        else
            button='Yes';
        end
		if strcmp(button,'Yes')
          %Get filename from user
          [fname,pname] = uiputfile('*.mat','Save filtered eeg data as');
          fname=sprintf('%s%s', pname, fname);
          
          %Save filename
          ud.DataFileName=fname;
          
		  %Refresh GUI
		  drawnow;

          if ~isempty(fname) & fname~=0,
              showMessage(ud.Handles.Texts.Message, 'Saving file', 0);
              save(fname, 'package');
              showMessage(ud.Handles.Texts.Message, 'DONE: Saving file', 1);
          end
          
		end
        set(fg, 'UserData', ud);
        
        drawnow;
    else
        if ~isempty(fname) & fname~=0,
            save(fname, 'package');
        end
    end%if ~menu_filter...
    
	ud.FigureName=sprintf('eegrhythm %s (%.3f Hz)', ud.DataFileName, ud.filter.Fs);
    set(fg, 'Name', ud.FigureName);
    set(fg, 'UserData', ud);
    
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    perform_close_sequence    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ud=perform_close_sequence()

    fg=gcbf;
    ud=get(fg, 'UserData');
    
    %Save version
    EEG_VERSION=ud.EEG_VERSION;
    
    %Reset figure name
    set(fg, 'Name', 'eegrhythm ');

    %Delete all of its children that are not menus
    menus=findobj(fg, 'Type', 'uimenu');
    allchildren=get(fg, 'Children');

    for i=1:length(allchildren),
        if ~isempty(find(allchildren(i)==menus)),
            allchildren(i)=NaN;
        end
    end
    non_menus=find(isnan(allchildren)==0);
    
    %Delete them
    delete(allchildren(non_menus));
            
	%Initialize the structs that will hold various GUI data
	[ud signals intervalCategories videoData]=initStructs;
	%Restore version
    ud.EEG_VERSION=EEG_VERSION;
    
	%construct and show the GUI backbone
	ud=guiBackbone(fg, ud, signals, intervalCategories, videoData);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    save_interval_matfile    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_interval_matfile(fname, signals, intervalCategories, varargin)

    fg=gcbf;
    ud=get(fg, 'UserData');

    %The relevant variables are signals.start_indx, signals.end_indx, start and end times,
    %and intervalCategories
    
    cbtag=get(gcbo, 'Tag');
    if strcmp(cbtag, 'menu_interval_save'),
        %If this is called by the menu_interval_save_callback, we need to get our data ourselves
		intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');
        signals=get(ud.Handles.Axes.Raw, 'UserData');
    end
    
    %By default, save all.
    to_be_saved='*';
    if nargin==4,
        to_be_saved=varargin{1};
    end
    
    %What categories are there?
    existing_categories_indx=zeros(1, max(intervalCategories.categories)+1);
    for i=1:length(existing_categories_indx),
        indx=find(intervalCategories.categories==i-1);
        if ~isempty(indx),
            existing_categories_indx(i)=1;
        end
    end
    all_categories=find(existing_categories_indx==1)-1;
    
    %Now select the intervals to be saved
    selection_mask=zeros(1, length(signals.start_indx));
    
    for i=1:length(all_categories),
        if ~isempty(find(all_categories(i)==to_be_saved)) | ...
           ~is_different(to_be_saved, '*'),
            selection_mask=...
                selection_mask|intervalCategories.categories==all_categories(i);
        end
    end
    selected_indx=find(selection_mask==1);
    
    package=[];
    package.start_indx=signals.start_indx(selected_indx);
    package.end_indx  =signals.end_indx(selected_indx);
    package.start_times=signals.t(signals.start_indx(selected_indx));
    package.end_times=signals.t(signals.end_indx(selected_indx));
    package.categories=intervalCategories.categories(selected_indx);

    showMessage(ud.Handles.Texts.Message, 'Saving file', 0);
    save(fname, 'package');
    showMessage(ud.Handles.Texts.Message, 'DONE: Saving file', 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    initIntervalCategories    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function intervalCategories=initIntervalCategories(ud, num_of_intervals)

    intervalCategories=get(ud.Handles.Axes.Filtered, 'UserData');

    intervalCategories.categories=zeros(1, num_of_intervals);
	intervalCategories.label_text_handles=zeros(2, num_of_intervals);
    
    %Save it
    set(ud.Handles.Axes.Filtered, 'UserData', intervalCategories);
        
%%%%%%%%%%%%%%%%%%%%%%
% get_interval_stats %
%%%%%%%%%%%%%%%%%%%%%%
function interval_stats_struct=get_interval_stats(intervalCategories, signals)

	labels=intervalCategories.categories;
    if isempty(labels),
		%Interval label
		interval_stats_struct.label=[];
		%Number of intervals
		interval_stats_struct.num_of_intervals=0;
		%Interval numbers
		interval_stats_struct.interval_numbers=[];
		%Start times
		interval_stats_struct.starts=[];
		%End times
		interval_stats_struct.ends=[];
		%Total duration
		interval_stats_struct.total_duration=[];
		%Mean duration
		interval_stats_struct.mean_duration=[];
		%Standard deviation of duration
		interval_stats_struct.std_of_duration=[];
		%Average power
		interval_stats_struct.avg_raw_power=[];
		interval_stats_struct.avg_fil_power=[];
		interval_stats_struct.avg_raw_power_perinterval=[];
		interval_stats_struct.avg_fil_power_perinterval=[];
		%Filtered to raw power ratio
		interval_stats_struct.fil_to_raw_ratio=[];
        return;
    end
    
    counter=1;
	for i=min(labels):max(labels),
      index=find(intervalCategories.categories==i);
      if isempty(index),
          continue;
      end
      
      %Interval label
      interval_stats_struct(counter).label=i;

      %Number of intervals
      num_of_intervals=length(signals.start_indx(index));
      interval_stats_struct(counter).num_of_intervals=num_of_intervals;
      
      %Interval numbers
      interval_stats_struct(counter).interval_numbers=index;
      
      %Start times
      starts=signals.t(signals.start_indx(index));
      interval_stats_struct(counter).starts=reshape(starts, 1, max(size(starts)));
      
      %End times
      ends=signals.t(signals.end_indx(index));
      interval_stats_struct(counter).ends=reshape(ends, 1, max(size(ends)));
      
      %Total duration
      interval_stats_struct(counter).total_duration=sum(ends-starts);
      %Mean duration
      interval_stats_struct(counter).mean_duration=mean(ends-starts);
      %Standard deviation of duration
      interval_stats_struct(counter).std_of_duration=std(ends-starts);
      
      %Average power
      avg_raw_power=0;
      avg_fil_power=0;
      avg_raw_power_perinterval=zeros(1, num_of_intervals);
      avg_fil_power_perinterval=zeros(1, num_of_intervals);
      tot_num_of_samples=0;
      for j=1:num_of_intervals,
          range=signals.start_indx(index(j)):signals.end_indx(index(j));
          tot_num_of_samples=tot_num_of_samples+length(range);
          avg_raw_power=avg_raw_power+sum(signals.eeg(range).^2);          
          avg_fil_power=avg_fil_power+sum(signals.y(range).^2);
          avg_raw_power_perinterval(j)=sum(signals.eeg(range).^2)/length(range);
          avg_fil_power_perinterval(j)=sum(signals.y(range).^2)/length(range);
      end
      avg_raw_power=avg_raw_power/tot_num_of_samples;
      avg_fil_power=avg_fil_power/tot_num_of_samples;
      interval_stats_struct(counter).avg_raw_power=avg_raw_power;
      interval_stats_struct(counter).avg_fil_power=avg_fil_power;
      interval_stats_struct(counter).avg_raw_power_perinterval=avg_raw_power_perinterval;
      interval_stats_struct(counter).avg_fil_power_perinterval=avg_fil_power_perinterval;
      
      %Filtered to raw power ratio
      interval_stats_struct(counter).fil_to_raw_ratio=avg_fil_power/avg_raw_power;
      
      counter=counter+1;
	end %i=min(labels):max(labels)

    
%%%%%%%%%%%%%%%%%%
%    avoidTeX    %
%%%%%%%%%%%%%%%%%%
function output=avoidTeX(input, char_str)

    output=input;
    for char_ctr=1:length(char_str),
        
        input=output;
        
        charloci=charfind(input, char_str(char_ctr));
        if isempty(charloci)
            output=input;
            continue;
        end
        
        numofchars=length(charloci);
        output=[];
        input_index=1;
        for i=1:numofchars,
            charposition=charloci(i);
            
            if charposition==1,
                output='\';                
            else
                if isempty(output),
                    output=sprintf('%s\\', input(input_index:charposition-1));
                else
                    output=sprintf('%s%s\\', output, input(input_index:charposition-1));
                end
                input_index=charposition;
            end            
        end
        if input_index<=length(input)
            output=sprintf('%s%s', output, input(input_index:end));
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    refresh_threshold    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ud, returnflag, signals]=refresh_threshold(ud, signals)

    %Default
    returnflag=0;
    
    button = questdlg('Signal was modified. Compute new threshold?',...
	'Refresh Threshold','Yes','No','Yes');
    drawnow;
	if strcmp(button,'Yes')
        %The user wants to compute new threshold.
        if isempty(ud.threshold.users),
            %But there is no user's threshold. Ask it to be entered.
            showMessage(ud.Handles.Texts.Message, ...
                'Please find intervals using the Interval/Find menu option', 1);
            returnflag=1;
            return;
        end
        %The signal change is detected within set_thresholdstruct. We do not
        %need to report it explicitly.
        ud=set_thresholdstruct(ud, ud.threshold);

        %Find intervals
        [ud signals]=findIntervals(ud);
        
		%At this point, the n'th interval is defined by [signals.start_indx(n) signals.end_indx(n)]
		%where the indeces are the entry numbers in flags, and thus in signals.y and my.
		%Create a copy of the eeg vector such that it contains NaN in the supra regions.
		%Create another copy that has NaNs in the complementing regions.
        ud=mark_supra_infra_eeg(ud);
        
        %Initialize the intervalCategories
        initIntervalCategories(ud, length(signals.start_indx));
        
		%plot the traces and intervals
		ud=updateGraphs(ud);           
	end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%
%    get_lastdotplace    %
%%%%%%%%%%%%%%%%%%%%%%%%%%
function lastdotplace=get_lastdotplace(fname)

    lastdotplace=max(charfind(fname, '.'));
	if isempty(lastdotplace),
       lastnonspace=max(find(isspace(fname)==0));
       lastdotplace=lastnonspace+1;
	end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    make_backward_compatible    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [package, status]=make_backward_compatible(fname, package)

    fg=gcbf;
    ud=get(fg, 'UserData');
    status=-1;
    save_file=0;
    
    %Who is calling?
    cbt=get(gcbo, 'Tag');

    if strcmp(cbt, 'menu_load_raw_eeg'),
        fldnames=fieldnames(package);
        if length(fldnames)==3,
            Gain=askGain;
            if isempty(Gain),
                return;
            end
            %convert to voltages
            package.eeg=package.eeg*10/65536/Gain;
            %Save updated data
            package.Gain=Gain;
            
            save_file=1;
        end
    else %strcmp(cbt, 'menu_load_raw_eeg')
        fldnames=fieldnames(package);
        if length(fldnames)==3,
            Gain=askGain;
            if isempty(Gain),
                return;
            end
            %convert to voltages
            package.saved_signals.eeg=package.saved_signals.eeg*10/65536/Gain;
            package.saved_signals.y=package.saved_signals.y*10/65536/Gain;
            package.Gain=Gain;
            
            save_file=1;            
        end
        
        signalfldnames=fieldnames(package.saved_signals);
        if length(signalfldnames)==7,
            signals=get(ud.Handles.Axes.Raw, 'UserData');
            package.saved_signals.threshold_record=signals.threshold_record;

            save_file=1;            
        end
        
        threshold_record_fldnames=fieldnames(package.saved_signals.threshold_record);
        if length(threshold_record_fldnames)==3,
            if isempty(package.saved_signals.threshold_record),
                signals=get(ud.Handles.Axes.Raw, 'UserData');
                package.saved_signals.threshold_record=signals.threshold_record;
            else
                package.saved_signals.threshold_record.interval_power_screen_ratio=...
                    ones(size(package.saved_signals.threshold_record.intervalCutoff));
                package.saved_signals.threshold_record.peak_grouping_window=...
                    ones(size(package.saved_signals.threshold_record.intervalCutoff));
                package.saved_signals.threshold_record.interval_fusion_window=...
                    ones(size(package.saved_signals.threshold_record.intervalCutoff));
            end
            
            save_file=1;            
        end
        if length(threshold_record_fldnames)==4,
            if isempty(package.saved_signals.threshold_record),
                signals=get(ud.Handles.Axes.Raw, 'UserData');
                package.saved_signals.threshold_record=signals.threshold_record;
            else
                package.saved_signals.threshold_record.peak_grouping_window=...
                    ones(size(package.saved_signals.threshold_record.intervalCutoff));
                package.saved_signals.threshold_record.interval_fusion_window=...
                    ones(size(package.saved_signals.threshold_record.intervalCutoff));
            end
            
            save_file=1;            
        end
        if length(threshold_record_fldnames)==5,
            if isempty(package.saved_signals.threshold_record),
                signals=get(ud.Handles.Axes.Raw, 'UserData');
                package.saved_signals.threshold_record=signals.threshold_record;
            else
                package.saved_signals.threshold_record.interval_fusion_window=...
                    ones(size(package.saved_signals.threshold_record.intervalCutoff));
            end
            
            save_file=1;            
        end
    end %strcmp(cbt, 'menu_load_raw_eeg')
    
    %Save updated data    
    if save_file,
        save(fname, 'package');
    end

    %Return with no problems
    status=0;
    
%%%%%%%%%%%%%%%%%%%%%%%%
%    fuse_intervals    %
%%%%%%%%%%%%%%%%%%%%%%%%
function signals=fuse_intervals(ud, signals)

    Ni=length(signals.start_indx);

    %Just return if interval fusion window is zero or there are at most 1 intervals
    if ud.threshold.interval_fusion_window==0 | Ni<2,
        return;
    end

    range=1:Ni-1;
    
    inter_interval_gaps=signals.t(signals.start_indx(range+1))-...
                        signals.t(signals.end_indx(range));

    %Find those that are too short
    fusion_window=ud.threshold.interval_fusion_window/ud.filter.F(2);
    too_short_indx=find(inter_interval_gaps<=fusion_window);
    
    if isempty(too_short_indx),
        return;
    end
    
    signals.start_indx(too_short_indx+1)=signals.start_indx(too_short_indx+1).*0-1;    
    valids=find(signals.start_indx~=-1);
    signals.start_indx=signals.start_indx(valids);

    signals.end_indx(too_short_indx)=signals.end_indx(too_short_indx).*0-1;    
    valids=find(signals.end_indx~=-1);
    signals.end_indx  =signals.end_indx(valids);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    get_interval_bitfield    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bit_field=get_interval_bitfield(n, start_indx, end_indx)
    
    bit_field=zeros(1, n+1);
    
    %put diracs
    bit_field(start_indx)=bit_field(start_indx)+1;
    bit_field(end_indx+1)=bit_field(end_indx+1)-1;
    
    %integrate
    bit_field=cumsum(bit_field);
    bit_field=bit_field(1:end-1);    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    test_waveform_feature    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function peaks=test_waveform_feature(peaks, eeg, features, ud)

    %Find the peak indeces
    p_indx=find(peaks==1);
    
    if isempty(p_indx),
        return;
    end

    %Default: no peaks
    peaks=peaks*0;
    
    dtl=features.dtl;    
    dtr=features.dtr;    
    dvl=features.dvl;    
    dvr=features.dvr;    
    
    left_sample_indx=p_indx-dtl;
    right_sample_indx=p_indx+dtr;
    offset=length(find(left_sample_indx<1));
    valids=find(left_sample_indx>=1 & right_sample_indx<=length(eeg));
    if isempty(valids),
        return;
    end
    
    left_sample_indx=left_sample_indx(valids);
    right_sample_indx=right_sample_indx(valids);
    p_indx=p_indx(valids);

    left_dv=eeg(p_indx)-eeg(left_sample_indx);
    right_dv=eeg(right_sample_indx)-eeg(p_indx);
    
    %Keep those that exceed thresholds
    if dvl<0,
        valids=find(left_dv<=dvl & right_dv>=dvr);
    else
        valids=find(left_dv>=dvl & right_dv<=dvr);
    end
    if isempty(valids),
        return;
    end

    peaks(p_indx(valids))=peaks(p_indx(valids))+1;
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    get_channel_numbers    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function channel_numbers=get_channel_numbers(fnames, ud)

    channel_numbers=zeros(1, size(fnames, 1));
    for i=1:size(fnames, 1),
        if ispc,
            dividerplaces=charfind(fnames{i}, '\');
        elseif isunix,
            dividerplaces=charfind(fnames{i}, '/');
        else
            showMessage(ud.Handles.Texts.Message, 'System not unix nor PC.', 1);
            channel_numbers=[];
            return;
        end
        
        fname=fnames{i}((dividerplaces(end)+1):end);
        
        if fname(1)=='0',
            channel_numbers(i)=str2num(fname(2));
        else
            channel_numbers(i)=str2num(fname(1:2));
        end
    end
    if length(channel_numbers)~=size(fnames, 1),
        %A str2num conversion failed
        showMessage(ud.Handles.Texts.Message, 'Failure to extract channel number from file name', 1);
        channel_numbers=[];
        return;
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    plot_data_vs_channels    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [FH, x, y, e]=plot_data_vs_channels(input_struct)

    %Rename
    channel_order=input_struct.channel_order;
    channel_numbers=input_struct.channel_numbers;
    num_data=input_struct.num_data;
    y_data=input_struct.y_data;
    e_data=input_struct.e_data;    
    
    xticklabel=' ';
    for i=1:length(channel_order),
        channel=channel_order(i);
        
        j=find(channel==channel_numbers);
        
        num(i)=num_data(j);
        y(i)=y_data(j);
        e(i)=e_data(j)/sqrt(num(i));
        
        xticklabel=sprintf('%s%d|', xticklabel, channel);
    end
    x=1:length(channel_order);
    xticklabel=xticklabel(2:end);
    
	FH=figure;bar(x, y);
	plotSTDerrBars(FH, x, y, e, 1, 'r');
	xlabel('Channel');
	set(gca, 'XTick', x, 'XTickLabel', xticklabel, 'FontUnits', 'Normalized');
    font_size=get(gca, 'FontSize');
    YLim=get(gca, 'YLim');
    font_size=diff(YLim)*font_size;
    num_text_y=((y>=0).*(y+e+font_size)+(y<0).*(y-e-font_size*2));
    miny=min(num_text_y);
    maxy=max(num_text_y);
    YLim(1)=min(YLim(1), miny*1.2);
    YLim(2)=max(YLim(2), maxy*1.2);
    set(gca, 'YLim', YLim);
    for i=1:length(channel_order),
        text(x(i), num_text_y(i), num2str(num(i)), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom');
    end
