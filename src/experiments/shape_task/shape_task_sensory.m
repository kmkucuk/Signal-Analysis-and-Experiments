% Clear the workspace and the screen
sca;
close all;
clearvars;


% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 1); 

% Get the screen numbers

screens = Screen('Screens');

% Draw to the external screen if avaliable

screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;


% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [700 0 1000 300]);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);


% Get the center coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);


monitor_distance = 140; % participants are 140 cm away from monitor
horizontal_moni_length = 44.3; % horizontal length of monitor is 44.3 cm
pixPerCm = screenXpixels / horizontal_moni_length;
degreePerCm =2*atand((1/2)/monitor_distance);  % how much degrees in 1 cm
unitDegreePerCm = 1/degreePerCm;


stimSizeInDegree = 4; % 8 cm corresponds to 4° visual angle at 140 cm viewing distance
stimSizeInCm = stimSizeInDegree*unitDegreePerCm; % stim will be 4 degree in size
stimSizeInPix = stimSizeInCm*pixPerCm;


% default x + y size
virtualSize = ceil(stimSizeInPix);
% radius of the disc edge
radius = floor(virtualSize / 2);

%%
% SQUARE: Make a Rect of 200 by 200 pixels
baseRect = [0 0 stimSizeInPix stimSizeInPix];

centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);
%%
% HEXAGON: Make a hexagon

% Number of sides for our polygon
triangleSides = 6; % 6 for hexagon

% Angles at which our polygon vertices endpoints will be. We start at zero
% and then equally space vertex endpoints around the edge of a circle. The
% polygon is then defined by sequentially joining these end points.
triangleAnglesDeg = linspace(0, 360, triangleSides + 1);
triangleAnglesRad = triangleAnglesDeg * (pi / 180);

triangle_yPosVector = sin(triangleAnglesRad) .* radius + yCenter;
triangle_xPosVector = cos(triangleAnglesRad) .* radius + xCenter;

%%
% CIRCLE: Make a Circle of 200 by 200 pixels
maxDiameter = max(baseRect) * 1.01;

%% OCTAGON: Make a Octagon of 200 by 200 pixels

% Number of sides for our polygon
octagonSides = 10; % 8 for octagon

% Angles at which our polygon vertices endpoints will be. We start at zero
% and then equally space vertex endpoints around the edge of a circle. The
% polygon is then defined by sequentially joining these end points.
octagonAnglesDeg = linspace(0, 360, octagonSides + 1);
octagonAnglesRad = octagonAnglesDeg * (pi / 180);

% X and Y coordinates of the points defining out polygon, centred on the
% centre of the screen
octagon_yPosVector = sin(octagonAnglesRad) .* radius + yCenter;
octagon_xPosVector = cos(octagonAnglesRad) .* radius + xCenter;
isConvex = 1;

