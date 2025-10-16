%% Task Parameters: 
% Training-Test 
% Standard White / Cued Colored 
% Left-Right Finger Counterbalancing etc.

trialType               = {'baseline_','training_','test_'};  % 1 
taskType                = {'exogenous_','endogenous_'}; % 2 
colorType               = {'white_','redBlue_','red','blue'}; % 3 
feedBackType            = {'noFeedback_','feedback_'}; % 4 
responseType            = {'change_','directions_','colorPosition_','colorOnly_','positionOnly_'}; % 5
stimulusDurations       = {'simpleRT_','stroboscopic_','stroboscopicSlow_'}; % 6
reversalType            = {'allStimuliEqual_','col_onlyRed_','col_onlyBlue_'}; % 7
revesalDotDuration      = {'normal','reversalEmphasized'}; % 8
experimentalParameters  = {trialType; taskType; colorType; feedBackType;responseType;stimulusDurations; reversalType;revesalDotDuration};

  
% 16 STEP TRAINING - FCRTT-EXO-DOTS AND EXOGENOUS TASK
        % FCRTT Exo training
experimentalBlocks      = { [2,1,1,2,5,1,1,1],... (1) FCRTT, white, position only, LEFT
    [2,1,1,2,5,1,1,1],... % (2) FCRTT, white, position only, RIGHT
    [2,1,2,2,4,1,1,1],... % (3) FCRTT respond only to colors with feedback, no press durations (two color + no durations)
    [2,1,3,2,3,1,1,1],... % (4) FCRTT, only RED dots are shown, press duration is required (one color + two durations)
    [2,1,4,2,3,1,1,1],... % (5) FCRTT, only BLUE dots are shown, press duration is required (one color + two durations)
    [2,1,2,2,3,1,1,1],... % (6) FCRTT, Red and Blue dots are shown, press duration is required (full: two color + two durations)
    ... % exo training - change only
    [2,1,2,2,1,2,1,1],... % (7) Exogenous, Red and Blue dots, report change only,  LEFT
    [2,1,2,2,1,2,1,1],... % (8) Exogenous, Red and Blue dots, report change only   RIGHT
    ... % exo training - color and change, no color position
    [2,1,2,2,4,3,1,1],... % (9) Exogenous, Red and Blue dots, report change and color (not color position),  1.5x slow
    [2,1,2,2,4,2,1,1],... % (10) Exogenous, Red and Blue dots, report change and color (not color position)
    ... % exo training - red color position
    [2,1,2,2,3,3,2,1],... % (11) Exogenous, Red dots, report change+color+position,  1.5x slow
    [2,1,2,2,3,2,2,1],... % (12) Exogenous, Red dots, report change+color+position
    ... % exo training - blue color position 
    [2,1,2,2,3,3,3,1],... % (13) Exogenous, Blue dots, report change+color+position,  1.5x slow
    [2,1,2,2,3,2,3,1],... % (14) Exogenous, Blue dots, report change+color+position
    ... % exo training RED+BLUE+POSITION
    [2,1,2,2,3,3,1,1],... % (15) Exogenous, Red and Blue dots, report change+color+position,  1.5x slow
    [2,1,2,2,3,2,1,1]};   % (16) Exogenous, Red and Blue dots, report change+color+position
                      
experimentalBlocks = {[3,1,2,1,3,2,1,1]};

