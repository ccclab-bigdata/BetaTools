function [ vector ] = SAClip( vector )
%function [ array ] = SAClip( array )
%   Clip is designed to clip (in a Stark and Abeles fashion) the array to
%   mean +- 2SD in each column.

if(~isvector(vector))
    throw(MException('SAClip:NotVector','SAClip requires a vector input'));
end

%Calculate mean and standard deviation
vmean = mean(vector);
vstd = std(vector);

%Calculate clipping values
upperlim = vmean+2*vstd;
lowerlim = vmean-2*vstd;

%Clip vector
vector(vector>upperlim) = upperlim;
vector(vector<lowerlim) = lowerlim;

end

