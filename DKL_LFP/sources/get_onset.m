function onset_indx_array=get_onset(package, params)
%[onset_indx_array, return_flag]=get_onset(package, params, ud)
%Compute the onset of episodes contained in intervals. Return the index of onset points.
%Author: Murat Okatan. 04/10/03.

%version 3. Allow onsets to be found inside intervals too.
%version 2. Report onsets only if the average power increases monotonically toward
%   the interval start.
%version 1. Compute the onset of episodes contained in intervals. Return the index of 
%onset points.

%Default
return_flag=0;
onset_indx_array=[];

%Rename
power_ratio=params(1);
power_window=params(2);
search_window=params(3);
check_window=params(4);
signals=package.saved_signals;
myfilter=package.saved_filter;

%process each interval.
counter=1;
for i=1:length(signals.start_indx),
    range=signals.start_indx(i):signals.end_indx(i);
    signal_segment=signals.y(range);
    [Pxx, fxx]=periodogram(signal_segment, [], length(signal_segment), package.Fs);
    tfrange=find(fxx>=myfilter.F(2) & ...
                 fxx<=myfilter.F(3));
    if isempty(tfrange),
        tfrange=1:length(fxx);
    end
    max_indx=find(Pxx(tfrange)==max(Pxx(tfrange)))+tfrange(1)-1;
    f_max=min(myfilter.F(2), ...
              max(myfilter.F(3), fxx(max_indx)));
    Niw=max(1, round(package.Fs/f_max*power_window));

    %What is the average power within the interval?
    avg_pow=sum(signal_segment.^2)/length(signal_segment);
    
    %Find the first point closest to the start of the interval from the left
    %where the average power over the integration window is power_ratio of the avg_pow
    %Consider a search_window cycles window before the interval's start point
    Sw=max(1, round(package.Fs/f_max*search_window));
    Sw=max(Sw, Niw);
    power_sig_range=max(1, signals.start_indx(i)-Sw):...
                    min(length(signals.t), signals.start_indx(i)+(Niw-1));
    power_sig=signals.y(power_sig_range).^2;
    avg_power_sig=filter(ones(1, Niw)/Niw, 1, power_sig);
    avg_power_sig=avg_power_sig(Niw:end);
    plot_trange=signals.t(signals.start_indx(i)-[length(avg_power_sig):-1:1]);
    ox=1;
    
    %Find the next point to the latest point that is below or eq. to power_ratio*avg_pow
    onset_indx=max(find(avg_power_sig<=avg_pow*power_ratio))+1;
    if isempty(onset_indx),
        continue;
    end
    %What is the distance between the interval's start and the onset_indx?
    offset=onset_indx-length(avg_power_sig);

    if onset_indx==length(avg_power_sig)+1,
        %The onset is somewhere within the interval. Search it inside.
        if signals.end_indx(i)-signals.start_indx(i)+1<Niw,
            %The integral length is shorter than integration length
            continue;
        end
        
        %Find the first point closest to the start of the interval from the right
        %where the average power over the integration window is power_ratio the avg_pow
        power_sig_range=signals.start_indx(i):signals.end_indx(i);
        power_sig=signals.y(power_sig_range).^2;
        avg_power_sig=filter(ones(1, Niw)/Niw, 1, power_sig);
        avg_power_sig=avg_power_sig(Niw:end);
        plot_trange=signals.t(signals.start_indx(i)+[0:length(avg_power_sig)-1]);
        
        %Find the first point that is above the power_ratio*avg_pow
        onset_indx=min(find(avg_power_sig>avg_pow*power_ratio));
        if isempty(onset_indx),
            continue;
        elseif onset_indx==length(avg_power_sig)+1,
            %The onset is too close to the interval end
            continue;
        end
        
        %What is the distance between the interval's start and the onset_indx?
        offset=onset_indx-1;
        ox=0;
    end    
    
    %What is the onset index in signal coordinates?
    onset_indx_insignal=signals.start_indx(i)+offset;
    
    %Now check whether the average power creeps above this level within 5 cycles
    %to the left of the onset point.
    Cw=max(1, round(package.Fs/f_max*check_window));
    Cw=max(Cw, Niw);
    check_range=max(1, onset_indx_insignal-1-Cw):...
                    min(length(signals.t), onset_indx_insignal-1+(Niw-1));
    check_sig=signals.y(check_range).^2;
    avg_check_sig=filter(ones(1, Niw)/Niw, 1, check_sig);
    avg_check_sig=avg_check_sig(Niw:end);

    %Enable to plot power curves and threshold
    if 0,
		figure;
		plot(plot_trange, avg_power_sig);
		XLim=get(gca, 'XLim');
		YLim=get(gca, 'YLim');
		line(XLim, [1 1]*avg_pow*power_ratio);
        line(signals.t(signals.start_indx(i))*[1 1], YLim);
        line(signals.t(signals.end_indx(i))*[1 1], YLim);
		
		hold on;
		plot(signals.t(onset_indx_insignal-ox-[length(avg_check_sig):-1:1]), avg_check_sig, 'ro');
		XLim=get(gca, 'XLim');
    end
    
    indx=find(avg_check_sig>avg_pow*power_ratio);
    if ~isempty(indx),
        %There are points that are above this level within check_window cycles to
        %the left of the onset point. Ignore this one.
        continue;
    end

    %Enable to plot power curves and threshold
    if 0,
		figure;
		plot(plot_trange, avg_power_sig);
		XLim=get(gca, 'XLim');
		YLim=get(gca, 'YLim');
		line(XLim, [1 1]*avg_pow*power_ratio);
        line(signals.t(signals.start_indx(i))*[1 1], YLim);
        line(signals.t(signals.end_indx(i))*[1 1], YLim);
		
		hold on;
		plot(signals.t(onset_indx_insignal-ox-[length(avg_check_sig):-1:1]), avg_check_sig, 'ro');
		XLim=get(gca, 'XLim');
    end
    
    %Keep the onset
    onset_indx_array(counter)=onset_indx_insignal;
    counter=counter+1;
end%i=1:length(signals.start_indx),