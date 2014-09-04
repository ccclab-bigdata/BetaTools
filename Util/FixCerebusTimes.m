% Find and fix errors in the Cerebus serial timestamps
%
%   Inputs:  * nev - struct resulting from openNEV('read') call
%
%   Outputs: * etimes - fixed uint32 vector of xPC experiment times
%            * ctimes - fixed uint32 vector of cerebus sample time stamps
%            * ctimessec - fixed double vector of cerebus time stamps (sec)
%
%   Written by Zach Irwin for the Chestek lab, 2013
%       * Last edited September, 2013 by Zach Irwin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [etimes, ctimes, ctimessec] = FixCerebusTimes(nev)

% Test if there's serial data here:
if (length(nev.Data.SerialDigitalIO.UnparsedData) < 8)
    etimes = [];
    ctimes = [];
    ctimessec = [];
    return;
end

% Extract xpc count + timestamps:
x = uint8(nev.Data.SerialDigitalIO.UnparsedData)';
samps = nev.Data.SerialDigitalIO.TimeStamp;
secs = nev.Data.SerialDigitalIO.TimeStampSec;

% Find first good byte:
for i = 1:length(x)-11%4
    if (all(diff(typecast(x(i:i+11), 'uint32'))==1))
    %if (all(x(i+4:i+7)-x(i:i+3) == [1 0 0 0]))
        idxstart = i;
        break;
    end
end

% Check if anything good is here:
if (~exist('idxstart', 'var'))
    etimes = [];
    ctimes = [];
    ctimessec = [];
    return;
end
    
% Find any restarts:
runidxs = [idxstart-1, idxstart + strfind(x(idxstart+1:end), [0 0 0 0 1 0 0 0]) - 1, length(x)]; 

% Iterate & fix each run:
for i = 2:length(runidxs)
    
    % Check for crap:
    while (1)
        
        % Re-check length:
        idxend = runidxs(i-1) + length(x(runidxs(i-1)+1:runidxs(i)))-mod(length(x(runidxs(i-1)+1:runidxs(i))),4);
        
        % Find index of 1st potential byte error:
        badidx = (runidxs(i-1)+1) + find(diff(typecast(x(runidxs(i-1)+1:idxend), 'uint32')) ~= 1, 1) * 4;
        
        % Verify that it is indeed an error, break if no errors:
        if (~isempty(badidx) && diff(typecast(x(badidx:badidx+7), 'uint32')) == 1)
            runidxs(i-1) = badidx-1;
            continue;
        elseif (isempty(badidx))
            break;
        end
        
        % Find index of next good byte:
        for j = badidx+1:badidx+10
            if (j+4 > length(x) || j+7 > length(x))
                goodidx = -1;
                break
            elseif (all(x(j+4:j+7)-x(j:j+3) == [1 0 0 0]))
                goodidx = j;
                break
            end
        end
        
        % Record current vector length:
        xlength = length(x);
        
        if (goodidx ~= -1)
            % Replace bad byte:
            x = [x(1:badidx-1), typecast(uint32(typecast(x(badidx-4:badidx-1),'uint32')+1),'uint8'), x(goodidx:end)];
            
            % Replace time stamps:
            samps = [samps(1:badidx), 0, 0, 0, samps(goodidx:end)];
            secs = [secs(1:badidx), 0, 0, 0, secs(goodidx:end)];
            
            % Update indices:
            runidxs(i:end) = runidxs(i:end) + (length(x)-xlength);
            %runidxs = runidxs + [0, (length(x)-xlength)*ones(1,length(runidxs)-1)];
            %runidxs(1) = goodidx + (length(x)-xlength) - 1;
        else
            x = x(1:badidx-1);
            samps = samps(1:badidx-1);
            secs = secs(1:badidx-1);
            runidxs(end) = length(x);
        end
    end
    
end

% Re-check length once more:
idxend = (idxstart-1) + length(x(idxstart:end))-mod(length(x(idxstart:end)),4);

% Return fixed count + timestamps:
etimes = typecast(x(idxstart:idxend), 'uint32');
ctimes = samps(idxstart:4:idxend);
ctimessec = secs(idxstart:4:idxend);

end