experimentalBlocks = {[3,2,1,1,1,2,1,1]}; % endo white
% 16 STEP TRAINING - FCRTT-ENDO-DOTS AND ENDOGENOUS TASK 
%         % FCRTT Endo training
% experimentalBlocks      = { [2,2,1,1,5,1,1,1],... (1) FCRTT, white, position only, LEFT-experimenter tells the button
%     [2,2,1,1,5,1,1,1],... % (2) FCRTT, white, position only, RIGHT-experimenter tells the button
%     [2,2,2,1,4,1,1,1],... % (3) FCRTT respond only to colors with feedback, no press durations (two color + no durations)
%     [2,2,3,1,3,1,1,1],... % (4) FCRTT, only RED dots are shown, press duration is required (one color + two durations)
%     [2,2,4,1,3,1,1,1],... % (5) FCRTT, only BLUE dots are shown, press duration is required (one color + two durations)
%     [2,2,2,1,3,1,1,1],... % (6) FCRTT, Red and Blue dots are shown, press duration is required (full: two color + two durations)
%     ... % endo training - change only
%     [2,2,2,1,1,2,1,1],... % (7) Endogenous, Red and Blue dots, report change only,  LEFT
%     [2,2,2,1,1,2,1,1],... % (8) Endogenous, Red and Blue dots, report change only   RIGHT
%     ... % endo training - color and change, no color position
%     [2,2,2,1,4,3,1,1],... % (9) Endogenous, Red and Blue dots, report change and color (not color position),  1.5x slow
%     [2,2,2,1,4,2,1,1],... % (10) Endogenous, Red and Blue dots, report change and color (not color position)
%     ... % endo training - red color position
%     [2,2,2,1,3,3,2,1],... % (11) Endogenous, Red dots, report change+color+position,  1.5x slow
%     [2,2,2,1,3,2,2,1],... % (12) Endogenous, Red dots, report change+color+position
%     ... % endo training - blue color position 
%     [2,2,2,1,3,3,3,1],... % (13) Endogenous, Blue dots, report change+color+position,  1.5x slow
%     [2,2,2,1,3,2,3,1],... % (14) Endogenous, Blue dots, report change+color+position
%     ... % endo training RED+BLUE+POSITION
%     [2,2,2,1,3,3,1,1],... % (15) Endogenous, Red and Blue dots, report change+color+position,  1.5x slow
%     [2,2,2,1,3,2,1,1]};   % (16) Endogenous, Red and Blue dots, report change+color+position

% % COLOR CONTROL STUDY 
% experimentalBlocks      = {[3,1,1,1,2,2,1,1],...   % (1) Exogenous, white dots, report change and direction
%     [3,2,1,1,2,2,1,1],...   % (2) Endogenous, white dots,  report change and direction
%     [3,1,2,1,2,2,1,1],...   % (3) Exogenous, Red and Blue dots,  report change and direction
%     [3,2,2,1,2,2,1,1]};     % (4) Endogenous, Red and Blue dots,  report change and direction
% 
% % below is the counterbalancing part for the "COLOR CONTROL STUDY"
% colorControlStudy = 1;
% if colorControlStudy==1
%     colorCB = 3; % 1) exo first, white first 2) endo first white first 3) exo first color first, 4) endo first color first
%     if colorCB == 1
%         
%     elseif colorCB == 2
%         experimentalBlocks([1 2 3 4]) = experimentalBlocks([2 1 4 2]);
%     elseif colorCB == 3
%         experimentalBlocks([1 2 3 4]) = experimentalBlocks([3 4 1 2]);
%     elseif colorCB == 4
%         experimentalBlocks([1 2 3 4]) = experimentalBlocks([4 3 2 1]);
%     end
% end



experimentalBlockNames={};
for blocksIndx=1:length(experimentalBlocks)
    
    for taskIndx=1:size(experimentalBlocks{blocksIndx},1)
        
        for paramIndx=1:size(experimentalBlocks{blocksIndx},2)

        experimentalBlockNames{blocksIndx}(taskIndx,paramIndx) = experimentalParameters{paramIndx}(experimentalBlocks{blocksIndx}(taskIndx,paramIndx));
        
        end
        
    end
end


% baselineColorBalance = 0; % (0) first white, second color; (1) first color, second white.
% testBlockColorBalance = 1; % (0) first white, second color; (1) first color, second white. 
% 
% if baselineColorBalance 
%     experimentalBlocks{1}=flip(experimentalBlocks{1});     %#ok<*UNRCH>
%     experimentalBlockNames{1}=flip(experimentalBlockNames{1}); 
% end

