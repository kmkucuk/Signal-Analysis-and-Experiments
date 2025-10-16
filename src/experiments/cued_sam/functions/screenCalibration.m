% This function calibrates the pixels in terms of centimeters for robust
% stimulus presentation across labs and display monitors. It requires you
% to measure your screen with a ruler and enter the centimeters into this
% function.
%
% Parameters
% enter the desired size of the stimuli into 'stimulusParameters' using cms
%
%   stimulusParameters = [11.2, 8.9, 0.4] (Standard Size: achieves the optimal 7 to 1 ratio for SAM)
%           Parameters above mean that:
%                   ? Height of black SAM rectangle is 11.2 cm
%                   ? Width of black SAM rectangle is 8.9 cm
%                   ? Length of each side of small white dots is 0.4 cm
%
% enter the horizontal centimeter length and horizontal pixel count of your
% display monitor into 'screenParameters'
%
%   screenParameters = [34.5, 1080; xCenter, yCenter] 
%           Parameters above mean that:
%                   ? Horizontal length of your screen is 34.5 centimeters
%                   ? Horizontal pixel count of your screen is 1080 pixels
%                   ? xCenter and yCenter define the pixels that center
%                   your screen. These are not used in this function. 


function stimulusParameters=screenCalibration(stimulusParameters,screenParameters)

% Get a ruler and measure the horizontal length of your screen. Divide that
% by horizontal pixels which is shown in your screen resolution. 
%
% IMPORTANT: This value is also stored in "screenXpixels" variable 
%
% e.g. 1920x1080 means that your horizontal pixel count is 1920
% e.g. 1024x768 means that your horizontal pixel count is 1024.
% Divide this pixel count by the length of your screen. And define it in
% the 'calibration_factor' variable.
%
% measure the horizontal distance of your screen (hor_cm). Then divide horizontal pixels to this cm. 
% e.g.   hor_cm = 34.5, pixels=1920x1080.
% Horizontal pixels is the one before the 'x', so:
% 1920/34.5 = 55.65 (laptop monitor)
% 1680/47.3 = 35.5179 (2nd lenovo screen at home)
%
% You can also use:
% screenXpixels / 47.3 etc.
horizontal_cm_length        = screenParameters(1,1);
horizontal_pixelCount       = screenParameters(1,2);
calibration_factor          = horizontal_pixelCount / horizontal_cm_length;


% Calibration of stimulus size and screen size (requires manual measurement of the display screen)
stimulusParameters=stimulusParameters*calibration_factor;