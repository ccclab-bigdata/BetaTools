%[groupPhasesS1,groupPhasesM1]=followAnalysis(phasesS1,phasesM1);
function [groupPhases1,groupPhases2]=followAnalysis(phases1,phases2)
    groupPhases1 = [];
    groupPhases2 = [];
    for i=1:length(phases1)
        if(mod(i,10000)==0)
            disp(i)
        end
        % get bins of phases, seperated at 45-degrees (n=8)
        [counts1,centers1] = hist(phases1(:,i),8);
        [v,k] = max(counts1);
        groupPhases1(i) = centers1(k);
        
        [counts2,centers2] = hist(phases2(:,i),8);
        [v,k] = max(counts2);
        groupPhases2(i) = centers2(k);
    end
    figure;
    plot(smooth(groupPhases1,1000));
    hold on;
    plot(smooth(groupPhases2,1000),'r');
    legend('S1','M1');
end