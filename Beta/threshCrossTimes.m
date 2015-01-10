% *should not return cell with one entry
function out=threshCrossTimes(data,threshold)

betaCrossings = find(data > threshold);
ad = [diff(betaCrossings')==1 0];
numcells = sum(ad==0);
out = cell(1,numcells);
indends = find(ad == 0);
ind = 1;
for k = 1:numcells
   out{k} = betaCrossings(ind:indends(k));
   ind = indends(k)+1;
end
