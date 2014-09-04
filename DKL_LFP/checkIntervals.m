function checkIntervals

txtHeight = 15;
btnHeight = 20;
editHeight = 20;
lineSpace = 30;
editBelowTxt = 2;

curChanTxtLeft = 10;
curChanTxtBot = 400;
curChanTxtWidth = 100;

curChanEditLeft = curChanTxtLeft + curChanTxtWidth + 10;
curChanEditBot = curChanTxtBot - editBelowTxt;
curChanEditWidth = 60;

curChan_ofTxtLeft = curChanEditLeft + curChanEditWidth + 10;
curChan_ofTxtBot = curChanTxtBot;
curChan_ofTxtWidth = 20;

chanMaxEditLeft = curChan_ofTxtLeft + curChan_ofTxtWidth + 10;
chanMaxEditBot = curChanEditBot;
chanMaxEditWidth = 60;

chanPlusButLeft = chanMaxEditLeft + chanMaxEditWidth + 20;
chanPlusButBot = curChanEditBot;
chanPlusButWidth = 30;

chanMinusButLeft = chanPlusButLeft + chanPlusButWidth + 10;
chanMinusButBot = chanPlusButBot;
chanMinusButWidth = chanPlusButWidth;

subjectTxtLeft = curChanTxtLeft + 10;
subjectTxtBot = curChanTxtBot - lineSpace;
subjectTxtWidth = 70;

subjectEditLeft = subjectTxtLeft + subjectTxtWidth + 10;
subjectEditBot = subjectTxtBot - editBelowTxt;
subjectEditWidth = 100;

dateTxtLeft = subjectEditLeft + subjectEditWidth + 20;
dateTxtBot = subjectTxtBot;
dateTxtWidth = 70;

dateEditLeft = dateTxtLeft + dateTxtWidth + 10;
dateEditBot = dateTxtBot - editBelowTxt;
dateEditWidth = 100;

tetrodeTxtLeft = dateEditLeft + dateEditWidth + 20;
tetrodeTxtBot = dateEditBot;
tetrodeTxtWidth = 60;

tetrodeEditLeft = tetrodeTxtLeft + tetrodeTxtWidth + 10;
tetrodeEditBot = tetrodeTxtBot - editBelowTxt;
tetrodeEditWidth = 100;

locTxtLeft = subjectTxtLeft;
locTxtBot = subjectTxtBot - lineSpace;
locTxtWidth = subjectTxtWidth;

locEditLeft = locTxtLeft + locTxtWidth + 10;
locEditBot = locTxtBot - editBelowTxt;
locEditWidth = subjectEditWidth;

sublocTxtLeft = dateTxtLeft;
sublocTxtBot = locTxtBot;
sublocTxtWidth = dateTxtWidth;

sublocEditLeft = sublocTxtLeft + sublocTxtWidth + 10;
sublocEditBot = sublocTxtBot - editBelowTxt;
sublocEditWidth = locEditWidth;

threshTxtLeft = curChanTxtLeft;
threshTxtBot = locTxtBot - 1.2 * lineSpace;
threshTxtWidth = 100;

threshEditLeft = threshTxtLeft + threshTxtWidth + 10;
threshEditBot = threshTxtBot - editBelowTxt;
threshEditWidth = 60;

inVoltsTxtLeft = threshEditLeft + threshEditWidth + 20;
inVoltsTxtBot = threshTxtBot;
inVoltsTxtWidth = 70;

inVoltsEditLeft = inVoltsTxtLeft + inVoltsTxtWidth + 10;
inVoltsEditBot = inVoltsTxtBot - editBelowTxt;
inVoltsEditWidth = 60;

curIntTxtLeft = curChanTxtLeft;
curIntTxtBot = threshTxtBot - 2 * lineSpace;
curIntTxtWidth = curChanTxtWidth;

curIntEditLeft = curIntTxtLeft + curIntTxtWidth + 10;
curIntEditBot = curIntTxtBot - editBelowTxt;
curIntEditWidth = curChanEditWidth;

curInt_ofTxtLeft = curIntEditLeft + curIntEditWidth + 10;
curInt_ofTxtBot = curIntTxtBot;
curInt_ofTxtWidth = curChan_ofTxtWidth;

intMaxEditLeft = curInt_ofTxtLeft + curInt_ofTxtWidth + 10;
intMaxEditBot = curIntEditBot;
intMaxEditWidth = chanMaxEditWidth;

intPlusButLeft = intMaxEditLeft + intMaxEditWidth + 20;
intPlusButBot = curIntEditBot;
intPlusButWidth = chanPlusButWidth;

intMinusButLeft = intPlusButLeft + intPlusButWidth + 10;
intMinusButBot = intPlusButBot;
intMinusButWidth = intPlusButWidth;

numAccTxtLeft = intMinusButLeft + intMinusButWidth + 20;
numAccTxtBot = curInt_ofTxtBot;
numAccTxtWidth = 120;

numAccEditLeft = numAccTxtLeft + numAccTxtWidth + 10;
numAccEditBot = numAccTxtBot - editBelowTxt;
numAccEditWidth = chanMaxEditWidth;
                          
gotoFirstBtnLeft = curIntTxtLeft;
gotoFirstBtnBot = curIntTxtBot - lineSpace;
gotoFirstBtnWidth = 130;

gotoNextBtnLeft = gotoFirstBtnLeft + gotoFirstBtnWidth + 20;
gotoNextBtnBot = gotoFirstBtnBot;
gotoNextBtnWidth = 160;

markNoiseBtnLeft = curIntTxtLeft;
markNoiseBtnBot = gotoFirstBtnBot - lineSpace;
markNoiseBtnWidth = 100;

markHVSBtnLeft = curIntTxtLeft;
markHVSBtnBot = markNoiseBtnBot - lineSpace;
markHVSBtnWidth = markNoiseBtnWidth;

unmarkNoiseBtnLeft = markNoiseBtnLeft + markNoiseBtnWidth + 20;
unmarkNoiseBtnBot = markNoiseBtnBot;
unmarkNoiseBtnWidth = 120;

unmarkHVSBtnLeft = markHVSBtnLeft + markHVSBtnWidth + 20;
unmarkHVSBtnBot = markHVSBtnBot;
unmarkHVSBtnWidth = unmarkNoiseBtnWidth;

recalcRefBtnLeft = markNoiseBtnLeft;
recalcRefBtnBot = markHVSBtnBot - 1.5 * lineSpace;
recalcRefBtnWidth = 150;

getIntsBtnLeft = recalcRefBtnLeft + recalcRefBtnWidth + 20;
getIntsBtnBot = recalcRefBtnBot;
getIntsBtnWidth = 100;
                  
HVStoSessionLeft = recalcRefBtnLeft;
HVStoSessionBot = recalcRefBtnBot - 1.5 * lineSpace;
HVStoSessionWidth = 300;

betaIntervals = initBetaIntervals();

f.gui = figure('units', 'pixels');
curPos = get(f.gui, 'position');
curPos(3) = curPos(3) + 100;
set(f.gui, 'position', curPos);

h.curChanText = uicontrol('style', 'text', ...
                          'position', [curChanTxtLeft, curChanTxtBot, curChanTxtWidth, txtHeight], ...
                          'string', 'current channel:');
h.curChanEdit = uicontrol('style', 'edit', ...
                          'position', [curChanEditLeft, curChanEditBot, curChanEditWidth, editHeight], ...
                          'callback', {@cb_curChanEdit});
h.chanPlusBut = uicontrol('style','pushbutton', ...
                          'position', [chanPlusButLeft, chanPlusButBot, chanPlusButWidth, btnHeight], ...
                          'string', '+', ...
                          'callback', {@cb_chanPlusBut});
