function [yline xline]  = drawslope(I, alpha, refpoint)
%      
%        function to draw a line at a desired angle <alpha>, 
%        which goes through a reference point <refpoint>
%        function inputs:
%       <I>:                       Image for which the drawing is desired.
%                                       Range:3Dim, grayscale, or logical
%        <alpha>:           Angle in degrees, where 0 is complete horizontal
%                                       Range:   -Inf   -   +Inf    (cyclic after + (-) 180 degrees of course)
%        <refpoint> :   Reference interception point with the slope
%                                        Range: A varaible of size 2x1, where refpoint(1) is horizontal and (2) is vertical
%       function outputs:
%       <yline> :             Y axis coordinates of both line ends
%       <xline>:              X axis coordinates of both line ends
%               
%                                         outputs should be used with plot function as following:
%                                         plot(yline,xline,...plot specifiers)
%         
%           Example usage:
%             Image = imread('someImage');
%             image_centroid =  [100 240];
%             [yline xline]  = drawslope(Image, -60, image_centroid);
%             imshow(Image);
%             hold on;
%             plot(yline, xline, 'blue','LineWidth',2);  
%
%               
%       Written by Elad Boneh, 15.8.2009
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

             [x y z] = size(I);
             %Infinite lines protection
             if (mod(alpha,180) <  0.01)
                 alpha = 0.01;
             elseif (mod(alpha,90) <  0.01)
                 alpha = 90.001;
             end
             horizontal_distance = ((refpoint(2)-1)/tand(alpha));
             if ((refpoint(1) + horizontal_distance) > y)
                 vertical_distance = ((refpoint(1)-1)/cotd(alpha));
                 verctical_distance_reversed = ((y-refpoint(1))/cotd(alpha));
                 xline = [(refpoint(2) + vertical_distance), (refpoint(2) - verctical_distance_reversed)];
                 yline = [1, y];
             else
                 horizontal_distance_reversed = ((x-refpoint(2))/tand(alpha));
                 xline = [1, x];
                 yline = [(refpoint(1)+ horizontal_distance), (refpoint(1)- horizontal_distance_reversed)];
             end