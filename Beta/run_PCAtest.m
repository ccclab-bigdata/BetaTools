
stdsp=std(spikes);
meansp=mean(spikes);
[n m] = size(spikes);

spikesnorm = (spikes - repmat(meansp,[n 1])) ./ repmat(stdsp,[n 1]);

[coeff,score,latent]=princomp(spikesnorm);

% figure;
% plot(coeff(:,1))% Prototypical spike, first principle component
% hold on;
% plot(coeff(:,2),'color','red')% Looks important

figure;
plot(score(:,1),score(:,2),'.');

ind1=(find(score(:,2)<-2));
ind2=(find(score(:,2)>-2 & score(:,2)<4));
ind3=(find(score(:,2)>5));
figure;
hold on;
plot(spikes(ind1(1:100),:)','b')
plot(spikes(ind2(1:100),:)','g')
plot(spikes(ind3(1:100),:)','r')
