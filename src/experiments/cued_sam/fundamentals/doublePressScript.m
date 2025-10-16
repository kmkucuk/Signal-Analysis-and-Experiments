    while 1        
        if (GetSecs()-vb)>=stimulus_duration(flowIteration)
            toc;
            break
        end
     [Pressed, PressedButtons]=KbQueueCheck();
         if Pressed && ~isempty(registeredKeys) && registeredKeys <2 % if (i) there is a press, (ii) not the first trial, (iii) not in the keyboard registery or locking stage
             %% Extract time and keyboard key information from the responses 
             responseText='Omission_SecondPress';
             PressedButtons(PressedButtons==0)=NaN; 
             KeyPressTime_V=PressedButtons-trialStart; % used for calculating dominance duration by response intervals
             KeyPressTime=KeyPressTime_V(KeyPressTime_V>0.05); % excludes durations below 50 ms
             [endtime, keyIndex]=min(PressedButtons);
             
             % logical statement of whether or not participant pressed correct response buttons.
             checkValidKeys=(keyIndex==red_key || keyIndex==blue_key); 
             % logical statement of correct or error responses: 1= correct press, 0=incorrect press
             checkCorrectError=(~isempty(regexp(stimProperties{2},'red')) && red_key==keyIndex) || (~isempty(regexp(stimProperties{2},'blue')) && blue_key==keyIndex);  
             %% Processing task-related key presses
             if checkValidKeys
                 keyName=KbName(keyIndex);                                  
                 if registeredKeys==0 % There are no prior presses for this reversal onset
                     %% First press
                     if  checkCorrectError                         
                         if regexp(stimProperties{2},'second')                         
                             %% double-press trials
                            firstKeyTime=min(PressedButtons);
                            registeredKeys=1;
                            firstKey=keyIndex;
                            firstKeyName=KbName(firstKey);                                                        
                         elseif regexp(stimProperties{2},'first')
                             %% single-press trials
                            responseText='Correct';
%                             keyName=KbName(keyIndex);                        
                            registeredKeys=2;
                         end
                         reactionTime=firstKeyTime-reversalTime;
                    else 
                        registeredKeys=2;
                        responseText='Wrong_First_Key';
                    end
                 elseif registeredKeys==1 % There is a response prior to this one for this reversal onset
                     %% Second press
                     if firstKey==keyIndex  
                         secondKeyTime=min(PressedButtons);
                         secondPressDelay=secondKeyTime-firstKeyTime;
                         registeredKeys=2;
                         keyName=[KbName(firstKey) KbName(keyIndex)];
                         responseText='Correct';                     
                     else
                        registeredKeys=2;
%                         keyName=KbName(keyIndex);
                        responseText='Wrong_Second_Key';
                     end       
                 end
             end
             %% Processing task-unrelated button presses
             if keyIndex==escape_key
                 exitmarker=1;
                 break
             elseif keyIndex==exit_key
                 exitmarker=1;
                 break
             end
             
             KbQueueFlush;
             
         end 
        checkResponseDuration       = GetSecs()-reversalTime>2.5;                       % did 2.5 seconds passed since the reversal onset
        checkSecondResponseDuration = GetSecs()-firstKeyTime>1;                         % did 1 seconds passed since the first reponse 
        checkSecondResponsePending  = ~isempty(registeredKeys) && registeredKeys==1;    % is the first response executed in double press trials
        checkKeyboardRegistery      = ~isempty(registeredKeys) && registeredKeys==2;    % did response execution finished and in the registery stage
        checkNoPress                = ~Pressed && ~isempty(checkResponseDuration) && checkResponseDuration;
        if checkKeyboardRegistery || (checkSecondResponsePending && (checkResponseDuration || checkSecondResponseDuration)) || (checkNoPress && registeredKeys<3)
        %% register task-related responses to responseTable
            if checkNoPress && registeredKeys<3
                responseText='Omission';
                reactionTime='';
                keyName='';                
            end
        responseTable{reversalIteration,5}=responseText;
        responseTable{reversalIteration,6}=keyName;
        responseTable{reversalIteration,7}=reactionTime; 
        responseTable{reversalIteration,8}=secondPressDelay;
        fprintf('\nStimulus Type: %s\nAccuracy: %s\nKeyboard Key: %s\nReaction Time: %f\nSecond Press Delay: %f\n', ...
            responseTable{reversalIteration,1},...
            responseTable{reversalIteration,5},...
            responseTable{reversalIteration,6},...
            responseTable{reversalIteration,7},...
            responseTable{reversalIteration,8});
        registeredKeys=3;
        end
    end
end
sca;
KbQueueFlush;
KbQueueRelease; 