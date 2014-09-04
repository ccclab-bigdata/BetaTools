function output=setPrecision(input, precision)
%%%%%%%%%%%%%%%%%%%%%
%   setPrecision    %
%%%%%%%%%%%%%%%%%%%%%

    switch precision
    case 'int8'
        output=int8(input);
    case 'int32'
        output=int32(input);
    case 'double'
        output=double(input);
    otherwise
        msg=sprintf('Error: Insert a case block for precision %s in setPrecision\n', ...
            precision);
        disp(msg);
        return;
    end %switch
        