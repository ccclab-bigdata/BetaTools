function indicatePairwiseSignificance(h_axes, x, y, ybar, p, varargin)
%
% usage:
%
% INPUTS:
%   h_axes - handle of the axes on which to place the significance
%       indicator
%   x - x at which the y were measured (vector)
%   y - y values (vector)
%   p - m x 3 array where in each row, the first value is the index
%       of one x,y pair; the second value is the index of a second x,y
%       pair, and the third value is the actual p-values

sigThresh     = 0.05;
sigIndicator  = '*';
sigCol        = 'k';
indicatorSide = 'pos';
x_offset      = 0;
y_offset      = 0.05;    % amount to add so that horizontal lines between two different sessions don't overlap
ytextOffset   = 0.05;
barOffset     = 0.01;
for iarg = 1 : 2 : nargin - 5
    switch lower(varargin{iarg})
        case 'sigthresh',
            sigThresh = varargin{iarg + 1};
        case 'sigindicator',
            sigIndicator = varargin{iarg + 1};
        case 'color',
            sigCol = varargin{iarg + 1};
        case 'indicatorside',
            indicatorSide = varargin{iarg + 1};   % 'pos' or 'neg'
        case 'xoffset',
            x_offset = varargin{iarg + 1};
        case 'yoffset',
            y_offset = varargin{iarg + 1};
        case 'ytextoffset',
            ytextOffset = varargin{iarg + 1};
        case 'baroffset',
            barOffset = varargin{iarg + 1};
    end
end

numComparisons = size(p, 1);

numSigComparisons = 0;
ylimits = get(h_axes, 'ylim');
yrange  = diff(ylimits);

axes(h_axes);

for iComparison = 1 : numComparisons
    
    if p(iComparison, 3) < sigThresh
        
        numSigComparisons = numSigComparisons + 1;
        
        idx1 = p(iComparison, 1);
        idx2 = p(iComparison, 2);

        pos_yline = max([y(idx1) + ybar(idx1) + barOffset * yrange, ...
                         y(idx2) + ybar(idx2) + barOffset * yrange]) + ...
                        (y_offset * numSigComparisons * yrange);
        neg_yline = min([y(idx1) - ybar(idx1) - barOffset * yrange, ...
                         y(idx2) - ybar(idx2) - barOffset * yrange]) - ...
                        (y_offset * numSigComparisons * yrange);
        if strcmpi(indicatorSide, 'pos')
            yline = pos_yline;
            ytext = yline + ytextOffset * yrange;
            y1 = y(idx1) + ybar(idx1) + barOffset * yrange;
            y2 = y(idx2) + ybar(idx2) + barOffset * yrange;
        else
            yline = neg_yline;
            ytext = yline - ytextOffset * yrange;
            y1 = y(idx1) - ybar(idx1) - barOffset * yrange;
            y2 = y(idx2) - ybar(idx2) - barOffset * yrange;
        end
        line([x(idx1), x(idx2)] + x_offset, ...
             [yline, yline], ...
             'color', sigCol);
        line([x(idx1), x(idx1)] + x_offset, ...
             [yline, y1], ...
             'color', sigCol);
        line([x(idx2), x(idx2)] + x_offset, ...
             [yline, y2], ...
             'color', sigCol);
             
        xtext = mean([x(idx1), x(idx2)]);
        text(xtext, ytext, sigIndicator, ...
             'color', sigCol);
        
    end
    
end         