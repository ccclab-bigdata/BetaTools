%%% Sync a Z Struct with the corresponding NEV file(s):

% Inputs:
% - Z: Z Struct to sync with the NEV file
% - run: which run does Z correspond to?
% - startRun: which run is the first one contained in the NEV files?
%       - Usually 1, but sometimes recording started after Run 1
% - NEVdir: directory containing relevant NEV files
%       - If not specified, will pop up the file picker GUI
% - badtrials: Specify bad trials here to be automatically put in Z

function [newZ] = SyncZNEV(Z, run, startRun, NEVdir)

if (nargin < 2)
    error('Feed me, Seymour! Neeeed moooore inpuuuuts...');
end

if (nargin < 3 || isempty(startRun))
    startRun = 1;                    % which run does NEV_001 correspond to?
end

if (nargin < 4 || isempty(NEVdir))
    NEVdir = uigetdir(pwd);          % grab directory for NEV files
end

notfirst = 0;
done = 0;
changed = 0;
breakfound = 0;

% First, find the corresponding Cerebus times for each trial:
D = dir(sprintf('%s\\*.nev', NEVdir));
runnum = startRun;
trialnum = 1;
start = 1;

if (length(D) < 1)
    error('Whoah there fella, shit''s empty!');
end

for i = 1:length(D)
    
    if (done)
        break;
    end
    
    % Load in current NEV:
    nev = openNEV(sprintf('%s\\%s', NEVdir, D(i).name), 'read');
    
    % Get experiment/Cerebus times included in file:
    [etime, ctime] = FixCerebusTimes(nev);
    
    if (isempty(etime) || isempty(ctime))
        breakfound = 1;
        continue;
    end
    
    runnum = runnum + breakfound;
    breakfound = 0;
    
    % Find run restarts included in file:
    runidxs = [1, find(etime(2:end)==0)+1, length(etime)+1];
    
    % Corresponding to which runs?
    if (etime(1) ~= 0)
        nevruns = runnum:(runnum + length(runidxs) - 2);
    else
        nevruns = (runnum+notfirst):(runnum + notfirst + length(runidxs) - 2);
        notfirst = 1;
    end
    
    % Is the ZStruct run included?
    if (ismember(run, nevruns)) 
        
        idx = find(nevruns == run, 1);
        
        % Go through trials & sync:
        for j = trialnum:length(Z)
            
            % If this trial started before the first file, skip to next:
            if (i == 1 && Z(j).ExperimentTime(1) < etime(1))
                continue;
            end
            
            % Find start of trial:
            if (~isempty(etime) && start)
                
                if (etime(runidxs(idx)) <= Z(j).ExperimentTime(1) && etime(runidxs(idx+1)-1) >= Z(j).ExperimentTime(1))  % this file contains trial start
                    Z(j).CerebusTimeStart = ctime(runidxs(idx)-1 + find(etime(runidxs(idx):runidxs(idx+1)-1) == Z(j).ExperimentTime(1),1));
                    start = 0;
                    changed = 0;
                end
                
            end
            
            % Find end of trial:
            if (~changed)
                if (~isempty(etime) && ~start)
                    
                    if (etime(runidxs(idx)) <= Z(j).ExperimentTime(end) && etime(runidxs(idx+1)-1) >= Z(j).ExperimentTime(end))  % this file contains trial start
                        Z(j).CerebusTimeStop = ctime(runidxs(idx)-1 + find(etime(runidxs(idx):runidxs(idx+1)-1) == Z(j).ExperimentTime(end),1));
                        start = 1;
                        Z(j).NEVFile = nev.MetaTags.Filename;
                        
                        continue;
                    end
                    
                end
            else
                changed = 0;
                start = 1;
                continue;
            end
            
            % If failed to find both, move to next NEV file:
            trialnum = j;
            changed = 1;
            break;
        
        end
        
        if (j == length(Z) && ~isempty(Z(j).CerebusTimeStop))
            if (etime(runidxs(idx+1)-1) > (Z(end).ExperimentTime(end) + single(Z(end).TrialTimeoutms)))
                error('Sheeeeiiiit, son, we''re looking in the wrong file!');
            end
            
            done = 1;
        end
        
    end
    
    runnum = nevruns(end);
    
end

newZ = Z;





