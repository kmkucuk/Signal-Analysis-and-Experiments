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
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey,[700 0 1000 300]);

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




stimduration = .300; %%% Stimulus duration (.98xxx seconds)

responseDuration = 1.5;
% stimulus vector for ONE-RESPONSE TASK
% stimulusVector = {"square","circle","triangle","octagon";1,1,1,1};

% stimulus vector for FOUR-CHOICE TASK
% stimulusVector = {"square","circle","triangle","octagon";1,2,3,4};

% % stimulus vector for sensory shape task 
stimulusVector = {'square','circle','triangle','octagon'};
% portVector =       {20,     21,         22,         23};

% sequences (4 trials each)
sequenceA = {'square','triangle','circle','octagon';1,3,2,4;20,22,21,23};
sequenceB = {'triangle','octagon','square','circle';3,4,1,2;22,23,20,21};
sequenceC = {'octagon','circle','triangle','square';4,2,3,1;23,21,22,20};
sequenceD = {'circle','square','octagon','triangle';2,1,4,3;21,20,22,23};

% sequence orders (16 trials each)
sequenceOrder1 = cat(2,sequenceA,sequenceB,sequenceC,sequenceD);
sequenceOrder2 = cat(2,sequenceB,sequenceD,sequenceA,sequenceC);
sequenceOrder3 = cat(2,sequenceD,sequenceC,sequenceB,sequenceA);
sequenceOrder4 = cat(2,sequenceC,sequenceA,sequenceD,sequenceB);
allsequences = {sequenceOrder1,sequenceOrder2,sequenceOrder3,sequenceOrder4;'s1','s2','s3','s4'};


% create full experiment 
stimulusRepetition = 36;
presentationMatrix = {};
drawingsequences = repmat(allsequences,[1 2]);
sequenceNames = [];
for k = 1:9
    
    if k == 1
        presentationMatrix = cat(2,presentationMatrix,sequenceOrder1);
        sequenceNames = [sequenceNames, allsequences{2,1}];
    else
        randindx = randi([1 size(drawingsequences,2)],1,1);

        currentsequence = drawingsequences{1,randindx};
        sequenceNames = [sequenceNames, drawingsequences{2,randindx}];
        
        drawingsequences(:,randindx)=[];
        presentationMatrix = cat(2,presentationMatrix,currentsequence);
        

    end
end

        

stimduration = .300; %%% Stimulus duration (.98xxx seconds)
responseDuration = 1.5;

ISIvector =  1.75:.25:3; %[2.125,2.043,1.939,1.787,2.002,2.262,2.263,2.076,2.248,2.146,1.623,2.004,1.847,1.592,1.647,1.698,2.172,1.931,2.195,1.757,1.509,2.032,1.779,2.447,2.407,1.893,1.524,2.172,2.338,2.472,1.556,1.950,2.083,2.187,2.220,2.150,2.227,1.874,2.082,1.616,1.557,2.480,1.785,2.095,2.463,1.685,1.693,1.841,2.433,1.891,1.773,1.652,1.897,1.875,1.631,1.935,1.591,2.115,1.510,2.073,2.290,1.735,1.948,2.069,1.561,1.996,2.142,1.721,2.337,2.472,2.347,2.006,1.779,2.247,1.737,2.458,2.120,2.100,1.672,1.590,1.755,2.359,2.411,2.200,2.225,1.730,2.076,2.311,1.904,2.489,1.590,1.821,2.011,1.560,2.226,2.057,2.029,2.330,2.359,2.289,1.818,1.952,2.252,1.609,1.609,1.770,2.025,2.473,2.211,1.812,1.791,2.351,2.412,2.139,1.755,1.588,2.339,2.085,2.449,1.561,2.085,1.785,2.328,1.691,1.942,1.893,2.327,2.177,1.707,1.818,1.633,2.172,2.071,1.669,1.647,1.976,2.409,2.052,1.532,1.553,2.305,1.951,1.883,2.290];
ISIvector = repmat(ISIvector,1,size(presentationMatrix,2)/length(ISIvector));
ISIvector = ISIvector(randperm(length(ISIvector)));
% sca
responseTableHeaders        = {'trialNo','Stimulus_Type','KeyName','responseByte','AccuracyText','Accuracy','reactionTime','stimulusStartTime','Date_Time'};
responseTable               = cell(length(presentationVector),length(responseTableHeaders));
responseTable(1,:)          = responseTableHeaders;


