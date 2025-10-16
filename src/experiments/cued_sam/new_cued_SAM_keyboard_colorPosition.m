% INTRODUCTION
% Most important problem in multistable perception research is to detect
% the perceptual reversal onset while using continuous presentation of
% ambiguous figures. This problem has been tackled by using discontinuous
% presentation of figures, however, they alter reversal rate dynamics and
% underlying brain activity due to the subsequent presentation of
% discontinuous images. 
% This is the first version of cued SAM paradigm. Novelty of this paradigm
% is that it gives us the exact stimulus onset of perceptual reversals during 
% continuous presentation of the regular SAM. Participants have to be trained very
% well to do this, so there is an advanced training schedule which must be
% mandatory for all experiments. 
%
% MAIN IDEA
% Gist of this paradigm is that we assign colors to each two of the double
% dots displays in a given sequence. Then we ask participants to pay close
% attention to the colors and their order (e.g. 1st or 2nd blue dot) and
% report at which of the colored dots they experienced the change in dot
% direction. 
%
% PARTICIPANT PROCEDURE
% Participants are asked to press and release a button quickly or hold the
% release for longer depending on their specific instructions. This
% difference in release of the button gives us the order information of the
% colored dot (2nd-red dot). This way we can stimulus lock our EEG data and
% conduct ITC/Phase coherence analyses even in multistable perception. 
%
% COMPARABLE DWELL TIMES FOR EXOGENOUS AND ENDOGENOUS TASK
% There is another important contribution of this paradigm which is that it
% extacts individual dwell times (dominance durations) of each percept and
% then use these in exogenous task in the same or randomized order
% (according to your choice). This will then enable researchers to compare
% endogenous and exogenous reversals with the exact dwell time durations,
% eliminating the ITI effects on deviance detection. 
%
% LIMITATIONS
% Potentially, this paradigm will increase the cognitive load and affect
% the EEG recording. Because of that, both standard presentation of
% exogenous and endogenous tasks will be administered along with their cued
% counter parts. Response locked EEG of all these conditions should be
% compared to investigate such additional effects. 
% Training and learning is known to affect perceptual reversal rates.
% Strict training schedule in this task will likely affect the dynamics.
% Therefore, baseline recordings of standard SAM and post-training
% recordings of standard SAM are necessary at least for the initial
% publications. 
%

%
%
%
%% Initialize experiment


% Clear the workspace and the screen
sca;
close all;
clearvars;
initializeParallelPort
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
KbName('UnifyKeyNames')
Screen('Preference', 'SkipSyncTests', 1); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Login prompt and open file for writing data out %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prompt = {'Subject''s number:', 'age', 'gender',...
    'Handedness (Left(0)/Right(1))',...
    'Red-Left/Blue-Right (0), Blue-Left/Red-Right Button (1)', ... % Color and left right definitions. One color is left the other is right
    'TopLeft-Short/BottomLeft-Long (0), BottomLeft-Short/First-Long (1)',... % position and press durations definitions. (Default: short presses > Top-left Ambiguous, Left-Hor, Top-Ver)
    ...                                                                       %                                                    long presses > Bot-Left Ambiguous, Right-Hor, Bot-Ver)
    'First Color (Red(0)/Blue(1)',... % which of the colors will be the first stimulus to be represented 
    'First Color-Position Pair (C1(0)/C2(1)'}; % adjust-color position pairs 
defaults = {'pcheck1', '28', 'Male','0','0','0','0','0','0'};
answer = inputdlg(prompt, 'Color Order SAM', 2, defaults);
[subid, subage, gender, handedness,balancePressedKeys, balancePressDuration, firstColor,firstCPPair] = deal(answer{:}); % all input variables are strings


% Counter-balancing keyboard keys and press durations
% balancePressDuration = 0; % (0) short: Top-left Ambiguous, Left-Hor, Top-Ver, long: Bot-Left Ambiguous, Right-Hor, Bot-Ver /// (1) inverse 
% balancePressedKeys   = 0; % (0) left-red/vertical right-blue/horizontal, (1) left-blue/horizontal, right-red/vertical
balancePressedKeys=str2num(balancePressedKeys);
balancePressDuration=str2num(balancePressDuration);
firstColor=str2num(firstColor);
firstCPPair=str2num(firstCPPair);

if balancePressedKeys
    % topLeft and bottomLeft represent the dot positions in SAM. These counterbalances also change exogenous position responses.
    % Responses to two set of three positions are the same for each row 
    % Top-left Ambiguous Left-Hor, Top-Ver = SHORT PRESS IF DEFAULT
    % Bot-Left Ambiguous: Right-Hor, Bot-Ver = LONG PRESS IF COUNTERBALANCED
    if balancePressDuration == 0
        counterBalanceGroup = 'R_topLeftShort'; % (1) red left button, first color changes require short presses
    else
        counterBalanceGroup = 'R_bottomLeftLong'; % (2) red left button, first color changes require long presses
    end
else
    if balancePressDuration == 0
        counterBalanceGroup = 'B_topLeftShort'; % (3) blue left button, first color changes require short presses
    else
        counterBalanceGroup = 'B_bottomLeftLong'; % (4) blue left button, first color changes require long presses
    end
end

% Create data folder in the directory specified below. 
dataFolder ='D:\MatlabDirectory\AllScripts\MertKucuk\Cued_SAM\behavioralData';
cd(dataFolder)
subname= ['sub', subid,'_',counterBalanceGroup];
subjectFolder = [dataFolder, '\', subname];

mkdir(subjectFolder)
cd(subjectFolder)

participantInfo = {subid, subage, gender, counterBalanceGroup};

participantInfo=cell2table(participantInfo);



%% Create experimental blocks and trials

prepareExperimentalBlocks;
experimentalBlockNames_table = cell2table(cat(1,experimentalBlockNames{:}));
writetable(participantInfo,[subid,'_info.txt']);
writetable(experimentalBlockNames_table,[subid,'_blockInfo.txt']);



%% Initialize Screen via Psychtoolbox
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens); %max(screens); % select the screen you want to display

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white); %  ,[0 0 550 550] , [0 0 700 700]

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
%% EXPERIMENT PARAMETERS: STIMULUS IN SIZE/COLORS/DURATIONS, RESPONSE PORTS, PRESS DURATIONS ETC.
default=1; % this does not have an effect at the moment
if default 
    % enter stimulus length properties 
    stimulusParameters(1:3)         = [11.2 , 8.9 , 0.4]; % 11.2 and 8.9 are H x W in cm of black rectangle, 0.4 is length of each margin of dot display in cm 
    screenParameters                = [44.3, screenXpixels;xCenter,yCenter]; % 44.3 is IEU lab Faraday Monitor's horizontal screen length in CM 
    % Create Stimulus Durations
    durations = {[5 1],[0.370 0.130],[0.555 0.195]}; % (1) simple reaction time task: 370 ms stimulus, 1 second fixation
                                           % (2) stroboscopic motion: 370 ms stimulus, 130 ms second fixation
                                           % (3) 1.5 slowed stroboscopic motion: 555 ms double dot, 195 ms fixation
    % color matrices for presentation: 
    whiteDot                        = {[1 1 1;1 1 1;1 1 1],[1 1 1],[1 1 1;1 1 1;1 1 1],[1 1 1]};
    redDot                          = {[1 1 1;0 0 1;0 0 1],[1 1 1],[1 1 1;0 0 1;0 0 1],[1 1 1]};  % colors are defined column-wise
    blueDot                         = {[0 0 1;.8 .8 1;.8 .8 1],[1 1 1],[0 0 1;.8 .8 1;.8 .8 1],[1 1 1]}; 
    allColors                       = {whiteDot, redDot, blueDot};
    %% Port variables 
    noPressByte                     = 120;
    leftPressByte                   = 248;
    rightPressByte                  = 104; 
    portVariables                   = {ioObj,portAddress,noPressByte};
    response_bytes                  = [leftPressByte, rightPressByte];
    response_names                  = {'SOL', 'SAG'};
    %% Keyboard variables
    left_key                        = KbName('d');   % !!!!!!!!!!!!!!!!counter balance 
    right_key                       = KbName('l');   % !!!!!!!!!!!!!!!!counter balance 
    response_keys                   = [left_key, right_key];    
    pause_key                       = KbName('p');
    escape_key                      = KbName('ESCAPE');
    resp_duration_text              = {'KISACA', 'UZUNCA'};
    resp_duration_text_FCRTT        = {'ambiguous_left_top','horizontal_left','vertical_top';'ambiguous_left_bottom','horizontal_right','vertical_bottom'};
    % press durations
    short_press                     = 0.5; 
    long_press                      = 2;
    standard_press                  = 2;
    long_lower_limit                = 0.5;
    
    % four choice reaction task sound reinforcement
    amp             = 1;
    sampling_fr     = 44100;
    duration_s      = 0.200; % short sound duration 
    duration_l      = 1; % long sound duration 
    freq            = 2000;
    timePoints_s    = 0:1/sampling_fr:duration_s;
    timePoints_l    = 0:1/sampling_fr:duration_l;
    shortSound      = amp*sin(2*pi*freq*timePoints_s);    % short sound array 
    longSound       = amp*sin(2*pi*freq*timePoints_l);    % long sound array 
    % Rise and fall time 
    riseFall        = .03;
    riseFallPoints  = floor(riseFall*sampling_fr);
    hanningWindow   = hanning(2*riseFallPoints).';
    
    beginHan        = hanningWindow(1:ceil(length(hanningWindow))/2);
    endHan          = hanningWindow((ceil(length(hanningWindow))/2)+1:end);
    
    beginHanShort   = [beginHan ones(1,length(shortSound)-length(beginHan))];
    beginHanLong    = [beginHan ones(1,length(longSound)-length(beginHan))];
    endHanShort   = [ones(1,length(shortSound)-length(endHan)) endHan];
    endHanLong    = [ones(1,length(longSound)-length(endHan)) endHan];
    
    shortSound_RF   = shortSound .* beginHanShort .* endHanShort;
    longSound_RF   = longSound .* beginHanLong .* endHanLong;
