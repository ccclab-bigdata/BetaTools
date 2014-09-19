for j=0:8:0
    figure('position',[0 0 700 1500]);
    window = 100000;
    start = 1;

    subplot(9,1,1);
    plot(fingerVector(etimes(start):etimes(start+window)));
    xlim([0 window]);
    ylim([0 1]);
    title('Finger Movement');

    params.fpass = [13 30];
    params.fs = 30000;

    for i=1:8
        subplot(9,1,i+1);
        betaspec(double(NS5.Data(j+i,ctimes(start):ctimes(start+window))));
        title(strcat('Channel ',int2str(j+i)));
    end
end