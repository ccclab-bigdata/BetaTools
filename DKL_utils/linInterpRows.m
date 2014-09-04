function interpData = linInterpRows(data)

interpData = data;
m = size(data, 1);
n = size(data, 2);

for iRow = 1 : m
    
    if isnan(data(iRow, 1))
        interpData(iRow, 1) = interpData(iRow, 2);
    end
    if isnan(data(iRow, n))
        interpData(iRow, n) = interpData(iRow, n - 1);
    end
    for iCol = 2 : n - 1
        
        if isnan(data(iRow, iCol))
            interpData(iRow, iCol) = mean([interpData(iRow, iCol-1), interpData(iRow, iCol + 1)]);
        end
    end
end
        