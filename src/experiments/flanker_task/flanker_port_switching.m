% Clear the workspace and the screen
sca; % close alll previous open windows
close all; % close all figures etc. 
clearvars; % clear all variables 


% call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2); % setup Psychtoolbox - make it two 

initializeParallelPort; % initialize port driver in MATLAB 

Screen('Preference', 'SkipSyncTests', 1); % skip monitor tests, is not preffered. 

% send experiment START signal
sendParallelSignal(portAddress,1,ioObj)  
WaitSecs(.005);
endParallelSignal(portAddress,ioObj) 

% open file for writing data out
% get the screen numbers
screens = Screen('Screens'); % gives index of monitors 

% draw to the external screen if avaliable
screenNumber = max(screens); % select the monitor by its index 

% define black and white
white = WhiteIndex(screenNumber); % get white index of screen
black = BlackIndex(screenNumber); % get black index of screen
grey = white / 2; % get grey index of screen 

% create output file & login prompt
prompt = {'Subjects ID:', 'age', 'gender',...
    'Handedness (Left(0)/Right(1))','Counterbalance Group'}; % adjust-color position pairs 
defaults = {'flankersw_', '25', 'Male','0','0'};
answer = inputdlg(prompt, 'Flanker', 2, defaults);
[subid, subage, gender, handedness,cb_group] = deal(answer{:}); % all input variables are strings


% cb group 1 = cong instruction start
% cb group 2 = incong instruction start
cb_group = str2num(cb_group);

% STIMULUS PRESENTATION: INSTRUCTION
%
% open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey); %[700 0 1000 300]

ifi = Screen('GetFlipInterval', window);

% get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);


% remove mouse 
HideCursor();

% load common fixation for pause display 
cd('D:\MatlabDirectory\experiments\common')
pause_fixation = imread('fixation_cross.jpg'); % read image from file (use jpg or jpeg). 
pause_fixation_text = Screen('MakeTexture',window, pause_fixation); % Converts image to an index, makes processing it faster 


% call the picture from its location
cd('D:\MatlabDirectory\experiments\flanker_task\instructions')

% read the picture and create texture
% create texture
instruction_cong = imread('instructions.jpg'); % read image from file (use jpg or jpeg). 
instruction_cong_text = Screen('MakeTexture',window, instruction_cong); % Converts image to an index, makes processing it faster 

instruction_incong = imread('instructions_incong.jpg'); % read image from file (use jpg or jpeg). 
instruction_incong_text = Screen('MakeTexture',window, instruction_incong); % Converts image to an index, makes processing it faster 

caution_inst = imread('caution_instructions.jpg'); % read image from file (use jpg or jpeg). 
caution_inst_text = Screen('MakeTexture',window, caution_inst); % Converts image to an index, makes processing it faster 

inst_vector = [instruction_cong_text, instruction_incong_text];

if cb_group == 1
    inst_vector = flip(inst_vector);
end

% STIMULUS PRESENTATION: STIMULUS LIST
cd('D:\MatlabDirectory\experiments\flanker_task\stimuli')
% fixation cross
background_image = imread('background.jpg'); % intruct the fixation image
background_texture = Screen('MakeTexture',window,background_image); % transform the image to texture


% fixation cross
fixation_image = imread('fixation_cross_flanker.jpg'); % intruct the fixation image
fixation_texture = Screen('MakeTexture',window,fixation_image); % transform the image to texture


% CONG left
cong_left_image = imread('congruent_left.jpg'); % intruct the fixation image
cong_left_texture = Screen('MakeTexture',window,cong_left_image); % transform the image to texture

% CONG right
cong_right_image = imread('congruent_right.jpg'); % intruct the fixation image
cong_right_texture = Screen('MakeTexture',window,cong_right_image); % transform the image to texture

% INCONG left
incong_left_image = imread('incong_left.jpg'); % intruct the fixation image
incong_left_texture = Screen('MakeTexture',window,incong_left_image); % transform the image to texture

