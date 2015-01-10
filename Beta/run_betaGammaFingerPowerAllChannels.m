% openNSx('read');
% openNEV
% load zStruct
function run_betaGammaFingerPowerAllChannels(NS5,NEV,z)
    dir = uigetdir;
    samples = 9e6;
    runTime = samples/3e4; %seconds
    channels = 28:30;

    [etimes,ctimes,~] = FixCerebusTimes(NEV);
    fingerVector = makeFingerVector(z);

    for i=1:length(channels)
        channel = channels(i);
        disp(strcat('channel:',num2str(channel)));
        data = double(NS5.Data(channel,1:samples));

        % get spectogram data
        [tB,fB,SnormB] = spectogramData(data,[17 40]);
        [tG,fG,SnormG] = spectogramData(data,[40 90]);
        % take average of Snorm matrix and normalize it to span 0-1
        meanBeta = normalize(smooth(mean(SnormB)));
        smoothBeta = meanBeta;
        %smoothBeta = smooth(meanBeta,15);
        meanGamma = normalize(smooth(mean(SnormG)));
        smoothGamma = meanGamma;
        %smoothGamma = smooth(meanGamma,15);

        xend = samples/3e4;
        h1 = figure('position',[0,0,1200,1000]);

        subplot(5,1,1);
        plot(linspace(0,runTime,samples),data);
        xlim([0 xend]);
        title('Raw Data');
        ylabel('Amplitude');
        xlabel('Time (s)');

        Hbp = makeBpFilt(17,40);
        BPdata = filter(Hbp,data);
        subplot(5,1,2);
        plot(linspace(0,runTime,samples),BPdata);
        xlim([0 xend]);
        title('Bandpass Data');
        ylabel('Amplitude');
        xlabel('Time (s)');

        subplot(5,1,3);
        fingerMaxIdx = find(ctimes<=1e6,1,'last');
        fingerData = fingerVector(1:int32(runTime*1e3));
        plot(runTime/length(fingerData):runTime/length(fingerData):runTime,fingerData,'color','k'); %s to ms
        hold on;
        plot(tB,smoothBeta,'b','LineWidth',3);
        hold on;
        plot(tG,smoothGamma,'r','LineWidth',3);

        xlim([0 xend]);
        title('Power');
        ylabel('normalized power');
        xlabel('Time (s)');
        legend('Finger','Beta','Gamma');

        subplot(5,1,4);
        imagesc(tB,fB,SnormB);
        xlim([0 xend]);
        title('Beta 13-30Hz');
        ylabel('frequency');
        xlabel('Time (s)');

        subplot(5,1,5);
        imagesc(tG,fG,SnormG);
        xlim([0 xend]);
        title('Gamma 30-90Hz');
        ylabel('frequency');
        xlabel('Time (s)');

        suptitle(strcat('Channel:',num2str(channel)));
        saveas(h1,fullfile(dir,strcat('betaGammaFinger_ch',num2str(channel),'.jpg')),'jpg');
        saveas(h1,fullfile(dir,strcat('betaGammaFinger_ch',num2str(channel))),'fig');
        close(h1);
    end
end

function Hbp=makeBpFilt(Fpass1,Fpass2)
    Fs = 30000;  % Sampling Frequency

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
end