h.chanMinusBut = uicontrol('style','pushbutton', ...
                          'position', [chanMinusButLeft, chanMinusButBot, chanMinusButWidth, btnHeight], ...
                          'string', '-', ...
                          'callback', {@cb_chanMinusBut});
h.curChan_ofText = uicontrol('style', 'text', ...
                             'position', [curChan_ofTxtLeft, curChan_ofTxtBot, curChan_ofTxtWidth, txtHeight], ...
                             'string', 'of');
h.maxChanEdit = uicontrol('style', 'edit', ...
                          'position', [chanMaxEditLeft, chanMaxEditBot, chanMaxEditWidth, editHeight], ...
                          'enable', 'off');
                      
h.subjectText = uicontrol('style', 'text', ...
                          'position', [subjectTxtLeft, subjectTxtBot, subjectTxtWidth, txtHeight], ...
                          'string', 'Subject:');          
h.subjectEdit = uicontrol('style', 'edit', ...
                          'position', [subjectEditLeft, subjectEditBot, subjectEditWidth, editHeight], ...
                          'enable', 'off');
h.dateText = uicontrol('style', 'text', ...
                          'position', [dateTxtLeft, dateTxtBot, dateTxtWidth, txtHeight], ...
                          'string', 'date:');              
h.dateEdit = uicontrol('style', 'edit', ...
                          'position', [dateEditLeft, dateEditBot, dateEditWidth, editHeight], ...
                          'enable', 'off');
h.tetrodeText = uicontrol('style', 'text', ...
                          'position', [tetrodeTxtLeft, tetrodeTxtBot, tetrodeTxtWidth, txtHeight], ...
                          'string', 'tetrode:');     
h.tetrodeEdit = uicontrol('style', 'edit', ...
                          'position', [tetrodeEditLeft, tetrodeEditBot, tetrodeEditWidth, editHeight], ...
                          'enable', 'off');
h.locText = uicontrol('style', 'text', ...
                          'position', [locTxtLeft, locTxtBot, locTxtWidth, txtHeight], ...
                          'string', 'Location:');       
h.locEdit = uicontrol('style', 'edit', ...
                          'position', [locEditLeft, locEditBot, locEditWidth, editHeight], ...
                          'enable', 'off');
h.sublocText = uicontrol('style', 'text', ...
                          'position', [sublocTxtLeft, sublocTxtBot, sublocTxtWidth, txtHeight], ...
                          'string', 'Subregion:');             
h.sublocEdit = uicontrol('style', 'edit', ...
                          'position', [sublocEditLeft, sublocEditBot, sublocEditWidth, editHeight], ...
                          'enable', 'off');

h.threshTxt = uicontrol('Style', 'text', ...
                        'position', [threshTxtLeft, threshTxtBot, threshTxtWidth, txtHeight], ...
                        'string', 'Threshold:');
h.threshEdit = uicontrol('style', 'edit', ...
                         'position', [threshEditLeft, threshEditBot, threshEditWidth, editHeight], ...
                         'callback', {@cb_threshEdit});
h.inVoltsTxt = uicontrol('Style', 'text', ...
                         'position', [inVoltsTxtLeft, inVoltsTxtBot, inVoltsTxtWidth, txtHeight], ...
                         'string', 'In mv:');
h.inVoltsEdit = uicontrol('style', 'edit', ...
                          'position', [inVoltsEditLeft, inVoltsEditBot, inVoltsEditWidth, editHeight], ...
                          'enable', 'off');

h.curIntText = uicontrol('style','text', ...
                         'position', [curIntTxtLeft, curIntTxtBot, curIntTxtWidth, txtHeight], ...
                         'string', 'current interval:');         
h.curIntEdit = uicontrol('style','Edit', ...
                         'position', [curIntEditLeft, curIntEditBot, curIntEditWidth, editHeight], ...
                         'callback', {@cb_currentInt});
h.curInt_ofTxt = uicontrol('style', 'text', ...
                           'position', [curInt_ofTxtLeft, curInt_ofTxtBot, curInt_ofTxtWidth, txtHeight], ...
                           'string', 'of');
h.maxIntEdit = uicontrol('style','Edit', ...
                         'position', [intMaxEditLeft, intMaxEditBot, intMaxEditWidth, editHeight], ...
                         'enable', 'off');

h.intPlusBut = uicontrol('style','pushbutton', ...
                         'position', [intPlusButLeft, intPlusButBot, intPlusButWidth, btnHeight], ...
                         'string', '+', ...
                         'callback', {@cb_intPlusBut});
h.intMinusBut = uicontrol('style','pushbutton', ...
                          'position', [intMinusButLeft, intMinusButBot, intMinusButWidth, btnHeight], ...
                          'string', '-', ...
                          'callback', {@cb_intMinusBut});
                      
h.numAcceptedTxt = uicontrol('style', 'text', ...
                             'position', [numAccTxtLeft, numAccTxtBot, numAccTxtWidth, txtHeight], ...
                             'string', 'Valid Oscillations: ');
h.numAcceptedEdit = uicontrol('style', 'edit', ...
                              'position', [numAccEditLeft, numAccEditBot, numAccEditWidth, editHeight], ...
                              'enable', 'off');

h.gotoFirstButton = uicontrol('style','pushbutton', ...
                              'position', [gotoFirstBtnLeft, gotoFirstBtnBot, gotoFirstBtnWidth, btnHeight], ...
                              'string', 'Go to First Interval', ...
                              'callback', {@cb_gotoFirst});
h.gotoNextAccButton = uicontrol('style','pushbutton', ...
                                'position', [gotoNextBtnLeft, gotoNextBtnBot, gotoNextBtnWidth, btnHeight], ...
                                'string', 'Go to Next Valid Interval', ...
                                'callback', {@cb_gotoNext});

h.markNoiseButton = uicontrol('style','pushbutton', ...
                              'position', [markNoiseBtnLeft, markNoiseBtnBot, markNoiseBtnWidth, btnHeight], ...
                              'string', 'Mark as Noise', ...
                              'callback', {@cb_markNoise});

h.markHVSbutton = uicontrol('style','pushbutton', ...
                            'position', [markHVSBtnLeft, markHVSBtnBot, markHVSBtnWidth, btnHeight], ...
                            'string', 'Mark as HVS', ...
                            'callback', {@cb_markHVS});

h.unmarkNoiseButton = uicontrol('style','pushbutton', ...
                              'position', [unmarkNoiseBtnLeft, unmarkNoiseBtnBot, unmarkNoiseBtnWidth, btnHeight], ...
                              'string', 'Unmark as Noise', ...
                              'callback', {@cb_unmarkNoise});

h.unmarkHVSbutton = uicontrol('style','pushbutton', ...
                            'position', [unmarkHVSBtnLeft, unmarkHVSBtnBot, unmarkHVSBtnWidth, btnHeight], ...
                            'string', 'Unmark as HVS', ...
                            'callback', {@cb_unmarkHVS});
                        
h.recalcRefButton = uicontrol('style','pushbutton', ...
                           'position', [recalcRefBtnLeft, recalcRefBtnBot, recalcRefBtnWidth, btnHeight], ...
                           'string', 'Recalculate Reference', ...
                           'callback', {@cb_recalculateRef});
                       
h.getInts = uicontrol('style','pushbutton', ...
                      'position', [getIntsBtnLeft, getIntsBtnBot, getIntsBtnWidth, btnHeight], ...
                      'string', 'Get Intervals', ...
                      'callback', {@cb_getInts});
                  
