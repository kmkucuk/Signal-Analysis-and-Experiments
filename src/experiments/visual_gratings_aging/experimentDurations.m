%% aging sensory experiment durations %%

% contrast detection task %

% Block interval = 5 sec * 6 block * 2 freqs = 60 s
% Stim duration = (.5 sec blank + .5 sec cue + .5 sec stim + 1.5 sec resp) * 6 (trials) * 6 (blocks) * 2 (frequencies) = 216 sec
% Total duration = 60 + 216 = 276 sec = 4.6 minutes
% 1.5 sec response time was liberal, it'll probably be about 1 second
% overall. So 4 to 5 minutes is total duration for this.

% 2-5 min break (inter task interval)

% sensory stimulation task %

% 2 spatial freqs (1 & 4 cpd), 2 contrasts, 2 orientations, 40 repeats
% stim duration: 500 ms /// ISI: 1 to 2 secs
sensoryTaskDuration = determineExperimentLength(.5,1.5,8,40);

% duration: 9.67 minutes (2 blocks, 2 to 5 min break)


% 2-5 min break (inter task interval)

% two alternative forced choice task %

% 1 spatial freq (4 cpd), 2 contrasts, 2 orientations, 40 repeats
% stim duration: 500 ms /// ISI: 1 to 2 secs
afcDuration = determineExperimentLength(.5,1.5,4,40);

% duration: 4.33 minutes 


% total durations
sessionBreak = 5; 
sensoryBreak = 5;

allTaskDurations = 5 + sensoryTaskDuration + afcDuration; 

maxWholeDuration = allTaskDurations + (sessionBreak*2) + sensoryBreak;

sessionBreak = 2; 
sensoryBreak = 2;

minWholeDuration = allTaskDurations + (sessionBreak*2) + sensoryBreak;

fprintf('\n\nTask Durations: %.2f minutes\n\nMin-Max Total Duration: %.2f-%.2f minutes\n\nMin-Max durations vary based on breaks (2-5 mins)\n\n', allTaskDurations, minWholeDuration,maxWholeDuration)
