function [signal, threshold, channel] = berkeBeta(channel, threshold, varargin)
%
% 
%
% usage: [signal, threshold, channel] = berkeBeta(channel, threshold,
%                                                 varargin)
% if supplied, varargin should be a signal structure

    defaultDrive = fullfile('/Volumes','data drive');
%     defaultDrive = '';
    
if nargin == 2
    
    LFPfn = channel.files.lfp.file;
    if LFPfn(1) == '\'
        LFPfn = PCfn2macfn(LFPfn);
    end
    
    [~, fn, ext, ~] = fileparts(LFPfn);
    
    if ~isempty(findstr(fn, '.lfp'))
        % funky work-around to get to the correct LFP files for Greg's data
        ext = '.hsdf';
        HSDfn = channel.files.highSpeedData.file;
        if ~isempty(HSDfn)
            HSDfn = PCfn2macfn(HSDfn);
            [~, fn, ~, ~] = fileparts(HSDfn);
        end
    end
    if ~isempty(defaultDrive)
        if exist([fn ext], 'file')
            LFPfn = whichx([fn ext]);
            if isempty(LFPfn)
                disp('no such lfp file');
                signal = initSignal('', 0);
                threshold = initThreshold();
            end
            LFPfn = LFPfn.path;
        end
    end

    wireNum = getRepWire(channel);
    signal = initSignal(LFPfn, wireNum);
    if ~wireNum
        disp('no good wires for this channel');
        return;
    end
    if isempty(signal.y)
        disp('lfp file does not exist.');
        return;
    end
    

else
    signal = varargin{1};
end
    
    if size(signal.y, 1) > 1
        signal.y = signal.y';
    end
    
%     threshold = initThreshold();
    threshold.compareType = 'mean';
%     threshold.filter.cutoff = [15 16 24 25];
    threshold.filter.b = designFilter(threshold.filter.cutoff, signal.Fs);
    
    signal.yfilt = filter_signal(signal.y, threshold.filter);

    if strcmpi(threshold.type, 'percentile')
        threshold.in_volts = findPercentileThresh(signal, threshold);
    else
        [signal.firstIntervals, threshold] = findBerkeRelThresh(signal, threshold);

        threshold.in_volts = threshold.users * threshold.reference;
    end
    
    [signal] = findIntervals(signal, threshold, 0);   % set last argument to 1 to plot individual
                                                      % oscillations and
                                                      % power spectra
    
    channel.timestamps.betaStart = signal.t(signal.final.start_indx);
    channel.timestamps.betaEnd = signal.t(signal.final.end_indx);
    
end    % berkeBeta

function [in_volts] = findPercentileThresh( signal, threshold )

    %Get positive and negative peaks in the filtered signal
    pos_peaks = get_peaks(signal.yfilt, 1, 'pos');
    neg_peaks = get_peaks(signal.yfilt, 1, 'neg');
    
    all_peaks = pos_peaks | neg_peaks;
    
    peakVals = signal.yfilt(all_peaks);
    peakVals = sort(peakVals);
    
    percentile = threshold.percentile;
    in_volts = peakVals(round(percentile * length(peakVals)));
    
end    % findPercentileThresh
    
    
function [firstIntervals, threshold] = findBerkeRelThresh( signal, threshold )

    current_threshold = 0.5;
    last_threshold_up = 1;
    last_threshold_down = 0;
    last_successful_threshold = 0;
 
    absolute_max = max(abs(signal.yfilt));
    %unlock is for the optional plotting of the progress of threshold search.
%     unlock=1;
    step_counter=1;
    while 1,        

        msg=sprintf('Searching for reference threshold: Step %d of %d', ...
            step_counter, ceil(-log(threshold.epsilon)/log(2)));
        disp(msg)
        disp(['threshold = ' num2str(current_threshold)]);
        step_counter=step_counter+1;

        %Activate these lines to see a plot of the search for the threshold            
