% Clear the workspace and the screen
sca; % close alll previous open windows
close all; % close all figures etc. 
clearvars; % clear all variables 


% call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2); % setup Psychtoolbox - make it two 

Screen('Preference', 'SkipSyncTests', 1); % skip monitor tests, is not preffered. 


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


% STIMULUS PRESENTATION: INSTRUCTION
%
% open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey,[700 0 1000 300]); %

ifi = Screen('GetFlipInterval', window);

% get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% call the picture from its location
cd('E:\Backups\Matlab Directory\ieu_directory\scripts\experiments\flanker_task\instructions')

% read the picture and create texture
% create texture
DMSInstruction1 = imread('DMSInstruction1.jpg'); % read image from file (use jpg or jpeg). 
DMSInstruction1Texture = Screen('MakeTexture',window, DMSInstruction1); % Converts image to an index, makes processing it faster 

% STIMULUS PRESENTATION: STIMULUS LIST
cd('E:\Backups\Matlab Directory\ieu_directory\scripts\experiments\flanker_task\stimuli')
% fixation cross
fixation_image = imread('FixationCross.jpg'); % intruct the fixation image
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
Screen('DrawTexture',window,DMSInstruction1Texture); % draw texture on the window, you cannot see it yet. 

% flip the screen
Screen('Flip',window);

% wait for the key press
KbWait(); % Kb = keyboard

% blank screen for 2000 ms
Screen('Flip',window);
WaitSecs(2);


%% response related variables 
% Port 
noPressByte                     = 120; % port signal without any press
one_pressByte                   = 248; % button - 1 port signal
two_pressByte                   = 88;  % button - 2 port signal 
three_pressByte                 = 248; % button - 3 port signal
four_pressByte                  = 112; % button - 4 port signal
response_bytes                  = [one_pressByte, two_pressByte,three_pressByte,four_pressByte];
response_bytes_names             = {'one','two','three','four'};
pause_key                       = KbName('p');
escape_key                      = KbName('ESCAPE');


%% Experimental parameters
stimulus_duration = 0.15;
fixation_duration = 0.2;
inter_trial_interval = 1; 
keyboard_duration = 1;
stimConditionRepeatCount = 30;


%% create display matrix %% 

% stimulus - response contingencies (correct responses are indicates by = )
% cong_left = 'd'                cong right = 'l'
% neutral-left = 'd'             neutral-right = 'l'
% incong-left = 'd'              incong-right = 'l' 

% stimulus types
stimulusTypeVector          = {'cong_left','cong_right','incong_left','incong_right','neut_left','neut_right'};
% responses correspond to each stimulus type, columnwise
responseVector              = {'d','l','d','l','d','l'};
% stimulus texture indices
stimulusVector              = {cong_left_texture,cong_right_texture,incong_left_texture,incong_right_texture,neutral_left_texture,neutral_right_texture};
% add each of the above vectors in rows and create a stimulus presentation
% matrix
% 1. stimVector
% 2. stimulusTypeVector
% 3. responseVector
stimulusPresentationMatrix  = cat(1,stimulusVector, stimulusTypeVector,responseVector);
% repeat the columns to match total trial count
stimulusPresentationMatrix  = repmat(stimulusPresentationMatrix,1,stimConditionRepeatCount);
trialCount                  = length(stimulusPresentationMatrix); 
% randomize stimulus presentation matrix-columnwise

randomizationIndex = randperm(length(stimulusPresentationMatrix));
stimulusPresentationMatrix = stimulusPresentationMatrix(:,randomizationIndex);

%% create response table 

responseTableColumns =  {'trialNo','Stimulus_Type','Accuracy','AccuracyText','KeyName','RT','pressDateTime'};
responseTable=cell(trialCount+1,7); %trialCount+1 becase first row is header
responseTable(1,:) = responseTableColumns;

%% 
KbQueueCreate;
KbQueueStart;

