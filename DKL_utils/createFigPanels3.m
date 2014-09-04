function [h_fig, h_axes] = createFigPanels3(figProps, varargin)
% this version allows for different numbers of columns in each row

unitName = 'centimeters';
for iarg = 1 : 2 : nargin - 1
    switch lower(varargin{iarg})
        case 'units',
            unitName = varargin{iarg + 1};
    end
end

h_fig = figure('units',unitName,...
               'position',[1 1 figProps.width figProps.height], ...
               'color','w');
           
m = figProps.m; n = figProps.n;

h_axes = zeros(m, n);

fullPanelWidth = max(sum(figProps.panelWidth,2) + sum(figProps.colSpacing,2));
ltMargin = (figProps.width - fullPanelWidth) / 2;
if ltMargin < 0
    disp('panels will not fit horizontally');
    return;
end
fullPanelHeight = sum(figProps.panelHeight) + sum(figProps.rowSpacing);
botMargin = (figProps.height - fullPanelHeight) / 2;
if botMargin < 0
    disp('panels will not fit vertically');
    return;
end

for iRow = 1 : m
    
    for iCol = 1 : n
    
        if figProps.panelWidth(iRow, iCol) > 0
            leftEdge = ltMargin + sum(figProps.panelWidth(iRow,1:iCol-1)) + sum(figProps.colSpacing(iRow,1:iCol-1));
            if iRow == m
                botEdge = botMargin;
            else
                botEdge  = botMargin + sum(figProps.panelHeight(iRow+1:end)) + sum(figProps.rowSpacing(iRow:end));
            end
            h_axes(iRow, iCol) = axes('parent',h_fig, ...
                                      'units',unitName, ...
                                      'position',[leftEdge, botEdge, figProps.panelWidth(iRow,iCol), figProps.panelHeight(iRow)]);
        end
                              
    end
    
end