% INCONG right
incong_right_image = imread('incong_right.jpg'); % intruct the fixation image
incong_right_texture = Screen('MakeTexture',window,incong_right_image); % transform the image to texture

% NEUT left
neutral_left_image = imread('neutral_left.jpg'); % intruct the fixation image
neutral_left_texture = Screen('MakeTexture',window,neutral_left_image); % transform the image to texture

% NEUT right
neutral_right_image = imread('neutral_right.jpg'); % intruct the fixation image
neutral_right_texture = Screen('MakeTexture',window,neutral_right_image); % transform the image to texture

% wait for loading images etc. to be safe
WaitSecs(.50);


% draw the texture
Screen('DrawTexture',window,inst_vector(1)); % draw texture on the window, you cannot see it yet. 

% flip the screen
Screen('Flip',window);

% wait for the key press
KbWait(); % Kb = keyboard
% Screen('DrawTexture',window,fixation_texture);
% display caution instructions
WaitSecs(.5);
Screen('DrawTexture',window,caution_inst_text); % draw texture on the window, you cannot see it yet. 
Screen('Flip', window); 

KbWait(); % Kb = keyboard
Screen('Flip', window); 
% blank screen for 2000 ms
WaitSecs(2);


%% response related variables 
% Port 
noPressByte                     = 120; % port signal without any press
one_pressByte                   = 248; % button - 1 port signal
two_pressByte                   = 88;  % button - 2 port signal 
three_pressByte                 = 248; % button - 3 port signal
four_pressByte                  = 112; % button - 4 port signal
response_bytes                  = [one_pressByte, two_pressByte,three_pressByte,four_pressByte];
response_bytes_names            = {'one','two','three','four'};
pause_key                       = KbName('p');
escape_key                      = KbName('ESCAPE');


%% Experimental parameters
stimulus_duration = .2;
fixation_duration = .6;
keyboard_duration = 1;
stimConditionRepeatCount = 6;
fixation_onset_after_stim = 2.4;  %  epochs are -1.2 s before and 2.3 after onset, to prevent 
%% create display matrix %% 

% stimulus - response contingencies (correct responses are indicates by = )
% cong_left = 'd'                cong right = 'l'
% neutral-left = 'd'             neutral-right = 'l'
% incong-left = 'd'              incong-right = 'l' 


% stimulus texture indices
stimulusVector              = {cong_left_texture,cong_right_texture,incong_left_texture,incong_right_texture,neutral_left_texture,neutral_right_texture};
% stimulus types
stimulusTypeVector          = {'cong_left','cong_right','incong_left','incong_right','neut_left','neut_right'};
% responses correspond to each stimulus type, columnwise
responseVector              = {one_pressByte,two_pressByte,one_pressByte,two_pressByte,one_pressByte,two_pressByte};
% stimulus condition port signals (cong, incong, neut; 20,21,22 respectively)
conditionPortVector          = {20,20,21,21,22,22};
% detailes stimulus port signals (cong-left, cong-right, incong-left, incong-right, neut-left, neut-right; 30,31,35,36,40,41 respectively)
stimulusPortVector           = {30,31,35,36,40,41};
% condition port vector 
stimulusConditionVector      = {'congruent','congruent','incongruent','incongruent','neutral','neutral'};

trialCount                  = 4*length(stimulusTypeVector)*stimConditionRepeatCount; 

stimulusPresentationMatrix = {};

for k = 1:4
    stimPressMini = {};
    % add each of the above vectors in rows and create a stimulus presentation
    % matrix
    % 1. stimVector
    % 2. stimulusTypeVector
    % 3. responseVector
    % 4. conditionPortVector
    % 5. stimulusPortVector 
    
    if k == 1
        if cb_group == 1
            responseVector = flip(responseVector);
        end
    else
        responseVector = flip(responseVector);
    end

    stimPressMini = cat(1,stimulusVector, stimulusTypeVector,responseVector,conditionPortVector,stimulusPortVector,stimulusConditionVector);

    % repeat the columns to match total trial count
    stimPressMini  = repmat(stimPressMini,1,stimConditionRepeatCount);       
    
    % randomize stimulus presentation matrix-columnwise
    randomizationIndex = randperm(size(stimPressMini,2));    
    stimPressMini = stimPressMini(:,randomizationIndex);
    
    stimulusPresentationMatrix = cat(2,stimulusPresentationMatrix,stimPressMini);
