function data = pts2data(h_axes, pts)
%
% convert font points to data units

startUnits = get(h_axes, 'units');
set(h_axes, 'units', 'points');

ylimits = get(h_axes,'ylim');
axpos   = get(h_axes, 'position');

data = pts * range(ylimits) / axpos(4);

set(gca,'units',startUnits);