function data = xpts2data(h_axes, pts)
%
% convert font points to data units

startUnits = get(h_axes, 'units');
set(h_axes, 'units', 'points');

xlimits = get(h_axes,'xlim');
axpos   = get(h_axes, 'position');

data = pts * range(xlimits) / axpos(3);

set(gca,'units',startUnits);