end


%     stimulusPresentationMatrix  = cat(1,stimulusVector, stimulusTypeVector,responseVector,conditionPortVector,stimulusPortVector,stimulusConditionVector);
% stimulusPresentationMatrix  = repmat(stimulusPresentationMatrix,1,stimConditionRepeatCount);
    

%% create an inter-trial interval vector 
  
iti_vector = [3.75:.250:5]; % segment length -1.2 2.3 
iti_vector = [3.75:.250:5]-2; % segment length -1 1.5 
iti_display_vector = repmat(iti_vector,1,ceil(trialCount/length(iti_vector)));
% randomize inter-trial interval values 
randomizationIndex = randperm(length(iti_display_vector));
iti_display_vector = iti_display_vector(:,randomizationIndex);
%% create response table 

responseTableColumns =  {'trialNo','condition','stimulus_type','responseSwitch','AccuracyText','AccuracyNumber','KeyName','RT','pressDateTime'};
responseTable=cell(trialCount+1,length(responseTableColumns)); %trialCount+1 becase first row is header
responseTable(1,:) = responseTableColumns;

%% 
KbQueueCreate;
KbQueueStart;

registeryIteration = 1;
%% experiment loop 
experimentStartTime = GetSecs(); % get current time

exitmarker = 1; % when 0, experiment terminates. This is processed in checkPauseOrExitKeys function you see at the beginning of each loop.

responseSwitchCondition = 'normal';

for trial_iteration = 1:length(stimulusPresentationMatrix)   
    
    inter_trial_interval = iti_display_vector(trial_iteration);
    
     checkPauseOrExitKeys;
    if ~exitmarker
        break
    end
   
    
    enableResponseRegistry = 1; % logical variable to check if there was a press made. used for creating omission registeries. 
    registeryIteration = registeryIteration+1; % shift one row for response registery table, every trial shifts it one row below. 
    
    % trial parameters
    
    % stimulus type (cong-left, cong-right etc.)
    stimulusType = stimulusPresentationMatrix{2,trial_iteration};
    % correct response byte 
    correctResponse = stimulusPresentationMatrix{3,trial_iteration};
    % stimulus condition port signal (cong=20, incong=21 etc.)
    conditionPortSignal = stimulusPresentationMatrix{4,trial_iteration};
    % stimulus type port signal (cong-left=30, cong-right=31 etc.)
    stimulusPortSignal = stimulusPresentationMatrix{5,trial_iteration};
    % current condition name (cong, incong)
    currentCondition = stimulusPresentationMatrix{6,trial_iteration};
    
    if trial_iteration == 1
        stimulus_offset = experimentStartTime;        
    end
    