h.HVStoSessionButton = uicontrol('style','pushbutton', ...
                                 'position', [HVStoSessionLeft, HVStoSessionBot, HVStoSessionWidth, btnHeight], ...
                                 'string', 'Apply Current HVS Markers to Current Session', ...
                                 'callback', {@cb_HVStoSession});
ud.h = h;
ud.betaIntervals = betaIntervals;
ud.y = [];
ud.yfilt = [];
ud.t = [];

ud.threshold = initThreshold;
ud.curChan = 1;
ud.curInt = 1;

% create plotting figures
f.lfp = figure('name', 'raw field potential');
f.lfpFilt = figure('name', 'filtered lfp');
f.power = figure('name', 'power spectrum');

ud.f = f;

% create menus
% first, delete previous menu bar
set(f.gui, 'menubar', 'none');

% File menu
file_handle = uimenu(f.gui, 'label', 'File');
file_open_handle = uimenu(file_handle, 'label', 'Open Beta Intervals File', ...
    'callback', {@cb_menu_openBetaIntervals}); %#ok<NASGU>
file_save_handle = uimenu(file_handle, 'label', 'Save Beta Intervals File', ...
    'callback', {@cb_menu_saveBetaIntervals}); %#ok<NASGU>

set(f.gui, 'userdata', ud);

end % checkIntervals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cb_menu_openBetaIntervals %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb_menu_openBetaIntervals(~, ~)
  
	%Get user data
	fg = gcbf;
	
    ud = get(fg, 'userdata');
    betaIntervals = ud.betaIntervals;
    
	%If data exist, ask user if they wish to continue
	if length(betaIntervals) > 1,
      replaceInts = questdlg('Overwrite beta intervals in memory?', ...
          'Overwrite Intervals?', 'yes', 'no');
      if strcmpi(replaceInts, 'no') || isempty(replaceInts)
          return;
      end
	end
	
    %Get filename
    startPath = fullfile('/Volumes', 'data drive');
    cd(startPath);
    [fn, pn, ~] = uigetfile('*.mat', 'multiselect', 'off');
    if isempty(fn)
        return;
    end
    fn = fullfile(pn, fn);
    
    newData = load(fn);
    if ~verifyBetaIntStuct(newData)
        disp('Not a valid beta interval structure');
        return;
    end
    
    ud.betaIntervals = newData.betaIntervals;
    
    ud.curInt = 1;
    ud.curChan = 1;
    
    set(fg, 'userdata', ud);
    
    updateGUI(ud);
    
end % cb_menu_openBetaIntervals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cb_menu_saveBetaIntervals %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb_menu_saveBetaIntervals(~, ~)
  
	%Get user data
	fg = gcbf;
    ud = get(fg, 'userdata');
    betaIntervals = ud.betaIntervals; %#ok<NASGU>
    
    %Get filename
    startPath = fullfile('/Volumes', 'data drive');
    cd(startPath);
    [fn, pn, ~] = uiputfile('*.mat');
    if isempty(fn)
        return;
    end
    fn = fullfile(pn, fn);
    
    save(fn, 'betaIntervals');

end % cb_menu_saveBetaIntervals

%%%%%%%%%%%%%%%%%%
% cb_curChanEdit %
%%%%%%%%%%%%%%%%%%
function cb_curChanEdit(~, ~)

    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    newVal = str2num(get(ud.h.curChanEdit, 'string')); %#ok<ST2NM>
    if numel(newVal) ~= 1 || ...
       newVal < 1 || ...
       newVal > length(ud.betaIntervals) || ...
       newVal ~= round(newVal)
        % not a valid input
        set(ud.h.curChanEdit, 'string', num2str(ud.curChan));
        return;
    end
    
    ud.curChan = newVal;
    ud.curInt = 1;
    
    ud.y = [];
    ud.yfilt = [];
    ud.t = [];
    
    set(fg, 'userdata', ud);
    updateGUI(ud);

end % cb_curChanEdit

%%%%%%%%%%%%%%%%%
% cb_currentInt %
%%%%%%%%%%%%%%%%%
function cb_currentInt(~, ~)

    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    newVal = str2num(get(ud.h.curIntEdit, 'string')); %#ok<ST2NM>
    if numel(newVal) ~= 1 || ...
       newVal < 0 || ...
       newVal > length(ud.betaIntervals(ud.curChan).prelim.start_indx) || ...
       newVal ~= round(newVal)
        % not a valid input
        set(ud.h.curChanEdit, 'string', num2str(ud.curInt));
        return;
    end
    
    ud.curInt = newVal;
    
    set(fg, 'userdata', ud);
    updateGUI(ud);

    updateGUI(ud);
    updateLFP(ud);
    updateLFPfilt(ud);
    updatePower(ud);
    
end % cb_curChanEdit


%%%%%%%%%%%%%%%%%%
% cb_chanPlusBut %
%%%%%%%%%%%%%%%%%%
function cb_chanPlusBut(~, ~)

    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    if ud.curChan == length(ud.betaIntervals)
        return;
    end
    ud.curChan = ud.curChan + 1;
    ud.curInt = 1;
    
    ud.y = [];
    ud.yfilt = [];
    ud.t = [];
    
    set(fg, 'userdata', ud);
    updateGUI(ud);

end % cb_curChanEdit

%%%%%%%%%%%%%%%%%%%
% cb_chanMinusBut %
%%%%%%%%%%%%%%%%%%%
function cb_chanMinusBut(~, ~)

    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    if ud.curChan == 1
        return;
    end
    ud.curChan = ud.curChan - 1;
    ud.curInt = 1;
    
    ud.y = [];
    ud.yfilt = [];
    ud.t = [];
    
    set(fg, 'userdata', ud);
    updateGUI(ud);

end % cb_curChanEdit

%%%%%%%%%%%%%%%%%
% cb_intPlusBut %
%%%%%%%%%%%%%%%%%
function cb_intPlusBut(~, ~)

    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    if ud.curInt == length(ud.betaIntervals(ud.curChan).prelim.start_indx)
        return;
    end
    ud.curInt = ud.curInt + 1;
    
    set(fg, 'userdata', ud);
    updateGUI(ud);
    updateLFP(ud);
    ud = get(fg, 'userdata');
    updateLFPfilt(ud);
    ud = get(fg, 'userdata');
    updatePower(ud);

end % cb_curChanEdit

%%%%%%%%%%%%%%%%%%
% cb_intMinusBut %
%%%%%%%%%%%%%%%%%%
function cb_intMinusBut(~, ~)

    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    if ud.curInt == 0
        return;
    end
    ud.curInt = ud.curInt - 1;
    
    set(fg, 'userdata', ud);
    
    updateGUI(ud);
    updateLFP(ud);
    ud = get(fg, 'userdata');
    updateLFPfilt(ud);
    ud = get(fg, 'userdata');
    updatePower(ud);

end % cb_curChanEdit