% if testBlockColorBalance 
%     experimentalBlocks([2 3])=experimentalBlocks([3 2]);  %#ok<*UNRCH>
%     experimentalBlockNames([2 3])=experimentalBlockNames([3 2]);
% end

% % PILOT STUDY (FAILED, TOO DIFFICULT)
% experimentalBlocks      = { [2,2,2,2,3,1],... % (1) four choice reaction time task: stim durations are different
%     [2,1,2,2,3,2],... % (2) colored exo response training with feedback
%     [3,2,2,1,3,2],... % (3) colored endo test - position response 
%     [3,1,2,1,3,2]};% (4) colored exo test - position response
% % [2,1,3,2,3,1,1,1],... (0) CUSTOM STUFF 
% 
% % 20 STEP TRAINING          % choice RT training
% experimentalBlocks      = { [2,1,1,2,5,1,1,1],... (1) FCRTT, white, position only, LEFT-experimenter tells the button
%     [2,1,1,2,5,1,1,1],... % (2) FCRTT, white, position only, RIGHT-experimenter tells the button
%     [2,1,2,2,4,1,1,1],... % (3) FCRTT respond only to colors with feedback, no press durations (two color + no durations)
%     [2,1,3,2,3,1,1,1],... % (4) FCRTT, only RED dots are shown, press duration is required (one color + two durations)
%     [2,1,4,2,3,1,1,1],... % (5) FCRTT, only BLUE dots are shown, press duration is required (one color + two durations)
%     [2,1,2,2,3,1,1,1],... % (6) FCRTT, Red and Blue dots are shown, press duration is required (full: two color + two durations)
%     ... % exo training - change only
%     [2,1,2,2,1,3,1,2],... % (7) Exogenous, Red and Blue dots, report change only,  1.5x slow, reversal dot 1.5x duration (reversalEmphasized)
%     [2,1,2,2,1,3,1,1],... % (8) Exogenous, Red and Blue dots, report change only,  1.5x slow
%     [2,1,2,2,1,2,1,1],... % (9) Exogenous, Red and Blue dots, report change only
%     ... % exo training - color and change, no color position
%     [2,1,2,2,4,3,1,2],... % (10) Exogenous, Red and Blue dots, report change and color (not color position), 1.5x slow, reversal dot 1.5x duration (reversalEmphasized)
%     [2,1,2,2,4,3,1,1],... % (11) Exogenous, Red and Blue dots, report change and color (not color position),  1.5x slow
%     [2,1,2,2,4,2,1,1],... % (12) Exogenous, Red and Blue dots, report change and color (not color position)
%     ... % exo training - red color position
%     [2,1,2,2,3,3,2,2],... % (13) Exogenous, Red dots, report change+color+position, 1.5x slow, reversal dot 1.5x duration (reversalEmphasized)
%     [2,1,2,2,3,3,2,1],... % (14) Exogenous, Red dots, report change+color+position,  1.5x slow
%     [2,1,2,2,3,2,2,1],... % (15) Exogenous, Red dots, report change+color+position
%     ... % exo training - blue color position 
%     [2,1,2,2,3,3,3,2],... % (16) Exogenous, Blue dots, report change+color+position, 1.5x slow, reversal dot 1.5x duration (reversalEmphasized)
%     [2,1,2,2,3,3,3,1],... % (17) Exogenous, Blue dots, report change+color+position,  1.5x slow
%     [2,1,2,2,3,2,3,1],... % (18) Exogenous, Blue dots, report change+color+position
%     ... % exo training RED+BLUE+POSITION
%     [2,1,2,2,3,2,1,1],... % (19) Exogenous, Red and Blue dots, report change+color+position,  1.5x slow
%     [2,1,2,2,3,2,1,1]};   % (20) Exogenous, Red and Blue dots, report change+color+position
