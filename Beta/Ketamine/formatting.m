figure;
h1=subplot(1,2,1);
[C,h] = contourf([1 2 3 4;5 6 7 8;9 10 11 12;13 14 15 16]);
axis vis3d
view(125,90)

h2=subplot(1,2,2);
[C,h] = contourf([1 2 3 4;5 6 7 8;9 10 11 12;13 14 15 16]);
axis vis3d
view(-100,90)