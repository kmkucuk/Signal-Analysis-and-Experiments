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
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);


% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);


% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

cd('D:\ieu_directory\scripts\experiments\gunce_tutorial\images')
stimulus1_image=imread('stimulus1', 'jpg');
stimulus1_texture=Screen('MakeTexture',window,stimulus1_image);



Screen('DrawTexture',window,stimulus1_texture);
Screen('DrawingFinished',window);

exo_vb=Screen('Flip',window);         

KbWait();

Screen('Flip',window);

WaitSecs(1);

sca;