%%%%%%%%%%%%%%%%
% cb_markNoise %
%%%%%%%%%%%%%%%%
function cb_markNoise(~, ~)

    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    currInt = ud.curInt;
    betaIntervals = ud.betaIntervals(ud.curChan);
    
    if currInt == 0
        start_indx = betaIntervals.firstIntervals.start_indx(1);
        end_indx = betaIntervals.firstIntervals.end_indx(1);
    else
        start_indx = betaIntervals.prelim.start_indx(currInt);
        end_indx = betaIntervals.prelim.end_indx(currInt);
    end
    
    % check to see if this interval is already marked as noise
    if any(betaIntervals.noiseIntervals.start_indx == start_indx)
        disp('Interval already marked as noise');
        return;
    end
    
    betaIntervals.noiseIntervals.start_indx = ...
        [betaIntervals.noiseIntervals.start_indx start_indx];
    betaIntervals.noiseIntervals.end_indx = ...
        [betaIntervals.noiseIntervals.end_indx end_indx];
    
    betaIntervals.noiseIntervals.start_indx = sort(betaIntervals.noiseIntervals.start_indx);
    betaIntervals.noiseIntervals.end_indx = sort(betaIntervals.noiseIntervals.end_indx);
    
    ud.betaIntervals(ud.curChan).noiseIntervals = betaIntervals.noiseIntervals;
    
    set(fg, 'userdata', ud);
    
    updateLFP(ud);
    updateLFPfilt(ud);
    
end % cb_markNoise

%%%%%%%%%%%%%%
% cb_markHVS %
%%%%%%%%%%%%%%
function cb_markHVS(~, ~)

    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    currInt = ud.curInt;
    betaIntervals = ud.betaIntervals(ud.curChan);
    
    if currInt == 0
        start_indx = betaIntervals.firstIntervals.start_indx(1);
        end_indx = betaIntervals.firstIntervals.end_indx(1);
    else
        start_indx = betaIntervals.prelim.start_indx(currInt);
        end_indx = betaIntervals.prelim.end_indx(currInt);
    end
    
    % check to see if this interval is already marked as an HVS
    if any(betaIntervals.HVS.start_indx == start_indx)
        disp('Interval already marked as HVS');
        return;
    end
    
    betaIntervals.HVS.start_indx = ...
        [betaIntervals.HVS.start_indx start_indx];
    betaIntervals.HVS.end_indx = ...
        [betaIntervals.HVS.end_indx end_indx];
    
    betaIntervals.HVS.start_indx = sort(betaIntervals.HVS.start_indx);
    betaIntervals.HVS.end_indx = sort(betaIntervals.HVS.end_indx);
    
    ud.betaIntervals(ud.curChan).HVS = betaIntervals.HVS;
    
    set(fg, 'userdata', ud);
    updateLFP(ud);
    updateLFPfilt(ud);
    
end % cb_markNoise

%%%%%%%%%%%%%%%%%%
% cb_unmarkNoise %
%%%%%%%%%%%%%%%%%%
function cb_unmarkNoise(~, ~)

    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    currInt = ud.curInt;
    betaIntervals = ud.betaIntervals(ud.curChan);
    
    % check to see if this interval is marked as noise
    if ~any(betaIntervals.noiseIntervals.start_indx == ...
           betaIntervals.prelim.start_indx(currInt))
        disp('Interval not marked as noise');
        return;
    end
    start_indx = betaIntervals.prelim.start_indx(currInt);
    
    unmarkIndx = (betaIntervals.noiseIntervals.start_indx == start_indx);
    betaIntervals.noiseIntervals.start_indx(unmarkIndx) = -1;
    valids = (betaIntervals.noiseIntervals.start_indx ~= -1);
    betaIntervals.noiseIntervals.start_indx = ...
        betaIntervals.noiseIntervals.start_indx(valids);
    betaIntervals.noiseIntervals.end_indx = ...
        betaIntervals.noiseIntervals.end_indx(valids);
    
    ud.betaIntervals(ud.curChan).noiseIntervals = betaIntervals.noiseIntervals;
    
    set(fg, 'userdata', ud);
    updateLFP(ud);
    updateLFPfilt(ud);
    
end % cb_unmarkNoise

%%%%%%%%%%%%%%%%
% cb_unmarkHVS %
%%%%%%%%%%%%%%%%
function cb_unmarkHVS(~, ~)
    
    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    currInt = ud.curInt;
    betaIntervals = ud.betaIntervals(ud.curChan);
    
    % check to see if this interval is marked as noise
    if ~any(betaIntervals.HVS.start_indx == ...
           betaIntervals.prelim.start_indx(currInt))
        disp('Interval not marked as HVS');
        return;
    end
    
    start_indx = betaIntervals.prelim.start_indx(currInt);
    
    unmarkIndx = (betaIntervals.HVS.start_indx == start_indx);
    betaIntervals.HVS.start_indx(unmarkIndx) = -1;
    valids = (betaIntervals.HVS.start_indx ~= -1);
    betaIntervals.HVS.start_indx = ...
        betaIntervals.HVS.start_indx(valids);
    betaIntervals.HVS.end_indx = ...
        betaIntervals.HVS.end_indx(valids);
    
    ud.betaIntervals(ud.curChan).HVS = betaIntervals.HVS;
    
    set(fg, 'userdata', ud);
    updateLFP(ud);
    updateLFPfilt(ud);
    
end % cb_unmarkHVS

%%%%%%%%%%%%%%%%%%%%%
% cb_recalculateRef %
%%%%%%%%%%%%%%%%%%%%%
function cb_recalculateRef(~, ~)

    %Get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    betaIntervals = ud.betaIntervals(ud.curChan);
    threshold = betaIntervals.threshold;
    Fs = betaIntervals.Fs;
    
    if isempty(ud.y)
        [~, ud.y] = loadLFP(ud);
    end
    if isempty(ud.yfilt)
        ud.yfilt = filterSignal(ud);
    end
    yfilt = ud.yfilt;
    ud.t = linspace(0, length(yfilt) / Fs, length(yfilt));
    
    excludeStarts = betaIntervals.noiseIntervals.start_indx;
    excludeEnds = betaIntervals.noiseIntervals.end_indx;
    for iExcludeInt = 1 : length(excludeStarts)
        yfilt(excludeStarts(iExcludeInt):excludeEnds(iExcludeInt)) = 0;
    end
    
    if threshold.excludeHVS
        excludeStarts = betaIntervals.HVS.start_indx;
        excludeEnds = betaIntervals.HVS.end_indx;
        for iExcludeInt = 1 : length(excludeStarts)
            yfilt(excludeStarts(iExcludeInt):excludeEnds(iExcludeInt)) = 0;
        end
    end % threshold.excludeHVS
    
    current_threshold = 0.5;
    last_threshold_up = 1;
    last_threshold_down = 0;
    last_successful_threshold = 0;
 
    absolute_max = max(abs(yfilt));
    step_counter=1; 
    while 1,        

        msg=sprintf('Searching for reference threshold: Step %d of %d', ...
            step_counter, ceil(-log(threshold.epsilon)/log(2)));
        disp(msg)
        disp(['threshold = ' num2str(current_threshold)]);
        step_counter=step_counter+1;
    
        %Use current threshold to see whether it results in episodes
        threshold.in_volts = absolute_max * current_threshold;
        
        %Does this find at least threshold.ints_at_rel_threshold intervals?
        betaIntervals = findIntervals(ud.t, ud.y, yfilt, threshold, betaIntervals);
        
        % added 8/2/10 by DL; keep track of what the first interval was so
        % it can be labelled as "noise" if necessary
        if ~isempty(betaIntervals.final.start_indx)
            firstIntervals = betaIntervals.final;
        end
        
        if isempty(betaIntervals.final.start_indx) || ...
                length(betaIntervals.final.start_indx) < threshold.ints_at_rel_threshold,
            %Not enough intervals found. Are we at the lowest allowed threshold?
            % added criterion for length of signal 7/31/2010 - DL
            if current_threshold <= threshold.lowerbound,
                %We are already at the bottom. Abort
                disp('No intervals even at lowest possible threshold. Using zero threshold');
                threshold.reference=0;
                threshold.users=0;
                return;
            else
                %Decrease the threshold.
                last_threshold_up = current_threshold;
                current_threshold = (current_threshold+last_threshold_down)/2;
                %Stop if the last_threshold_up came close enough to 
                %last_successful_threshold
                if last_threshold_up-last_successful_threshold <= threshold.epsilon,
                    break;
                end
                %Continue search
            end
        else
            %Intervals found. 
            %Stop if we are satisfied with this threshold
            last_successful_threshold = current_threshold;
            if last_threshold_up-current_threshold <= threshold.epsilon,
                break;
            else
                %Or continue the search by incrementing it.
                last_threshold_down = current_threshold;
                current_threshold = (current_threshold+last_threshold_up)/2;
                %Continue search
            end
        end

    end %Infinite loop while 1
    
    threshold.reference = last_successful_threshold * absolute_max;
    threshold.in_volts = threshold.reference * threshold.users;
    
    betaIntervals.threshold = threshold;
    betaIntervals.firstIntervals = firstIntervals;
    
    betaIntervals = findIntervals(ud.t, ud.y, yfilt, threshold, betaIntervals);
    ud.betaIntervals(ud.curChan) = betaIntervals;
    
    set(fg, 'userdata', ud);
    updateGUI(ud);
    
