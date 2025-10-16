


function [displayVectors, combinedReversalMatrix] = createDisplaySequence (stim_resp_durations, reversalRate, trialDuration,reversal_type)

%% Initialize stimulus presentation vectors
rndSave=rng('shuffle');
stimulus_duration       = stim_resp_durations(1,:);
press_duration          = stim_resp_durations(2,:);
sequenceDuration        = sum(stimulus_duration);
trialMinutes            = trialDuration/60;
requiredSequenceCount   = ceil(trialDuration/sequenceDuration);
flowVector              = repmat([1 2 3 4 5 2 7 4],[1,requiredSequenceCount]); % red sequence is 1,2,3,4 and blue sequence is 5,2,7,4. This will be changed later on
                                                                               % this is used to define reversals for each
                                                                               % color/presentation order pairs.
                                                                               
stimulusDurationVector      = repmat(stimulus_duration,[1,requiredSequenceCount]);
cumulativeDurations         = cumsum(stimulusDurationVector)-stimulus_duration(1); % get cumulative stimulus durations for spotting endogenous reversal onsets
pressDurationVector         = repmat(press_duration,[1,ceil(trialMinutes*reversalRate/8)]); % reproduce press durations for the number of reversals
reversalIndex               = ones(1,requiredSequenceCount*8); % create a vector with the same length of flow vector. This will be used for defining motion directions.
if reversal_type == 1
    reversalVector              = repmat([1 3 5 7 1 3 5 7],[1,ceil(trialMinutes*reversalRate/8)]); % all stimuli (red/blue + top/down dots) will be used for reversals. 
elseif reversal_type == 2
    reversalVector              = repmat([1 3 1 3 1 3 1 3],[1,ceil(trialMinutes*reversalRate/8)]); % only red stimuli will be used for reversals
elseif reversal_type == 3
    reversalVector              = repmat([5 7 5 7 5 7 5 7],[1,ceil(trialMinutes*reversalRate/8)]); % only blue stimuli will be used for reversals 
end
                                                                          % Divided by 8 because there are four stimuli, each has to get equal number of reversals, and reversal count has to stay the same 
combinedReversalMatrix      = [reversalVector;pressDurationVector]; % combine reversal and press duration indices 
permIndices                 = randperm(length(pressDurationVector)); % randomize combined indices above 
combinedReversalMatrix      = combinedReversalMatrix(:,permIndices); % select the randomized order 


displayVectors=[flowVector; stimulusDurationVector; cumulativeDurations; reversalIndex];