%         if 0,
%             if unlock,
%                pctr=0;
%                W=0.4375; H=0.4102;
%                HF=figure('Units', 'normalized', 'Position', [(1-W)/2 (1-H)/2 W H]);
%             end
%             figure(HF);
%             plot(pctr, current_threshold, 'go', pctr, last_threshold_up, 'ro', ...
%                  pctr, last_threshold_down, 'bo');
%             legend('current best', 'too high', 'lower bound');
%             str=sprintf('Difference: %f. Must be no larger than: %f', ...
%                 last_threshold_up-current_threshold, ud.threshold.epsilon);
%             set(get(gca, 'Title'), 'String', str);
%             hold on;
%             pctr=pctr+1;
%             unlock=0;
%         end

        %Use current threshold to see whether it results in episodes
        threshold.in_volts = absolute_max * current_threshold;

        %Does this find at least threshold.ints_at_rel_threshold intervals?
        [signal] = findIntervals(signal, threshold, 0);
        
        % added 8/2/10 by DL; keep track of what the first interval was so
        % it can be labelled as "noise" if necessary
        if ~isempty(signal.final.start_indx)
            firstIntervals = signal.final;
        end
        
        if isempty(signal.final.start_indx) || ...
                length(signal.final.start_indx) < threshold.ints_at_rel_threshold,
            %Not enough intervals found. Are we at the lowest allowed threshold?
            % added criterion for length of signal 7/31/2010 - DL
            if current_threshold <= threshold.lowerbound,
                %We are already at the bottom. Abort
                showMessage(ud.Handles.Texts.Message, ...
                    'No intervals even at lowest possible threshold. Using zero threshold', 0);
                threshold.reference=0;
                threshold.users=0;
                set(fg, 'Pointer', old_ptr);
                return;
            else
                %Decrease the threshold.
                last_threshold_up = current_threshold;
                current_threshold = (current_threshold+last_threshold_down)/2;
                %Stop if the last_threshold_up came close enough to 
                %last_successful_threshold
                if last_threshold_up-last_successful_threshold <= threshold.epsilon,
                    break;
                end
                %Continue search
            end
        else
            %Intervals found. 
            %Stop if we are satisfied with this threshold
            last_successful_threshold = current_threshold;
            if last_threshold_up-current_threshold <= threshold.epsilon,
                break;
            else
                %Or continue the search by incrementing it.
                last_threshold_down = current_threshold;
                current_threshold = (current_threshold+last_threshold_up)/2;
                %Continue search
            end
        end

    end %Infinite loop while 1

    %If we reached this point, then last_successful_threshold is the largest threshold 
    %at which intervals appear. Use it as the reference threshold.
    threshold.reference = last_successful_threshold * absolute_max;
    
    
    
    %Save the new reference into record and file
%     if isempty(signals.threshold_record) | isempty(signals.threshold_record.intervalCutoff),
%         dummy_struct.intervalCutoff=threshold.intervalCutoff;
%         dummy_struct.interval_power_screen_ranges=...
%             {threshold.interval_power_screen_ranges};
%         dummy_struct.reference=threshold.reference;
%         dummy_struct.interval_power_screen_ratio=...
%             threshold.interval_power_screen_ratio;
%         dummy_struct.peak_grouping_window=threshold.peak_grouping_window;
%         dummy_struct.interval_fusion_window=threshold.interval_fusion_window;
%         
%         signals.threshold_record=dummy_struct;
%     else
%         signals.threshold_record.intervalCutoff=...
%             [signals.threshold_record.intervalCutoff threshold.intervalCutoff];
%         signals.threshold_record.interval_power_screen_ranges=...
%             {signals.threshold_record.interval_power_screen_ranges{:}, ...
%                 threshold.interval_power_screen_ranges};
%         signals.threshold_record.reference=[signals.threshold_record.reference ...
%                 threshold.reference];
%         signals.threshold_record.interval_power_screen_ratio=...
%             [signals.threshold_record.interval_power_screen_ratio ...
%                 threshold.interval_power_screen_ratio];
%         signals.threshold_record.peak_grouping_window=...
%             [signals.threshold_record.peak_grouping_window threshold.peak_grouping_window];
%         signals.threshold_record.interval_fusion_window=...
%             [signals.threshold_record.interval_fusion_window threshold.interval_fusion_window];
%     end

% 	showMessage(ud.Handles.Texts.Message, ...
%         'DONE: Searching for reference threshold', 1);
    
end    % findBerkeRelThresh
        
%%%%%%%%%%%%%%%%%%%%%%%
%    findIntervals    %
%%%%%%%%%%%%%%%%%%%%%%%
function [signal] = findIntervals(signal, threshold, plotValids)

    %Show message