%     Screen('DrawTexture',window,fixation_texture);
%     % display fixation cross 
%     fixation_onset = Screen('Flip', window , stimulus_offset + inter_trial_interval);  
    
    
    Screen('DrawTexture',window,stimulusPresentationMatrix{1,trial_iteration});
    
    % display stimulus 
    stimulus_onset = Screen('Flip',window,stimulus_offset+inter_trial_interval); 
    
    % send condition port marker (cong, incong, neut)
    sendParallelSignal(portAddress,conditionPortSignal,ioObj)  % send parallel port signal for stimulus marker right after display was made on screen
    WaitSecs(.005);
    endParallelSignal(portAddress,ioObj) 
    
    % send stimulus port marker (cong-left, incong left, neut-right etc.)
    sendParallelSignal(portAddress,conditionPortSignal,ioObj)  % send parallel port signal for stimulus marker right after display was made on screen
    WaitSecs(.005);
    endParallelSignal(portAddress,ioObj)     
    KbQueueFlush;
    
    while 1
        % response registery between stimulus onset and stimulus offset 
        checkPauseOrExitKeys;
        if ~exitmarker
            break
        end
        terminateLoop = (GetSecs() - stimulus_onset) >= (stimulus_duration-ifi); 
        if terminateLoop
            % end keyboard press registery if stimulus duration is about to
            % be exceeded.
            break
        end
        
        if enableResponseRegistry
            
            currentResponseByte = double(io64(ioObj,portAddress(2)));   % second port address is response input
            Pressed  = noPressByte ~= currentResponseByte;

            if Pressed == 1
                enableResponseRegistry = 0; % stop registering responses until the next trial. 
                pressTime = GetSecs();
                reactionTime = pressTime - stimulus_onset;         

                responseIndex       = findIndices(response_bytes,currentResponseByte);
                responseAccuracy    = correctResponse == currentResponseByte;
                responseName        = response_bytes_names{responseIndex};
                
                accuracyNumber = 0;
                accuracyText = "early";
                portMarker = 9;
                % send INCORRECT response marker
                sendParallelSignal(portAddress,portMarker,ioObj);
                WaitSecs(.005);
                endParallelSignal(portAddress,ioObj)                  


                
                dateTimeStr = datetime;
                dateTimeStr = datestr(dateTimeStr);
                dateTimeStr = regexprep(dateTimeStr, ' ', '_'); % remove all spaces in date and replace them with underscores
                dateTimeStr = regexprep(dateTimeStr, ':', '-'); % remove all COLONS in date and replace them with dashes

                responseTable{registeryIteration,1} = trial_iteration; % trial index ( 1,2,3,4...., n)
                responseTable{registeryIteration,2} = currentCondition; % stimulus condition (incong, cong, neutral)
                responseTable{registeryIteration,3} = stimulusPresentationMatrix{2,trial_iteration}; % stimulus type (left-right+cong-inong) 
                responseTable{registeryIteration,4} = responseSwitchCondition; % switched or normal 
                responseTable{registeryIteration,5} = accuracyNumber; % accuracy in number format 
                responseTable{registeryIteration,6} = accuracyText; % accuracy in text  format 
                responseTable{registeryIteration,7} = responseName; % name of the button 
                responseTable{registeryIteration,8} = reactionTime; % reaction time in secodns
                responseTable{registeryIteration,9} = dateTimeStr;    % date and time of the press 
                
                
                % print respose registery for this trial
                fprintf('\nTrial Number: %d\nCondition: %s\nStimulus Type: %s\nAccuracy: %s\nKeyboard Key: %s\nReaction Time: %f\nDate: %s\n', ...
                                        responseTable{registeryIteration,1},...
                                        responseTable{registeryIteration,2},...
                                        responseTable{registeryIteration,3},...
                                        responseTable{registeryIteration,5},...
                                        responseTable{registeryIteration,6},...
                                        responseTable{registeryIteration,7},...
                                        responseTable{registeryIteration,8});       
            end
        end
            
    end
    
    % draw fixation cross
    Screen('DrawTexture',window,background_texture);
    stimulus_offset = Screen('Flip', window , stimulus_onset + stimulus_duration); 
    
    while 1
        checkPauseOrExitKeys;
        if ~exitmarker
            break
        end
        % response registery after stimulus offset 
        terminateLoop = (GetSecs() - stimulus_onset) >= (keyboard_duration-ifi); 
        if terminateLoop
            % end keyboard press registery if stimulus duration is about to
            % be exceeded.
            
            if enableResponseRegistry == 1
                % register omission response if there was no press made
                % until the keyboard duration expiration.
                accuracyNumber = 2;
                accuracyText = 'omission';
                reactionTime = nan;
                responseName = "none";
                dateTimeStr = datetime;
                dateTimeStr = datestr(dateTimeStr);
                dateTimeStr = regexprep(dateTimeStr, ' ', '_'); % remove all spaces in date and replace them with underscores
                dateTimeStr = regexprep(dateTimeStr, ':', '-'); % remove all COLONS in date and replace them with dashes

                responseTable{registeryIteration,1} = trial_iteration; % trial index ( 1,2,3,4...., n)
                responseTable{registeryIteration,2} = currentCondition; % stimulus condition (incong, cong, neutral)
                responseTable{registeryIteration,3} = stimulusPresentationMatrix{2,trial_iteration}; % stimulus type (left-right+cong-inong) 
                responseTable{registeryIteration,4} = responseSwitchCondition; % switched or normal 
                responseTable{registeryIteration,5} = accuracyNumber; % accuracy in number format 
                responseTable{registeryIteration,6} = accuracyText; % accuracy in text  format 
                responseTable{registeryIteration,7} = responseName; % name of the button 
                responseTable{registeryIteration,8} = reactionTime; % reaction time in secodns
                responseTable{registeryIteration,9} = dateTimeStr;    % date and time of the press 
                
                
                % print respose registery for this trial
                fprintf('\nTrial Number: %d\nCondition: %s\nStimulus Type: %s\nAccuracy: %s\nKeyboard Key: %s\nReaction Time: %f\nDate: %s\n', ...
                                        responseTable{registeryIteration,1},...
                                        responseTable{registeryIteration,2},...
                                        responseTable{registeryIteration,3},...
                                        responseTable{registeryIteration,5},...
                                        responseTable{registeryIteration,6},...
                                        responseTable{registeryIteration,7},...
                                        responseTable{registeryIteration,8});           
                               
                
                                    
                                    
                % send OMISSION response marker
                portMarker = 8;                
                sendParallelSignal(portAddress,portMarker,ioObj);
                WaitSecs(.005);
                endParallelSignal(portAddress,ioObj) 
                
            end           
            
            % terminate response registery loop
            break            
            
        end
        
        if enableResponseRegistry
            
            currentResponseByte = double(io64(ioObj,portAddress(2)));   % second port address is response input
            % check if no response byte is different, it is different if there is a button press .
            Pressed  = noPressByte ~= currentResponseByte;

            if Pressed == 1
                enableResponseRegistry = 0; % stop registering responses until the next trial. 
                pressTime = GetSecs();
                % calculate reaction time 
                reactionTime = pressTime - stimulus_onset;         
                
                
                % find out which of the port buttons were pressed 
                responseIndex       = findIndices(response_bytes,currentResponseByte);                
                responseAccuracy    = correctResponse == currentResponseByte;
                % get the name of the button press
                responseName        = response_bytes_names{responseIndex};

                if responseAccuracy == 1
                    accuracyText = "correct";
                    accuracyNumber = 1;
                    portMarker = 10;
                    % send CORRECT response marker
                    sendParallelSignal(portAddress,portMarker,ioObj);

                else
                    accuracyNumber = 0;
                    accuracyText = "error";
                    portMarker = 9;
                    % send INCORRECT response marker
                    sendParallelSignal(portAddress,portMarker,ioObj);

                end
                % END accuracy marker signals
                WaitSecs(.005);
                endParallelSignal(portAddress,ioObj)                  


                
                dateTimeStr = datetime;
                dateTimeStr = datestr(dateTimeStr);
                dateTimeStr = regexprep(dateTimeStr, ' ', '_'); % remove all spaces in date and replace them with underscores
                dateTimeStr = regexprep(dateTimeStr, ':', '-'); % remove all COLONS in date and replace them with dashes

                responseTable{registeryIteration,1} = trial_iteration; % trial index ( 1,2,3,4...., n)
                responseTable{registeryIteration,2} = currentCondition; % stimulus condition (incong, cong, neutral)
                responseTable{registeryIteration,3} = stimulusPresentationMatrix{2,trial_iteration}; % stimulus type (left-right+cong-inong) 
                responseTable{registeryIteration,4} = responseSwitchCondition; % switched or normal 
                responseTable{registeryIteration,5} = accuracyNumber; % accuracy in number format 
                responseTable{registeryIteration,6} = accuracyText; % accuracy in text  format 
                responseTable{registeryIteration,7} = responseName; % name of the button 
                responseTable{registeryIteration,8} = reactionTime; % reaction time in secodns
                responseTable{registeryIteration,9} = dateTimeStr;    % date and time of the press 
                
                
                  % print respose registery for this trial
                fprintf('\nTrial Number: %d\nCondition: %s\nStimulus Type: %s\nAccuracy: %s\nKeyboard Key: %s\nReaction Time: %f\nDate: %s\n', ...
                                        responseTable{registeryIteration,1},...
                                        responseTable{registeryIteration,2},...
                                        responseTable{registeryIteration,3},...
                                        responseTable{registeryIteration,5},...
                                        responseTable{registeryIteration,6},...
                                        responseTable{registeryIteration,7},...
                                        responseTable{registeryIteration,8});        
            end
        end
            
    end
    
    % present fixation cross after response window    
