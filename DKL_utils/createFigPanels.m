function [h_fig, h_axes] = createFigPanels(figProps, varargin)

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

fullPanelWidth = sum(figProps.panelWidth) + (n - 1) * figProps.colSpacing;
ltMargin = (figProps.width - fullPanelWidth) / 2;
if ltMargin < 0
    disp('panels will not fit horizontally');
    return;
end
fullPanelHeight = sum(figProps.panelHeight) + (n - 1) * figProps.rowSpacing;
botMargin = (figProps.height - fullPanelHeight) / 2;
if botMargin < 0
    disp('panels will not fit vertically');
    return;
end

for iRow = 1 : m
    
    for iCol = 1 : n
    
        leftEdge = ltMargin + sum(figProps.panelWidth(1:iCol-1)) + (iCol-1) * figProps.colSpacing;
        if iRow == m
            botEdge = botMargin;
        else
            botEdge  = botMargin + sum(figProps.panelHeight(iRow+1:end)) + (m - iRow) * figProps.rowSpacing;
        end
        h_axes(iRow, iCol) = axes('parent',h_fig, ...
                                  'units',unitName, ...
                                  'position',[leftEdge, botEdge, figProps.panelWidth(iCol), figProps.panelHeight(iRow)]);
                              
    end
    
end