end    

%%%% CREATE STIMULUS COORDINATES AND RECTANGLES %%%%
% create stimulus rectangles and dots calibrated to your screen 
[baseRectCenter, allRects] = createStimuli(stimulusParameters, screenParameters);

%% Create Descriptions of Stimulus Properties
% names for each double dot and fixation displays. 
% Recall the row order of stimulus configurations in AllRects. Names are
% also defined in the same row order below.
stimTypes={'ambiguous_left_bottom','fixation','ambiguous_left_top','fixation';
    'vertical_bottom','fixation','vertical_top','fixation';
    'horizontal_right','fixation','horizontal_left','fixation'};

if firstCPPair == 1 % switch color-position pairs according to counterbalance group 
    stimTypes([1 2 3 7 8 9])=stimTypes([7 8 9 1 2 3]);
end

% names for movement directions
movementDirections={'ambiguous','vertical','horizontal'};

% presentation order for colored dots. First-red, second-red, first-blue
% etc. 
presentationOrder={'first','','second','','first','','second',''};  % first or second presentation of a given color

% handedness names 
handednessNames = {'left handed','right handed'};





% % create color vectors
% whiteVector                 = repmat(whiteDot,[1,360]);                                         
% redBlueVector               = repmat([redDot blueDot],[1,180]); % redDot and blueDot variables contain white fixations as well.
% 
% colorVector                 = {whiteVector,redBlueVector};
rectColor = [0 0 0]; % color of black base rectangle of SAM



%% send end of experiment marker = S1
sendParallelSignal(portAddress,1,ioObj)
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)

%% Start experiment loop
KbQueueCreate;    KbQueueStart;
exitmarker                      = 1; % becomes 0 if ESC is pressed, experiment terminates
exogenousTestRT                 = []; % accumulates exogenous RTs in test trials in later sections. This is used for onset estimation. 
baselineBehavioralParameters    = []; % baseline reversal rates initialization, default is 7 reversals per minute

