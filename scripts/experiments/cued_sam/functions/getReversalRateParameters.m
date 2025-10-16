function jitterParameters = getReversalRateParameters(stim_resp_durations,reversalRate)

stimulus_duration=stim_resp_durations(1,:);

% get how many seconds required for one reversal on average
reversalPeriod          = 60/reversalRate;

% get the duration of one double-dot sequence
sequenceDuration        = sum(stimulus_duration(1:4));

% get how many sequences are required for one reversal to occur
seq_Count_Per_Reversal  = round(reversalPeriod/sequenceDuration);

% get how many stimuli presentations are required for one reversal to occur
stim_Count_Per_Reversal = seq_Count_Per_Reversal*4;

% define jitter in seconds
jitterSeconds=3;

% get how many stimuli are required for jitter duration
jitterStimulusCount     = round(4*jitterSeconds/sequenceDuration);


% define first jitter
jitterParameters        = [stim_Count_Per_Reversal, jitterStimulusCount];

end