end % cb_recalculateRef

%%%%%%%%%%%%%%
% cb_getInts %
%%%%%%%%%%%%%%
function cb_getInts(~, ~)

    % get user data
    fg = gcbf;
    ud = get(fg, 'userdata');
    betaIntervals = ud.betaIntervals(ud.curChan);
    threshold = betaIntervals.threshold;
    Fs = betaIntervals.Fs;
    
    if isempty(ud.y)
        [~, ud.y] = loadLFP(ud);
    end
    if isempty(ud.yfilt)
        ud.yfilt = filterSignal(ud);
    end
    yfilt = ud.yfilt;
    ud.t = linspace(0, length(yfilt) / Fs, length(yfilt));
    
    excludeStarts = betaIntervals.noiseIntervals.start_indx;
    excludeEnds = betaIntervals.noiseIntervals.end_indx;
    for iExcludeInt = 1 : length(excludeStarts)
        yfilt(excludeStarts(iExcludeInt):excludeEnds(iExcludeInt)) = 0;
    end
    
    if threshold.excludeHVS
        excludeStarts = betaIntervals.HVS.start_indx;
        excludeEnds = betaIntervals.HVS.end_indx;
        for iExcludeInt = 1 : length(excludeStarts)
            yfilt(excludeStarts(iExcludeInt):excludeEnds(iExcludeInt)) = 0;
        end
    end % threshold.excludeHVS
    
    betaIntervals = findIntervals( ud.t, ud.y, yfilt, threshold, betaIntervals );
    
    ud.betaIntervals(ud.curChan) = betaIntervals;
    
    set(fg, 'userdata', ud);
    
    updateGUI(ud);
    
end % cb_getInts
    
%%%%%%%%%%%%%%%%%%%%%%%
%    findIntervals    %
%%%%%%%%%%%%%%%%%%%%%%%
function betaIntervals = findIntervals( t, y, yfilt, threshold, betaIntervals )

    disp('Initial screen')
    [betaIntervals.prelim] = get_interval_starts_ends( t, yfilt, threshold, betaIntervals );
    
    disp('calculating power ratios')
    [betaIntervals.final] = interval_power_screen( y, betaIntervals );

%     [signal.fused.start_indx, signal.fused.end_indx] = fuse_intervals(signal, threshold, 'final');
    
	%At this point, the n'th interval is defined by [signals.start_indx(n) signals.end_indx(n)]
	%where the indeces are the entry numbers in flags, and thus in
	%signals.y and my.
    
end    % findIntervals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function get_interval_starts_ends  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out] = get_interval_starts_ends( t, yfilt, threshold, betaIntervals ) %#ok<STOUT>

    Fs = betaIntervals.Fs;
    
    %Get positive and negative peaks in the filtered signal
    pos_peaks = get_peaks(yfilt, 1, 'pos');
    neg_peaks = get_peaks(yfilt, 1, 'neg');
    %Select only those that are above threshold
    if size(yfilt, 1) ~= size(pos_peaks, 1)
        yfilt = yfilt';
    end
    test_y = yfilt .* pos_peaks;
    infraindx = find(test_y < threshold.in_volts);
    pos_peaks(infraindx) = pos_peaks(infraindx)*0;
    
    test_y = yfilt .* neg_peaks;
    infraindx = find(abs(test_y) < threshold.in_volts);
    neg_peaks(infraindx) = neg_peaks(infraindx)*0;
    
    %Find interval starts and ends for both peak types
    start_indx = cell(2,1);
    end_indx = cell(2,1);
    for type = 1 : 2,
        %Rename
        if type == 1,
            flags = pos_peaks;
        else
            flags = neg_peaks;
        end
        
        %Find threshold crossings
		%At this point, flags is 1 at places where x has suprathreshold peaks
		%and zero elsewhere. Now, we need to process flags to remove intermediate lines
		ticks = find(flags == 1);
		LT = length(ticks);
        
        if LT,
			diffs = ticks(2:LT)-ticks(1:LT-1);
			largest_prd = threshold.peak_grouping_window / threshold.filter.cutoff(2);
            % largest_prd (largest_period) is the number of cycles
            % (contained in "peak_grouping_window") divided by the lower
            % limit of the passband of the filtered signal. largest_prd is
            % in seconds
			merge_width = Fs * largest_prd;
            % merge_width is the number of samples contained in largest_prd
			indx = find(diffs >= merge_width);
			% find peaks where the distance to the next peak is greater
            % than merge_width
            
			end_indx(type)={ticks([indx LT])};
			start_indx(type)={ticks([1 indx+1])};
			
			%Reject intervals shorter than P periods of the lowest frequency in the passband
			intervalCutoffDuration = threshold.intervalCutoff / threshold.filter.cutoff(2);
			durations = t(end_indx{type}) - t(start_indx{type});
			valids = find(durations >= intervalCutoffDuration);
			end_indx(type) = {end_indx{type}(valids)};
			start_indx(type) = {start_indx{type}(valids)};

        else
			end_indx(type)={[]};
			start_indx(type)={[]};
        end%if LT,
    end %for type=1:2,
    
    %Now we have the starts and ends computed using the positive and negative peaks
    %Take the logical OR of them.
    int_pos = get_interval_bitfield(length(yfilt), start_indx{1}, end_indx{1});
    int_neg = get_interval_bitfield(length(yfilt), start_indx{2}, end_indx{2});
    
    %OR
    int_all = int_pos | int_neg;
    int_all = [0 int_all 0];
    
    %differentiate
    int_new = diff(int_all);
    
    start_indx = find(int_new==1);
    end_indx = find(int_new==-1)-1;
    
    betaIntervals.prelim.start_indx = start_indx;
    betaIntervals.prelim.end_indx = end_indx;
    %At this point signals.start_indx and signals.end_indx contain the start and end
    %indeces of the intervals. Now, fuse those that are too close to each other
    [out.start_indx, out.end_indx] = fuse_intervals(t, betaIntervals, 'prelim');
    
end    % get_interval_starts_ends

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    interval_power_screen    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out] = interval_power_screen( y, betaIntervals )

