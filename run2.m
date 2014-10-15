x=1:.1:4*pi;
y=x;
z=randn(1,length(x))/1.5;
y=y+z;

plot(sin(y),'r');
hold on;
plot(sin(x),'LineWidth',4);

spikes=sin(y)>.8;
% hold on;
% plot(spikes,'o');

timestamps=find(spikes==1);
hold on;
plot(timestamps,0,'o','color','k');