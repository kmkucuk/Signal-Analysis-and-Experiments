function [flowVector, reversalIndex, stimulusTable, wholeFlow, positionFlow] = createStimulusTable(displayVectors, stimulusTable, displayProperties, endo_exo, response_training, long_or_right_DotPosition_text)
% displayVectors = numeric vectors related to color and reversal onset information 
% stimulusTable  = cell table where stimulus-related properties are registered such as: position, duration, color, percept duration (seconds of stable
% percept) 
% displayProperties = cell variable with stimulus properties written in text explanations
% endo_exo = logical variable indicating whether the trial is an endogenous or exogenous task
% response_training = whether the trial involves response training with feedback etc. 
% long_or_right_DotPosition_text = string variable involving the names of dot positions that require either long press or RIGHT-press (no color response required)


stimTypes           = displayProperties{1};
movementDirections  = displayProperties{2};
presentationOrder   = displayProperties{3};
presentationColors  = displayProperties{4};
stimulus_duration   = displayProperties{5};

flowVector          = displayVectors(1,:);
reversalIndex       = displayVectors(2,:);
cumulativeDurations = displayVectors(3,:);

% Format stimulus presentation vectors for loops
wholeFlow                   = flowVector;
flowVector(flowVector==5)   = 1; % discard color information, replace them with up/down or left/right 
flowVector(flowVector==7)   = 3; 

% switch to ambiguous or exogenous presentation of motion 
% according to the condition marker. reversalIndex will be used for
% changing rows of AllRects variable during stimulus presentation
if endo_exo==2
    reversalIndex(:)=1; % SAM: ambiguous reversal of motion direction
else
    % Control/Exogenous: exogenous (computer controlled) reversal of motion
    % direction 
    reversalIndex(reversalIndex==1)     =2; % place 2 and 3 for switching between vertical and horizontal motions 
    reversalIndex(reversalIndex==-1)    =3; % 2 = vertical, 3 = horizontal motion rows in AllRects variable. 
end

%% Register stimulus properties into stimulusTable variable
coloriteration=0;
trialLength = length(stimulusTable);
positionFlow = nan(1,trialLength);
halfTrial = floor(trialLength/2);
lastShiftDuration = 0;
shiftEnabled = 1;

for k = 1:length(stimulusTable)
    coloriteration=coloriteration+1;
      
        if coloriteration==9
            coloriteration=1;
        end

    if ~response_training % change CP pairs when it is past the middle of presentation duration if it is not a response training trial 
        checkShiftRequired = k >= halfTrial;
        if checkShiftRequired && shiftEnabled
            checkNoReversalsAround = sum(diff(reversalIndex(k-4:k+4)))==0;   % if there are no reversals 1 second before and after the current stimulus, change pairs.
            if checkNoReversalsAround
                shiftEnabled = 0;
                stimTypes([1 2 3 7 8 9])=stimTypes([7 8 9 1 2 3]);
            end
        end
    elseif response_training && (k < trialLength - 5) && (k > 6) % change CP pairs periodically for response training trial 
                                 % do not attempt to change if there are less than five stim presentations remain, because it will cause an error
        presentationDuration = cumulativeDurations(k);
        checkShiftRequired = presentationDuration-lastShiftDuration>=150; % if there has been at least 150 seconds since the last CP shift
        checkNoReversalsAround = sum(diff(reversalIndex(k-4:k+4)))==0; % if there are no reversals 1 second before and after the current stimulus, change pairs.        
        if checkShiftRequired && checkNoReversalsAround % change CP pairs at every 90th second 
            lastShiftDuration=presentationDuration;
            stimTypes([1 2 3 7 8 9])=stimTypes([7 8 9 1 2 3]);
        end
    end
    stimulusTable{k,1}  = stimTypes{reversalIndex(k),flowVector(k)}; % stim types
    stimulusTable{k,2}  = movementDirections{reversalIndex(k)}; % which movement direction is observed
    stimulusTable{k,3}  = [presentationColors{coloriteration},'_',presentationOrder{flowVector(k)}]; % first or second presentation of a given color
    stimulusTable{k,4}  = stimulus_duration(flowVector(k)); % stimulus durations
        %% CREATE COLOR + POSITION FLOW VECTOR
        isLongPress        = ~isempty(regexp(long_or_right_DotPosition_text,stimulusTable{k,1}));
        isRed               = ~isempty(regexp(presentationColors{coloriteration},'red'));
        isBlue               = ~isempty(regexp(presentationColors{coloriteration},'blue'));
        isFixation          = ~isempty(regexp(stimulusTable{k,1},'fixation'));
        positionFlow(k)     = 1 + (isLongPress*2);
        if isRed
            positionFlow(k)     = 1 + (isLongPress*2);
        elseif isBlue
            positionFlow(k)     = 5 + (isLongPress*2);
        elseif isFixation
            positionFlow(k)     = 2;
        end
end


