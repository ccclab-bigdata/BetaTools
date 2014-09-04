function pixelnums=getpixelnums(infile, bufferinfo, imagedimensions)
%Compute the pixel numbers for those pixels that changed
%   Author: Murat Okatan

imagesize=prod(imagedimensions);
pixelnums=zeros(bufferinfo(4), 1);

%If bufferinfo(3)==2*imagesize, then full image was sent. Construct pixelnums
%here
range=1:imagedimensions(2);
if bufferinfo(3)== 2*imagesize,
    for im=imagesize-imagedimensions(2):-imagedimensions(2):0,
        pixelnums(range)=im:im+imagedimensions(2)-1;
        range=range+imagedimensions(2);
    end
    return;
end
        

[data, count]=fread(infile, bufferinfo(3), 'uint16');
checkcount(count, bufferinfo(3), 'Error reading pixel numbers for position data');

%Find the FFFF
if isempty(data),
    maxes=[];
else
    maxes=find(data==2^16-1);
end

if length(maxes)==0,
    pixelnums=data;
    return;
end
    
pixelcounter=1;
datacounter=1;
maxescounter=1;

if(maxes(1)==1)
    pixelnums(pixelcounter)=sum(data(datacounter:datacounter+1));
    pixelcounter=pixelcounter+1;
    datacounter=datacounter+2;
    maxescounter=maxescounter+1;
end

for i=maxescounter:length(maxes),
    datarange=datacounter:maxes(i)-1;
    pixelrange=pixelcounter:pixelcounter+length(datarange)-1;
    
    pixelnums(pixelrange)=data(datarange);
    
    pixelcounter=pixelcounter+length(datarange);
    datacounter=maxes(i);
    pixelnums(pixelcounter)=sum(data(datacounter:datacounter+1));
    pixelcounter=pixelcounter+1;
    datacounter=datacounter+2;
end

if datacounter~=length(data)+1,
    datarange=datacounter:length(data);
    pixelrange=pixelcounter:pixelcounter+length(datarange)-1;

    pixelnums(pixelrange)=data(datarange);
end

return;