% keyboardPressDurationExercise_PortAdapted;
presentationRects = allRects;
howManyBlocks     = length(experimentalBlockNames);
for blockIndx=1:howManyBlocks
    checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
    if ~exitmarker
        break        
    end

    blockParameters=experimentalBlocks{blockIndx};
    if isempty(baselineBehavioralParameters)
        reversalRate = 8; % just arbitrary number, it will not be used in trials of baseline block
    else
        baselineTrialCount = size(experimentalBlocks{1},1);
        reversalRate = sum(baselineBehavioralParameters)/(trialMinutes*baselineTrialCount); % sums total reversals of baseline trials, divides it by the sum of minutes in all baseline trials.
    end
    
    for trialIndx=1:size(blockParameters,1)
        
        checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
        if ~exitmarker
            break
        end        
        %% Initialize trial parameters: training/test, endogenous/exogenous/, white/colored, nofeedback/feedback etc.
        trialParameters=blockParameters(trialIndx,:);
        training_test                   = trialParameters(1); % 1=baseline, 2=training, 3=test 
                                                                    % No EEG recording in training (2) 
                                                                    % Baseline (1) means that no EEG recording will happen, 
                                                                    % and reversal rates in baseline will be used in later stages.
        exo_endo                        = trialParameters(2); % 1=exo, 2=endo
        
        white_colored                   = trialParameters(3); % 1 = white, 2 = redBlue, 3 = red, 4 = blue. 
        
        no_yes_feedback                 = trialParameters(4); % 1=no feedback, 2=feedback
        
        response_type                   = trialParameters(5); % 1= report change only, 2= report change and new direction, 3= report change and color order at the time of change
        
        presentation_durations          = trialParameters(6); % 1= short stimulus long fixation duration (four choice reaction time task for colored), 
                                                              % 2= stroboscopic motion durations, 3 = 1.5x slowed down SAM durations
                                                              
        reversal_type                   = trialParameters(7); % (1) standard, all stimuli are equally used for reversals
                                                              % (2) only red dots are used for reversals
                                                              % (3) only blue dots are used for reversals
                                                              
        reversalEmphasis                 = trialParameters(8); % (1) normal reversals, (2) duration of the reversal double dot is 1.5x slowed
        
        stimulus_duration               = durations{presentation_durations};
        if reversalEmphasis == 2
            stimulus_duration(1)        = stimulus_duration(1)*1.5;
        end
        
        stimulus_duration               = repmat(stimulus_duration,1,4);
        enableOnsetEstimation           = response_type==3 && training_test==3; % estimate stimulus onsets if it is a test trial and dots are colored
        enableReversalRateEstimation    = (training_test == 1) && (exo_endo == 2) && (presentation_durations==2); % estimate reversal rate if white-endo-training trial (i.e. baseline trial)
        enableColorResponseOnly         = response_type==4;
        enablePressDuration             = response_type==3 || response_type ==5; % (1) only report change no direction or color (e.g. first press is registered)
                                                            % (2) report change and to which direction change happened (e.g. only first presses are registered )
                                                            % (3) at which color and dot position the change happened (e.g.
                                                            % red-topleft || blue-bottomright etc.
                                                            % (4) at which color the change has happened (e.g. red=press left etc.)
                                                            % (5) at which position that the change has happened
        
        response_training               = white_colored==2 && response_type ==3 && exo_endo == 1 && training_test == 2 && presentation_durations~=1 && reversal_type == 1;

        %% PORT SIGNALS FOR DIFFERENT TRIALS
        % adjust port signal according to the trial (for start and end of
        % trials)
        colorTypeMarker    = (2*abs(white_colored-1)); % white color = 0, colored = 2. 
        reversalTypeMarker = (5*abs(exo_endo-2)); % endo task = 0 , exo task = 5.         
        taskTypeMarker     = (10*mod(2,presentation_durations)); % simple RT = 10, standard stroboscopic = 0.        
        % these are calculated using the three 'typeMarker' variables
        % above. 
        %
        % Endogenous Port Markers
%         white endogenous trial start/stop: S50/S51
%         color endogenous trial start/stop: S52/S53

        % Exogenous Port Markers
%         white exogenous trial start/stop: S55/S56
%         color exogenous trial start/stop: S57/S58 

        % Simple RT Port Markers
%         using "endogenous" double dots
                % white dots     start/stop: S60/S61
                % colored dots   start/stop: S62/S63
%         using "exogenous" double dots
                % white dots     start/stop: S65/S66
                % colored dots   start/stop: S67/S68
                
%       End of each trial also triggers a port signal which is just +1 of
%       the portMarker_Trial value below 
        portMarker_Trial   = 50 + taskTypeMarker + reversalTypeMarker + colorTypeMarker;   
        
        % Adjust press duration requirements for the trial
        if enablePressDuration % if trial has two different press duration requirements
            press_duration              = repmat([short_press, long_press],1,4);
        else                     % if trial does not differentiate between press durations (e.g. baseline or standard white tasks)
            press_duration              = repmat([standard_press, standard_press],1,4);            
        end
        
        if balancePressDuration
            press_duration              = flip(press_duration); % counterbalanced release durations (1)
            resp_duration_text          = flip(resp_duration_text); % counterbalanced duration descriptions for stroboscopic
            resp_duration_text_FCRTT    = flip(resp_duration_text_FCRTT); % counterbalanced duration descriptions for simple RT
        end
        short_or_left_DotPosition_text      = [resp_duration_text_FCRTT{1,:}]; % dot positions that either require short press in color+position tasks OR only left press in tasks where color information is not taken into account
        long_or_right_DotPosition_text      = [resp_duration_text_FCRTT{2,:}]; % vice versa above
        
        if balancePressedKeys
            response_keys       = flip(response_keys); % counterbalanced response keys (1)
            response_names      = flip(response_names); % counterbalanced response key descriptions (1)
        end
                
        % Adjust trial duration for the trial
        if training_test == 1 % if it is a baseline trial  
            trialMinutes  = 1;
        else % if it is training or test trial
            trialMinutes  = 5;
             % duration is 6 minutes (training trials will stop once %95 accuracy (exogenous) 
                                  % or 5-10 reversals (endogenous) are achieved
                                  % Endo is shorter because they already
                                  % got 6 minutes of it in baseline. 
                                  % >>Maybe 1 min training for endo?
        end
        
        if response_training 
            trialMinutes = 20; % 20 minutes of trial duration if this is the response training trial 
        end
        
        
        trialDuration = 60*trialMinutes;
        % aggregate stimulus and response durations for later use         
        stim_resp_durations         = [stimulus_duration ; press_duration];    
        
        % Reversal-rate dependent jitter calculation based on
        % stimulus presentations. 
        [jitterParameters]                                                      = getReversalRateParameters (stim_resp_durations,reversalRate);
        
        % Create vectors related to stimulus presentation and response
        % durations 
        if presentation_durations >= 2
            %% STROBOSCOPIC STIMULUS PRESENTATION
            [displayVectors, combinedReversalMatrix]                            = createDisplaySequence     (stim_resp_durations, reversalRate, trialDuration, reversal_type);
        else
            %% FCRTT STIMULUS PRESENTATION
            if white_colored == 2
                trialCountScalar_color = 2; % we use a scalar for colored sequences. because colored ones have 4 double dot stimuli and single colored ones have only two.
            else
                trialCountScalar_color = 1;
            end
              
                
            FCRTT_feedbackRepmat = 8;  % THE FIRST "FCRTT_feedbackRepmat" trials have feedback at the beginning
            FCRTT_feedbackTrials = FCRTT_feedbackRepmat *2; % we multiply feedback trials with 2 because there are fixation stimuli in between.
            FCRTT_testRepmat     = 16; % there are 26 test trials
            FCRTT_allRepmat      = (FCRTT_testRepmat + FCRTT_feedbackRepmat)/trialCountScalar_color; % divide the replication number of stimuli by two if there are 8 (colored dots) instead of 4 (single colored dots) stimuli in a sequence. 
            
            [displayVectors, combinedReversalMatrix]                            = createDisplaySequenceSimpleRT (stim_resp_durations, FCRTT_allRepmat,white_colored);
        end
        cumulativeDurations = displayVectors(3,:); % extract cumulative stimulus durations.
        stimulusDurations = displayVectors(2,:); % extract stimulus durations for the whole trial
        
        % Create color vectors for double dots 
        [colorVector, presentationColors]                                       = createColorPresentation(allColors,length(displayVectors),white_colored,firstColor);
        

        % Create a cell variable with all the visual properties of stimuli
        % for later use 

        displayProperties = {stimTypes ; movementDirections ; presentationOrder ; presentationColors ; stimulus_duration};
        
        
        % Create exogenous reversals based on previous jitter calculations 
        [displayVectors, stimulusTable]                                         = createExogenousReversals  (displayVectors, combinedReversalMatrix, jitterParameters,presentation_durations);
        
        % Create a table with all stimulus properties of the following
        % trial
        [flowVector, reversalIndex, stimulusTable, wholeFlow, positionFlow]     = createStimulusTable       (displayVectors, stimulusTable, displayProperties, exo_endo,response_training, long_or_right_DotPosition_text);

        if presentation_durations == 1
            %% RANDOMIZE TRIALS FOR FCRTT TASK 
            trialLength                         = length(flowVector);
            halfTrialIndx                       = floor(trialLength/2);
            for randIteration = 1:3
                if randIteration == 1 % randomize practice trials within themselves
                    FCRTT_InitialIndex = 1: 2 : FCRTT_feedbackTrials;
                elseif randIteration == 2 % randomize first half first because of the color-position pair occurence at the half
                    FCRTT_InitialIndex                  = FCRTT_feedbackTrials+1 : 2 : halfTrialIndx;
                elseif randIteration == 3 % then randomize the second half of trials 
                    FCRTT_InitialIndex                  = halfTrialIndx+1 : 2 : trialLength;
                end
                simplePermIndex                     = FCRTT_InitialIndex(randperm(length(FCRTT_InitialIndex)));
                stimulusTable(FCRTT_InitialIndex,:) = stimulusTable(simplePermIndex,:);
                flowVector(FCRTT_InitialIndex)      = flowVector(simplePermIndex);
                wholeFlow(FCRTT_InitialIndex)       = wholeFlow(simplePermIndex);
                positionFlow(FCRTT_InitialIndex)    = positionFlow(simplePermIndex);
                colorVector{2}(FCRTT_InitialIndex)  = colorVector{2}(simplePermIndex);
            end
        end
           
        
        % INSTRUCTION DISPLAYS %
        checkBaselineInstructionDisplay       = training_test == 1 && trialIndx == 1; % if it is first baseline trial
        checkTrainingFeedbackDisplay          = training_test == 2 && no_yes_feedback == 2; % feedback-training display 
        checkTrainingNoFeedbackDisplay        = training_test == 2 && no_yes_feedback == 1; % no feedback-training display 
        checkReminderDisplay                  = blockIndx > 1      && training_test == 3; % if test trial 
        Screen('TextSize',window,25);
        %% Load instruction texts 
        % they change in each block and might change across trials, so we
        % load them each time we want to present them. 
        prepareTextInstructions;

                                                                                   
        %% Create instruction texts according to requirements of the task 
        if presentation_durations ~=1
            %% STROBOSCOPIC INSTRUCTIONS
            instructionText = [];
            instructionText = [instructionText stimulusDescriptions{1:white_colored}]; % get stimulus descriptions for instructions, get direction explanation and color explanation if it is a colored trial.
                                                                                       % get only direction-movement explanation if it is a white trial 
            instructionText = [instructionText responseDescriptions{response_type}];   % get response descriptions according to response_type
                                                                                       % (1) respond to change irrespective of direction, 
                                                                                       % (2) respond to change according to direction
                                                                                       % (3) respond to color order 
            if  response_type == 1 % if response only requires change report and nothing else 

                    if white_colored == 2 % it is a colored trial
                        instructionText = [instructionText ignoreDescriptions{1} ignoreDescriptions{2}]; % add ignore color and direction information texts
                    else % if it is white  
                        instructionText = [instructionText ignoreDescriptions{2}]; % add direction ignore text
                    end

            elseif response_type == 2 % if  response requires reporting of the direction of change 

                    if white_colored == 2 % it is colored trial 
                        instructionText = [instructionText ignoreDescriptions{1}]; % add ignore color information text 
                    end

            elseif response_type == 3 % if response requires report of color order- Only possible if trial is colored, so no additional conditions were necessary 
                instructionText = [instructionText ignoreDescriptions{2}]; % add ignore direction information text 
            end

            if no_yes_feedback == 1 % if there is no feedback
                instructionText = [instructionText feedbackDescriptions{1}]; % no feedback will be provided text
            else
                instructionText = [instructionText feedbackDescriptions{2}]; % you will see feedback text
            end
            instructionText = [instructionText taskDescriptions{response_type}]; % get response instructions according to "response_type"
                                                                                       % (1) press ONE BUTTON for any change
                                                                                       % (2) press LEFT for one direction and RIGHT for other direction
                                                                                       % (3) press LEFT for one color and RIGHT for other color: press
                                                                                       % longer for Xth position and short for Yth position
           
        elseif presentation_durations == 1
             %% FCRTT INSTRUCTIONS
                instructionText = [];
                instructionText = [instructionText FCRTTDescriptions{1}];
                if response_type == 1 % apperance is enough
                    
                    instructionText = [instructionText FCRTTresponseDescriptions{1}{1}];
                elseif response_type == 3 % color + position
                    instructionText = [instructionText FCRTTresponseDescriptions{4}];
                    instructionText = [instructionText FCRTTDescriptions{2}{2}];                    
                    instructionText = [instructionText FCRTTtaskDescriptions{3}];
                elseif response_type == 4 % color only
                    instructionText = [instructionText FCRTTresponseDescriptions{2}];
                    instructionText = [instructionText FCRTTDescriptions{2}{1}];                    
                    instructionText = [instructionText FCRTTtaskDescriptions{1}];
                elseif response_type == 5 % position only
                    instructionText = [instructionText FCRTTresponseDescriptions{3}];
                    instructionText = [instructionText FCRTTDescriptions{2}{2}];                    
                    instructionText = [instructionText FCRTTtaskDescriptions{2}];
                end
        end
        

        instructionText = [instructionText '\n\n' pressEnterToContinue];
        callTextInstruction(window,instructionText,xCenter, yCenter)
        
        
        WaitSecs(2); % wait for 2 seconds before starting stimulus display
        expStart = GetSecs();
            %% Initialize response registery variables
            stimOnsetRegistery                  = NaN(1,length(flowVector));
            responseTable_stimOnset             = cell(reversalRate*6,8); % Initialize response registery variable, stim_type, color_order (red_first), reversal, percept_duration, responseCorrect/Error, keyCode, reactionTime
            responseTable_stimOnset(1,:)        = {'Stimulus_Type','Percept_Duration','Accuracy','KeyName','RT','Release_Duration','Reversal_Onset_Index','Total_Press_Time'};
            responseTable_estimatedOnset        = cell(reversalRate*6,11); % Initialize endogenous response registery table 
            responseTable_estimatedOnset(1,:)   = {'Stimulus_Type','Stimulus_Duration','Accuracy','KeyName','Estimated_RT','Release_Duration','Estimated_Onset_Index','Total_Press_Time','Reversal_To','Estimated_Onset_TimeCorrected','Reversal_From'};
            responseTable_FCRTT              = cell(ceil(length(flowVector)/2),5); % initialize simple RT response registery table 
            responseTable_FCRTT(1,:)         = {'Stimulus_Type','Accuracy','KeyName','RT','Release_Duration'};
            % look 
            if isempty(exogenousTestRT)
                expectedRT    = .7; % estimated RT is fixed to .7 if there are no completed exogenous test trials
            else
                expectedRT    = nanmean(exogenousTestRT);
            end
                    %% Initialize variables in stimulus presentation and keyboard registery loops
                    % this is necessary to prevent crashes due to
                    % 'undefined function/variable' error
                    global_iteration        = 0; % counts the number of stimulus presentation
                    registeredKeys          = 0; % marks the state of keyboard registery: 0-detect press, 1-detect release, 2-register response, 3-block recording
                    reversalTime            = []; % motion change onset in exogenous trials
                    FCRTT_OnsetTime         = []; % double-dot onset in FCRTT trials
                    reversalIteration       = 0; % reversal iteration marker in exogenous trials, increases by 1 after each reversal. Used in stimulus-onset based response registeries
                    responseIteration       = 1; % response iteration marker used in onset estimation and response registery in endogenous task, increases by 1 after each response
                    FCRTT_ResponseIteration = 0; % simple RT response registery iteration variab  
                    estimateReversalOnset   = 0; % logical variable that decides whether or not to estimate stimulus onsets and register response-based response registeries (no stimulus onset information)
                    Pressed                 = 0; % logical variable that indicate whether a button is pressed or not. 
                    feedbackAvailable       = 0; % logical variable that indicate whether a feedback will be shown or not 
                    trainingComplete        = 0; % logical variable that index the completion of training trial (after a given accuracy: %90 default)
                    relativePress           = []; % button press time relative to the first double dot display onset                                       
                    lastShiftDuration       = 0; % initialize the duration variable that is used for switching the CP in response training trial (switches per 90 secs)
                    shiftEnabled            = 1; % logical variable that allows you to shift COLOR-POSITION pairs only once in a trial. 
                    omissionTrial           = 0; %logical variable that indicate the trial within which there was an omission. Used to prevent repeated omission registeries within one trial
                    FCRTT_keyReg            = 0;
                    numberCorrect           = 0;
                    numberOmission          = 0;
                    relativePressVector     = []; % a vector where all the relative press durations are registered. This is used for manually adding first button press markers on EEG data. 
        for flowIteration=flowVector
            checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
            %% Create stimuli and display
            if ~exitmarker
                break
            end
            
            global_iteration=global_iteration+1;
            
            %% FEEDBACK CONDITIONS FOR FCRTT
            
            if presentation_durations == 1  % only give feedback to first "#FCRTT_feedbackTrials" number of trials in simple RT task 
                FCRTT_feedbackTrialCondition    = global_iteration <= FCRTT_feedbackTrials; % if the trial is within the feedback/sound reinforcement trials (first couple of trials defined by FCRT_feedbackTrials variable.
                FCRTT_doubleDotDisplay          = presentation_durations == 1 && mod(global_iteration,2)==1; % if it is a double dot display of FCRTT                 
                    if feedbackAvailable==1
                        feedbackAvailable = FCRTT_feedbackTrialCondition;
                    end
                    
            end
             %% FEEDBACK DISPLAY 
             displayFeedback = no_yes_feedback==2;
             
            if  displayFeedback && feedbackAvailable==1 
                Screen('TextSize',window,50)
                DrawFormattedText2(feedbackText,'win',window, 'sx',xCenter,'sy', yCenter,'xalign','center','yalign','center','xlayout','center','baseColor',feedbackColor);
                feedbackAvailable=0;                
                Screen('Flip',window);
                WaitSecs(1);
            end
            if presentation_durations == 1
                    if global_iteration == FCRTT_feedbackTrials
                        Screen('TextSize',window,25);
                        DrawFormattedText2('Alistirma asamasi bitti. Bundan sonra ses ve geri bildirim verilmeyecektir.\n 5 saniye sonra deney baslayacaktir','win',window, 'sx',xCenter,'sy', yCenter,'xalign','center','yalign','center','xlayout','center','baseColor',feedbackColor);
                        Screen('Flip',window);
                        WaitSecs(5);
                        Screen('Flip',window);
                        WaitSecs(1);
                    end                
            end
            
            
            %% MAKE A BREAK AND CHANGE COLOR-POSITION PAIRS OF DOTS
            changeColorPositionPairs; 
            
            
            %% INSERT Inter-trial interval for simple RT task 
            
            if presentation_durations == 1 && (flowIteration==2 || flowIteration==4)
                Screen('Flip',window);
                WaitSecs(1); % 1000 ms ITI 
            end
            
            %% SAM & EXO-SAM Display
            if global_iteration == 1 && presentation_durations == 1    
                Screen('FillRect', window, rectColor, baseRectCenter);
                Screen('FillRect', window, ...
                    colorVector{white_colored}{global_iteration+1}, ...
                    presentationRects{reversalIndex(global_iteration+1),2});
                Screen('Flip',window);
                WaitSecs(1);
             	Screen('FillRect', window, rectColor, baseRectCenter);
                Screen('FillRect', window, ...
                    colorVector{white_colored}{global_iteration}, ...
                    presentationRects{reversalIndex(global_iteration),flowIteration});
            else
                Screen('FillRect', window, rectColor, baseRectCenter);
                Screen('FillRect', window, ...
                    colorVector{white_colored}{global_iteration}, ...
                    presentationRects{reversalIndex(global_iteration),flowIteration});
            end
            
            %% FCRTT reinforcement sound play            
            if presentation_durations == 1 && enablePressDuration
                if FCRTT_feedbackTrialCondition && FCRTT_doubleDotDisplay % only play the reinforcement sound when double dots are displayed and within training trials 
                    
                    if ~isempty(regexp(short_or_left_DotPosition_text,stimulusTable{global_iteration,1})) % look-up if current stimulus display is at one of the short duration positions.
                        sound(shortSound_RF,sampling_fr); % play short beep for short presses                            
                    else                        
                        sound(longSound_RF,sampling_fr); % play long beep for long presses
                    end        
                    
                end
            end
            
            
            %% flip the screen for double dot display
            vb=Screen('Flip',window);  
            
            %% mark the first stimulus display as 'first_vb'
            if global_iteration==1 % marks the first stimulus display 
                first_vb=vb;
            end

           %% register all stimulus onsets into stimOnsetRegistery
            stimOnsetRegistery(global_iteration)= vb;
            
            % Logical statements for checking reversals of exogenous and endogenous
            % tasks.
            checkExogenousReversal      = global_iteration>1 && reversalIndex(global_iteration)~=reversalIndex(global_iteration-1) && exo_endo==1;
            checkEndogenousTask         = exo_endo==2;
            if checkExogenousReversal && presentation_durations >= 2
                %% EXOGENOUS STIMULUS PRESENTATION
                % check if there is an exogenous reversal
                % register trial index, time, and relevant stimulus properties
                % record properties to responseTable       
                reversalTime                                        = vb; % register stimulus onset of exogenous reversal
                reversalOnsetIndex                                  = global_iteration; % register index of stimulus onset
                reversalIteration                                   = reversalIteration+1; % exogenous reversal loop continues
                stimProperties                                      = stimulusTable(global_iteration,[1 3 5 6]); % get stimulus type, color-order, stimulus duration, reversal or not
                responseTable_stimOnset(reversalIteration+1,[1 2])  = stimProperties([1 4]); % register stim properties to response sheet (+1 because first row belong to variable names)
                responseTable_stimOnset{reversalIteration+1,1}      = [responseTable_stimOnset{reversalIteration+1,1},'_',stimProperties{2}]; % merge stimulus type and color-order information
                registeredKeys                                      = 0; % 0=no press yet,  1= check for second  press, 2 = registery mode, 3 = lock response tracking, keyboard is inresponsive
                % if reversal is from horizontal to vertical
                if response_type<3
                    if ~isempty(regexp(stimProperties{1}, 'vertical'))
                        exoReversalSignal = 40;  % send s40 if reversal is hor to vertical 
                    else
                        exoReversalSignal = 41;  % send s41 if reversal is vertical to hor
                    end
                else
                    
                    if ~isempty(regexp(stimProperties{2}, 'red'))
                        exoReversalSignal = 45;  % send s45 if reversal was on red dot at short duration positions
                        sendParallelSignal(portAddress,45,ioObj) 
                    elseif ~isempty(regexp(stimProperties{2}, 'blue'))
                        exoReversalSignal = 47; % send s47 if reversal was on blue dot at short duration positions
                    end
                    
                    if isempty(regexp(short_or_left_DotPosition_text,stimProperties{1})) && enablePressDuration  % returns 1 if positions are not short dot positions.                   
                        exoReversalSignal = exoReversalSignal + 1;  % add one to the red/blue signal if dot was at long duration positions                        
                    end
                    
                end
                sendParallelSignal(portAddress,exoReversalSignal,ioObj) % send s41 if reversal is vertical to hor
            elseif checkEndogenousTask && presentation_durations >= 2        
                %% ENDOGENOUS STIMULUS PRESENTATION

                if registeredKeys==3
                        registeredKeys=0;       
                        
                        if estimateReversalOnset==1
                            onsetIndex                              = []; % reset estimated onset index for the next calculation 
                        end
                      
                        estimateReversalOnset=0; % does not estimate and register onsets if there are no press and release of relevant buttons
                end
            elseif presentation_durations == 1   
                %% FCRTT REACTION TIME TRIAL 
                if mod(global_iteration,2)==1
                    %% variables below are used for exogenous reversals as well
                    % here they represent the onset of simple visual
                    % stimulation elicited by double dot stimuli. So there
                    % are no reversals even though the names suggests as
                    % such. 
                    FCRTT_keyReg                                            = 1; % register responses only during double dot displays
                    FCRTT_OnsetTime                                         = vb; % register stimulus onset of stimulus display
                    FCRTT_ResponseIteration                                 = FCRTT_ResponseIteration+1; % FCRTT response registery iteration variable                    
                    stimProperties                                          = stimulusTable(global_iteration,[1 3]); % get stimulus type, color-order
                    deleteIndex                                             = regexp(stimProperties{2},'_'); % get the underscore index for deleting order info
                    stimProperties{2}                                       = stimProperties{2}(1:deleteIndex-1); % delete the order info, color info remains                   
                    responseTable_FCRTT{FCRTT_ResponseIteration+1,1}        = [stimProperties{1},'_',stimProperties{2}]; % merge stimulus type and color-order information

                else
                    FCRTT_keyReg                                         = 0; % do not register responses during fixation displays
                end
                
                if registeredKeys == 3
                    registeredKeys = 0; % 0=no press yet,  1= check for second  press, 2 = registery mode, 3 = lock response tracking, keyboard is inresponsive
                end

            end
            
            %% SEND PORT SIGNALS %%
            if training_test == 3
                if global_iteration==1 % marks the first stimulus display 
                    %% send for beginning of trial
                    sendParallelSignal(portAddress,portMarker_Trial,ioObj)
                else
                    %% send for rest of stimuli in stroboscopic trials
                    portMarker_Stimulus = positionFlow(global_iteration);
                    
                    % does not send signals for fixation stimuli
                    if portMarker_Stimulus ~= 2 && portMarker_Stimulus ~= 4 && ~checkExogenousReversal

                            portMarker=(white_colored*10)+portMarker_Stimulus;
                            sendParallelSignal(portAddress,portMarker,ioObj)
                        
                    end                
                end            
            elseif presentation_durations == 1  
                %% if it is the FCRTT task 
                if global_iteration==2 % marks the first stimulus display 
                    %% send for beginning of trial
                    sendParallelSignal(portAddress,portMarker_Trial,ioObj)
                elseif global_iteration > FCRTT_feedbackTrials
                    portMarker_Stimulus = positionFlow(global_iteration);

                    portMarker=(white_colored*10)+portMarker_Stimulus;
                    sendParallelSignal(portAddress,portMarker,ioObj)  
                end
            end
            
            % end signal %
            WaitSecs(.005);
            endParallelSignal(portAddress,ioObj)
            %%%%%%%%%%%%%%
           
            while 1
                checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
                currentTime=GetSecs();
                checkFCRTTPressMade = registeredKeys==3 && presentation_durations == 1; % check if FCRTT response was made, if so stop display and move on to next presentation 
                checkDisplayTimeElapsed = (currentTime-vb)>=stimulus_duration(flowIteration); % check if time spent during registery reached the stimulus duration, if so, move on to next display 
                % stop looking for press if:
                % 1) stim duration is exceeded OR
                % 2) ESCAPE key is pressed OR
                % 3) if there is a registered press already (FCRTT only) OR
                % 4) training is complete (response training only)
                if  (currentTime-vb)>=stimulus_duration(flowIteration) || ~exitmarker || trainingComplete || checkFCRTTPressMade
                   break
                end
                
                % start the search for keyboard registery if:
                % 1) first reversal occured in exogenous stroboscopic OR 
                % 2) it is a endogenous stroboscopic task OR
                % 3) it is the double dot display of FCRTT task               
                if (reversalIteration>=1 || (checkEndogenousTask && presentation_durations == 2) || FCRTT_keyReg)
                        %% Check task-related button presses
                        [Pressed, PressedButton,firstRelease]=KbQueueCheck(); 
                        
                        
                        if Pressed && registeredKeys == 0  % if there is a press and it is the first one since the reversal
                            %% CHECK BUTTON PRESS AND REGISTER PARAMETERS 
                                PressedButton(PressedButton==0) = NaN; % format press-matrix 
                                [~, keyIndex]                   = min(PressedButton); % get the earliest press
                                pressTime                       = PressedButton(keyIndex); % get the press time 
                                keyName                         = KbName(keyIndex); % get the keyboard key name                          
                                relativePress                   = pressTime-first_vb; % get relative press time, because raw press time value cannot be used in algebra with fixed value (e.g. .2 or 2)
                                relativePressVector             = [relativePressVector relativePress];
                                stimInterval                    = [relativePress - 2.5 relativePress - 0.15]; % expected onset interval is between .15 to 2.3 seconds before the button press 
                                if keyIndex==response_keys(1)  % if left key is pressed
                                    stimulusMarkers = [1 3]; % select 1 and 3 stim markers. 1: first-red (short-press j), 2: second-red (long press j)
                                elseif keyIndex==response_keys(2)   % if right key is pressed
                                    stimulusMarkers = [5 7]; % select 5 and 7 stim markers. 5: first-blue (short-press k), 7: second-blue (long press k)
                                end  
                                %% CORRECT & VALID RESPONSE DEFINITIONS 
                                
                                checkValidKeys=(keyIndex==response_keys(1) || keyIndex==response_keys(2)); % if pressed keys are valid (e.g. j or k)
                                % correct responses can only be defined in EXOGENOUS STROBOSCOPIC or FCRTT tasks
                                %  checkCorrectError = 1 means correct response
                                %  checkCorrectError = 0 mean incorrect response
                                if ~checkEndogenousTask || presentation_durations == 1
                                    
                                    if response_type == 1 % NO LEFT - RIGHT DISCRIMINATION
                                        checkCorrectError               =1;
                                    
                                    elseif response_type == 2 % LEFT - RIGHT response to motion direction
                                        checkCorrectError               =(~isempty(regexp(stimProperties{1},'horizontal')) && response_keys(1)==keyIndex) || (~isempty(regexp(stimProperties{1},'vertical')) && response_keys(2)==keyIndex);                      %#ok<*RGXP1>
                                    
                                    elseif response_type == 3 || response_type == 4 % LEFT - RIGHT response to colors 
                                        checkCorrectError               =(~isempty(regexp(stimProperties{2},'red')) && response_keys(1)==keyIndex) || (~isempty(regexp(stimProperties{2},'blue')) && response_keys(2)==keyIndex);                     
                                    
                                    elseif response_type == 5 % long & short press to dot positions, no color info, no left/right distinction
                                        checkCorrectError               = 1;
                                    end
                                    
                                end
                                
                                if enablePressDuration  % continue with press release algorithm
                                    registeredKeys=1;
                                else % bypass press release algorithm for white/directional trials   
                                    releaseDuration     = [];
                                    estimated_RT        = 999;      
                                    onsetIndex          = [];
                                    if checkValidKeys
                                        registeredKeys=2;
                                        if checkEndogenousTask && presentation_durations ~= 1
                                            noOnsetresponseText   = 'Reversal'; % not actually correct, it is just to mark reversals
                                            if response_keys(1)==keyIndex
                                                reversalTo = 'horizontal';
                                                reversalFrom = 'vertical';
                                            elseif response_keys(2)==keyIndex
                                                reversalTo = 'vertical';
                                                reversalFrom = 'horizontal';
                                            end
                                            estimateReversalOnset   = 1;
                                        
                                            
                                        elseif ~checkEndogenousTask || presentation_durations == 1 % if it is an exogenous OR FCRTT trial
                                            reactionTime = pressTime-reversalTime;
                                            if presentation_durations == 1
                                                reactionTime_FCRTT = pressTime-FCRTT_OnsetTime; % get the reaction time for FCRTT 
                                            end
                                            if checkCorrectError
                                                responseText        = 'Correct';
                                                feedbackText        = 'DOGRU CEVAP!';
                                                feedbackColor       = [0 0 1];
                                                feedbackAvailable   = 1; 
                                                % SEND PORT SIGNAL %
                                                if training_test == 3
                                                    sendParallelSignal(portAddress,9,ioObj) % S15 = correct answer port signal
                                                    WaitSecs(.005);
                                                    endParallelSignal(portAddress,ioObj)
                                                end
                                                %%%%%%%%%%%%%%%%%%%%
                                            else
                                                responseText        = 'Wrong_Key';  
                                                feedbackText = 'YANLIS TUSA BASTINIZ!';
                                                feedbackColor = [1 0 0];
                                                feedbackAvailable = 1;                                                  
                                            end
                                        end 
                                    else
                                        noOnsetresponseText ='invalid_key';
                                        responseText        ='invalid_key';
                                        feedbackText = 'GECERSIZ TUS!';
                                        feedbackColor = [1 0 0];
                                        feedbackAvailable = 1;                                          
                                        reactionTime        = [];
                                    end
                                    responseIteration        = responseIteration+1;
                                end                                                      
                                
                        elseif registeredKeys ==1 && checkReleasePending(pressTime,long_press) && checkValidKeys
                            %% check if there is a valid press and release is still pending
                            responseText        = 'Undefined';
                            noOnsetresponseText = 'Undefined';
                            
                                while 1 
                                    currentTime = GetSecs();
                                    checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
                                    %% look for the release of the initial press
                                    % stop looking for press release if:
                                    % 1) stim duration is exceeded
                                    % 2) ESCAPE key is pressed
                                    % 3) if there was a release and it triggered registery (registeredKeys = 2)
                                    % 4) if release window is exceeded (750 ms at max)
                                    if (currentTime-vb)>=stimulus_duration(flowIteration)  || ~exitmarker || registeredKeys == 2 || ~checkReleasePending(pressTime,long_press)
                                        
                                        break
                                    end
                                    
                                    if ~checkEndogenousTask || presentation_durations == 1
                                        
                                        checkLongerDuration     = ~isempty(regexp(long_or_right_DotPosition_text,stimProperties{1})); % output is 1 if response has to be long, 0 if it has to be short
                                    end                         
                                    [~,~,firstRelease]     = KbQueueCheck(); 
                                    checkRelease           = ~isempty(firstRelease(firstRelease>0));

                                        if checkRelease && checkReleasePending(pressTime,long_press) && registeredKeys ==1 
                                            %% if there is a release and release is still pending
                                            releaseTime                     = GetSecs();% get the release time 
                                            releaseDuration                 = releaseTime-pressTime; % calculate release duration 
                                            checkLowerBound                 = releaseDuration>long_lower_limit; % check if the lower release threshold direction is reached for longer presses
                                            registeredKeys                  = 2; % switch to keyboard registery mode 
                                            % exogenous response conditions (stimulus
                                            % based estimation of release duration etc.)
                                            % stim onsets are known and used before the
                                            % responses. 
                                            if (exo_endo == 1 || presentation_durations ==1) && checkCorrectError
                                                
                                                    reactionTime = pressTime-reversalTime; % get the reaction time for exogenous stroboscopic
                                                
                                                    reactionTime_FCRTT = pressTime-FCRTT_OnsetTime; % get the reaction time for FCRTT 
                                                
                                                if checkLongerDuration && checkLowerBound % if release is supposed to be longer and met the lower duration threshold 
                                                    responseText='Correct'; 
                                                    feedbackText = 'DOGRU YANIT';
                                                    feedbackColor = [0 0 255];
                                                    feedbackAvailable = 1;
                                                    % SEND PORT SIGNAL %
                                                    if training_test == 3 || presentation_durations ==1
                                                        sendParallelSignal(portAddress,9,ioObj) % S15 = correct answer port signal
                                                        WaitSecs(.005);
                                                        endParallelSignal(portAddress,ioObj)
                                                    end
                                                    %%%%%%%%%%%%%%%%%%%%
                                                elseif ~checkLongerDuration && ~checkLowerBound  % if release is shorter and release duration is below 200 ms                                   
                                                    responseText='Correct';
                                                    feedbackText = 'DOGRU YANIT';
                                                    feedbackColor = [0 0 255];
                                                    feedbackAvailable = 1;  
                                                    % SEND PORT SIGNAL %
                                                    if training_test == 3 || presentation_durations ==1
                                                        sendParallelSignal(portAddress,9,ioObj) % S15 = correct answer port signal
                                                        WaitSecs(.005);
                                                        endParallelSignal(portAddress,ioObj)
                                                    end
                                                    %%%%%%%%%%%%%%%%%%%%
                                                elseif checkLongerDuration && ~checkLowerBound % if release shouldve longer but was below 200 ms
                                                    responseText='Short_Timing'; 
                                                    feedbackText = 'KISA BASTINIZ';
                                                    feedbackColor = [255 0 0];
                                                    feedbackAvailable = 1;
                                                elseif ~checkLongerDuration && checkLowerBound
                                                    responseText='Long_Timing'; 
                                                    feedbackText = 'UZUN BASTINIZ';
                                                    feedbackColor = [255 0 0];
                                                    feedbackAvailable = 1;                                                    
                                                end
                                            elseif (exo_endo == 1 || presentation_durations ==1) && ~checkCorrectError
                                                reactionTime=[];
                                                reactionTime_FCRTT = [];
                                                responseText='Wrong_Key';
                                                feedbackText = 'YANLIS TUS';
                                                feedbackColor = [255 0 0];
                                                feedbackAvailable = 1;                                                  
                                            end


                                            % (1) estimate reversal onsets 
                                            % (0) don't estimate onsets    
                                            estimateReversalOnset=enableOnsetEstimation;


                                            % no onset response conditions. release
                                            % durations are calculated by responses and
                                            % then these were used to mark the related
                                            % stimuli markers. This is done for
                                            % exogenous reversals as well. Because that
                                            % will be then used for checking the
                                            % validity of estimation.
                                            no_onset_ShortRelease = releaseDuration <=short_press; % get short release based on responses
                                            no_onset_LongRelease  = checkLowerBound && releaseDuration <= long_press; % get long release based on responses 
                                                if no_onset_LongRelease % if release duration is 2000 ms> x >500 ms (1 and 5th stimulus markers in wholeFlow vector)
                                                    currentStim         = stimulusMarkers(2);
                                                    % Get the index of irrelevant stimulus markers. 
                                                    unrelatedOnsets     = find(positionFlow~=currentStim); % stimulusMarkers(2) select stimuli other than 3rd or 7th stims that have 750 ms release duration. 
                                                                                                       % Then delete these indices to get desired stimulus onsets.
                                                    noOnsetresponseText ='Correct';
                                                    keyName             = [keyName '_long'];
                                                elseif no_onset_ShortRelease % if release duration is x<300 ms (1 and 5th stimulus markers in wholeFlow vector)
                                                    currentStim         = stimulusMarkers(1);
                                                     % Get the index of irrelevant stimulus markers. 
                                                    unrelatedOnsets     = find(positionFlow~=currentStim); % stimulusMarkers(1) select stimuli other than 1st or 5th stims that have 200 ms release duration. 
                                                                                                       % Then delete these indices to get desired stimulus onsets.
                                                    noOnsetresponseText = 'Correct';
                                                else
                                                    estimateReversalOnset=0; % don't estimate or register stim onset of reversals in wrong timing trials
                                                    noOnsetresponseText ='Wrong_timing';                                   
                                                end

                                                if estimateReversalOnset==1 % estimate onsets on correct timing trials
                                                    specificOnsets                      = stimOnsetRegistery-first_vb;
