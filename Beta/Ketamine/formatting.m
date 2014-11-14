figure;

subplot(2,2,1);
rose([1 2 3]);
title('Phase');

subplot(2,2,2);
rose([1 2 3]);
title('Phase');

subplot(2,2,3);
contourf([1 2 3 4;5 6 7 8;9 10 11 12;13 14 15 16]);
title('S1')
axis vis3d
view(125,90)
axis off

subplot(2,2,4);
contourf([1 2 3 4;5 6 7 8;9 10 11 12;13 14 15 16]);
title('M1')
axis vis3d
view(-100,90)
axis off