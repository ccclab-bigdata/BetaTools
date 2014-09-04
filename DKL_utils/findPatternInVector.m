function startElements = findPatternInVector(searchVector, findVector)

% make sure both are row vectors
if size(searchVector, 1) > size(searchVector, 2)
    searchVector = searchVector';
end
if size(findVector, 1) > size(findVector, 2)
    findVector = findVector';
end

startElements = [];
for i = 1 : length(searchVector) - length(findVector) + 1
    if all(searchVector(i:i+length(findVector)-1) == findVector)
        startElements = [startElements, i];
    end
end
    