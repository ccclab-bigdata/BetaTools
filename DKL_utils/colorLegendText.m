function colorLegendText(legend_h, colList, varargin)

hideLines = 1;

for iarg = 1 : 2 : nargin - 2
    switch lower(varargin{iarg})
        case 'hidelines',
            hideLines = varargin{iarg + 1};
    end
end

object_h = get(legend_h, 'children');
object_h = flipud(object_h);

text_h = []; line_h = [];hggroup_h = [];
for iObject = 1 : length(object_h)
    
    switch lower(get(object_h(iObject), 'type'))
        case 'line',
            line_h = [line_h; object_h(iObject)];
        case 'text',
            text_h = [text_h; object_h(iObject)];
        case 'hggroup',
            hggroup_h = [hggroup_h; object_h(iObject)];
    end
end

numLabels = length(text_h);
                                           
for iLabel = 1 : numLabels
    set(text_h(iLabel), 'color', colList{iLabel});
    
end

if hideLines
    for iLine = 1 : length(line_h)
        set(line_h(iLine), 'visible', 'off');
    end
    for ihggroup = 1 : length(hggroup_h)
        set(hggroup_h(ihggroup), 'visible', 'off');
    end
end