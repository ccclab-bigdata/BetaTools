function [commonElements] = commonElements(A, varargin)

% function to find the common elements of 2 or more vectors.

% INPUTS:
%   A - either the first of multiple vectors, or a cell array of vectors

% varargin:
%   any additional vectors to check

if iscell(A)
    vectors = A;
else
    vectors{1} = A;
end

for iarg = 1 : nargin - 2
    vectors{length(vectors) + iarg} = varargin{iarg};
end

commonElements = vectors{1};
for iVector = 2 : length(vectors)
    
    numCommonElements = 0;
    updatedCommonElements = [];
    for iElement = 1 : length(commonElements)
        
        if any(vectors{iVector} == commonElements(iElement))
            numCommonElements = numCommonElements + 1;
            updatedCommonElements(numCommonElements) = ...
                commonElements(iElement);
        end
    end
    
    commonElements = updatedCommonElements;
    
end