startTime=GetSecs(); %%% Marks the start of the experiment. 
KbQueueCreate;
KbQueueStart;

exitmarker = 0; % logical, if 1 = quit experiment, 0 = continue experiment loop
triali=0;    % Iteration variable for trials. 

for triali = 1:size(presentationMatrix,2)
    
    checkPauseOrExitKeys;
    
    if exitmarker == 1
        break;
    end    
    
    
    isiDuration = ISIvector(triali);
    % stimulusType: what is the name of the current stimulus? (e.g.
    % "circle")
    stimulusType            = presentationMatrix{1,triali};
    
    % correctResponseIndex: which of the bytes in "responseBytes" variable is the correct answer?
    correctResponseIndex    = presentationMatrix{2,triali}; 
    
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
    

    if triali >1
        
        previousStimTime=stimOnset; 
        
    else
        
        previousStimTime=startTime; %%% equals stim presentation time to exp start time for the first trial. This is required for Screen('Flip') function's [when] argument. 
        
    end
    
    stimOnset=Screen('Flip', window,previousStimTime+isiDuration+responseDuration);    
    %% send stimulus marker to EEG recorder
%     sendParallelSignal(portAddress,portMarker,ioObj);
%     % end signal %
%     WaitSecs(.005);
    %%  end stimulus marker signal
%     endParallelSignal(portAddress,ioObj)    
    
    stimOnset-previousStimTime %#ok<NOPTS>    
    
    exitKeyReg=1;
    while GetSecs()-stimOnset >=  responseDuration
        checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses: i) pauses or ii) terminates the experiment, respectively. 
            if ~exitmarker
                break
            end
        %%
        currentResponseByte = io64(ioObj,portAddress(2));   % second port address is response input
        Pressed  = noPressByte ~= currentResponseByte;
        
        if Pressed == 1
            pressTime = GetSecs();
            reactionTime = pressTime - stimOnset; 
        end
        
        responseIndex       = findIndices(response_bytes,currentResponseByte);
        responseAccuracy    = correctResponseIndex == responseIndex;
        responseName        = response_bytes_names(responseIndex);
        
        if responseAccuracy == 1
            accuracyText = "correct";
            %% send CORRECT response marker
            %     sendParallelSignal(portAddress,portMarker,ioObj);
          
        else
            accuracyText = "error";
            %% send INCORRECT response marker
            %     sendParallelSignal(portAddress,portMarker,ioObj);
   
        end
        %% END accuracy marker signals
        %     WaitSecs(.005);
        %     endParallelSignal(portAddress,ioObj)                  
        
        fprintf('stimulus name: %s \n',stimulusType);
        fprintf('response name: %s \n',responseName);
        fprintf('accuracy     : %s \n',accuracyText);
        fprintf('reaction time: %s \n',reactionTime);
        fprintf('stimulus time: %s \n',stimOnset-startTime);
        fprintf('date         : %s \n',char(datetime));
        
        responseTable{triali+1,1}=triali;
        responseTable{triali+1,2}=stimulusType;
        responseTable{triali+1,3}=responseName;
        responseTable{triali+1,4}=currentResponseByte;  % keyboard key name
        responseTable{triali+1,5}=accuracyText;         % accuracy text
        responseTable{triali+1,6}=responseAccuracy;     % accuracy text        
        responseTable{triali+1,7}=reactionTime;         % estimated RT  
        responseTable{triali+1,8}=stimOnset-startTime;   % stimulus start time   
        responseTable{triali+1,9}=char(datetime);       % stimulus start time   
    end
    

    
    isi_vbl=Screen('Flip', window,stimOnset+stimduration); 
    if triali == length(presentationVector)
        break;
    end
    
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
