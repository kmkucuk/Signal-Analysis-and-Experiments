
echo off

clear;

sca;

% Setup defaults and unit color range:
PsychDefaultSetup(2);

% Disable synctests for this quick demo:
oldSyncLevel = Screen('Preference', 'SkipSyncTests', 2);

% Select screen with maximum id for output window:
screenid = max(Screen('Screens'));


baseColor = [.5 .5 .5 1];
[window, winRect] = PsychImaging('OpenWindow', screenid, baseColor); % ,[0 0 200 200]
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
% Query frame duration: We use it later on to time 'Flips' properly for an animation with constant framerate:
ifi = Screen('GetFlipInterval', window);


% Physical Distance/Length parameters

monitor_distance = 140; % participants are 140 cm away from monitor
horizontal_moni_length = 44.3; % horizontal length of monitor is 44.3 cm
pixPerCm = screenXpixels / horizontal_moni_length;
degreePerCm =2*atand((1/2)/monitor_distance);  % how much degrees in 1 cm
unitDegreePerCm = 1/degreePerCm;
unitDegreePerPixel = pixPerCm * unitDegreePerCm;


stimSizeInDegree = 8; % 8 cm corresponds to 4° visual angle at 140 cm viewing distance
stimSizeInCm = stimSizeInDegree*unitDegreePerCm; % stim will be 4 degree in size
stimSizeInPix = stimSizeInCm*pixPerCm;

pc_to_head_cm = 140;

% parameters to play with
tiltInDegrees = 0;

% Some notes:
% 1) To obtain identical size of circle grating stim across different cycle sizes:
%       • Multiply the standard deviation by the inverse of the ratio
%       you increase the grating pixels (x2 size means, std*1/2)
%               e.g. first grating (small): [pixels = 200, std = 1] 
%                    second gration (large): [pixels = 400, std = .5];
% 2) You cannot enter "widthOfGrid" values larger than the minimum pixels of your screen, otherwise it will not show
basePixelsPerPeriod = 200; 
baseCycleStd = .75;




pixelsPerPeriod = 400; % How many pixels will each period/cycle occupy?
periodsCoveredByOneStandardDeviation = 1; % the number of periods/cycles covered by one standard deviation of the radius of
                                            % the gaussian mask.
                                            
                                            
gratingPixels = 400; % pixels used for each cycle
pixelRatio = gratingPixels / basePixelsPerPeriod; 
gratingCycleStd = 1;%^baseCycleStd * (1/pixelRatio);



widthOfGrid = stimSizeInPix;

% secondary parameters from the inital ones 
tiltInRadians = tiltInDegrees * pi / 180; % The tilt of the grating in radians.

cyclePerDegree = 1;
% pixPerCycle = 
spatialFrequency = 1 / gratingPixels; % How many periods/cycles are there in a pixel?
radiansPerPixel = spatialFrequency * (2 * pi); % = (periods per pixel) * (2 pi radians per period)


gaussianSpaceConstant = gratingCycleStd  * gratingPixels;

% *** If the grating is clipped on the sides, increase widthOfGrid.
halfWidthOfGrid = widthOfGrid / 2;
widthArray = (-halfWidthOfGrid) : halfWidthOfGrid;  % widthArray is used in creating the meshgrid.  

% ---------- Color Setup ----------
% Gets color values.

% Retrieves color codes for black and white and gray.
black = BlackIndex(window);  % Retrieves the CLUT color code for black.
white = WhiteIndex(window);  % Retrieves the CLUT color code for white.
backgroundColor = (black + white) / 2;  % Computes the CLUT color code for gray.
if round(backgroundColor)==white
    backgroundColor=backgroundColor;
end

% Taking the absolute value of the difference between white and gray will
% help keep the grating consistent regardless of whether the CLUT color
% code for white is less or greater than the CLUT color code for black.
absoluteDifferenceBetweenWhiteAndGray = abs(white - backgroundColor);

% ---------- Image Setup ----------
% Stores the image in a two dimensional matrix.

% Creates a two-dimensional square grid.  For each element i = i(x0, y0) of
% the grid, x = x(x0, y0) corresponds to the x-coordinate of element "i"
% and y = y(x0, y0) corresponds to the y-coordinate of element "i"
[x y] = meshgrid(widthArray, widthArray);

% Replaced original method of changing the orientation of the grating
% (gradient = y - tan(tiltInRadians) .* x) with sine and cosine (adapted from DriftDemo). 
% Use of tangent was breakable because it is undefined for theta near pi/2 and the period
% of the grating changed with change in theta.  

a=cos(tiltInRadians)*radiansPerPixel;
b=sin(tiltInRadians)*radiansPerPixel;

% Converts meshgrid into a sinusoidal grating, where elements
% along a line with angle theta have the same value and where the
% period of the sinusoid is equal to "pixelsPerPeriod" pixels.
% Note that each entry of gratingMatrix varies between minus one and
% one; -1 <= gratingMatrix(x0, y0)  <= 1
gratingMatrix = sin(a*x+b*y);

% Creates a circular Gaussian mask centered at the origin, where the number
% of pixels covered by one standard deviation of the radius is
% approximately equal to "gaussianSpaceConstant."
% For more information on circular and elliptical Gaussian distributions, please see
% http://mathworld.wolfram.com/GaussianFunction.html
% Note that since each entry of circularGaussianMaskMatrix is "e"
% raised to a negative exponent, each entry of
% circularGaussianMaskMatrix is one over "e" raised to a positive
% exponent, which is always between zero and one;
% 0 < circularGaussianMaskMatrix(x0, y0) <= 1
circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2));

% Since each entry of gratingMatrix varies between minus one and one and each entry of
% circularGaussianMaskMatrix vary between zero and one, each entry of
% imageMatrix varies between minus one and one.
% -1 <= imageMatrix(x0, y0) <= 1
imageMatrix = gratingMatrix .* circularGaussianMaskMatrix;

% Since each entry of imageMatrix is a fraction between minus one and
% one, multiplying imageMatrix by absoluteDifferenceBetweenWhiteAndGray
% and adding the gray CLUT color code baseline
% converts each entry of imageMatrix into a shade of gray:
% if an entry of "m" is minus one, then the corresponding pixel is black;
% if an entry of "m" is zero, then the corresponding pixel is gray;
% if an entry of "m" is one, then the corresponding pixel is white.
grayscaleImageMatrix = backgroundColor + absoluteDifferenceBetweenWhiteAndGray * imageMatrix;

% ---------- Image Display ---------- 
% Displays the image in the window.

% Colors the entire window gray.
Screen('FillRect', window, backgroundColor);

% Writes the image to the window.  
Screen('PutImage', window, grayscaleImageMatrix);

% Writes text to the window.
currentTextRow = 0;
Screen('DrawText', window, sprintf('black = %d, white = %d', black, white), 0, currentTextRow, black);
currentTextRow = currentTextRow + 20;
Screen('DrawText', window, 'Press any key to exit.', 0, currentTextRow, black);

% Updates the screen to reflect our changes to the window.
Screen('Flip', window);

KbWait;


sca;
