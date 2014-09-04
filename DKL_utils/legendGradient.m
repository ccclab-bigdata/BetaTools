function h_patch = legendGradient(h_axes, legendPos, colList, varargin)
%
% usage: 
%
% INPUTS:
%   h_axes - axis handle
%   legendPos - 4-element vector containing [x,y,width,height]
%   colList - cell array containing a list of colors to include in the bar
%
% VARARGs:
%   'orientation' - 'horizontal' or 'vertical'. Default horizontal

legendOrient = 'horizontal';
legendDir = 'normal';    % from left to right or bottom to top. alternative is 'reverse' - right to left or top to bottom
% legendUnits = 'centimeters';
blockLabels = {};
labelSide = 'left';

axes(h_axes);
fontSize = get(gca,'fontsize');

for iarg = 1 : 2 : nargin - 3
    switch lower(varargin{iarg})
        case 'orientation',
            legendOrient = varargin{iarg + 1};
        case 'direction',
            legendDir = varargin{iarg + 1};
%         case 'units',
%             legendUnits = varargin{iarg + 1};
        case 'labelside',
            labelSide = varargin{iarg + 1};
        case 'fontsize',
            fontSize = varargin{iarg + 1};
        case 'blocklabels',
            blockLabels = varargin{iarg + 1};
    end
end

numBlocks = length(colList);

textPos = zeros(numBlocks, 2);

% FIGURE OUT HOW TO CONVERT FONT SIZE INTO DATA UNITS
maxTextLength = 0;
for iLabel = 1 : length(blockLabels)
    if length(blockLabels{iLabel}) > maxTextLength
        maxTextLength = length(blockLabels{iLabel});
    end
end
switch lower(legendOrient)
    case 'horizontal',
        ypos = ones(1, numBlocks+1) * legendPos(2);
        blockHeight = ones(1, numBlocks) * legendPos(4);
        
        xpos = linspace(legendPos(1), legendPos(1) + legendPos(3), numBlocks + 1);
        blockWidth = diff(xpos);
        
        textPos(:, 1) = xpos(1:numBlocks)';
        switch lower(labelSide)
            case 'top',
                textPos(:, 2) = ones(1, numBlocks) * (ypos(1) + (blockHeight(1) * 1.1));
            case 'bottom',
                textPos(:, 2) = ones(1, numBlocks) * (ypos(1) - pts2data(gca,fontSize) * 1.1);
        end
        
    case 'vertical',
        xpos = ones(1, numBlocks+1) * legendPos(1);
        blockWidth = ones(1, numBlocks) * legendPos(3);
        
        ypos = linspace(legendPos(2), legendPos(2) + legendPos(4), numBlocks + 1);
        blockHeight = diff(ypos);
        
        textPos(:, 2) = ypos(1:numBlocks)';
    switch lower(labelSide)
        case 'left',
            textPos(:,1) = ones(1, numBlocks) * (legendPos(1) - 0.9*(xpts2data(gca,fontSize))*maxTextLength);
        case 'right',
            textPos(:,1) = ones(1, numBlocks) * (legendPos(1) + 1.2 * blockWidth(1));
    end
end



h_patch = zeros(1, numBlocks);
for iCol = 1 : numBlocks
    
    switch legendDir
        case 'normal',
            colIdx = iCol;
        case 'reverse',
            colIdx = numBlocks - iCol + 1;
    end
    
    patch_x = [xpos(colIdx), xpos(colIdx)+blockWidth(colIdx), xpos(colIdx)+blockWidth(colIdx), xpos(colIdx)];
    patch_y = [ypos(colIdx), ypos(colIdx), ypos(colIdx) + blockHeight(colIdx), ypos(colIdx) + blockHeight(colIdx)];
    
    h_patch(iCol) = patch(patch_x, patch_y, colList{iCol}, ...
                          'edgecolor', colList{iCol});
    
	if ~isempty(blockLabels)
        h_text = text(textPos(colIdx,1),textPos(colIdx,2),blockLabels{iCol},...
                      'color',colList{iCol}, ...
                      'verticalalignment','bottom',...
                      'fontsize',fontSize);
    end
end