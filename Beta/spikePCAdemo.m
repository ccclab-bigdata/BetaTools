load spikes


plot(spikes(1:1000,:)','b');

stdsp=std(spikes);
meansp=mean(spikes);
[n m] = size(spikes);

spikesnorm = (spikes - repmat(meansp,[n 1])) ./ repmat(stdsp,[n 1]);

[coeff,score,latent]=princomp(spikesnorm);


plot(coeff(:,1))% Prototypical spike, first principle component
plot(coeff(:,2))% Looks important


cumsum(latent)./sum(latent)
%top six components give you 90% of the variance


%What is the same thing
plot(score(1,:));
plot(spikesnorm(1,:)*coeff);

%How do you get the data back?
plot(score(1,:)*coeff')
plot(spikesnorm(1,:))
size
%How do you make it look like a spike again?
plot(spikesnorm(1,:).*stdsp+meansp);
plot(spikes(1,:));

%Now do it with only the top four components
plot((score(1,1:10)*coeff(:,1:10)').*stdsp+meansp,'b--')
hold on
plot(spikes(1,:));

%Why is this useful?
plot(score(1:1000,1),score(1:1000,2),'.');

%Looks like there's a nice division at 1.5
ind1=(find(score(:,1)>1.5));
ind2=(find(score(:,1)<1.5));


%Now we've sorted out two units
plot(spikes(ind1(1:100),:)','b')
hold on
plot(spikes(ind2(1:100),:)','g')

%Kmeans clustering of these spikes
clusternum=3;
colors=['bgrmc'];
[ind,centroid]=kmeans(score(:,1:4),clusternum);
close all
hold on
for i=1:clusternum
    plotind=find(ind==i);
    plot(score(plotind,1),score(plotind,2),[colors(i) '.'])
    plot(centroid(i,1),centroid(i,2),[colors(i) 'x']);
end


%Mixture of gaussians
clusternum=3
options = statset('Display','final');
obj = gmdistribution.fit(score(:,1:2),clusternum,'Options',options);
scatter(score(1:10000,1),score(1:10000,2),10,'.');
hold on
h = ezcontour(@(x,y)pdf(obj,[x y]),[-15 15],[-15 15]);
scatter(obj.mu(:,1),obj.mu(:,2),1000,'ro','LineWidth',2)

close
obj = gmdistribution.fit(score(:,1:4),clusternum,'Options',options);
scatter(score(1:10000,1),score(1:10000,2),10,'.');
hold on
scatter(obj.mu(:,1),obj.mu(:,2),1000,'ro','LineWidth',2)

clusternum=8;
close
obj = gmdistribution.fit(score(:,1:2),clusternum,'Options',options);
scatter(score(1:10000,1),score(1:10000,2),10,'.');
hold on
scatter(obj.mu(:,1),obj.mu(:,2),1000,'ro','LineWidth',2)

