releasePortByte        = io64(ioObj,portAddress(2));   % second port address is response input
checkRelease           = releasePortByte == noPressByte;  % 1 = released the press, 0 = still pressing                                        
if checkRelease && checkReleasePending(pressTime,long_press) && registeredKeys ==1 
    %% if there is a release and release is still pending
    releaseTime                     = GetSecs();% get the release time 
    releaseDuration                 = releaseTime-pressTime; % calculate release duration 
    checkLowerBound                 = releaseDuration>long_lower_limit; % check if the lower release threshold direction is reached for longer presses
    registeredKeys                  = 2; % switch to keyboard registery mode 
    % exogenous response conditions (stimulus
    % based estimation of release duration etc.)
    % stim onsets are known and used before the
    % responses. 
    if (exo_endo == 1 || simple_stroboscopic ==1) && checkCorrectError
        if exo_endo == 1
            reactionTime = pressTime-reversalTime; % get the reaction time for exogenous stroboscopic
        elseif simple_stroboscopic ==1
            reactionTime_simple = pressTime-simpleOnsetTime; % get the reaction time for simple RT 
        end
        if checkLongerDuration && checkLowerBound % if release is supposed to be longer and met the lower duration threshold 
            responseText='Correct'; 
            feedbackText = 'DOGRU YANIT';
            feedbackColor = [0 0 255];
            feedbackAvailable = 1;
            % SEND PORT SIGNAL %
            if training_test == 3 || simple_stroboscopic ==1
                sendParallelSignal(portAddress,15,ioObj) % S15 = correct answer port signal
                WaitSecs(.005);
                endParallelSignal(portAddress,ioObj)
            end
            %%%%%%%%%%%%%%%%%%%%
        elseif ~checkLongerDuration && ~checkLowerBound  % if release is shorter and release duration is below 200 ms                                   
            responseText='Correct';
            feedbackText = 'DOGRU YANIT';
            feedbackColor = [0 0 255];
            feedbackAvailable = 1;  
            % SEND PORT SIGNAL %
            if training_test == 3 || simple_stroboscopic ==1
                sendParallelSignal(portAddress,15,ioObj) % S15 = correct answer port signal
                WaitSecs(.005);
                endParallelSignal(portAddress,ioObj)
            end
            %%%%%%%%%%%%%%%%%%%%
        elseif checkLongerDuration && ~checkLowerBound % if release shouldve longer but was below 200 ms
            responseText='Short_Timing'; 
            feedbackText = 'KISA BASTINIZ';
            feedbackColor = [255 0 0];
            feedbackAvailable = 1;
        elseif ~checkLongerDuration && checkLowerBound
            responseText='Long_Timing'; 
            feedbackText = 'UZUN BASTINIZ';
            feedbackColor = [255 0 0];
            feedbackAvailable = 1;                                                    
        end
    elseif (exo_endo == 1 || simple_stroboscopic ==1) && ~checkCorrectError
        reactionTime=[];
        reactionTime_simple = [];
        responseText='Wrong_Key';
        feedbackText = 'YANLIS TUS';
        feedbackColor = [255 0 0];
        feedbackAvailable = 1;                                                  
    end


    % (1) estimate reversal onsets 
    % (0) don't estimate onsets    
    estimateReversalOnset=enableOnsetEstimation;


    % no onset response conditions. release
    % durations are calculated by responses and
    % then these were used to mark the related
    % stimuli markers. This is done for
    % exogenous reversals as well. Because that
    % will be then used for checking the
    % validity of estimation.
    no_onset_ShortRelease = releaseDuration <=short_press; % get short release based on responses
    no_onset_LongRelease  = checkLowerBound && releaseDuration <= long_press; % get long release based on responses 
        if no_onset_LongRelease % if release duration is 750 ms> x >200 ms (1 and 5th stimulus markers in wholeFlow vector)
            currentStim         = stimulusMarkers(2);
            % Get the index of irrelevant stimulus markers. 
            unrelatedOnsets     = find(wholeFlow~=currentStim); % stimulusMarkers(2) select stimuli other than 3rd or 7th stims with 750 ms release duration. 
                                                               % Then delete these indices to get desired stimulus onsets.
            noOnsetresponseText ='Correct';
            keyName             = [keyName '_long'];
        elseif no_onset_ShortRelease % if release duration is x<200 ms (1 and 5th stimulus markers in wholeFlow vector)
            currentStim         = stimulusMarkers(1);
             % Get the index of irrelevant stimulus markers. 
            unrelatedOnsets     = find(wholeFlow~=currentStim); % stimulusMarkers(1) select stimuli other than 1st or 5th stims with 200 ms release duration. 
                                                               % Then delete these indices to get desired stimulus onsets.
            noOnsetresponseText = 'Correct';
        else
            estimateReversalOnset=0; % don't estimate or register stim onset of reversals in wrong timing trials
            noOnsetresponseText ='Wrong_timing';                                   
        end

        if estimateReversalOnset==1 % estimate onsets on correct timing trials
            specificOnsets                      = stimOnsetRegistery-first_vb;
