% parameters = a struct variable with stimulus parameters. 
%               more than one row will create multiple visual gratings
%               in the output. 

function createGrating(stimparameters,screen_x_pixels)

cyclePerDegree = grating_parameters.cyclePerDegree; 

monitor_distance = grating_parameters.monitorDistance; % participants are 140 cm away from monitor

horizontal_moni_length = grating_parameters.monitorHorizontalDistance; % horizontal length of monitor is 44.3 cm

stimSizeInDegree = grating_parameters.stimulusSizeDegrees; % 8 cm corresponds to 4° visual angle at 140 cm viewing distance

angle = grating_parameters.angle;

maskInDegrees = grating_parameters.gaussianMask;

%% estimate: visual angle and required pixels for size in degrees 
pixPerCm = screen_x_pixels / horizontal_moni_length;
degreePerCm =2*atand((1/2)/monitor_distance);  % how much degrees in 1 cm
unitDegreePerCm = 1/degreePerCm; 

unitDegreePerPixel =  unitDegreePerCm * pixPerCm;


stimSizeInCm = stimSizeInDegree*unitDegreePerCm; % stim will be 4 degree in size
stimSizeInPix = ceil(stimSizeInCm*pixPerCm);



angleRadians = angle * pi / 180; 


widthOfGrid = stimSizeInPix;

% cyclePerDegree = 1;
pixelCountForCycles = cyclePerDegree / unitDegreePerPixel;



spatialFrequency = pixelCountForCycles ; % How many periods/cycles are there in a pixel?
radiansPerPixel = spatialFrequency * (2 * pi); % (periods per pixel) * (2 pi radians per period)

gaussianSpaceConstant =  ceil(maskInDegrees * unitDegreePerPixel); 

% *** If the grating is clipped on the sides, increase widthOfGrid.
halfWidthOfGrid = widthOfGrid / 2;
% halfWidth_screenX = floor(screenXpixels /2)-1 ;
widthArray = (-halfWidthOfGrid) : halfWidthOfGrid;  % widthArray is used in creating the meshgrid.  
% x_widthArray = (-halfWidth_screenX):halfWidth_screenX;

%% color setup
% Retrieves color codes for black and white and gray.
% Retrieves color codes for black and white and gray.
black = BlackIndex(window);  % Retrieves the CLUT color code for black.
white = WhiteIndex(window);  % Retrieves the CLUT color code for white.
backgroundColor = (black + white) / 2;  % Computes the CLUT color code for gray.
% if round(backgroundColor)==white
%     backgroundColor=backgroundColor;
% end
absoluteDifferenceBetweenWhiteAndGray = abs(white - backgroundColor);


[x, y] = meshgrid(widthArray, widthArray);


a=cos(angleRadians)*radiansPerPixel;
b=sin(angleRadians)*radiansPerPixel;

gratingMatrix = sin(a*x+b*y);

circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2));

imageMatrix = gratingMatrix .* circularGaussianMaskMatrix;

grayscaleImageMatrix = backgroundColor + absoluteDifferenceBetweenWhiteAndGray * imageMatrix;



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
end
