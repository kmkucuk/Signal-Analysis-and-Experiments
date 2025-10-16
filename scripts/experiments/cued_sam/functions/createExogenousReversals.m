


function [displayVectors, stimulusTable] = createExogenousReversals(displayVectors, combinedReversalMatrix, jitterParameters, presentation_durations)

% get how many stimuli are required for jitter duration
stim_Count_Per_Reversal     = jitterParameters(1); 
% get how many stimuli presentations are required for one reversal to occur
jitterSequenceCount         = jitterParameters(2); 

flowVector = displayVectors(1,:);
stimulusDurationVector = displayVectors(2,:);
reversalIndex = displayVectors(4,:);
%% Initialize definition of randomized reversals in exogenous condition
searchConstant      = 1; % loop marker for search
searchIteration     = 1; % marker for iteration progress 
mov_direction       = reversalIndex(1); % =1. Just to define initial movement, this will change later
stimulusTable       = cell(length(flowVector),7); % Stimulus registeries 
isExogenous         = isempty(find(reversalIndex,1)); % 0 if it is not exogenous, 1 if the trial is exogenous. Because reversalIndex is always 1 for endogenous so there will be 1s and it will not be empty.
for i = 1:length(flowVector)
    
  
    
    if presentation_durations == 1
       jitter = 2; 
    else
        jitter = randi([stim_Count_Per_Reversal-jitterSequenceCount stim_Count_Per_Reversal+jitterSequenceCount]); % randomly select a jitter as in # of stimulus 
    end
    if i > searchConstant + jitter  % add jitter (# of stimulus) onto previous match
        
        if searchIteration>length(combinedReversalMatrix) && flowVector(i)==1 % if all reversal points are defined 
            % delete redundant elements in flow matrices used for stimulus
            % presentation
            stimulusTable(i:end,:)      = [];
            flowVector(i:end)           = [];
            reversalIndex(i:end)        = [];
            break            
        elseif searchIteration<=length(combinedReversalMatrix) % if there are still reversals to be defined           
            
            matchOrNot=flowVector(i)==combinedReversalMatrix(1,searchIteration); % check if reversal and presentation stimuli are matching
            
            if matchOrNot % if there is a match
                if isExogenous % register the exogenous reversal text identifier if it is an exogenous trial 
                    stimulusTable{i,5}      = 'exogenous_reversal'; % register this as the onset of reversal 
                end
                stimulusTable{i,6}      = sum(stimulusDurationVector(searchConstant:i-1)); % sum durations starting from the previous reversal to the new one. 
                searchConstant          = i; % mark the mathcing index for adding jitter later
                searchIteration         = searchIteration+1;
                mov_direction           = mov_direction*-1; % change the movement direction by multiplying it with -1. This creates (1,1,1,1,1,-1,-1,-1,-1) where positive and negatives represent different directions
                
                
            end
            
        end
    end
reversalIndex(i)=mov_direction; % register movement direction 
end
cumulativeDurations = displayVectors(3,:); 
displayVectors=[flowVector; reversalIndex ; cumulativeDurations];
