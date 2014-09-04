function status=writeNexIntervals(fname, frequency, interval_struct)
%   status=writeNexIntervals(fname, frequency, interval_struct)
%   Writes eegrhythm intervals in .nex file format
%   fname: string
%   frequency: clock rate in Hz
%   interval_struct(i).data=[s1 s2 s3... sN e1 e2 e3... eN] contains the
%   start (s) and end (e) points of the N intervals of an interval-variable.
%   interval_struct(i).label is a number indicating the label of this interval
%   variable.

%   Author: Murat Okatan 12/05/02

status=-1;
sizeof_fh=544;
sizeof_vh=208;
sizeof_int32=4;

start_time=min(interval_struct(1).data);
end_time=max(interval_struct(1).data);
for i=2:length(interval_struct),
    if start_time>min(interval_struct(i).data)
        start_time=min(interval_struct(i).data);
    end
    if end_time<max(interval_struct(i).data)
        end_time=max(interval_struct(i).data);
    end
end
end_time=end_time+1;

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
            fh(i).Value=setPrecision(length(interval_struct), fh(i).Precision);
        case 'NextFileHeader'
            fh(i).Value=setPrecision(0, fh(i).Precision);
        case 'Padding'
            fh(i).Value=setPrecision(zeros(1, 256), fh(i).Precision);
    end %switch
end

outfile=fopen(fname, 'wb');
for i=1:length(fh),
    fwrite(outfile, fh(i).Value, fh(i).Precision);
end

for i=1:length(vh),
    switch(vh(i).Name)
        case 'Type'
            vh(i).Value=setPrecision(2, vh(i).Precision);
        case 'Version'
            vh(i).Value=setPrecision(100, vh(i).Precision);
        case 'Name'
            vh(i).Value=setPrecision(zeros(1, 64), vh(i).Precision);
        case 'DataOffset'
        case 'Count'
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
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'ADtoMV'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'NPointsWave'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'NMarkers'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'MarkerLength'
            vh(i).Value=setPrecision(0, vh(i).Precision);
        case 'Padding'
            vh(i).Value=setPrecision(zeros(1, 68), vh(i).Precision);
    end %switch
end

offset=sizeof_fh+sizeof_vh*length(interval_struct);

for i=1:length(interval_struct),
    varheader=vh;
    if interval_struct(i).label<10,
        name=sprintf('Interval0%d', interval_struct(i).label);
    else
        name=sprintf('Interval%d', interval_struct(i).label);
    end

	for j=1:length(varheader),
        switch(varheader(j).Name)
            case 'Name'
                name_length=length(name);
                varheader(j).Value(1:name_length)=setPrecision(name, ...
                    varheader(j).Precision);
            case 'DataOffset'
                varheader(j).Value=setPrecision(offset, varheader(j).Precision);
            case 'Count'
                varheader(j).Value=setPrecision(length(interval_struct(i).data)/2, ...
                    varheader(j).Precision);
        end %switch
        
        fwrite(outfile, varheader(j).Value, varheader(j).Precision);
	end
    offset=offset+length(interval_struct(i).data)*sizeof_int32;
end

for i=1:length(interval_struct),
    fwrite(outfile, interval_struct(i).data, 'int32');
end

fclose(outfile);

%Return normally
status=0;