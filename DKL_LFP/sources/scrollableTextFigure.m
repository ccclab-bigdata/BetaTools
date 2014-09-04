function FH=scrollableTextFigure(figure_name, msg)
%Show a text message in a figure that has a bar to scroll down to read the text.
%function FH=scrollableTextFigure(figure_name, msg)
%Writes the string msg to a figure and sets the figure name to figure_name. Places a vertical
%scroll bar that enables scrolling the text. Returns the handle to the figure.

%Author: Murat Okatan --Feb/03/03

%Find how many times new lines occur in the message
new_line_starts=find(msg==10);
%The number of lines
num_of_lines=length(new_line_starts);

%Create the figure
H=0.9; W=0.9;
FH=figure(...
    'Color', [1 1 1], ...
    'Visible', 'off', ...
    'Units', 'normalized', ...
    'Position', [(1-W)/2 (1-H)/4 W H], ...
    'DoubleBuffer', 'on', ...
    'BackingStore', 'off', ...
    'Name', figure_name, ...
    'WindowButtonMotionFcn', {@WindowButtonMotionFunction}, ...
    'NumberTitle', 'off');

%Put the axis for the text
ud.ax=axes('Parent', FH, ...
           'Units', 'normalized', ...
           'Visible', 'off', ...
           'Position', [0 0 0.9 1]);
ud.ax_init_pos=get(ud.ax, 'Position');

%The top line is at y=1 (normalized) if we set the text's VertAlign property to 'top'.
%Each line is line_height normalized units thick.
%Thus, the height of text is:
line_height=0.017;
ud.text_height=line_height*num_of_lines;

%Put a slider uicontrol
scroll_x=0.98;
ud.Scroller=uicontrol('Style', 'slider', ...
                   'Parent', FH, ...
                   'Units', 'normalized', ...
                   'Position', [scroll_x 0 1-scroll_x 1], ...
                   'Min', 0, ...
                   'Max', ud.text_height, ...
                   'Value', ud.text_height, ...
                   'SliderStep', [0.01, 0.1], ...
                   'Callback', {@TFScrollerCallback});                             

%Print text
ud.text_handle=text('Position', [0.01 1], ...
     'String', msg, ...
     'VerticalAlignment', 'top', ...
     'Editing', 'on', ...
     'Parent', ud.ax);
 
%Store ud
set(FH, 'UserData', ud);            
 
%Show the figure 
set(FH, 'Visible', 'on');


%%%%%%%%%%%%%%%%%%%%
% TFScrollerCallback %
%%%%%%%%%%%%%%%%%%%%
function TFScrollerCallback(eventSrc,eventData)
 %---Change parameter value (eventData = new value)
  ud = get(gcbf,'UserData');
  ax_pos=get(ud.ax, 'Position');
  
  set(ud.ax, 'Position', ud.ax_init_pos-(get(gcbo, 'Value')-ud.text_height)*[0 1 0 0]);

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WindowButtonMotionFunction %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WindowButtonMotionFunction(eventSrc,eventData)
  
  ud = get(gcbf,'UserData');  
  set(ud.text_handle, 'Edit', 'on');

  