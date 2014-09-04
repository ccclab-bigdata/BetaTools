function print_to_ps(saveName, h_fig, pageNum)
%
% usage: function print_to_ps(saveName, h_fig, pageNum)
%
% utility to print a figure to a page in a .ps file. If pageNum = 1, then
% create a new file; otherwise, append to the previous file
%
% INPUTS:
%   saveName - the name of the file to save to
%   h_fig - handle of the figure to save
%   pageNum - page number. Only important to distinguish page 1 from higher
%       pages. If page 1, create a new file; if not, append if a file named
%       saveName can be found

if ~exist(saveName,'file') || pageNum == 1
    print(saveName, ['-f' num2str(h_fig)],'-dpsc');
else
    print(saveName,'-append',['-f' num2str(h_fig)],'-dpsc');
end