%     % draw fixation cross
%     Screen('DrawTexture',window,fixation_texture);
%     fixation_onset = Screen('Flip', window , stimulus_onset + fixation_onset_after_stim); 
    
        
     if trial_iteration == (trialCount*1/4) || trial_iteration == (trialCount*2/4) || trial_iteration == (trialCount*3/4)  
        if trial_iteration > (trialCount*1/4)
            % after the first switch ( because there are no prior switches before that)
            % send previous switch FINISHED (6) marker through port
            sendParallelSignal(portAddress,6,ioObj);
            WaitSecs(.1);
            endParallelSignal(portAddress,ioObj)   
        end
        if strcmp(responseSwitchCondition,'normal')
            responseSwitchCondition = 'switched';
        else
            responseSwitchCondition = 'normal';
        end
        
      
        
        inst_vector = flip(inst_vector);
        % draw the texture
        Screen('DrawTexture',window,inst_vector(1)); % draw texture on the window, you cannot see it yet. 

        % flip the screen
        Screen('Flip',window);

        % wait for the key press
        KbWait(); % Kb = keyboard
        % Screen('DrawTexture',window,fixation_texture);
        WaitSecs(.5);
        % display caution instructions
        Screen('DrawTexture',window,caution_inst_text); % draw texture on the window, you cannot see it yet. 
        Screen('Flip', window);     
        
        KbWait(); % Kb = keyboard
        Screen('Flip', window);          
        % send switched (5) marker through port
        sendParallelSignal(portAddress,5,ioObj);
        WaitSecs(.1);
        endParallelSignal(portAddress,ioObj)        
        
        % blank screen for inter_trial_interval ms
        WaitSecs(inter_trial_interval);

        
          
     end
    
    
end

% change directory for response registery 
cd('D:\MatlabDirectory\experiments\flanker_task\data')
tableResponse = cell2table(responseTable);
tableResponse.Properties.VariableNames = responseTable(1,:);
tableResponse(1,:)=[];

dateTimeStr = datetime;
dateTimeStr = datestr(dateTimeStr);
dateTimeStr = regexprep(dateTimeStr, ' ', '_'); % remove all spaces in date and replace them with underscores
dateTimeStr = regexprep(dateTimeStr, ':', '-'); % remove all COLONS in date and replace them with dashes

dataFileName = [subid,'_flanker_',dateTimeStr,'.xlsx'];
writetable(tableResponse,dataFileName);
fclose('all');
sca;

% show mouse 
ShowCursor();

% send experiment STOPPED signal
sendParallelSignal(portAddress,2,ioObj)  
WaitSecs(.005);
endParallelSignal(portAddress,ioObj) 
