function run_multichannelSlopes(NS5,NEV)
    dir = uigetdir;
    samples = 9e6;
    unit = 1;
    channels = [1,18,26,27,28,29,30,31,35,36,42,48,54,62,63,82,83,92];
    
    window = 3:3:30;
    range = 10:3:90;
    
    for k=1:length(window)
        for j=1:length(range)
            Fs = 30000;  % Sampling Frequency

            Fpass1 = range(j);          % First Passband Frequency
            Fpass2 = range(j)+window(k);          % Second Passband Frequency
            
            Fstop1 = Fpass1-1;          % First Stopband Frequency
            Fstop2 = Fpass2+1;          % Second Stopband Frequency
            
            Astop1 = 3;           % First Stopband Attenuation (dB)
            Apass  = 1;           % Passband Ripple (dB)
            Astop2 = 3;           % Second Stopband Attenuation (dB)
            match  = 'stopband';  % Band to match exactly

            % Construct an FDESIGN object and call its BUTTER method.
            h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                                  Astop2, Fs);
            Hbp = design(h, 'butter', 'MatchExactly', match);
            
            h1=figure('position',[0 0 900 900]);
            h2=figure('position',[0 50 900 900]);

            for i=1:length(channels)
                data = double(NS5.Data(channels(i),1:samples));
                % % HPdata = wavefilter(data,5);
                [allTimestamps,allSnippets,allIndices] = findEventTimes(NEV,channels(i),unit);
                validInd = find(allTimestamps<samples);

                % % figure;
                % % plot(HPdata);
                % % hold on;
                % % plot(allTimestamps(validInd),HPdata(allTimestamps(validInd)),'o','color','red');
                % % legend('Highpass','Spikes');

                % spikeTimes = allTimestamps/3e4;
        % %         smoothData = Smooth(data,100);

                % % figure;
                % % plot(data);
                % % hold on;
                % % plot(smoothData,'m');
                % % hold on;
                % % plot(allTimestamps(validInd),data(allTimestamps(validInd)),'o','color','red');
                % % title(strcat('Channel:',num2str(channel),', Spikes:',num2str(length(validInd))));
                % % legend('Raw','Smoothed','Spikes');

                smoothData = filter(Hbp,data);
                diffData = diff(smoothData);
                [h,p,ci,stats] = ttest(diffData);

                % % figure;
                % % plot(diffData);
                % % hold on;
                % % plot(allTimestamps(validInd),diffData(allTimestamps(validInd)),'o','color','red');
                % % legend('diff(smoothed)','Spikes');

                diffVals = diffData(allTimestamps(validInd));

                figure(h1);
                subplot(6,3,i);
                hist(diffVals,25);
                xlim([-5 5]);
                title(strcat('Channel:',num2str(channels(i)),', Spikes:',...
                    num2str(length(validInd)),' p:',num2str(p)));

                figure(h2);
                subplot(6,3,i);
                pie([length(find(diffVals>0)),length(find(diffVals<0))]);
                title(strcat('Channel:',num2str(channels(i)),', Spikes:',...
                    num2str(length(validInd)),' p:',num2str(p)));
            end
            %legend('>0','<0','location','northeast');
            figure(h1);
            suptitle(strcat('Slopes:',num2str(Fpass1),'-',num2str(Fpass2)));
            saveas(h1,fullfile(dir,strcat('hist_',num2str(Fpass1),'-',num2str(Fpass2),'Hz.fig')));
            close(h1);
            
            figure(h2);
            suptitle(strcat('Slopes (Blue>0, Red<0):',num2str(Fpass1),'-',num2str(Fpass2)));
            saveas(h2,fullfile(dir,strcat('pie_',num2str(Fpass1),'-',num2str(Fpass2),'Hz.fig')));
            close(h2);                      
        end
    end