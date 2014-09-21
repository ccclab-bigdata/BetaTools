% thresholds the data, splits continuous regions into seperate cells
function out=getThreshCrossTimes(data,smoothAmt,threshold)

smoothData= smooth(data,smoothAmt);
betaCrossings = find(smoothData > threshold);
ad = [diff(betaCrossings')==1 0];
numcells = sum(ad==0);
out = cell(1,numcells);
indends = find(ad == 0);
ind = 1;
for k = 1:numcells
   out{k} = betaCrossings(ind:indends(k));
   ind = indends(k)+1;
end
