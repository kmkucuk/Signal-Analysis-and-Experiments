

% Clear the workspace and the screen
sca;
close all;
clearvars;


% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 1); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Login prompt and open file for writing data out %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prompt = {'Outputfile', 'Subject''s number:', 'age', 'gender', 'Without Training=1, With Training=2'};
defaults = {'Checkerboard', '300', '20', 'F','1'};
answer = inputdlg(prompt, 'Checkerboard', 2, defaults);
[output, subid, subage, gender, trainingOrNot] = deal(answer{:}); % all input variables are strings

trainingOrNot=str2num(trainingOrNot);

outputname = [output gender '_' subid '_' subage '.xls'];

if exist(outputname)==2 %#ok<EXIST> % check to avoid overiding an existing file
    
fileproblem = input('That file already exists! Append a .x (1), overwrite (2), or break (3/default)?');

    if isempty(fileproblem) | fileproblem==3 
        return;
    elseif fileproblem==1
        outputname = [outputname '.x'];
    end
end
cd('D:\MatlabDirectory\AllScripts\MertKucuk\Checkerboard\RawDataFolder');

outfile = fopen(outputname,'w'); % open a file for writing data out

fprintf(outfile, 'subid\t subage\t gender\t Block_Type\t Press_Array\t Pressed_Key\t Reaction_Time\t \n');

% Get the screen numbers

screens = Screen('Screens');

% Draw to the external screen if avaliable

screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;


% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);


% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);


% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

CheckerInstructions=imread('CheckerInstructions', 'jpg');
CheckerInstructionsTXT=Screen('MakeTexture',window,CheckerInstructions);

% Make a base Rect of 200 by 200 pixels
baseR_height = 200;
baseR_width  = 140; % measures of black base rectangle

dot_length=10; % length of small dots, for fixation and double dots

% coordinates for double dots

% vertical exogenous





baseRect = [0 0 baseR_height baseR_width];

OvalRect=baseRect/2;

OvalDiamater=max(OvalRect)*1.01;

GrayRectWidth=(screenXpixels-screenYpixels)/2; %%% We calculate the amount of pixels required for creating a square view for our checkboard. 
                                               %%% We equalize the pixels both on X and Y axis
                                               
GrayRect=[0 0 GrayRectWidth screenYpixels];

% Make the coordinates for our grid of squares

%Target positions

[TarxPos, TaryPos] = meshgrid(-10:1:10, -10:1:10);  %%% Creates the raw matrix for the later coordinates system for each square's center. 
                                                    %%% There is are a lot of points (21 points total) because we want all screen to be consisted of squares. 


% Calculate the number of squares and reshape the matrices of coordinates
% into a vector
[Tars1, Tars2] = size(TarxPos);                 %%% Here we calculate the number of squares by using the grid we've created above. 
NumSquares = Tars1 * Tars2;                     %%% The grid values are converted into a vector for CenterRectOnPointd function, which we will use later. 
TarxPos = reshape(TarxPos, 1, NumSquares);
TaryPos = reshape(TaryPos, 1, NumSquares);



% Scale the grid spacing to the size of our squares and centre

TarxPosCenter = TarxPos .* dim + screenXpixels/2;           %%% This is the calculation of the actual coordinate values using the grid we've created above.
TaryPosCenter = TaryPos .* dim + screenYpixels/2;           %%% Grid is placed at the center of the screen and associated values are multiplied by the rectangle's length.

NonxPosCenter = TarxPos .* dim + screenXpixels/2-dim/2;     %%% Here we slide the gird just a little so that square intersection will be on the center of the screen
NonyPosCenter = TaryPos .* dim + screenYpixels/2+dim/2;     %%% 

GraykRectLeft = 0+GrayRect(3)/2;                            %%% We want our checkerboard to be presented as a square image. But it is difficult to do that with adjusting the raw grid we've created.
GrayRectRight= max(screenXpixels)-GrayRect(3)/2;            %%% So, instead, we will fill the screen with the checkerboard first, and then place grey rectangles on the left and the right side of the screen
                                                            %%% We will achieve a rectangular view with this method

%%% Set the colors of each of our squares white-black - Target

wBColors=[1,1,1;0,0,0];                             %%% This is the color matrix of our checkerboard. This part starts with white rectangles.
wBColors=wBColors.';                                %%% We transpose the matrix to use it later in FillRect function. Raw format is not acceptable [1,1,1;0,0,0] in this function.    
wBColors=repmat(wBColors,1,round(NumSquares/2,0)-1);        %%% Here we iterate the same color (white-black) pattern enough times that the count of total the color columns (1;1;1....) correspond to the total count of rectangles.  
wBColors(:,end+1)=[1;1;1];                                  %%% Then we add one additional color column for cases where there is uneven number of rectangles. 