%    showMessage(ud.Handles.Texts.Message, 'Finding Intervals', 0, 0.1);

    [signal.prelim.start_indx, signal.prelim.end_indx] = ...
        get_interval_starts_ends(signal, threshold);

    %For gamma, throw away intervals in which the power in 7-30 Hz is larger than that in 30-100 Hz. 
    [signal.final.start_indx, signal.final.end_indx] = interval_power_screen(signal, threshold, plotValids);
    
%     [signal.fused.start_indx, signal.fused.end_indx] = fuse_intervals(signal, threshold, 'final');
    
	%At this point, the n'th interval is defined by [signals.start_indx(n) signals.end_indx(n)]
	%where the indeces are the entry numbers in flags, and thus in
	%signals.y and my.
    
end    % findIntervals
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function get_interval_starts_ends  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [start_indx, end_indx] = get_interval_starts_ends( signal, threshold )

% INPUTS:
%   y - the filtered signal
%   threshold - structure with the following fields:
%       .in_volts - the threshold in volts
%       .peak_grouping_window - the number of cycles by which successive
%          peaks must cross the threshold to be considered an epoch
%       .intervalCutoff - minimum duration of an epoch in cycles
%       .interval_fusion_window - the maximum length of time allowed
%          between epochs before they are fused. In cycles at the minimum 
%          frequency.
%       .interval_power_screen_ranges
%       .interval_power_screen_ratio
%       .filter.cutoffs - 4 element vector containing cutoff frequencies
%           [f1,f2,f3,f4), where f1 is the upper limit on the first
%           stopband, f2 is the lower limit on the passband, f3 is the
%           upper limit on the passband, and f4 is the lower limit on the
%           upper stopband
%       .filter.b - filter coefficients
%   Fs - sampling rate (Hz)