% INPUTS:
%   signal - standard signal structure
%   threshold - threshold structure (for details, see top of m-file)
%   start_indx - start indices of candidate epochs
%   end_indx - end indices of candidate epochs
%   Fs - sampling rate of y in Hz

    threshold = betaIntervals.threshold;
    compareType = threshold.compareType;
    start_indx = betaIntervals.prelim.start_indx;
    end_indx = betaIntervals.prelim.end_indx;
    Fs = betaIntervals.Fs;
    %If no range or ratio to use, or no intervals, return.
    ranges = threshold.interval_power_screen_ranges;
    ratio = threshold.interval_power_screen_ratio;
    if isempty(ranges) || isempty(start_indx) || isempty(ratio),
        out.start_indx = start_indx;
        out.end_indx = end_indx;
        return;
    end

    num_of_ints = length(start_indx);
    durations = end_indx - start_indx;
    
    nfft = max(2 ^ nextpow2(max(durations)), 512);
%     nfft_dummy1 = ceil(log(max(durations))/log(2));
%     nfft=2^nfft_dummy1;


    for i=1:num_of_ints,
        [Pxx,f] = periodogram(detrend(y(start_indx(i):end_indx(i))), ...
                              [], nfft, Fs);
                          
        stopbandranges = [];
        for j = 1 : size(ranges, 1),
            stopbandranges = [stopbandranges find(f'>=ranges(j,1) & f'<=ranges(j,2))]; %#ok<AGROW>
        end
        passband=find(f>=threshold.filter.cutoff(2) & f<=threshold.filter.cutoff(3));

        %Check whether the bands overlap. This may happen in batch mode if files that have different
        %passbands are somehow processed using the same stopband
        testfield=ones(1, length(Pxx));
        testfield(stopbandranges)=testfield(stopbandranges).*0;
        if any(testfield(passband)==0),
            errmsg='The stopband for interval power screen overlaps with passband!';
            showMessage(ud.Handles.Texts.Message, errmsg, 0, 0.1);
            errordlg(errmsg);
        end
        
        compareString = ['ratio*' compareType '(Pxx(stopbandranges))>' compareType '(Pxx(passband))'];
        if eval(compareString),    % "mean" instead of "sum" - 
                                   % "sum" was used in origninal eegrhythm code
           start_indx(i)=-1; 
        end
    end
    
    valids = start_indx~=-1;
    out.start_indx = start_indx(valids);    
    out.end_indx = end_indx(valids);        

end    % interval_power_screen

%%%%%%%%%%%%%%%%%%%%%%%%
%    fuse_intervals    %
%%%%%%%%%%%%%%%%%%%%%%%%
function [start_indx, end_indx] = fuse_intervals( t, betaIntervals, useInts)

    threshold = betaIntervals.threshold;
    
    start_indx = betaIntervals.(useInts).start_indx;
    end_indx = betaIntervals.(useInts).end_indx;
    
    Ni = length(start_indx);    % number of intervals

    %Just return if interval fusion window is zero or there are at most 1 intervals
    if threshold.interval_fusion_window == 0 || Ni < 2,
        return;
    end

    range = 1:Ni-1;
    
    inter_interval_gaps = t(start_indx(range+1))-...
                          t(end_indx(range));

    %Find those that are too short
    fusion_window = threshold.interval_fusion_window / threshold.filter.cutoff(2);
    % fusion_window is the maximum amount of time allowed between epochs
    % before they should be fused (in seconds)
    too_short_indx = find(inter_interval_gaps <= fusion_window);
    
    if isempty(too_short_indx),
        return;
    end
    
    start_indx(too_short_indx+1) = start_indx(too_short_indx+1).*0-1;    
    valids = start_indx~=-1;
    start_indx = start_indx(valids);

    end_indx(too_short_indx) = end_indx(too_short_indx).*0-1;    
    valids = end_indx~=-1;
    end_indx = end_indx(valids);

end    % fuse_intervals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    get_interval_bitfield    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bit_field = get_interval_bitfield(n, start_indx, end_indx)
    
    bit_field = zeros(1, n+1);
    
    %put diracs
    bit_field(start_indx) = bit_field(start_indx)+1;
    bit_field(end_indx+1) = bit_field(end_indx+1)-1;
    
    %integrate
    bit_field = cumsum(bit_field);
    bit_field = bit_field(1:end-1);    
    
end    % get_interval_bitfield

%%%%%%%%%%%%%
% updateGUI %
%%%%%%%%%%%%%
function updateGUI(ud)
    
    currCh = ud.curChan;
    currInt = ud.curInt;
    h = ud.h;
    
    set(h.curChanEdit, 'string', num2str(currCh));
    set(h.maxChanEdit, 'string', num2str(length(ud.betaIntervals)));
    
    if ~isempty(ud.betaIntervals(currCh).channel)
        set(h.subjectEdit, 'string', ud.betaIntervals(currCh).channel.subject);
        set(h.dateEdit, 'string', ud.betaIntervals(currCh).channel.date);
        set(h.tetrodeEdit, 'string', ud.betaIntervals(currCh).channel.tetrode.name);
        set(h.locEdit, 'string', ud.betaIntervals(currCh).channel.location.name);
        set(h.sublocEdit, 'string', ud.betaIntervals(currCh).channel.location.subclass);

        set(h.curIntEdit, 'string', num2str(currInt));
        set(h.maxIntEdit, 'string', num2str(length(ud.betaIntervals(currCh).prelim.start_indx)));
        
        set(h.threshEdit, 'string', num2str(ud.betaIntervals(currCh).threshold.users));
        set(h.inVoltsEdit, 'string', num2str(ud.betaIntervals(currCh).threshold.in_volts));
        set(h.numAcceptedEdit, 'string', num2str(length(ud.betaIntervals(currCh).final.start_indx)));
    else
        set(h.subjectEdit, 'string', '');
        set(h.dateEdit, 'string', '');
        set(h.tetrodeEdit, 'string', '');
        set(h.locEdit, 'string', '');
        set(h.sublocEdit, 'string', '');

        set(h.curIntEdit, 'string', '');
        set(h.maxIntEdit, 'string', '');
        
        set(h.threshEdit, 'string', '');
        set(h.inVoltsEdit, 'string', '');
        set(h.numAcceptedEdit, 'string', '');
    end
    
end % updateDisplay

%%%%%%%%%%%%%
% updateLFP %
%%%%%%%%%%%%%
function updateLFP(ud)

    ud = get(ud.f.gui, 'userdata');
    
    edge_time = 0.05;
    edge_samples = round(edge_time * ud.betaIntervals(ud.curChan).Fs);
    
    betaIntervals = ud.betaIntervals(ud.curChan);
    
    figure(ud.f.lfp);
    if isempty(ud.y)
        [ud.t, ud.y] = loadLFP(ud);
    end
    
    % get interval to plot
    if ud.curInt == 0
        start_indx = betaIntervals.firstIntervals.start_indx(1);
        end_indx = betaIntervals.firstIntervals.end_indx(1);
    else
        start_indx = betaIntervals.prelim.start_indx(ud.curInt);
        end_indx = betaIntervals.prelim.end_indx(ud.curInt);
    end
    
    start_indx_edge = max(1, start_indx - edge_samples);
    end_indx_edge = min(length(ud.y), end_indx + edge_samples);
    
    hold off
    plot(ud.t(start_indx_edge:end_indx_edge), ud.y(start_indx_edge:end_indx_edge), 'k');
    hold on
    if any(betaIntervals.final.start_indx == start_indx)
        plotCol = 'r';
    else
        plotCol = 'b';
    end
    plot(ud.t(start_indx:end_indx), ud.y(start_indx:end_indx), plotCol);
    
    if any(betaIntervals.noiseIntervals.start_indx == start_indx)
        text('units', 'normalized', 'position', [.6 .8], ...
             'string', 'labelled noise');
    end
    
    if any(betaIntervals.HVS.start_indx == start_indx)
        text('units', 'normalized', 'position', [.6 .9], ...
             'string', 'labelled HVS', 'color', 'r');
    end

    set(gca,'xlim', [ud.t(start_indx_edge), ud.t(end_indx_edge)]);
    
    set(ud.f.gui, 'userdata', ud);
    
