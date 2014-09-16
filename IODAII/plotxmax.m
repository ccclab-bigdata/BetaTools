function plotxmax(data,xmax)
    window = 10;
    figure;
    for i=1:length(xmax.loc)
        hold on;
        if(xmax.loc(i) > window && xmax.loc(i) < length(data)-window)
            plot(data(xmax.loc(i)-window:xmax.loc(i)+window));
        end
    end
end