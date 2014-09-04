function scale_array=frq2scal(frequency_array, wname, sampling_period, tol)
%scale_array=frq2scal(frequency_array, wname, sampling_period, tol)
%Searches for the scale that results in a frequency that is within 
%+/- tol of the desired frequency
%   Author: Murat Okatan 09/13/2002
%   Copyright (c) 2002 Boston University

 [rf, cf]=size(frequency_array);

 scale_array=zeros(rf, cf);
 
 for row=1:rf,
 % for row=1:rf,
     for col=1:cf,
     %for col=1:cf,
         frequency=frequency_array(row, col);
         
         scale=1/sampling_period/frequency;
         freq=scal2frq(scale, wname, sampling_period);
		
         %if the difference is within tol, we found it. Return;
         if (abs(freq-frequency)<=tol)
             return;
         end
         
         if (freq>frequency),
             %The current scale is too small
             last_scale_down=scale;
             %Find a scale that is larger than needed
             while(freq>frequency),
                 scale=scale*2;
                 freq=scal2frq(scale, wname, sampling_period);
             end
             %if the difference is within tol, we found it. Return;
             if (abs(freq-frequency)<=tol)
                 return;
             end
             last_scale_up=scale;
         else
             %The current scale is too large
             last_scale_up=scale;
             %Find a scale that is smaller than needed
             while(freq<frequency),
                 scale=scale/2;
                 freq=scal2frq(scale, wname, sampling_period);
             end
             %if the difference is within tol, we found it. Return;
             if (abs(freq-frequency)<=tol)
                 return;
             end
             last_scale_down=scale;
         end
         
         %Now search for the scale in the interval [last_scale_down last_scale_up]
         while abs(freq-frequency)>tol,
             
             if (freq>frequency)
                 %scale is too small
                 last_scale_down=scale;
                 scale=(scale+last_scale_up)/2;
             else
                 %scale is too large
                 last_scale_up=scale;
                 scale=(scale+last_scale_down)/2;
             end
             freq=scal2frq(scale, wname, sampling_period);
         end         

         scale_array(row, col)=scale;
     %for col=1:cf,
     end
 % for row=1:rf,
 end

