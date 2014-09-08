%%% Re-references ECoG data in a Z Struct to the common average:
function Zout = CAR(Zin, numElectrodes, ncElectrodes)

% Copy Z Struct to output, generate electrode list:
Zout = Zin;
elist = setdiff(1:numElectrodes, ncElectrodes);

% Iterate through each trial:
for i = 1:length(Zin)
    
    % Skip empty trials:
    if (isempty(Zin(i).ECoG))
        continue;
    end
    
    % Generate CARs for each bank:
    CAR = zeros(ceil(numElectrodes/32), length(Zin(i).ECoG(1).Data));
    for j = 1:size(CAR, 1)
        
        c = setdiff((j-1)*32+1:min(numElectrodes, j*32), ncElectrodes);
        CAR(j,:) = sum(cell2mat(arrayfun(@(x) Zin(i).ECoG(x).Data, c, 'UniformOutput', false)'), 1)/length(c);
        
    end
    
    % Re-reference each channel:
    for j = 1:length(elist)
        
        Zout(i).ECoG(elist(j)).Data = Zout(i).ECoG(elist(j)).Data - CAR(ceil(elist(j)/32),:);
        
    end
    
end

end