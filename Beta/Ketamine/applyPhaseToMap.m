function applyPhaseToMap(phases,map)
    phaseMaps = NaN(size(map,1),size(map,2),size(phases,2));
    for i=1:size(phases,2) %samples
        for j=1:size(phases,1) %channels
            [y,x] = find(map==j);
            phaseMaps(x,y) = phases(j,i);
        end
    end
end