%%
blackColor = [0 0 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Keyboard Responses %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

noPressByte                     = 120;

one_pressByte                   = 248;
two_pressByte                   = 88; 
three_pressByte                 = 248;
four_pressByte                  = 112; 

response_bytes                  = [one_pressByte, two_pressByte,three_pressByte,four_pressByte];
response_byte_names             = {'one','two','three','four'};
pause_key                       = KbName('p');
escape_key                      = KbName('ESCAPE');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Variable Properties and Trial Timers %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KbQueueCreate;
KbQueueStart;



stimulusRepetition = 36;
stimduration = .300; %%% Stimulus duration (.98xxx seconds)
responseDuration = 1.5;

% stimulus vector for sensory shape task 
stimulusVector = {'square','circle','triangle','octagon'};
portVector = {20,21,22,23};
presentationVector = cat(1,stimulusVector,portVector);


presentationVector = repmat(presentationVector,1,stimulusRepetition);
ISIvector =  1.75:.25:3; %[2.125,2.043,1.939,1.787,2.002,2.262,2.263,2.076,2.248,2.146,1.623,2.004,1.847,1.592,1.647,1.698,2.172,1.931,2.195,1.757,1.509,2.032,1.779,2.447,2.407,1.893,1.524,2.172,2.338,2.472,1.556,1.950,2.083,2.187,2.220,2.150,2.227,1.874,2.082,1.616,1.557,2.480,1.785,2.095,2.463,1.685,1.693,1.841,2.433,1.891,1.773,1.652,1.897,1.875,1.631,1.935,1.591,2.115,1.510,2.073,2.290,1.735,1.948,2.069,1.561,1.996,2.142,1.721,2.337,2.472,2.347,2.006,1.779,2.247,1.737,2.458,2.120,2.100,1.672,1.590,1.755,2.359,2.411,2.200,2.225,1.730,2.076,2.311,1.904,2.489,1.590,1.821,2.011,1.560,2.226,2.057,2.029,2.330,2.359,2.289,1.818,1.952,2.252,1.609,1.609,1.770,2.025,2.473,2.211,1.812,1.791,2.351,2.412,2.139,1.755,1.588,2.339,2.085,2.449,1.561,2.085,1.785,2.328,1.691,1.942,1.893,2.327,2.177,1.707,1.818,1.633,2.172,2.071,1.669,1.647,1.976,2.409,2.052,1.532,1.553,2.305,1.951,1.883,2.290];
ISIvector = repmat(ISIvector,1,length(presentationVector)/length(ISIvector));
ISIvector = ISIvector(randperm(length(ISIvector)));
% sca
responseTableHeaders        = {'trialNo','Stimulus_Type','KeyName','responseByte','AccuracyText','Accuracy','reactionTime','stimulusStartTime','Date_Time'};
responseTable               = cell(length(presentationVector),length(responseTableHeaders));
responseTable(1,:)          = responseTableHeaders;


startTime=GetSecs(); %%% Marks the start of the experiment. 
KbQueueCreate;
KbQueueStart;

exitmarker = 0; % logical, if 1 = quit experiment, 0 = continue experiment loop
for trialIteration = 1:length(presentationVector)
    
    checkPauseOrExitKeys;
    
    if exitmarker == 1
        break;
    end    
    
    iti_duration = ISIvector(trialIteration);
    % stimulusType: what is the name of the current stimulus? (e.g.
    % "circle")
    stimulusType            = presentationVector{1,trialIteration};
    
    % portMarker = which number to display in recorder (20> S20, 23>S23)
    portMarker              = presentationVector{2,trialIteration}; 
    
    if strcmp(stimulusType,"square")        
        
        Screen('FillRect',window, blackColor,centeredRect);
        
    elseif strcmp(stimulusType,"circle")
        
        Screen('FillOval', window, blackColor, centeredRect, maxDiameter);
        
    else
        if strcmp(stimulusType,"octagon")
            % if this is an octagon, use its angles.
            xPosVector = octagon_xPosVector;
            yPosVector = octagon_yPosVector;
        else
            % if this is a triangle, use its angles. 
            xPosVector = triangle_xPosVector;
            yPosVector = triangle_yPosVector;
        end    
        Screen('FillPoly', window, blackColor, [xPosVector; yPosVector]', isConvex);
    end
    

    if trialIteration >1
        
        stim_time=stim_vbl; 
        
    else
        
        stim_time=startTime; %%% equals stim presentation time to exp start time for the first trial. This is required for Screen('Flip') function's [when] argument. 
        
    end
    
    stim_vbl=Screen('Flip', window,stim_time+iti_duration+responseDuration);    
    % send stimulus marker to EEG recorder
    sendParallelSignal(portAddress,portMarker,ioObj);
    % end signal %
    WaitSecs(.005);
    %  end stimulus marker signal
    endParallelSignal(portAddress,ioObj)
    

    isi_vbl=Screen('Flip', window,stim_vbl+stimduration);     
    
%     while GetSecs()-stim_vbl >=  responseDuration
%         checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses: i) pauses or ii) terminates the experiment, respectively. 
%             if ~exitmarker
%                 break
%             end
%         %%
%         currentResponseByte = io64(ioObj,portAddress(2));   % second port address is response input
%         Pressed  = noPressByte ~= currentResponseByte;
%         
%         if Pressed == 1
%             pressTime = GetSecs();
%             reactionTime = pressTime - stim_vbl; 
%         end
%         
%         responseIndex       = findIndices(response_bytes,currentResponseByte);
%         responseAccuracy    = correctResponseIndex == responseIndex;
%         responseName        = response_bytes_names(responseIndex);
%         
%         if responseAccuracy == 1
%             accuracyText = "correct";
%             %% send CORRECT response marker
%             %     sendParallelSignal(portAddress,portMarker,ioObj);
%           
%         else
%             accuracyText = "error";
%             %% send INCORRECT response marker
%             %     sendParallelSignal(portAddress,portMarker,ioObj);
%    
%         end
%         %% END accuracy marker signals
%         %     WaitSecs(.005);
%         %     endParallelSignal(portAddress,ioObj)                  
%         
%         fprintf('stimulus name: %s \n',stimulusType);
%         fprintf('response name: %s \n',responseName);
%         fprintf('accuracy     : %s \n',accuracyText);
%         fprintf('reaction time: %s \n',reactionTime);
%         fprintf('stimulus time: %s \n',stim_vbl-startTime);
%         fprintf('date         : %s \n',char(datetime));
%         
%         responseTable{trialIteration+1,1}=trialIteration;
%         responseTable{trialIteration+1,2}=stimulusType;
%         responseTable{trialIteration+1,3}=responseName;
%         responseTable{trialIteration+1,4}=currentResponseByte;  % keyboard key name
%         responseTable{trialIteration+1,5}=accuracyText;         % accuracy text
%         responseTable{trialIteration+1,6}=responseAccuracy;     % accuracy text        
%         responseTable{trialIteration+1,7}=reactionTime;         % estimated RT  
%         responseTable{trialIteration+1,8}=stim_vbl-startTime;   % stimulus start time   
%         responseTable{trialIteration+1,9}=char(datetime);       % stimulus start time   
%     end
    
    
    

    
end


dataFolder ='E:\Backups\Matlab Directory\all_matlab_scripts\experiments\shape_task\rawData';
cd(dataFolder)
subjectCode = 'p001';
table_motor = cell2table(responseTable);
currentTime = char(datetime);
currentTime=strrep(currentTime,':','-');
currentTime=strrep(currentTime,' ','_');
writetable(table_motor,[subjectCode,'_taskName','.txt']);


% Clear the screen
sca;
