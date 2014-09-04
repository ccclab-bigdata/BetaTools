function I=constructimage(I, pixelnums, pixelcolors)
%Construct a megasystem video image
%Murat Okatan

imsize=size(I);
J=I';
J=J(:);
J(pixelnums+1)=pixelcolors;

range=1:imsize(2);
for i=1:imsize(1),
        I(i,:)=J(range)';
        range=range+imsize(2);
end

return;