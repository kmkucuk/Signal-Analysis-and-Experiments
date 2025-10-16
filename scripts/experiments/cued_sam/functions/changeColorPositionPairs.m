trialLength = length(stimulusTable);
halfTrial = floor(trialLength/2);

if firstCPPair == 1 % change color-position pairs (CPPair) at the beginning for second color-position counterbalance condition
    if global_iteration == 1
        presentationRects([1 2 3 7 8 9])=presentationRects([7 8 9 1 2 3]);
    end
end

    if ~response_training
        %% regular trials with no training
        checkShiftRequired = global_iteration >= halfTrial;
        if checkShiftRequired && shiftEnabled
            checkNoReversalsAround = sum(diff(reversalIndex(global_iteration-4:global_iteration+4)))==0;   % if there are no reversals 1 second before and after the current stimulus, change pairs.
            checkIfSimpleRT = presentation_durations == 1; % checks for simple RT task, because simple RT task does not require for controlling 'checkNoReversalsAround' because there are no reversals. 
            if  (checkNoReversalsAround || checkIfSimpleRT) % change color-position pairs (CPPair) at half at first color-position counterbalance condition
                shiftEnabled = 0; % stop shifting CP pairs if it was done once in a trial. This variable resets to '1' at the beginning of each trial. 
                presentationRects([1 2 3 7 8 9])=presentationRects([7 8 9 1 2 3]);
                Screen('TextSize',window,50)
                DrawFormattedText2(['Deney 15 saniye sonra devam edecek'],'win',window, 'sx',xCenter,'sy', yCenter,'xalign','center','yalign','center','xlayout','center','baseColor',[0 0 0]);
                Screen('Flip',window);
                WaitSecs(15);
                Screen('Flip',window);
             
                WaitSecs(1);
            end
        end
    else
        %% response training requires additional effort for the shift of
        % color-position pairs because it does not have a fixed time
        % window. So we cannot just make it half. For now lets make it
        % change at every 90 seconds.
        % initiate the preparation of this shift after some time to prevent errors (e.g. undefined variable etc.)
        if global_iteration > 20 && (global_iteration < trialLength - 5)  % do not attempt to change if there are less than four stim presentations, because it will cause an error
            presentationDuration = cumulativeDurations(global_iteration);
            checkShiftRequired = presentationDuration-lastShiftDuration>=150; % if there has been at least 150 seconds since the last CP shift
            checkNoReversalsAround = sum(diff(reversalIndex(global_iteration-4:global_iteration+4)))==0; % if there are no reversals 1 second before and after the current stimulus, change pairs.
            if checkShiftRequired && checkNoReversalsAround
                lastShiftDuration=presentationDuration;
                presentationRects([1 2 3 7 8 9])=presentationRects([7 8 9 1 2 3]);
                DrawFormattedText2(['Deney 15 saniye sonra devam edecek'],'win',window, 'sx',xCenter,'sy', yCenter,'xalign','center','yalign','center','xlayout','center','baseColor',[0 0 0]);
                Screen('Flip',window);

                WaitSecs(15);
                Screen('Flip',window);

                WaitSecs(1);
            end

        end
    end