% OUTPUTS:
%   start_indx - indices into y of the starts of epochs
%   end_indx - indices into y of the ends of epochs

    satTolerance = 0.05; % how close does the signal need to be to saturated to get discarded?
    
    if isempty(signal.yfilt)
        disp('Signal has not yet been filtered.');
        start_indx = [];
        end_indx = [];
        return;
    end
    
    t = signal.t;
    Fs = signal.Fs;
    yfilt = signal.yfilt;
    y = signal.y;
    % set yfilt to zeros during periods of noise and high voltage spindles
    % (if threshold.excludeHVS = 1)
    excludeStarts = signal.noiseIntervals.start_indx;
    excludeEnds = signal.noiseIntervals.end_indx;
    for iExcludeInt = 1 : length(excludeStarts)
        yfilt(excludeStarts(iExcludeInt):excludeEnds(iExcludeInt)) = 0;
    end
    
    if threshold.excludeHVS
        excludeStarts = signal.noiseIntervals.start_indx;
        excludeEnds = signal.noiseIntervals.end_indx;
        for iExcludeInt = 1 : length(excludeStarts)
            yfilt(excludeStarts(iExcludeInt):excludeEnds(iExcludeInt)) = 0;
        end
    end % threshold.excludeHVS
    
    if threshold.useOnlyTrials
        goodSamps = true(1, length(yfilt));
        trialStarts = signal.trials.start_indx;
        trialEnds = signal.trials.end_indx;
        for iTrialInt = 1 : length(trialStarts)
            goodSamps(trialStarts(iTrialInt) : trialEnds(iTrialInt)) = false;
        end
        goodSamps = ~goodSamps;
        yfilt = yfilt .* double(goodSamps);
    end
    %Get positive and negative peaks in the filtered signal
    pos_peaks = get_peaks(yfilt, 1, 'pos');
    neg_peaks = get_peaks(yfilt, 1, 'neg');
    % Select only those that are above threshold and eliminate those that
    % are saturated
    test_y = yfilt .* pos_peaks;
    sat_test = y .* pos_peaks;
    infraindx = find(test_y < threshold.in_volts);
    satIndx = find(sat_test > signal.satVolt - satTolerance);
    pos_peaks(infraindx) = pos_peaks(infraindx)*0;
    if ~isempty(satIndx)
        pos_peaks(satIndx) = pos_peaks(satIndx)*0;
    end
    
    test_y = yfilt .* neg_peaks;
    sat_test = y .* neg_peaks;
    infraindx = find(abs(test_y) < threshold.in_volts);
    satIndx = find(abs(sat_test) > signal.satVolt - satTolerance);
    neg_peaks(infraindx) = neg_peaks(infraindx)*0;
    if ~isempty(satIndx)
        neg_peaks(satIndx) = neg_peaks(satIndx)*0;
    end
    
    %Find interval starts and ends for both peak types
    start_indx = cell(2,1);
    end_indx = cell(2,1);
    for type = 1 : 2,
        %Rename
        if type == 1,
            flags = pos_peaks;
        else
            flags = neg_peaks;
        end
        
        %Find threshold crossings
		%At this point, flags is 1 at places where x has suprathreshold peaks
		%and zero elsewhere. Now, we need to process flags to remove intermediate lines
		ticks = find(flags == 1);
		LT = length(ticks);
        
        if LT,
			diffs = ticks(2:LT)-ticks(1:LT-1);
			largest_prd = threshold.peak_grouping_window / threshold.filter.cutoff(2);
            % largest_prd (largest_period) is the number of cycles
            % (contained in "peak_grouping_window") divided by the lower
            % limit of the passband of the filtered signal. largest_prd is
            % in seconds
			merge_width = Fs * largest_prd;
            % merge_width is the number of samples contained in largest_prd
			indx = find(diffs >= merge_width);
			% find peaks where the distance to the next peak is greater
            % than merge_width
            
			end_indx(type)={ticks([indx LT])};
			start_indx(type)={ticks([1 indx+1])};
			
			%Reject intervals shorter than P periods of the lowest frequency in the passband
			intervalCutoffDuration = threshold.intervalCutoff / threshold.filter.cutoff(2);
			durations = t(end_indx{type}) - t(start_indx{type});
			valids = find(durations >= intervalCutoffDuration);
			end_indx(type) = {end_indx{type}(valids)};
			start_indx(type) = {start_indx{type}(valids)};

        else
			end_indx(type)={[]};
			start_indx(type)={[]};
        end%if LT,
    end %for type=1:2,
    
    %Now we have the starts and ends computed using the positive and negative peaks
    %Take the logical OR of them.
    int_pos = get_interval_bitfield(length(signal.y), start_indx{1}, end_indx{1});
    int_neg = get_interval_bitfield(length(signal.y), start_indx{2}, end_indx{2});
    
    %OR
    int_all = int_pos | int_neg;
    int_all = [0 int_all 0];
    
    %differentiate
    int_new = diff(int_all);
    
    start_indx = find(int_new==1);
    end_indx = find(int_new==-1)-1;
    
    signal.prelim.start_indx = start_indx;
    signal.prelim.end_indx = end_indx;
    
    %At this point signals.start_indx and signals.end_indx contain the start and end
    %indeces of the intervals. Now, fuse those that are too close to each other
    [start_indx, end_indx] = fuse_intervals(signal, threshold, 'prelim');
    
end    % get_interval_starts_ends

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    get_interval_bitfield    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bit_field = get_interval_bitfield(n, start_indx, end_indx)
    
    bit_field = zeros(1, n+1);
    
    %put diracs
    bit_field(start_indx) = bit_field(start_indx)+1;
    bit_field(end_indx+1) = bit_field(end_indx+1)-1;
    
    %integrate
    bit_field = cumsum(bit_field);
    bit_field = bit_field(1:end-1);    
    
end    % get_interval_bitfield
    
%%%%%%%%%%%%%%%%%%%%%%%%
%    fuse_intervals    %
%%%%%%%%%%%%%%%%%%%%%%%%
function [start_indx, end_indx] = fuse_intervals(signal, threshold, useInts)

    t = signal.t;
    start_indx = signal.(useInts).start_indx;
    end_indx = signal.(useInts).end_indx;
    
    Ni = length(start_indx);    % number of intervals

    %Just return if interval fusion window is zero or there are at most 1 intervals
    if threshold.interval_fusion_window == 0 || Ni < 2,
        return;
    end

    range = 1:Ni-1;
    
    inter_interval_gaps = t(start_indx(range+1))-...
                          t(end_indx(range));

    %Find those that are too short
    fusion_window = threshold.interval_fusion_window / threshold.filter.cutoff(2);
    % fusion_window is the maximum amount of time allowed between epochs
    % before they should be fused (in seconds)
    too_short_indx = find(inter_interval_gaps <= fusion_window);
    
    if isempty(too_short_indx),
        return;
    end
    
    start_indx(too_short_indx+1) = start_indx(too_short_indx+1).*0-1;    
    valids = start_indx~=-1;
    start_indx = start_indx(valids);

    end_indx(too_short_indx) = end_indx(too_short_indx).*0-1;    
    valids = end_indx~=-1;
    end_indx = end_indx(valids);

