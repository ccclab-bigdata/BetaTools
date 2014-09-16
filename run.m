figure;
window = 200;

for i=1:50:5000
    subplot(2,1,1);
    plot(fingerVector(etimes(0+i):etimes(window+i)));
    xlim([0 window]);
    ylim([0 1]);
    subplot(2,1,2);
    params.fpass = [13 30];
    params.fs = 30000;
    [S,f] = mtspectrumc(double(NS5.Data(3,ctimes(0+i):ctimes(window+i))),params);
    plot_vector(S,f);
    xlim([13 30]);
    ylim([0 30]);
    pause(.01);
end

