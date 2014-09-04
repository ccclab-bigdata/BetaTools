%%%%%%%%%%%%%%%%%%
%   checkcount   %
%%%%%%%%%%%%%%%%%%
%Murat Okatan
function checkcount(count, value, message)
	
	if(count~=value)
            error(message);
	end
