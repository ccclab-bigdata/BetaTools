figure;
for i=1:size(filtDataM1,1)
    hold on;
    plot(filtDataS1(i,1:1e5));
    hold on;
    plot(filtDataM1(i,1:1e5),'r');
end

% stdPhasesS1 = std(phasesS1);
% stdPhasesM1 = std(phasesM1);
% plot(smooth(stdPhasesS1,100));
% hold on;
% plot(smooth(stdPhasesM1,100),'r');

for i=2:size(dataM1,1)
    figure;
    plot(dataS1(1,1:1e5));
    hold on;
    plot(dataS1(i,1:1e5),'r');
end