%                                                     specificOnsets                      = cumulativeDurations; % create a temporary variable  with cumulative onsets
                                                    specificOnsets(unrelatedOnsets)     = NaN; %#ok<*SAGROW> % replace irrelevant stimulus markers with NaN. Relevance is defined by the response
                                                     % stimulus durations were subtracted from cumulative durations because the durations
                                                     % are cumulative. Normally these cumulative durations start at the end of the stimulus
                                                     % presentations, subtraction results in correct onset times                                     
%                                                     specificOnsets                      = specificOnsets-stimulus_duration(1);
                                                    indx1                               = findIndices(specificOnsets,stimInterval); % get stimulus markers within the stimulus interval (RT-2.3 RT-.3 secs)                                   
                                                    interval                            = indx1(1):indx1(2); % create an array of indices
                                                    indx2                               = find(positionFlow(interval)==currentStim)+interval(1)-1; % Get the indices of possible stimulus onsets 
                                                    referencePoint                      = relativePress - expectedRT; % calculate the reference point to get the closest stimulus onsets to this
                                                    % :) now we have it.
                                                    deleteIndex=[];
                                                    registeredOnsets=[];
                                                        for checkOnsets = indx2
                                                              % Check if estimated onsets exceed the [response - .25/.1 to 2.5] sec threshold 
                                                              if exo_endo == 2
                                                                  lowThreshold = .1;
                                                              else
                                                                  lowThreshold = .25;
                                                              end
                                                              highThreshold = 2.5;
                                                                if relativePress-specificOnsets(checkOnsets)>lowThreshold && relativePress-specificOnsets(checkOnsets)<highThreshold
                                                                    registeredOnsets=[registeredOnsets checkOnsets];                                                    %#ok<*AGROW>
                                                                end                                   
                                                        end

                                                        if ~isempty(registeredOnsets)
                                                            onsetIndex                          = registeredOnsets(findIndices(specificOnsets(registeredOnsets),referencePoint)); % find the index of the closest stimulus onset 
                                                            % -1 because durations are cumulative
                                                            % and onsets correspond to index before
                                                            % the actual one 
                                                            screenStimOnset                    = stimOnsetRegistery(onsetIndex); % get the exact display time of estimated stimulus onset                                                     
                                                            estimated_RT                       = pressTime - screenStimOnset; % calculated estimated RT                                                            
                                                            if  isnan(estimated_RT) || isnan(screenStimOnset)     
                                                                [~, latestDisplay] = max(stimOnsetRegistery);
                                                                ['latest display: ', num2str(latestDisplay)]
                                                                ['onset index: ', num2str(onsetIndex)]
                                                                ['global index: ', num2str(global_iteration)] % display onset indices if there is an error of estimation
                                                                noOnsetresponseText = 'Invalid_Estimation' 
                                                                estimateReversalOnset    = 0;                                                  
                                                            end
                                                            responseIteration                  = responseIteration+1; % continue with endogenous response registery loop
                                                            unrelatedOnsets                    = []; % refresh variable 
                                                        else
                                                            noOnsetresponseText = 'Invalid_Estimation' 
                                                            estimateReversalOnset=0;
                                                        end
                                                end                                    
                                        end

                                end
                          % if there is a press  AND  750 ms passed since the press
                        elseif registeredKeys==1 && ~checkReleasePending(pressTime,long_press)% if release time is exceeded and participant't couldn't release
                            responseText='Long_Timing'; 
                            feedbackText = 'UZUN BASTINIZ';
                            feedbackColor = [255 0 0];
                            feedbackAvailable = 1;                               
                            estimateReversalOnset   = 0; % don't estimate or register stim onset of reversals in failed release trials
                            releaseDuration         = [];
                            reactionTime            = [];
                            reactionTime_FCRTT     = [];
                            if ~exist('keyName')
                                keyName             = [];
                            end
                            registeredKeys          = 2; % switch to keyboard registery mode              

                        elseif registeredKeys ==1 && (exo_endo == 1 || presentation_durations ==1) && ~checkCorrectError% if wrong press was made. Only applicable to exogenous task
                            responseText        = 'Wrong_Key';
                            feedbackText        = 'YANLIS TUS';
                            feedbackColor       = [255 0 0];
                            feedbackAvailable   = 1;                                    
                            releaseDuration     = [];
                            reactionTime        = [];
                            reactionTime_FCRTT = [];
                            registeredKeys      = 2;     % switch to keyboard registery mode
                        end       
                       % check if omission: no press was made and three seconds has passed
                       % since the reversal. Only applicable to exogenous task.
                        if  (exo_endo == 1 && presentation_durations ~=1) 
                           isThereResponse = isempty(responseTable_stimOnset{reversalIteration+1,3});
                           checkOmission = registeredKeys==0 && GetSecs()-reversalTime>4 && reversalIteration>omissionTrial && isThereResponse;                           
                               if checkOmission 
                                   omissionTrial = reversalIteration;
                                   feedbackText = 'TUSA BASMADINIZ';
                                   feedbackColor = [1 0 0];
                                   feedbackAvailable = 1;                                      
                                   responseText             = 'Omission';
                                   responseIteration        = responseIteration+1;
                                   estimateReversalOnset    = 0;
                                   relativePress            = [];
                                   releaseDuration          = [];
                                   reactionTime             = [];
                                   reactionTime_FCRTT      = [];
                                   keyName                  = [];
                                   registeredKeys           = 2;  
                               end
                        end
                        if registeredKeys==2
                            
                            if checkEndogenousTask
                                %% Response registry for stroboscopic endo 
                                % check if estimate RT and press Intervals are eligible for recording
                                
                                % press Interval < 2 not valid 
                                 if (exo_endo == 1 || presentation_durations ==1)
                                    checkValidRT     = estimated_RT>0.25; % exogenous lower bound RT
                                else
                                    checkValidRT     = estimated_RT>0.1; % endogenous lower bound RT 
                                end
                            

                                if  checkValidRT
                                    
                                    if enableOnsetEstimation && estimateReversalOnset
                                        responseTable_estimatedOnset(responseIteration,[1 2])     = stimulusTable(onsetIndex,[1 4]); % get stimulus type and duration                       
                                        responseTable_estimatedOnset{responseIteration,1}         = [responseTable_estimatedOnset{responseIteration,1},'_',stimulusTable{onsetIndex,3}]; % merge color and order 
                                        responseTable_estimatedOnset{responseIteration,5}         = estimated_RT; % estimated RT 
                                        responseTable_estimatedOnset{responseIteration,7}         = onsetIndex; % estimated stimulus onset 
                                    elseif response_type == 2
                                        responseTable_estimatedOnset{responseIteration,9}         = reversalTo;
                                        responseTable_estimatedOnset{responseIteration,11}        = reversalFrom;
                                    end         
                                    
                                    responseTable_estimatedOnset{responseIteration,3}             = noOnsetresponseText; % accuracy
                                    responseTable_estimatedOnset{responseIteration,4}             = keyName; % keyboard key name 
                                    
                                    responseTable_estimatedOnset{responseIteration,6}             = releaseDuration; % release duration 
                                    
                                    responseTable_estimatedOnset{responseIteration,8}             = relativePress; % total time elapsed since the first display 
                                    % registeries are printed above at the beginning of
                                    % display onset registery loop
                                    fprintf('\nStimulus Type: %s\nAccuracy: %s\nKeyboard Key: %s\nReaction Time: %f\nRelease Delay: %f\n', ...
                                    responseTable_estimatedOnset{responseIteration,1},...
                                    responseTable_estimatedOnset{responseIteration,3},...
                                    responseTable_estimatedOnset{responseIteration,4},...
                                    responseTable_estimatedOnset{responseIteration,5},...
                                    responseTable_estimatedOnset{responseIteration,6});                            
                                    % registeries are printed above at the beginning of
                                    % display loop
                                    fprintf('\n     RESPONSE COUNT     : %d\n', responseIteration-1)
                                end
                            end
                            %% Response registry for FCRTT task                            
                            isThereResponse = isempty(responseTable_FCRTT{FCRTT_ResponseIteration+1,3});
                            responseTable_FCRTT(1,:)         = {'Stimulus_Type','Accuracy','KeyName','RT','Release_Duration'};
                            if  presentation_durations == 1 && isThereResponse
                                if FCRTT_feedbackTrialCondition
                                    responseText=[responseText(1:3),'_practice'];
                                end
                                responseTable_FCRTT{FCRTT_ResponseIteration+1,2}=responseText; % accuracy
                                responseTable_FCRTT{FCRTT_ResponseIteration+1,3}=keyName; % keyboard key name
                                responseTable_FCRTT{FCRTT_ResponseIteration+1,4}=reactionTime_FCRTT; % estimated RT  
                                responseTable_FCRTT{FCRTT_ResponseIteration+1,5}=releaseDuration; % release duration 
                                fprintf('\nStimulus Type: %s\nAccuracy: %s\nKeyboard Key: %s\nReaction Time: %f\nRelease Delay: %f\n', ...
                                    responseTable_FCRTT{FCRTT_ResponseIteration+1,1},...
                                    responseTable_FCRTT{FCRTT_ResponseIteration+1,2},...
                                    responseTable_FCRTT{FCRTT_ResponseIteration+1,3},...
                                    responseTable_FCRTT{FCRTT_ResponseIteration+1,4},...
                                    responseTable_FCRTT{FCRTT_ResponseIteration+1,5}) % ...combinedReversalMatrix(2,reversalIteration));
                                fprintf('\n     TRIAL COUNT     : %d\n', FCRTT_ResponseIteration)
                                
                            end
                            
                            %% Response registry for stroboscopic exo
                            isThereResponse = isempty(responseTable_stimOnset{reversalIteration+1,3}); % 0 - if there is, 1 if there is not
                            
                            if  exo_endo == 1 && presentation_durations > 1
                                if isThereResponse
                                    if strcmp(responseText,'Correct')
                                        numberCorrect=numberCorrect+1;
                                    elseif strcmp(responseText,'Omission')
                                        numberOmission=numberOmission+1;
                                    end
                                    if numberCorrect >= 1
                                        accuracyPercentage=numberCorrect / (reversalIteration-numberOmission);
                                    else
                                        accuracyPercentage = 0;
                                    end
                                    responseTable_stimOnset{reversalIteration+1,3}=responseText; % accuracy
                                    responseTable_stimOnset{reversalIteration+1,4}=keyName; % keyboard key name
                                    responseTable_stimOnset{reversalIteration+1,5}=reactionTime; % estimated RT  
                                    responseTable_stimOnset{reversalIteration+1,6}=releaseDuration; % release duration 
                                    responseTable_stimOnset{reversalIteration+1,7}=reversalOnsetIndex; % estimated stimulus onset 
                                    responseTable_stimOnset{reversalIteration+1,8}=relativePress; % total time elapsed since the first display 
                                    fprintf('\nStimulus Type: %s\nResponse: %s\nTotal Accuracy: %f\nKeyboard Key: %s\nReaction Time: %f\nRelease Delay: %f\n Required Delay: %f\n', ...
                                        responseTable_stimOnset{reversalIteration+1,1},...
                                        responseTable_stimOnset{reversalIteration+1,3},...
                                        accuracyPercentage,...
                                        responseTable_stimOnset{reversalIteration+1,4},...
                                        responseTable_stimOnset{reversalIteration+1,5},...
                                        responseTable_stimOnset{reversalIteration+1,6},...
                                        combinedReversalMatrix(2,reversalIteration));
                                    fprintf('\n     TRIAL COUNT     : %d\n', reversalIteration)

                                    %% Check accuracy rate for colored exogenous response training 
                                    if response_training == 1 && reversalIteration >= 12
                                        correctIndices   = regexp(responseTable_stimOnset(reversalIteration-11:reversalIteration,3),'Correct'); % get the index of correct responses
                                        omissionIndices  = regexp(responseTable_stimOnset(reversalIteration-11:reversalIteration,3),'Omission');
                                        correctIndices   = find(~cellfun(@isempty,correctIndices)); % how many correct responses 
                                        omissionCount    = length(find(~cellfun(@isempty,omissionIndices))); % how many correct responses 
                                        trainingAccuracy     = length(correctIndices) / (12-omissionCount); % calculate accuracy rate (correctTrials/(AllTrials-Omission Trials))
    %                                     DrawFormattedText2(['<color=0.,0.,0.>Accuracy Percentage: ' num2str(accuracyRate) ' \n  Trial Number: ' num2str(reversalIteration)],'win',window, 'sx',xCenter/10,'sy', yCenter*.2,'xalign','left','yalign','top','xlayout','left','baseColor',[0 0 0],'vSpacing',1.25,'wrapat',120);

    %                                     accuracyRate
    %                                     lastThreeAccuracy   = regexp(onset_responseTable((reversalIteration-2):(reversalIteration+1),3),'Correct'); % check the last 10 responses
    %                                     lastThreeAccuracy   = find(~cellfun(@isempty,correctIndices)); 
                                        disp(['Training Accuracy (last 12 trials):', num2str(trainingAccuracy)])
                                        trainingComplete = trainingAccuracy >= 0.90; % if responses have higher than %90 accuracy, terminate training. 
                                        if trainingComplete                                       
                                            break
                                        end


                                    end
                                
                                elseif ~isThereResponse
                                feedbackText = 'ZATEN BASTINIZ';
                                end
                            end                            
                            
                            
                            
                            FCRTT_keyReg = 0;
                            registeredKeys=3;
                            Pressed=0;
                            responseText='';
                            noOnsetresponseText='';

                        end


                end
               if trainingComplete                                        
                    break
               end                
            end
        if trainingComplete                                        
            break
        end

        end
        expEnd = GetSecs();
        blockDuration  = expEnd-expStart;
        disp(['Next block: ' num2str(blockIndx+1)]);
            if training_test == 3
                %% signal the end of test trial 
                sendParallelSignal(portAddress,portMarker_Trial+1,ioObj)
                WaitSecs(.005);
                endParallelSignal(portAddress,ioObj)
            end
            Screen('TextSize',window,25);
            %% CREATE TRIAL NAME AND DIRECTORY FOR REGISTERIES
            trialName=[experimentalBlockNames{blockIndx}{trialIndx,:}]; 
            cd(subjectFolder)
            blockFolder = [subjectFolder, '\block_',num2str(blockIndx)];
            mkdir(blockFolder)
            cd(blockFolder)
            blockInfo = cell2table({trialName; ['Block Duration: ' num2str(expEnd-expStart)]});
            writetable(blockInfo,[subid, '_block',num2str(blockIndx),'_info.txt']);
            
            
            %% create TABLE variables from cell matrices for registery (EXOGENOUS AND FCRTT TASKS)       
            table_stimOnset         = cell2table(responseTable_stimOnset);
            table_FCRTT             = cell2table(responseTable_FCRTT);
            %% create time points in a given sampling freq
            samplingFreq                = 500; % IEU 
            samplingFreqCorrection      = 1000/500; % divide 1 sec in msecs to sampling freq
            timePointCorrectedOnsets    =   (round((stimOnsetRegistery-first_vb)/samplingFreqCorrection,3)+.001)*1000; % correct screen onset times into sampling rate corrected time points (1 256... 1325 etc.)
            %% ADD BELWO TO DATA TABLES 
            timePointCorrectedPresses   =   (round(relativePressVector/samplingFreqCorrection,3)+.001)*1000;  % transform time in seconds to time in points by using sampling frequency of brainvision amplifier.
            
            %% create sampling-rate corrected onset registeries for matching with marker files (ENDOGENOUS TASK)
            table_estimatedOnset    = cell2table(responseTable_estimatedOnset);
            if enableOnsetEstimation % if there is onset estimation                 
                estimatedOnsetIndex         =   [responseTable_estimatedOnset{2:end,7}]; % get estimated onset Indices 
                markerFileOnsets            =   timePointCorrectedOnsets(estimatedOnsetIndex); % extract estimated onset time points 
                onsetIndices                =   find(~cellfun(@isempty,responseTable_estimatedOnset(2:end,7))); % find estimated onset row numbers 
                for markerIndx = 1:length(markerFileOnsets) % go through all onset time points 
                    responseTable_estimatedOnset{onsetIndices(markerIndx)+1,10}=markerFileOnsets(markerIndx); % register these time points to estimated onset response table 
                end                
                writetable(table_estimatedOnset,[subid, '_block',num2str(blockIndx), '_estimatedOnset.txt']) % write estimated onset response table 
            elseif checkEndogenousTask
                writetable(table_estimatedOnset,[subid, '_block',num2str(blockIndx), '_reversals.txt']) % write estimated onset response table 
            end 
            
            if exo_endo == 1 && presentation_durations ~=1 % if it is exogenous trial 
                
                writetable(table_stimOnset,[subid, '_block',num2str(blockIndx), '_stimOnset.txt']) % write actual onset response table                 
                correctIndices   = regexp(responseTable_stimOnset(:,3),'Correct'); % get the index of correct responses
                omissionIndices  = regexp(responseTable_stimOnset(:,3),'Omission');
                correctIndices   = find(~cellfun(@isempty,correctIndices)); % how many correct responses                 
                omissionCount    = length(find(~cellfun(@isempty,omissionIndices))); % how many correct responses 
                accuracyRate     = length(correctIndices) / (reversalIteration-omissionCount); % calculate accuracy rate (correctTrials/(AllTrials-Omission Trials))
                RTs              = [responseTable_stimOnset{correctIndices,5}];
                dataFigure       = figure(2);
                subplot(ceil(howManyBlocks/5),5,blockIndx)
                hist(RTs)
                title(['Block: ',num2str(blockIndx),' Accuracy: ', num2str(accuracyRate)]);
                
            end
            if presentation_durations ==1

                writetable(table_FCRTT,[subid, '_block',num2str(blockIndx), '_FCRTT.txt']) % write actual onset response table 
                correctIndices   = regexp(responseTable_FCRTT(:,2),'Correct'); % get the index of correct responses
                omissionIndices  = regexp(responseTable_FCRTT(:,2),'Omission');
                correctIndices   = find(~cellfun(@isempty,correctIndices)); % how many correct responses                 
                omissionCount    = length(find(~cellfun(@isempty,omissionIndices))); % how many correct responses 
                accuracyRate     = length(correctIndices) / (FCRTT_ResponseIteration-omissionCount-FCRTT_feedbackRepmat); % calculate accuracy rate (correctTrials/(AllTrials-Omission Trials))
                RTs              = [responseTable_FCRTT{correctIndices,4}];
                dataFigure       = figure(2);
                subplot(ceil(howManyBlocks/5),5,blockIndx)
                hist(RTs)
                title(['Block: ',num2str(blockIndx),' Accuracy: ', num2str(accuracyRate)]);
            end
            % write stimulus onsets to stimulusTable
            for writeOnsetIndex = 1:length(stimOnsetRegistery)
                stimulusTable{writeOnsetIndex,7}=stimOnsetRegistery(writeOnsetIndex);
            end
            
            table_stimulusTable = cell2table(stimulusTable);
            writetable(table_stimulusTable,[subid, '_block',num2str(blockIndx),'stimulusTable.txt'])
            % get behavioral parameters of the past trial
            cd(subjectFolder)
            behavioralParameters=matchOnsets(responseTable_stimOnset,responseTable_estimatedOnset,...
                                            enableOnsetEstimation,...
                                            enableReversalRateEstimation,...
                                            exo_endo);
            % get reversal rates (baseline) OR reaction times (test-exogenous) in previous trials     
            if training_test == 1 % register reversal rates in baseline trials. 
                baselineBehavioralParameters=[baselineBehavioralParameters, behavioralParameters];
            elseif training_test == 2 && (exo_endo == 1 || presentation_durations ==1) % get reaction times that will be used in onset estimation later on
                if ~isempty(behavioralParameters)
                    exogenousTestRT = [exogenousTestRT behavioralParameters(1)];                
                end
            end
            %% END OF TRIAL INSTRUCTION CONDITIONS
            checkLastTrial          = trialIndx==size(blockParameters,1); % check if it is the last trial of the current block
            checkExperimentFinished = checkLastTrial && blockIndx==length(experimentalBlockNames); % check if experiment finishes (if it is the last trial of the last block)    
            % terminate is ESCAPE is pressed
            if ~exitmarker
                break
            end
            %% CLOSE SCREEN FOR EXPERIMENTER INSTRUCTIONS IF THE BLOCK IS ENDED

                
            if ~checkExperimentFinished && (checkLastTrial || training_test == 3)
                % CALL 'EXPERIMENTER SHALL ARRIVE NOW' NOTICE BEFORE CLOSING THE SCREEN
                callTextInstruction(window,callExperimenterNotification,xCenter, yCenter,portVariables)
                disp('block finished go to participant')
                
                Screen('Close', window);
            while 1
                proceedPrompt = 'Type in <continue> to proceed';
                proceedAnswer = input(proceedPrompt, 's');
                isContinue = strcmp(proceedAnswer,'continue');
                if isContinue
                    isContinue=[];
                    break
                end
            end
                
                [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white ); % ,[0 0 700 700]
                
            end
            
            %% DISABLE TRAINING 'BREAK' FUNCTIONS 
            if trainingComplete 
                trainingComplete=0;
            end
            
            %% RESTORE COLOR POSITION PAIRS OF DOUBLE DOTS FOR THE NEXT TRIAL 
            presentationRects=allRects;    
    end
end
%% send end of experiment marker = S2
sendParallelSignal(portAddress,2,ioObj)
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)    

%% Close all screens and stop keyboard registery
fclose('all');    
sca;
KbQueueFlush;
KbQueueRelease;  

%% Get statistics and histogram of ITIs of exogenous reversals
% mean([stimulusTable{:,6}])
% std([stimulusTable{:,6}],1)
% hist([stimulusTable{:,6}])