end % updateLFP

%%%%%%%%%%%%%%%%%
% updateLFPfilt %
%%%%%%%%%%%%%%%%%
function updateLFPfilt(ud)

    betaIntervals = ud.betaIntervals(ud.curChan);
    Fs = betaIntervals.Fs;
    
    edge_time = 0.05;
    edge_samples = round(edge_time * Fs);

    figure(ud.f.lfpFilt);
    if isempty(ud.yfilt)
        ud.yfilt = filterSignal(ud);
    end
    
    if length(ud.t) < length(ud.yfilt)
        ud.t = linspace(0, length(ud.yfilt) / Fs, length(ud.yfilt));
    end
    
    % get interval to plot
    if ud.curInt == 0
        start_indx = betaIntervals.firstIntervals.start_indx(1);
        end_indx = betaIntervals.firstIntervals.end_indx(1);
    else
        start_indx = betaIntervals.prelim.start_indx(ud.curInt);
        end_indx = betaIntervals.prelim.end_indx(ud.curInt);
    end
    
    start_indx_edge = max(1, start_indx - edge_samples);
    end_indx_edge = min(length(ud.yfilt), end_indx + edge_samples);
    
    hold off
    plot(ud.t(start_indx_edge:end_indx_edge), ud.yfilt(start_indx_edge:end_indx_edge), 'k');
    hold on
    if any(betaIntervals.final.start_indx == start_indx)
        plotCol = 'r';
    else
        plotCol = 'b';
    end
    plot(ud.t(start_indx:end_indx), ud.yfilt(start_indx:end_indx), plotCol);
    line([ud.t(start_indx_edge), ud.t(end_indx_edge)], ...
         [betaIntervals.threshold.in_volts, betaIntervals.threshold.in_volts], ...
         'color', 'k');
    
    if any(betaIntervals.noiseIntervals.start_indx == start_indx)
        text('units', 'normalized', 'position', [.6 .8], ...
             'string', 'labelled noise');
    end
    
    if any(betaIntervals.HVS.start_indx == start_indx)
        text('units', 'normalized', 'position', [.6 .9], ...
             'string', 'labelled HVS', 'color', 'r');
    end
    
    set(gca,'xlim', [ud.t(start_indx_edge), ud.t(end_indx_edge)]);
    
    set(ud.f.gui, 'userdata', ud);
    
end % updateLFPfilt

%%%%%%%%%%%%%%%
% updatePower %
%%%%%%%%%%%%%%%
function updatePower(ud)

    ud = get(ud.f.gui, 'userdata');
    
    betaIntervals = ud.betaIntervals(ud.curChan);
    threshold = betaIntervals.threshold;
    compareType = threshold.compareType;
    
    ranges = threshold.interval_power_screen_ranges;
    figure(ud.f.power)
    
    Fs = betaIntervals.Fs;
    % get interval to plot
    if ud.curInt == 0
        start_indx = betaIntervals.firstIntervals.start_indx(1);
        end_indx = betaIntervals.firstIntervals.end_indx(1);
    else
        start_indx = betaIntervals.prelim.start_indx(ud.curInt);
        end_indx = betaIntervals.prelim.end_indx(ud.curInt);
    end
    all_durations = betaIntervals.prelim.end_indx - ...
                    betaIntervals.prelim.start_indx;
    duration = end_indx - start_indx;
    nfft = max(2 ^ nextpow2(max(all_durations)), 512);
    
    startTime = ud.t(start_indx)
    endTime = ud.t(end_indx)
    
    [Pxx, f] = periodogram(detrend(ud.y(start_indx:end_indx)), ...
        [], nfft, Fs);
    
    stopbandranges = [];
    for j = 1 : size(ranges, 1),
        stopbandranges = [stopbandranges find(f'>=ranges(j,1) & f'<=ranges(j,2))]; %#ok<AGROW>
    end
    passband=find(f>=threshold.filter.cutoff(2) & f<=threshold.filter.cutoff(3)); %#ok<NASGU>

    compareString = [compareType '(Pxx(passband))/' compareType '(Pxx(stopbandranges))'];
    ratio = eval(compareString);
    
    hold off
    maxF = find(f < 60, 1, 'last');
    plot(f(1:maxF), Pxx(1:maxF));
    
    text('units', 'normalized', 'position', [.6, .7], ...
         'string', ['power ratio = ' num2str(ratio)]);
    
end % updatePower

%%%%%%%%%%%
% loadLFP %
%%%%%%%%%%%
function [t, LFP] = loadLFP(ud)

    fn = ud.betaIntervals(ud.curChan).channel.lfpFile;
    
    if ~exist(fn, 'file')
        [~, fname, ext, ~] = fileparts(fn);
        fn = which([fname ext]);
        ud.betaIntervals(ud.curChan).channel.lfpFile = fn;
    end
    
    lfpHeader = getHSDHeader(fn);
    Fs = lfpFs(lfpHeader);
    ud.betaIntervals(ud.curChan).Fs = Fs;
    
    repWire = ud.betaIntervals(ud.curChan).channel.repWire;
    
    disp('loading field potential...')
    tic
    LFP = readSingleWire(fn, repWire, 'datatype', 'int16');
    toc
    
    LFP = int2volt(LFP);
    
    t = linspace(0, length(LFP) / Fs, length(LFP));
    
    ud.y = LFP;
    ud.t = t;
    
    set(ud.f.gui, 'userdata', ud);
    
end

%%%%%%%%%%%%%%%%
% filterSignal %
%%%%%%%%%%%%%%%%
function yfilt = filterSignal(ud)
    
    b = ud.betaIntervals(ud.curChan).threshold.filter.b;
    a = ud.betaIntervals(ud.curChan).threshold.filter.a;
    
    if isempty(ud.y)
        [ud.t, ud.y] = loadLFP(ud);
    end
    
    disp('filtering signal');
    tic
    yfilt = filtfilt(b,a,ud.y);
    toc
    
    ud.yfilt = yfilt;
    
    set(ud.f.gui, 'userdata', ud);
    
end % filterSignal

%%%%%%%%%%%%%%%%%
% cb_threshEdit %
%%%%%%%%%%%%%%%%%
function cb_threshEdit(~, ~)

    fg = gcbf;
    ud = get(fg, 'userdata');
    
    threshold = ud.betaIntervals(ud.curChan).threshold;
    newThresh = str2num(get(ud.h.threshEdit, 'string')); %#ok<ST2NM>
    if numel(newThresh) ~= 1 || ...
       newThresh < 0 || ...
       newThresh > 1
        set(ud.h.threshEdit, 'string', num2str(threshold.users));
        return;
    end
    
    threshold.users = newThresh;
    threshold.in_volts = newThresh * threshold.reference;
    
    ud.betaIntervals(ud.curChan).threshold = threshold;
    
    set(fg, 'userdata', ud);
    
end % cb_threshEdit
    
%%%%%%%%%%%%%%%%%%
%  cb_gotoFirst  %
%%%%%%%%%%%%%%%%%%
function cb_gotoFirst(~, ~)

    fg = gcbf;
    ud = get(fg, 'userdata');
   
    ud.curInt = 0;
    
    set(ud.h.curIntEdit, 'string', '0');
    
    set(fg, 'userdata', ud);
    
    updateGUI(ud);
    ud = get(fg, 'userdata');
    updateLFP(ud);
    ud = get(fg, 'userdata');
    updateLFPfilt(ud);
    ud = get(fg, 'userdata');
    updatePower(ud);
    