registeryIteration = 1;
%% experiment loop 
experimentStartTime = GetSecs(); % get current time
for trial_iteration = 1:length(stimulusPresentationMatrix)   
    
    
    registeryEnabled = 1; % logical variable to check if there was a press made. used for creating omission registeries. 
    registeryIteration = registeryIteration+1; % shift one row for response registery table, every trial shifts it one row below. 
    correctResponse = stimulusPresentationMatrix{3,trial_iteration};
    if trial_iteration == 1
        stimulus_offset = experimentStartTime;        
    end
    
    Screen('DrawTexture',window,fixation_texture);
    
    fixation_onset = Screen('Flip', window , stimulus_offset + inter_trial_interval);  
    
    
    Screen('DrawTexture',window,stimulusPresentationMatrix{1,trial_iteration});
    
    stimulus_onset = Screen('Flip',window,fixation_onset+fixation_duration); 
    KbQueueFlush;
    
    while 1
        terminateLoop = (GetSecs() - stimulus_onset) >= (stimulus_duration-ifi); 
        if terminateLoop
            % end keyboard press registery if stimulus duration is about to
            % be exceeded.
            break
        end
        [pressed,buttonTimeVector] = KbQueueCheck;
        
        if pressed && registeryEnabled
            
            registeryEnabled = 0; % disable response registery after the first valid press
            buttonTimeVector(find(buttonTimeVector==0))=NaN;
            
            [pressTime, keyIndex] = min(buttonTimeVector);
            
            reactionTime = pressTime - stimulus_onset;
            
            pressedKeyName = KbName(keyIndex); 
            
            accuracyNumber = 0; % accuracy is incorrect because this is an early press with an RT < 250 ms
            
            if accuracyNumber == 0
                accuracyText='early';
            end
            
            dateTimeStr = datetime;
            dateTimeStr = datestr(dateTimeStr);
            dateTimeStr = regexprep(dateTimeStr, ' ', '_'); % remove all spaces in date and replace them with underscores
            dateTimeStr = regexprep(dateTimeStr, ':', '-'); % remove all COLONS in date and replace them with dashes
            
            responseTable{registeryIteration,1} = trial_iteration; % trial index ( 1,2,3,4...., n)
            responseTable{registeryIteration,2} = stimulusPresentationMatrix{2,trial_iteration}; % stimulus type 
            responseTable{registeryIteration,3} = accuracyNumber; % accuracy in number format 0
            responseTable{registeryIteration,4} = accuracyText; % accuracy in text  format 
            responseTable{registeryIteration,5} = pressedKeyName; % name of the button 
            responseTable{registeryIteration,6} = reactionTime; % reaction time in secodns
            responseTable{registeryIteration,7} = dateTimeStr;    % date and time of the press               
            
            % print respose registery for this trial
            fprintf('\nTrial Number: %d\nStimulus Type: %s\nAccuracy: %s\nKeyboard Key: %s\nReaction Time: %f\nDate: %f\n', ...
                                    responseTable{registeryIteration,1},...
                                    responseTable{registeryIteration,2},...
                                    responseTable{registeryIteration,4},...
                                    responseTable{registeryIteration,5},...
                                    responseTable{registeryIteration,6},...
                                    responseTable{registeryIteration,7});            
                                
        end
            
    end
    
    stimulus_offset = Screen('Flip', window , stimulus_onset + stimulus_duration); 
    
    while 1
        terminateLoop = (GetSecs() - stimulus_onset) >= (keyboard_duration-ifi); 
        if terminateLoop
            % end keyboard press registery if stimulus duration is about to
            % be exceeded.
            
            if registeryEnabled == 1
                % register omission response if there was no press made
                % until the keyboard duration expiration.
                accuracyNumber = 2;
                accuracyText = 'omission';
                reactionTime = nan;
                pressedKeyName = "none";
                dateTimeStr = datetime;
                dateTimeStr = datestr(dateTimeStr);
                dateTimeStr = regexprep(dateTimeStr, ' ', '_'); % remove all spaces in date and replace them with underscores
                dateTimeStr = regexprep(dateTimeStr, ':', '-'); % remove all COLONS in date and replace them with dashes

                responseTable{registeryIteration,1} = trial_iteration; % trial index ( 1,2,3,4...., n)
                responseTable{registeryIteration,2} = stimulusPresentationMatrix{2,trial_iteration}; % stimulus type 
                responseTable{registeryIteration,3} = accuracyNumber; % accuracy in number format 
                responseTable{registeryIteration,4} = accuracyText; % accuracy in text  format 
                responseTable{registeryIteration,5} = pressedKeyName; % name of the button 
                responseTable{registeryIteration,6} = reactionTime; % reaction time in secodns
                responseTable{registeryIteration,7} = dateTimeStr;    % date and time of the press 
                
                
                % print respose registery for this trial
                fprintf('\nTrial Number: %d\nStimulus Type: %s\nAccuracy: %s\nKeyboard Key: %s\nReaction Time: %f\nDate: %f\n', ...
                                        responseTable{registeryIteration,1},...
                                        responseTable{registeryIteration,2},...
                                        responseTable{registeryIteration,4},...
                                        responseTable{registeryIteration,5},...
                                        responseTable{registeryIteration,6},...
                                        responseTable{registeryIteration,7});                  
            end           
            
            break
            
            
        end
        [pressed,buttonTimeVector] = KbQueueCheck;
        
        if pressed && registeryEnabled
            
            registeryEnabled = 0; % disable response registery after the first valid press
            
            buttonTimeVector(find(buttonTimeVector==0))=NaN;
            
            [pressTime, keyIndex] = min(buttonTimeVector);
            
            reactionTime = pressTime - stimulus_onset;
            
            pressedKeyName = KbName(keyIndex); 
            
            accuracyNumber = double(keyIndex == KbName(correctResponse));
            
            if accuracyNumber == 1
                accuracyText='correct';
            else
                accuracyText='incorrect';
            end
            
            dateTimeStr = datetime;
            dateTimeStr = datestr(dateTimeStr);
            dateTimeStr = regexprep(dateTimeStr, ' ', '_'); % remove all spaces in date and replace them with underscores
            dateTimeStr = regexprep(dateTimeStr, ':', '-'); % remove all COLONS in date and replace them with dashes
            
            % register responses 
            responseTable{registeryIteration,1} = trial_iteration; % trial index ( 1,2,3,4...., n)
            responseTable{registeryIteration,2} = stimulusPresentationMatrix{2,trial_iteration}; % stimulus type 
            responseTable{registeryIteration,3} = accuracyNumber; % accuracy in number format 0
            responseTable{registeryIteration,4} = accuracyText; % accuracy in text  format 
            responseTable{registeryIteration,5} = pressedKeyName; % name of the button 
            responseTable{registeryIteration,6} = reactionTime; % reaction time in secodns
            responseTable{registeryIteration,7} = dateTimeStr;    % date and time of the press 
            
            % print respose registery for this trial
            fprintf('\nTrial Number: %d\nStimulus Type: %s\nAccuracy: %s\nKeyboard Key: %s\nReaction Time: %f\nDate: %f\n', ...
                                    responseTable{registeryIteration,1},...
                                    responseTable{registeryIteration,2},...
                                    responseTable{registeryIteration,4},...
                                    responseTable{registeryIteration,5},...
                                    responseTable{registeryIteration,6},...
                                    responseTable{registeryIteration,7});  
            
        end
            
    end
     
    
    
end

sca;