%                                                     specificOnsets                      = cumulativeDurations; % create a temporary variable  with cumulative onsets
            specificOnsets(unrelatedOnsets)     = NaN; %#ok<*SAGROW> % replace irrelevant stimulus markers with NaN. Relevance is defined by the response
             % stimulus durations were subtracted from cumulative durations because the durations
             % are cumulative. Normally these cumulative durations start at the end of the stimulus
             % presentations, subtraction results in correct onset times                                     
%                                                     specificOnsets                      = specificOnsets-stimulus_duration(1);
            indx1                               = findIndices(specificOnsets,stimInterval); % get stimulus markers within the stimulus interval (RT-2.3 RT-.3 secs)                                   
            interval                            = indx1(1):indx1(2); % create an array of indices
            indx2                               = find(wholeFlow(interval)==currentStim)+interval(1)-1; % Get the indices of possible stimulus onsets 
            referencePoint                      = relativePress - expectedRT; % calculate the reference point to get the closest stimulus onsets to this
            % :) now we have it.
            deleteIndex=[];
            registeredOnsets=[];
                for checkOnsets = indx2
                      % Check if estimated onsets exceed the [response - .25 to 2.5] sec threshold 
                      if exo_endo == 2
                          lowThreshold = .1;
                      else
                          lowThreshold = .25;
                      end
                      highThreshold = 2.5;
                        if relativePress-specificOnsets(checkOnsets)>lowThreshold && relativePress-specificOnsets(checkOnsets)<highThreshold
                            registeredOnsets=[registeredOnsets checkOnsets];                                                    %#ok<*AGROW>
                        end                                   
                end

                if ~isempty(registeredOnsets)
                    onsetIndex                          = registeredOnsets(findIndices(specificOnsets(registeredOnsets),referencePoint)); % find the index of the closest stimulus onset 
                    % -1 because durations are cumulative
                    % and onsets correspond to index before
                    % the actual one 
                    screenStimOnset                    = stimOnsetRegistery(onsetIndex); % get the exact display time of estimated stimulus onset                                                     
                    estimated_RT                       = pressTime - screenStimOnset; % calculated estimated RT                                                            
                    if  isnan(estimated_RT) || isnan(screenStimOnset)     
                        [~, latestDisplay] = max(stimOnsetRegistery);
                        ['latest display: ', num2str(latestDisplay)]
                        ['onset index: ', num2str(onsetIndex)]
                        ['global index: ', num2str(global_iteration)] % display onset indices if there is an error of estimation
                        noOnsetresponseText = 'Invalid_Estimation' 
                        estimateReversalOnset    = 0;                                                  
                    end
                    responseIteration                  = responseIteration+1; % continue with endogenous response registery loop
                    unrelatedOnsets                    = []; % refresh variable 
                else
                    noOnsetresponseText = 'Invalid_Estimation' 
                    estimateReversalOnset=0;
                end
        end                                    
end