end

%%%%%%%%%%%%%%%%%
%  cb_gotoNext  %
%%%%%%%%%%%%%%%%%
function cb_gotoNext(~, ~)

    fg = gcbf;
    ud = get(fg, 'userdata');
    
    betaIntervals = ud.betaIntervals(ud.curChan);
    
    if ud.curInt > 0
        curInt = ud.curInt;
    else
        curInt = 1;
    end
    curStartIndx = betaIntervals.prelim.start_indx(curInt);
    
    nextFinalIndx = find(betaIntervals.final.start_indx > curStartIndx, 1, 'first');
    if isempty(nextFinalIndx)
        nextFinalIndx = 1;
    end
    nextStartIndx = betaIntervals.final.start_indx(nextFinalIndx);
    
    ud.curInt = find(betaIntervals.prelim.start_indx == nextStartIndx);
    set(fg, 'userdata', ud);
    
    updateGUI(ud);
    updateLFP(ud);
    ud = get(fg, 'userdata');
    updateLFPfilt(ud);
    ud = get(fg, 'userdata');
    updatePower(ud);
    ud = get(fg, 'userdata');
    
end % cb_gotoNext

%%%%%%%%%%%%%%%%%%%
% cb_HVStoSession %
%%%%%%%%%%%%%%%%%%%
function cb_HVStoSession(~, ~)

    % since HVS are ubiquitous when they occur, transfer HVS timestamps
    % from one tetrode/stereotrode/eeg from a single session to all other
    % channels from that session
    fg = gcbf;
    ud = get(fg, 'userdata');
    
    betaIntervals = ud.betaIntervals;
    curChan = ud.curChan;
    curDate = betaIntervals(curChan).channel.date;
    curSubject = betaIntervals(curChan).channel.subject;
    
    numCh = 0;
    for iCh = 1 : length(betaIntervals)
        % loop through all elements of betaIntervals to find recordings
        % made in the same subject on the same data
        if iCh == curChan
            continue;
        end
        
        if isempty(betaIntervals(iCh).channel)
            continue;
        end
        
        if betaIntervals(iCh).channel.repWire == 0
            % no good wires for this channel
            continue;
        end
        
        if strcmp(betaIntervals(iCh).channel.date, curDate) && ...
           strcmp(betaIntervals(iCh).channel.subject, curSubject)
            % the data for the current channel were collected the same day
            % as the channel currently being edited. (Also, these channels
            % are from the same subject).
            
            betaIntervals(iCh).HVS.start_indx = ...
                [betaIntervals(iCh).HVS.start_indx, ...
                 betaIntervals(curChan).HVS.start_indx];
            betaIntervals(iCh).HVS.end_indx = ...
                [betaIntervals(iCh).HVS.end_indx, ...
                 betaIntervals(curChan).HVS.end_indx];
             
            numCh = numCh + 1;
            changedCh(numCh) = iCh; %#ok<AGROW>
            
        end
    end
    
    ud.betaIntervals = betaIntervals;
    % now, recalculate reference thresholds for each channel that had its
    % HVS markers changed
    for iCh = 1 : numCh

        ud.curChan = changedCh(iCh);

        betaIntervals = ud.betaIntervals(ud.curChan);
        threshold = betaIntervals.threshold;
        Fs = betaIntervals.Fs;
        
        disp(['Recalculating reference threshold for subject ' ...
              betaIntervals.channel.subject ', ' ...
              betaIntervals.channel.date ', channel ' ...
              betaIntervals.channel.tetrode.name ' (' ...
              num2str(iCh) ' of ' num2str(numCh) ')']);

        [~, ud.y] = loadLFP(ud);

        ud.yfilt = filterSignal(ud);

        yfilt = ud.yfilt;
        ud.t = linspace(0, length(yfilt) / Fs, length(yfilt));
    
        excludeStarts = betaIntervals.noiseIntervals.start_indx;
        excludeEnds = betaIntervals.noiseIntervals.end_indx;
        for iExcludeInt = 1 : length(excludeStarts)
            yfilt(excludeStarts(iExcludeInt):excludeEnds(iExcludeInt)) = 0;
        end
    
        if threshold.excludeHVS
            excludeStarts = betaIntervals.HVS.start_indx;
            excludeEnds = betaIntervals.HVS.end_indx;
            for iExcludeInt = 1 : length(excludeStarts)
                yfilt(excludeStarts(iExcludeInt):excludeEnds(iExcludeInt)) = 0;
            end
        end % if threshold.excludeHVS
    
        current_threshold = 0.5;
        last_threshold_up = 1;
        last_threshold_down = 0;
        last_successful_threshold = 0;
 
        absolute_max = max(abs(yfilt));
        step_counter=1; 
        while 1,        

            msg=sprintf('Searching for reference threshold: Step %d of %d', ...
                step_counter, ceil(-log(threshold.epsilon)/log(2)));
            disp(msg)
            disp(['threshold = ' num2str(current_threshold)]);
            step_counter=step_counter+1;

            %Use current threshold to see whether it results in episodes
            threshold.in_volts = absolute_max * current_threshold;

            %Does this find at least threshold.ints_at_rel_threshold intervals?
            betaIntervals = findIntervals(ud.t, ud.y, yfilt, threshold, betaIntervals);

            % added 8/2/10 by DL; keep track of what the first interval was so
            % it can be labelled as "noise" if necessary
            if ~isempty(betaIntervals.final.start_indx)
                firstIntervals = betaIntervals.final;
            end

            if isempty(betaIntervals.final.start_indx) || ...
                    length(betaIntervals.final.start_indx) < threshold.ints_at_rel_threshold,
                %Not enough intervals found. Are we at the lowest allowed threshold?
                % added criterion for length of signal 7/31/2010 - DL
                if current_threshold <= threshold.lowerbound,
                    %We are already at the bottom. Abort
                    disp('No intervals even at lowest possible threshold. Using zero threshold');
                    threshold.reference=0;
                    threshold.users=0;
                    return;
                else
                    %Decrease the threshold.
                    last_threshold_up = current_threshold;
                    current_threshold = (current_threshold+last_threshold_down)/2;
                    %Stop if the last_threshold_up came close enough to 
                    %last_successful_threshold
                    if last_threshold_up-last_successful_threshold <= threshold.epsilon,
                        break;
                    end
                    %Continue search
                end
            else
                %Intervals found. 
                %Stop if we are satisfied with this threshold
                last_successful_threshold = current_threshold;
                if last_threshold_up-current_threshold <= threshold.epsilon,
                    break;
                else
                    %Or continue the search by incrementing it.
                    last_threshold_down = current_threshold;
                    current_threshold = (current_threshold+last_threshold_up)/2;
                    %Continue search
                end
            end

        end %Infinite loop while 1
    
        threshold.reference = last_successful_threshold * absolute_max;
        threshold.in_volts = threshold.reference * threshold.users;

        betaIntervals.threshold = threshold;
        betaIntervals.firstIntervals = firstIntervals;

        betaIntervals = findIntervals(ud.t, ud.y, yfilt, threshold, betaIntervals);
        ud.betaIntervals(ud.curChan) = betaIntervals;

        set(fg, 'userdata', ud);
        updateGUI(ud);
    
    end    % for iCh
    
    ud.curChan = curChan;
    set(fg, 'userdata', ud);
    
    updateGUI(ud);
    
end  % end function cb_HVStoSession
            