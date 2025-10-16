function keyboardPressDurationExercise()
PsychDefaultSetup(2);
KbName('UnifyKeyNames')
Screen('Preference', 'SkipSyncTests', 1); 
%% Initialize Screen via Psychtoolbox
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens); %; % select the screen you want to display

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);


KbQueueCreate();    KbQueueStart();


solKey = KbName('j');
sagKey = KbName('k');
shortPress = 0.2;
longPress = 0.75;
keyVector = {solKey solKey sagKey sagKey};
durationVector = {shortPress longPress shortPress longPress};
keyboardKeys = {'SOL', 'SOL', 'SAG', 'SAG'};
pressDurations = {'KISA','UZUN','KISA','UZUN'};

pressVector = repmat([keyVector;durationVector;keyboardKeys;pressDurations],1,5);
permIndices = randperm(length(pressVector));
pressVector = pressVector(:,permIndices);
% WaitSecs(seconds);
startTime=GetSecs();
for k = 1:length(pressVector)
    DrawFormattedText(window, [pressVector{3,k} ' ' pressVector{4,k}], xCenter*.9, yCenter, 1/6, [], [], [], 1.5);
    Screen('Flip',window);    
    exitKeyReg=1;
    while exitKeyReg

    [Pressed, PressedButton,firstRelease]=KbQueueCheck(); 
        if Pressed
            PressedButton(PressedButton==0)=NaN;        
            [~, keyIndex]                   = min(PressedButton); % get the earliest press
            pressTime                       = PressedButton(keyIndex); % get the press time 
            keyName                         = KbName(keyIndex); % get the keyboard key name        

            %         KbName([pressIndex releaseIndex])
            while 1
                if GetSecs()-PressedButton(keyIndex)>=0.7
                    DrawFormattedText(window, 'COK UZUN BASTINIZ!', xCenter*.9, yCenter, [1 0 0], [], [], [], 1.5);
                    Screen('Flip',window);   
                    exitKeyReg = 0;
                    WaitSecs(1.5);
                    break
                else
                [~,~,firstRelease]=KbQueueCheck(); 
                    if firstRelease(firstRelease>0)>0
                        firstRelease(firstRelease==0)=NaN;
                        [~, releaseIndex]=min(firstRelease);
                        releaseTime=firstRelease(releaseIndex);
                        releaseDuration                 = releaseTime-pressTime; % calculate release duration 

                        Pressed=0;
                        KbQueueFlush();
                        isShort = pressVector{2,k}==0.2;
                        if keyIndex == pressVector{1,k}

                                if isShort
                                    isCorrectDuration = releaseDuration <= pressVector{2,k};
                                else
                                    isCorrectDuration = (releaseDuration >= 0.3) && (releaseDuration <= pressVector{2,k});
                                end

                                if isCorrectDuration 
                                    DrawFormattedText(window, '!!DOGRU CEVAP!!', xCenter*.9, yCenter, [0 0 1], [], [], [], 1.5);
                                    Screen('Flip',window); 
                                elseif ~isCorrectDuration && isShort
                                    DrawFormattedText(window, 'COK UZUN BASTINIZ!', xCenter*.9, yCenter, [1 0 0], [], [], [], 1.5);
                                    Screen('Flip',window); 
                                elseif ~isCorrectDuration && ~isShort
                                    DrawFormattedText(window, 'COK KISA BASTINIZ!', xCenter*.9, yCenter, [1 0 0], [], [], [], 1.5);
                                    Screen('Flip',window);             
                                end
                        else
                            DrawFormattedText(window, 'YANLIS TUSA BASTINIZ!', xCenter*.9, yCenter, [1 0 0], [], [], [], 1.5);
                            Screen('Flip',window);                           
                        end
                        WaitSecs(1.5);
                        exitKeyReg = 0;
                        break


                    end                    
                end

            end
        end
    end
end


sca;


KbQueueFlush();