%%% Set the colors of each of our squares black-white - Target

bWColors=[0,0,0;1,1,1];
bWColors=bWColors.';
bWColors=repmat(bWColors,1,round(NumSquares/2,0)-1);
bWColors(:,end+1)=[0;0;0];

%%% Color matrix for Target and Nontarget checkerboard rectangles,
%%% respectively 

ColorMatrix(:,:,1)=wBColors;
ColorMatrix(:,:,2)=bWColors;

%%% Color vectors for left and right grey squares that will create a
%%% squared checkerboard view. 

GrayRectColors=[.5 .5 .5; .5 .5 .5];
GrayRectColors=GrayRectColors.'; 

% Make our rectangle coordinates, center the oval coordinates

CenterOval=CenterRectOnPointd(OvalRect,xCenter,yCenter);                %%% Fixation oval coordinates.

GrayRectCenter(:,1)=CenterRectOnPointd(GrayRect,GraykRectLeft,yCenter); %%% Left black rectangle for square view
GrayRectCenter(:,2)=CenterRectOnPointd(GrayRect,GrayRectRight,yCenter); %%% Right black rectangle



for i = 1:NumSquares
    
    TarallRectsCenter(:, i) = CenterRectOnPointd(baseRect,...
        TarxPosCenter(i), TaryPosCenter(i));      %#ok<SAGROW>
    NonAllRectsCenter(:,i)=CenterRectOnPointd(baseRect,...
        NonxPosCenter(i), NonyPosCenter(i));
end

CallInstructionChecker(window,CheckerInstructionsTXT);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Variable Properties and Trial Timers %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KbQueueCreate;
KbQueueStart;

trialIteration=0;    %%% Iteration variable for trials. 

stimduration=1-.018; %%% Stimulus duration (.98xxx seconds)

nontargetIteration=0; %%% Non-target stimulus presentation marker. This is used for presenting the non-target checkerboard with correct order WITHOUT ANY ITERATION OF THE PATTERNS (e.g. W-B-W-B-W-B-W-B)

ExperimentTrials=[0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,...         %%% 0-> non-target trials (%75: 150 trials), 1-> target trials (%25: 50 trials)
    1,0,0,1,0,1,0,0,1,0,0,0,0,0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,1,...
    0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,1,0,0,...
    0,0,1,0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,1,0,0,0,...
    1,0,0,0,0,1,0,0,1,0,1,0,0,0,0,1,0,0,1,0,0,1,0,0,0,0,1,0,0,0,0,1,0,...
    0,1,0,0,0,0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,1,...
    0,0,0,0,1,0,0,0,1,0];

start_time=GetSecs(); %%% Marks the start of the experiment. 

stim_time=start_time; %%% equals stim presentation time to exp start time for the first trial. This is required for Screen('Flip') function's [when] argument. 

sheetmarker=0; %%% Used for typing into excel files. KeyboardReg function increases its value by 1 with every new keyboard input registry. 


while 1
    tic;
    
    trialIteration=trialIteration+1;    
    
    if ExperimentTrials(trialIteration)==0
        
        nontargetIteration=nontargetIteration+1;
        
        Screen('FillRect',window, ColorMatrix(:,:,mod(nontargetIteration,2)+1),NonAllRectsCenter);
        
    else
        
        Screen('FillRect',window, ColorMatrix(:,:,1),TarallRectsCenter); %%% We are using only the first dimension of ColorMatrix because we want our fixation Oval to stay on top of a white rectangle, not a black one. 
        
    end
    
    Screen('FillOval',window, [0 1 0],CenterOval,OvalDiamater); %%% This creates a green oval at the center of the screen. This oval will be on the intersection of rectangles on non-target trials. Oval is placed on the center of a white rectangle in target trials.
        
    Screen('FillRect',window, GrayRectColors, GrayRectCenter);
    
    if trialIteration >1
        
        stim_time=stim_vbl; 
        
    else
        
        stim_time=0;
        
    end
    
    stim_vbl=Screen('Flip', window,stim_time+stimduration);    
    
    stim_vbl-stim_time %#ok<NOPTS>    
    
    [Pressed, PressedButton]=KbQueueCheck();    
    
    if Pressed == 1
        
        KeyboardReg(PressedButton,start_time,sheetmarker,stim_time,0);
        
        fprintf(outfile,'%s\t %s\t %s\t %d\t %d\t %s\t %6.3f\t \n', subid, subage,gender,ExperimentTrials(trialIteration),sheetmarker,Key_Code,ReactionTime);
        
        if KeyIndex == KbName('ESCAPE')
            
            break;
            
        end 
            
    end
    
    KbQueueFlush; 
    
    toc
    
    if trialIteration == 200
        
        break;
        
    end
    
end



% Clear the screen
sca;
