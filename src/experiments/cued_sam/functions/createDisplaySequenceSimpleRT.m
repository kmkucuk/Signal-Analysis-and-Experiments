


function [displayVectors, combinedReversalMatrix] = createDisplaySequenceSimpleRT (stim_resp_durations, FCRTT_allRepmat,white_colored)

%% Initialize stimulus presentation vectors
rndSave=rng('shuffle');

FCRT_testSequence       = FCRTT_allRepmat;
if white_colored == 2
    presentationSequence        = [1 2 3 4 5 2 7 4];
    reversalSequence            = [1 3 5 7 1 3 5 7];
elseif white_colored == 1
    presentationSequence        = [1 2 3 2];
    reversalSequence            = [1 3 1 3];
elseif white_colored == 3
    presentationSequence        = [1 2 3 2];
    reversalSequence            = [1 3 1 3];
elseif white_colored == 4
    presentationSequence        = [5 2 7 2];
    reversalSequence            = [5 7 5 7];
end
sequenceLength = length(presentationSequence);

stimulus_duration       = stim_resp_durations(1,1:sequenceLength);
press_duration          = stim_resp_durations(2,1:sequenceLength);

flowVectorTest              = repmat(presentationSequence,[1,FCRT_testSequence]); % red sequence is 1,2,3,4 and blue sequence is 5,2,7,4. This will be changed later on
                                                                               % this is used to define reversals for each
                                                                               % color/presentation order pairs.
                                                                   
                                                                               
stimulusDurationVector      = repmat(stimulus_duration,[1,FCRT_testSequence]);
cumulativeDurations         = cumsum(stimulusDurationVector)-stimulus_duration(1); % get cumulative stimulus durations for spotting endogenous reversal onsets
pressDurationVector         = repmat(press_duration,[1,FCRT_testSequence]); % reproduce press durations for the number of reversals
reversalIndex               = ones(1,FCRT_testSequence*sequenceLength); % create a vector with the same length of flow vector. This will be used for defining motion directions.

reversalVector              = repmat(reversalSequence,[1,FCRT_testSequence]); % reproduce elements that will be used for reversals. 

    
                                                                          % Divided by 8 because there are four stimuli, each has to get equal number of reversals, and reversal count has to stay the same 
combinedReversalMatrix      = [reversalVector;pressDurationVector]; % combine reversal and press duration indices 


displayVectors=[flowVectorTest; stimulusDurationVector; cumulativeDurations; reversalIndex];
