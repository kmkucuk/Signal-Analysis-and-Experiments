function [baseRectCenter, allRects]=createStimuli(stimulusParameters,screenParameters)

% calibrate pixels and stimulus length measures for reliable displays
% across different monitors and laboratories 
stimulusParameters               = screenCalibration(stimulusParameters,screenParameters);

[baseRectCenter, allRects]       = stimulusCoordinates(stimulusParameters,screenParameters);

