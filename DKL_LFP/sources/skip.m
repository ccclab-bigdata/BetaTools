function skip(infile, num_of_bytes)
%Skip num_of_bytes bytes in file infile
%Murat Okatan

if(fseek(infile, num_of_bytes, 'cof'))
    message=sprintf('Error skipping at offset %d', ftell(infile));
    errordlg(message, 'In file skip.m');
end
