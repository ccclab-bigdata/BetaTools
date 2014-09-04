%%% Trains a Naive Bayes decoder on collected RPNI trials, outputting the mean
%%% and variance parameters to a file on the server.

function [mu, sigma, pcorr] = TrainRPNIDecoderOnline(monkey, run)

trialsToIgnore = 50;
samplesToAverage = 50;
% velocityThreshold = .25;
msToLag = 10;

if (nargin < 1 || isempty(monkey))
    error('Feed me a monkey name, Seymour!');
end

datapath = fullfile('Z:', 'Data', monkey, datestr(now, 'yyyy-mm-dd'));

if (nargin < 2 || isempty(runs))
    D = dir(fullfile(datapath, 'Run*'));
    run = D(end).name; 
else
    run = sprintf('Run-%03d', run);
end

runpath = fullfile(datapath, run);

% Import current trials in the selected run:
z = ZStructTranslator_RPNI(runpath, 1);
z = z(trialsToIgnore+1:end);

% Generate velocity threshold - throw out lowest 10%:
fvel = smooth(diff(smooth(cell2mat(arrayfun(@(x) x.RawInputVals(:,2), z, 'UniformOutput', false)')',50)),50);
velocityThreshold = median(fvel(fvel>0));

% Extract periods of flexion from the finger data:
skiptrials = [1, find(diff([z.TrialNum]) ~= 1), length(z)]; %missing data
flexRPNI = []; otherRPNI = [];
for i = 2:length(skiptrials)
    
    % All trials corresponding to this section of non-skipped data:
    zi = z(skiptrials(i-1):skiptrials(i));
    
    % Collect all finger data from this section of trials:
    fpos = cell2mat(arrayfun(@(x) x.RawInputVals(:,2), zi, 'UniformOutput', false)')';
    
    % Collect corresponding RPNI data:
    RPNI = cell2mat(arrayfun(@(x) x.RPNIavg, zi, 'UniformOutput', false)')';
    
    % Convert position to velocity & smooth:
    fvel = smooth(diff(smooth(fpos, 50)), samplesToAverage);
    
    % Find and label flex and rest/extend periods:
    flexidx = fvel > velocityThreshold;
    start = find(diff([0, flexidx', 0]) == 1);
    stop = find(diff([0, flexidx', 0]) == -1) - 1;
    good = (stop-start+1) >= samplesToAverage & start > msToLag;
    flexidx = cell2mat(arrayfun(@(x,y) x+samplesToAverage/2:samplesToAverage:y-samplesToAverage/2, start(good), stop(good), 'UniformOutput', false));
    
    otheridx = fvel <= 0;
    start = find(diff([0, otheridx', 0]) == 1);
    stop = find(diff([0, otheridx', 0]) == -1) - 1;
    good = (stop-start+1) >= samplesToAverage & start > msToLag;
    otheridx = cell2mat(arrayfun(@(x,y) x+samplesToAverage/2:samplesToAverage:y-samplesToAverage/2, start(good), stop(good), 'UniformOutput', false));
    
    % Collect the associated RPNI data:
    flexRPNI = [flexRPNI, RPNI(flexidx-msToLag)];       %#ok
    otherRPNI = [otherRPNI, RPNI(otheridx-msToLag)];    %#ok
    
end

% Compute Naive Bayes parameters:
mu(1) = mean(flexRPNI);
mu(2) = mean(otherRPNI);
sigma(1) = var(flexRPNI);
sigma(2) = var(otherRPNI);

% What's our percent correct using these?
num = min(length(flexRPNI), length(otherRPNI));
data = [flexRPNI(1:num), otherRPNI(1:num)]';
probfun = @(x, m, v) ((1./sqrt(2*pi*repmat(v,size(x,1),1))).*exp(-.5*((x-repmat(m,size(x,1),1)).^2)./repmat(v,size(x,1),1)));
loglike(:,1) = log(probfun(data, mu(1), sigma(1)));
loglike(:,2) = log(probfun(data, mu(2), sigma(2)));
[~, maxidx] = max(loglike, [], 2);
pcorr = (sum(maxidx == [ones(1,num), 2*ones(1,num)]')/(2*num));

% Save parameters in same path:
xpcMU = single(mu); xpcSIGMA = single(sigma); %#ok
save(fullfile(datapath, 'decodeParamsNB.mat'), 'xpcMU', 'xpcSIGMA');







