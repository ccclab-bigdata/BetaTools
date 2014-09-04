function h_axes = createFigText(h_fig, textPos, textString, varargin)
%
% usage: h_axes = createFigText(h_fig, textPos, textString, varargin)
%
% INPUTS:
%   h_fig - figure handle
%   textPos - position at which to place text. Default is in normalized
%       units. this is a standard 2-element position vector
%   textString - string to add onto the figure
%
% varargs: axes properties to set for the whole figure axes
%
% OUTPUTS:
%   h_axes - axis handle for the invisible axes taking up the full figure

figPos = get(gcf,'position');
units =  get(h_fig, 'units');

h_axes = axes('parent', h_fig, ...
              'units', units, ...
              'position', [0 0 figPos(3) figPos(4)], ...
              'visible', 'off');
     
for iarg = 1 : 2 : nargin - 3
    if strcmpi(varargin{iarg}, 'units')
        units = varargin{iarg + 1};
    end
    set(gca,varargin{iarg}, varargin{iarg + 1});
end

text('units', units, ...
     'position', textPos, ...
     'string', textString);