function status=writeNexPosition(fname, frequency, pos_data_struct)
%   status=writeNexPosition(fname, frequency, pos_data_struct)
%   Writes rat's position data generated by eegrhythm in .nex file format
%   fname: string
%   frequency: clock rate in Hz
%   pos_data_struct: The data struct that contains the following fields:
%           start_time      : the first time stamp in units of ticks (1/frequency s)
%           end_time        : the last time stamp in units of ticks (1/frequency s)
%           sampling_rate   : Sampling rate of the A/D board
%           data_vector     : 1-D array of the data itself in one block.

%   Author: Murat Okatan 03/17/03

status=-1;
sizeof_fh=544;
sizeof_vh=208;

start_time=pos_data_struct.start_time; %Units: ticks
end_time=pos_data_struct.end_time+1;   %Units: ticks

fh=struct('Name', {'MagicNumber', ...
                   'Version', ...
                   'Comment', ...
                   'Frequency', ...
                   'Beg', ...
                   'End', ...
                   'NumVars', ...
                   'NextFileHeader', ...
                   'Padding'}, ...
          'Value', [], ...
          'Precision', {'int8', ...
                        'int32', ...
                        'int8', ...
                        'double', ...
                        'int32', ...
                        'int32', ...
                        'int32', ...
                        'int32', ...
                        'int8'});

vh=struct('Name', {'Type', ...
                   'Version', ...
                   'Name', ...
                   'DataOffset', ...
                   'Count', ...
                   'WireNumber', ...
                   'UnitNumber', ...
                   'Gain', ...
                   'Filter', ...
                   'XPos', ...
                   'YPos', ...
                   'WFrequency', ...
                   'ADtoMV', ...
                   'NPointsWave', ...
                   'NMarkers', ...
                   'MarkerLength', ...
                   'Padding'}, ...
          'Value', [], ...
          'Precision', {'int32', ...
                        'int32', ...
                        'int8', ...
                        'int32', ...
                        'int32', ...
                        'int32', ...
                        'int32', ...
                        'int32', ...
                        'int32', ...
                        'double', ...
                        'double', ...
                        'double', ...
                        'double', ...
                        'int32', ...
                        'int32', ...
                        'int32', ...
                        'int8'});                               
                
for i=1:length(fh),
    switch(fh(i).Name)
        case 'MagicNumber'
            fh(i).Value=setPrecision('NEX1', fh(i).Precision);
        case 'Version'
            fh(i).Value=setPrecision(100, fh(i).Precision);
        case 'Comment'
            fh(i).Value=setPrecision(zeros(1, 256), fh(i).Precision);
        case 'Frequency'
            fh(i).Value=setPrecision(frequency, fh(i).Precision);
        case 'Beg'
            fh(i).Value=setPrecision(start_time, fh(i).Precision);
        case 'End'
            fh(i).Value=setPrecision(end_time, fh(i).Precision);
        case 'NumVars'
            fh(i).Value=setPrecision(1, fh(i).Precision);
        case 'NextFileHeader'
            fh(i).Value=setPrecision(0, fh(i).Precision);
        case 'Padding'
            fh(i).Value=setPrecision(zeros(1, 256), fh(i).Precision);
    end %switch
end

%Write the file header
outfile=fopen(fname, 'wb');
for i=1:length(fh),
    fwrite(outfile, fh(i).Value, fh(i).Precision);
end

%Set offset to after the file header and the var header for the only variable that we have
offset=sizeof_fh+sizeof_vh;

for i=1:length(vh),
    switch(vh(i).Name)
        case 'Type'
            vh(i).Value=setPrecision(5, vh(i).Precision);
        case 'Version'
            vh(i).Value=setPrecision(100, vh(i).Precision);
        case 'Name'
            vh(i).Value=setPrecision(zeros(1, 64), vh(i).Precision);
            name_length=length('Position');
            vh(i).Value(1:name_length)=setPrecision('Position', vh(i).Precision);
        case 'DataOffset'
            vh(i).Value=setPrecision(offset, vh(i).Precision);
        case 'Count'
            vh(i).Value=setPrecision(1, vh(i).Precision);
        case 'WireNumber'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'UnitNumber'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'Gain'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'Filter'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'XPos'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'YPos'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'WFrequency'
            vh(i).Value=setPrecision(pos_data_struct.sampling_rate, vh(i).Precision);
        case 'ADtoMV'
            vh(i).Value=setPrecision(1, vh(i).Precision);
        case 'NPointsWave'
            vh(i).Value=setPrecision(length(pos_data_struct.data_vector), vh(i).Precision);
        case 'NMarkers'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'MarkerLength'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'Padding'
            vh(i).Value=setPrecision(zeros(1, 68), vh(i).Precision);
    end %switch
end

%Write the variable header
varheader=vh;
for j=1:length(varheader),
    fwrite(outfile, varheader(j).Value, varheader(j).Precision);
end

%Write the first tstamp
fwrite(outfile, fh(5).Value, fh(5).Precision);
%Write the start index
fwrite(outfile, 0, 'int32');
%Write the A/D data
fwrite(outfile, pos_data_struct.data_vector, 'int16');

fclose(outfile);

%Return normally
status=0;