end    % fuse_intervals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    interval_power_screen    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [start_indx, end_indx] = interval_power_screen(signal, threshold, plotValids)

% INPUTS:
%   signal - standard signal structure
%   threshold - threshold structure (for details, see top of m-file)
%   start_indx - start indices of candidate epochs
%   end_indx - end indices of candidate epochs
%   Fs - sampling rate of y in Hz

    compareType = threshold.compareType;
    y = signal.y;
    start_indx = signal.prelim.start_indx;
    end_indx = signal.prelim.end_indx;
    Fs = signal.Fs;
    %If no range or ratio to use, or no intervals, return.
    ranges = threshold.interval_power_screen_ranges;
    ratio = threshold.interval_power_screen_ratio;
    if isempty(ranges) || isempty(start_indx) || isempty(ratio),
        return;
    end

    num_of_ints = length(start_indx);
    durations = end_indx - start_indx;
    
    nfft = 2 ^ nextpow2(max(durations));
%     nfft_dummy1 = ceil(log(max(durations))/log(2));
%     nfft=2^nfft_dummy1;

    powerRat = zeros(num_of_ints);
    numValids = 0;
    temp = zeros(num_of_ints, (nfft / 2) + 1);
    for i=1:num_of_ints,
        [Pxx,f] = periodogram(detrend(y(start_indx(i):end_indx(i))), ...
                              [], nfft, Fs);
                          
        stopbandranges = [];
        for j = 1 : size(ranges, 1),
            stopbandranges = [stopbandranges find(f'>=ranges(j,1) & f'<=ranges(j,2))];
        end
        passband=find(f>=threshold.filter.cutoff(2) & f<=threshold.filter.cutoff(3));

        %Check whether the bands overlap. This may happen in batch mode if files that have different
        %passbands are somehow processed using the same stopband
        testfield=ones(1, length(Pxx));
        testfield(stopbandranges)=testfield(stopbandranges).*0;
        if any(testfield(passband)==0),
            errmsg='The stopband for interval power screen overlaps with passband!';
            showMessage(ud.Handles.Texts.Message, errmsg, 0, 0.1);
            errordlg(errmsg);
        end
        
        
        compareString = ['ratio*' compareType '(Pxx(stopbandranges))>' compareType '(Pxx(passband))'];
        if eval(compareString),    % "mean" instead of "sum" - 
                                   % "sum" was used in origninal eegrhythm code
           start_indx(i)=-1; 
        else
            numValids = numValids + 1;
            powerRat(numValids) = eval([compareType '(Pxx(passband)) / ' compareType '(Pxx(stopbandranges))']);
            temp(numValids, :) = Pxx';
        end
    end
    
    valids = start_indx~=-1;
    start_indx = start_indx(valids);    
    end_indx = end_indx(valids);        

    if plotValids
        for i = 1 : length(start_indx)
            figure(1)
            hold off
            plot(signal.t(start_indx(i) - 100:end_indx(i) + 100), ...
                signal.y(start_indx(i) - 100:end_indx(i) + 100));
            hold on
            plot(signal.t(start_indx(i):end_indx(i)), ...
                signal.y(start_indx(i):end_indx(i)),'r');
            figure(2)
            plot(f, temp(i,:))
            set(gca,'xlim',[0 80]);
            set(gcf,'name',['ratio = ' num2str(powerRat(i))]);
            keyboard;
        end
    end
end    % interval_power_screen

%%%%%%%%%%%%%%%%
% designFilter %
%%%%%%%%%%%%%%%%
function b = designFilter(cutoffs, Fs)

	M = [0 1 0];
	[n,fo,mo,w] = firpmord(cutoffs, M, [1 1 1]*0.01, Fs);
	b = firpm(n,fo,mo,w);
    
end    % designFilter

%%%%%%%%%%%%%%%%%%%%%%%
%    filter_signal    %
%%%%%%%%%%%%%%%%%%%%%%%
function yfilt = filter_signal(y, filtParams)

   
	disp('filtering signal')

	yfilt = filtfilt(filtParams.b, filtParams.a, y);
	disp('Status: Done Filtering EEG');

    
end    % filter_signal