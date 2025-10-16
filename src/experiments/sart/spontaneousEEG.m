%Before start the experiment upload the order of stimuli(modified_stim_order)
clear all

PsychDefaultSetup(2); % setup psychtoolbox ettings

initializeParallelPort; % setup port settings
KbName('UnifyKeyNames'); % unify all keyboard keys 


%% Window
Screen('Preference', 'SkipSyncTests', 0); % screen options
Screen('Preference','TextRenderer',1);
screens=Screen('Screens'); % get screen numbers
SCNM = max(screens); % get the maximum screen number for experiment display

white=WhiteIndex(SCNM); % screen white index: 1 1 1
black=BlackIndex(SCNM); % screen black index: 0 0 0
grey=white/2; % screen grey index .5 .5 .5

% OpenWindow
[window,windowrect]=PsychImaging('OpenWindow',SCNM,black);  %,[700 0 1000 300]

[Xcenter,Ycenter]=RectCenter(windowrect); % center pixel coordinates
centercoordinates=[Xcenter, Ycenter]; 
HideCursor(window);

%% Response Variables

% Keyboard Related
pause_key                       = KbName('p');

escape_key                      = KbName('ESCAPE');

%% Port Signals

%Response related
eyesClosedMarker    = 15; % for sending out port signal every 1 sec during eyes closed spontaneous recording
eyesOpenMarker      = 16; % for sending out port signal every 1 sec during eyes open spontaneous recording

% initialize response variables for errors 
exitKeyReg=1;

PressedPort=[];
PressedKeyboard = [];
exitmarker=1;
fixationCross = '+';
% initialize keyboard press registry
KbQueueCreate; KbQueueStart;

Screen('TextSize',window,75); % feedback and stimuli have 25 punto

% send experiment start signal to mark the start of spontaneous EEG recordings
sendParallelSignal(portAddress,1,ioObj) 
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)  

%% display fixation cross 
% press enter to start the recording
while 1
    KbPressWait();
     [~, ~, keyCode]=KbCheck;
            if keyCode(KbName('Return'))
                break;
            end
end
DrawFormattedText(window,fixationCross,'center', 'center',[1 1 1],120,[],[],1.25);
Screen('Flip',window);    
WaitSecs(2);


%% EYES CLOSED SPONTANEOUS

% send parallel port signal 6- to mark the *  START  * of EYES CLOSED SPONTANEOUS
sendParallelSignal(portAddress,6,ioObj)  
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)  
for k = 1:70
    
    checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
    if ~exitmarker
        break
    end
    
    WaitSecs(1);
    sendParallelSignal(portAddress,eyesClosedMarker,ioObj)  % send marker each second for segmenting spontaneous EEG
                                                            
    WaitSecs(.01);
    endParallelSignal(portAddress,ioObj) 

end

sendParallelSignal(portAddress,7,ioObj) % send parallel port signal 7- to mark the *  START  * of EYES CLOSED SPONTANEOUS
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)      

%% BREAK between EYES OPEN AND EYES CLOSED 
% press enter to continue after you instruct the participant 
Screen('Flip',window);
while 1
    KbPressWait();
     [~, ~, keyCode]=KbCheck;
            if keyCode(KbName('Return'))
                break;
            end
end

DrawFormattedText(window,fixationCross,'center', 'center',[1 1 1],120,[],[],1.25);
Screen('Flip',window);   
WaitSecs(2);
%% EYES OPEN SPONTANEOUS

sendParallelSignal(portAddress,8,ioObj)  % send parallel port signal 8- to mark the *  START  * of EYES OPEN SPONTANEOUS
WaitSecs(.01);
endParallelSignal(portAddress,ioObj) 
WaitSecs(1);

for k = 1:70
    
    checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
    if ~exitmarker
        break
    end
    WaitSecs(1);
    sendParallelSignal(portAddress,eyesOpenMarker,ioObj) % send marker each second for segmenting spontaneous EEG
    WaitSecs(.01);
    endParallelSignal(portAddress,ioObj) 
    
end

% end of eyes open 
sendParallelSignal(portAddress,9,ioObj)  % send parallel port signal 9- to mark the   *  END  *  of EYES OPEN SPONTANEOUS
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)      
    

%% % send experiment start signal to mark the  * END * of spontaneous EEG recordings
sendParallelSignal(portAddress,2,ioObj)
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)  

fclose('all');
sca;