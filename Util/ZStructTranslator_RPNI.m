% This function translates the File Logger binaries into Z structs.
%
% Inputs: (1 - optional) Path to folder containing File Logger binaries.
%                           - Default: Assumes current directory as path
%         (2 - optional) Overwrite flag
%                           - Default: Will NOT overwrite previous Z Struct
%                           - 0: Will load any previous Z Struct in folder
%                           - 1: Will overwrite previous Z Struct in folder
%
% Output: (1) Z struct array (1 struct for every available trial)
%
% NOTE: Make sure the folder path includes the entire directory structure 
%       (i.e. the name\date\run folders).
%
% NOTE: This script assumes that neural data is sent as variable length
%       packets with an EndPacket byte of 255. It also assumes that there
%       is exactly 1 feature in each neural packet.
%
%   Written by Zach Irwin for the Chestek Lab, 2012
%       * Last edited: August, 2013 by Zach Irwin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [z, varargout] = ZStructTranslator(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parse Inputs: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch (nargin)
    case 0
        directory = pwd; % take directory as current working directory
        overwrite = 0; % don't overwrite files unless told to do so
    case 1 
        if (ischar(varargin{1}))
            directory = varargin{1};
            overwrite = 0;
        elseif (varargin{1} == 0 || varargin{1} == 1)
            overwrite = varargin{1};
            directory = pwd;
        else
            error('Input(s) should be either a directory name (string) or the overwrite flag (0 or 1).');
        end
    case 2
        if (ischar(varargin{1}) && ~ischar(varargin{2}) && (varargin{2} == 0 || varargin{2} == 1))
            directory = varargin{1};
            overwrite = varargin{2};
        elseif (~ischar(varargin{1}) && (varargin{1} == 0 || varargin{1} == 1) && ischar(varargin{2}))
            overwrite = varargin{1};
            directory = varargin{2};
        else
            error('Input(s) should be either a directory name (string), the overwrite flag (0 or 1), or both.');
        end
    otherwise
        error('Input(s) should be eithera directory name (string), the overwrite flag (0 or 1), or both.');
end

if (nargout == 2)
    fileoutflag = 1;
else
    fileoutflag = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Check for Previous Z Struct: %%%%%%%%%%%%%%%%%%%%%%%

%Split directory into individual folder names:
folders = regexp(directory, '\\', 'split');

%Test directory for completeness:
if (exist(sprintf('%s\\zScript.txt', directory), 'file') == 0)
    error('Directory does not contain zScript file, please check inputs.');
end

%Check for previous Z Struct:
zfilename = sprintf('Z_%s_%s_%s.mat', folders{end-2:end});
if (~overwrite && exist(sprintf('%s\\%s', directory, zfilename), 'file') == 2)
    disp('Loading previous Z Struct...');
    s = load(sprintf('%s\\%s', directory, zfilename));
    z = s.z;
    if (fileoutflag)
        varargout{1} = zfilename;
    end
    return
end

%Move into working directory:
currentdir = cd(directory);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parse Z String: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Load and read in Z Translator file:
zstr = fread(fopen('zScript.txt'), '*char')';

%Supported data types and their byte sizes:
cls = {'uint8', 'int8', 'uint16', 'int16', 'uint32', 'int32', 'single', 'double';
        1,      1,       2,          2,      4,      4,         4,       8};

%Split Z string into its P/M/D/N substrings:
split = regexp(zstr, '\:\w\:', 'split'); %1st entry is blank

%Split each substring into its fieldname/datatype/numels substrings:
split = regexp(split, '\-', 'split'); %last entry in each cell is blank

%Collect names, types, and sizes into separate arrays:
names = cellfun(@(x) x(1:3:length(x)-1), split(2:end), 'UniformOutput',false);
types = cellfun(@(x) x(2:3:length(x)-1), split(2:end), 'UniformOutput',false);
sizes = cellfun(@(x) x(3:3:length(x)-1), split(2:end), 'UniformOutput',false);

%Recover number of fields in each file type:
fnum = cellfun(@length, names); %Number of fields in each file type

%Calculate byte sizes for each feature and collect field names:
fnames = cell(1,2*sum(fnum)); num = 0; bsizes = sizes;
for i = 1:3
    
    fnames(num+1:2:num+2*fnum(i)) = names{i};
    num = num + 2*fnum(i);
    
    %Match type to cls, get type byte size, mutiply by feature length:
    for j = 1:fnum(i)
        bsizes{i}{j} = cls{2,strcmp(cls(1,:),types{i}{j})}*bsizes{i}{j};
    end
    
end
fnames(num+1) = {'Channel'};

%Calculate bytes per timestep for each file:
bytes = cellfun(@(x) sum([x{:}]),bsizes) + 2; % plus 2 for the trial count

%Get number of trials in this run:
files = dir('tParams*.bin');
trials = sort(cellfun(@str2num,regexp([files.name], '\d+', 'match')));
ntrials = length(trials);

if (trials(end) ~= ntrials)
    warning('This run has 1 or more dropped trials.');
end

%Initialize z struct array with fieldnames:
z = repmat(struct(fnames{:}),1,ntrials);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% Parse Data Strings Into Z Struct: %%%%%%%%%%%%%%%%%%%%

%Extract trial data & pack into Z structs:
for i = 1:ntrials
    
    %Insert trial count into struct:
    z(i).TrialNum = trials(i);
    
    %Read in data files:
    data{1} = fread(fopen(sprintf('tParams%d.bin', trials(i))), '*uint8');    %Trial Parameter file
    data{2} = fread(fopen(sprintf('mBehavior%d.bin', trials(i))), '*uint8');  %Measured Behavior file
    data{3} = fread(fopen(sprintf('dBehavior%d.bin', trials(i))), '*uint8');  %Decoded Behavior file
    data{4} = fread(fopen(sprintf('neural%d.bin', trials(i))), '*uint8');     %Neural Data file
    
    
    %Iterate through file types 1-3 and add data to Z:
    for j = 1:3
        
        %Calculate # of timesteps in this file:
        nstep = length(data{j})/bytes(j);
        
        %Calculate the byte offsets for each feature in the timestep:
        offs = [3,3+cumsum([bsizes{j}{:}])]; %starts at 3 because of trial counts
        
        %Iterate through each field:
        for k = 1:fnum(j)
            
            %Create a byte mask for the uint8 data:
            bmask = zeros(1,bytes(j));
            bmask(offs(k)+(0:bsizes{j}{k}-1)) = 1;
            bmask = repmat(bmask,1,nstep);
            
            %Extract data and cast to desired type:
            dat = typecast(data{j}(logical(bmask)),types{j}{k});
            
            %Reshape the data and add to Z:
            z(i).(names{j}{k}) = reshape(dat,sizes{j}{k},nstep)';
        end
        
    end
    
    %Extract Neural data packets (split around TrialCount and End Packet byte):
%    ndata = regexp(char(data{4}'), [char(typecast(uint16(trials(i)),'uint8')) '[^' char(255) ']' '*' char(255)], 'match');
%    z(i).NeuralData = cellfun(@(x) uint8(x(3:end-1)), ndata, 'UniformOutput', false);
%     
%     ndata = cell(1, length(regexp(char(data{4}'), char(typecast(uint16(trials(i)),'uint8')))));
%     idx = 1; num = 0;
%     while (idx < length(data{4}))
%         
%         if (typecast(data{4}(idx:idx+1), 'uint16') ~= trials(i))
%             error('Mismatch in neural data - check trial %d',trials(i));
%         end
%         
%         num = num + 1;
% %         len = double(typecast(data{4}(idx+2:idx+3), 'int16')*2);
% len = double(typecast(data{4}(idx+2:idx+5), 'single')*4);
%        
% %         ndata{num} = typecast(data{4}(idx+4:idx+3+len)', 'int16');
% ndata{num} = typecast(data{4}(idx+6:idx+5+len)', 'single');
%         
% %         idx = idx + 4 + len;
% idx = idx + 6 + len;
%         
%     end
%     
%     z(i).Channel(1).RPNI = cell2mat(ndata(1:num));
    
    fclose('all');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% Format specific fields: %%%%%%%%%%%%%%%%%%%%%%%%%

%Change neural data field into spike times per channel:
% for i = 1:length(z)
%     
%     spikenums = zeros(96,length(z(i).NeuralData));
%     for t = 1:length(z(i).NeuralData)
%         for j = 1:length(z(i).NeuralData{t})
%             spikenums(z(i).NeuralData{t}(j), t) = spikenums(z(i).NeuralData{t}(j), t) + 1;
%         end
%     end
%     
%     for c = 1:96
%         if (any(spikenums(c,:)))
%             times = z(i).ExperimentTime(logical(spikenums(c,:)));
%             spikenumsi =spikenums(c,spikenums(c,:) ~= 0);
%             idx = cumsum(spikenumsi);
%             j = zeros(1, idx(end));
%             j([1 idx(1:end-1)+1]) = 1;
%             z(i).Channel(c).SpikeTimes = times(cumsum(j));
%         else
%             z(i).Channel(c).SpikeTimes = [];
%         end
%     end
% end
% 
% z = rmfield(z, {'SpikeChans', 'NeuralData'});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Save Z Struct Array to File: %%%%%%%%%%%%%%%%%%%%%%%

disp('Saving Z Struct...');
save(zfilename, 'z');
if (fileoutflag)
    varargout{1} = zfilename;
end
fclose('all');
cd(currentdir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







