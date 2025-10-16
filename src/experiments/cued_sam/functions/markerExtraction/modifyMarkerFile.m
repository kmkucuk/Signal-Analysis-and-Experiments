cd('D:\MatlabDirectory\MertKucuk\Cued_SAM\Cued_SAM\behavioralData\subpilotcheck3_B_firstShort\block_3')
estimatedMarkers=readtable('pilotcheck3_block3ESTIMATED.txt');
estimatedMarkers=table2cell(estimatedMarkers);
stimNames = estimatedMarkers(2:end,1); % we start from two because the first row is column name headers
estimatedTimePoints = estimatedMarkers(2:end,10);  % we start from two because the first row is column name headers

cd('D:\BrainVision Analyzer 2.2\export\CuedSAM\pilotcheck3')
visionMarkers=importdata('pilotcheck3_extract_endogenous.Markers');


for k = 1: length(estimatedTimePoints)
    estimatedPoint = estimatedTimePoints{k};
    currentStim = stimNames{k}; 
    
    if ~isempty(estimatedPoint) % if there is an estimated onset time point
        %% Adjust the name of estimated onset marker 
        if ~isempty(regexp(currentStim,'red', 'once'))
            estimatedMarker = 55; % red_first onset = S55
        elseif ~isempty(regexp(currentStim,'blue', 'once'))
            estimatedMarker = 57; % blue_first onset = S57
        end
        
        if ~isempty(regexp(currentStim,'second', 'once'))
            estimatedMarker = estimatedMarker +1; % add +1 to marker no if it is '#_second' color. 
        end
        
        
        %% Search for match between Brainvision Stimulus Onset and Estimated Onset Time Points
        for i = 1:length(visionMarkers)
            markerElements = split(visionMarkers{i});
            markerPoint = str2double(erase(markerElements{4},','));
            matchOrNot = abs(estimatedPoint - markerPoint) <= 2; % subtract marker point from estimated point, it is a match if discrepancy is less than 2 time points. 
            if matchOrNot
                visionMarkers{i}(13:14)=num2str(estimatedMarker); % change stimulus marker to 16 for estimated onsets
            end
        end
        
    end

end
