
% PsychDefaultSetup(2);
% initializeParallelPort;
% KbName('UnifyKeyNames')
% Screen('Preference', 'SkipSyncTests', 1); 
% %% Initialize Screen via Psychtoolbox
% screens = Screen('Screens');
% 
% % Draw to the external screen if avaliable
% screenNumber = max(screens); %; % select the screen you want to display
% 
% % Define black and white
% white = WhiteIndex(screenNumber);
% black = BlackIndex(screenNumber);
% 
% % Open an on screen window
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white); % , [0 0 550 550]
% 
% % Get the size of the on screen window
% [screenXpixels, screenYpixels] = Screen('WindowSize', window);
% 
% % Get the centre coordinate of the window
% [xCenter, yCenter] = RectCenter(windowRect);

% Sounds for long and short presses

amp             = 1;
sampling_fr     = 10000;
duration_s      = 0.100;
duration_l      = 0.400;
freq            = 2000;
timePoints_s    = 0:1/sampling_fr:duration_s;
timePoints_l    = 0:1/sampling_fr:duration_l;
shortSound      = amp*sin(2*pi*freq*timePoints_s);
longSound       = amp*sin(2*pi*freq*timePoints_l);

% noPressByte                     = 120;
% leftPressByte                   = 248;
% rightPressByte                  = 104; 
% response_bytes                  = [leftPressByte, rightPressByte];
% response_byte_names             = {'SOL','SAG'};
% pause_key                       = KbName('p');
% escape_key                      = KbName('ESCAPE');

solShort = 10;
solLong  = 11;
sagShort = 12;
sagLong  = 13;

short_press = 0.2;
long_press = 0.75;
markerVector = {solShort solLong sagShort sagLong};
keyVector = {leftPressByte leftPressByte rightPressByte rightPressByte};
motor_durationVector = {short_press long_press short_press long_press};
motor_responseNameVector = {'SOL', 'SOL','SAG', 'SAG'};
motor_pressDurations = {'KISA','UZUN','KISA','UZUN'};
motor_feedbackText = {'<color=0.,0.,1.>DOGRU YANIT', '<color=1.,0.,0.>UZUN BASTINIZ', '<color=1.,0.,0.>KISA BASTINIZ' ,'<color=1.,0.,0.>YANLIS TUS'};


motor_practiceVector = repmat([keyVector;motor_durationVector;motor_responseNameVector;motor_pressDurations;markerVector],1,3);
motor_trainingLength = length(motor_practiceVector); % used for beep sound and feedback

motor_pressVector = repmat([keyVector;motor_durationVector;motor_responseNameVector;motor_pressDurations;markerVector],1,35);
motor_permIndices = randperm(length(motor_pressVector));
motor_pressVector = motor_pressVector(:,motor_permIndices);
motor_pressVector = cat(2,motor_practiceVector,motor_pressVector);

% Instruction visual
motorTrainingInstructions=['Degerli katilimci,\n \n'...
        'Bu deneyin ilk asamasidir. Bu asamada sizden sag ve solunuzdaki tuslara kisa veya uzunca basmanizi isteyecegiz.\n\n'...
        'Ekranda "<" gordugunuzde SOL, ">" gordugunuzde SAG tusa basmalisiniz.'...
        'Eger bu isaretlerden sadece iki tane varsa kisaca, daha fazla varsa uzunca basmalisiniz.\n\n'...
        'Ilk birkac denemenizde yanitlarinizin dogru veya yanlis olduguna dair geri bildirimler alacaksiniz. '...
        'Ayni zamanda bu denemelerde isaretlerle beraber kisa ve uzun bip sesleri duyacaksiniz.\n\n'...
        'Bu bip sesleri ve geri bildirimler ilk birkac denemeden sonra verilmeyecektir. Sizden sesleri dinleyerek ve bildirimlere dikkat ederek sureleri ogrenmenizi istiyoruz.\n\n\n'...
        'Hazir oldugunuzda bir tusa basili tutarak deneye devam edebilirsiniz\n\n'];
callExperimenterNotification = ['Bu asama bitmistir. Arastirmaci simdi yaniniza gelip bilgilendirme yapacak.\n\n\n\n'...
     'Bir tusa basili tutarak ekrani kapatabilirsiniz\n'];

    
callTextInstruction_Port(window,motorTrainingInstructions,xCenter, yCenter,portVariables)
WaitSecs(2);
exitmarker=1;

motor_responseTable            = cell(length(motor_pressVector),5);
motor_responseTable(1,:)        = {'Stimulus_Type','KeyName','Accuracy','RT','Release_Duration'};

%% send end of experiment marker = S1
sendParallelSignal(portAddress,80,ioObj)
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)

for k = 1:length(motor_pressVector)
    checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
    if ~exitmarker
        break
    end
    Screen('TextSize',window,50); % feedback and stimuli have 25 punto
    % create stimulus display by direction
    whichDirection = regexp(motor_pressVector(3,k),'SOL');
    if whichDirection{:}
        stimuliDirection='<'; % left arrow 
    else
        stimuliDirection='>'; % right arrow 
    end
    
    % create stimulus display by press duration
    whichDuration = regexp(motor_pressVector(4,k),'UZUN');
    if whichDuration{:}
        stimuliDirection=repmat(stimuliDirection,1,5); % 5 replicas if long
    else
        stimuliDirection=repmat(stimuliDirection,1,2); % 2 replicas if short 
    end
    
    DrawFormattedText2(['<color=0.,0.,0.>' stimuliDirection],'win',window, 'sx',xCenter,'sy', yCenter,'xalign','center','yalign','center','xlayout','center','baseColor',[0 0 0]);
%     DrawFormattedText2(window, [pressVector{3,k} ' ' pressVector{4,k}], xCenter*.9, yCenter, 1/6, [], [], [], 1.5);
    
    if k <= motor_trainingLength
        if motor_pressVector{2,k} == 0.75            
            sound(longSound,sampling_fr);
        elseif motor_pressVector{2,k} == 0.20            
            sound(shortSound,sampling_fr);
        end
    end
    
    vb=Screen('Flip',window);    
    portMarker=motor_pressVector{5,k};
    if k>=9
        sendParallelSignal(portAddress,portMarker,ioObj)
        WaitSecs(.005);
        endParallelSignal(portAddress,ioObj)
    end

    
    exitKeyReg=1;
    while exitKeyReg
    checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
        if ~exitmarker
            break
        end
    %%
    currentResponseByte = io64(ioObj,portAddress(2));   % second port address is response input
    Pressed  = noPressByte ~= currentResponseByte;
        if Pressed
            if k>motor_trainingLength
                sendParallelSignal(portAddress,portMarker+10,ioObj) % S20 21 22 23 = press times
            end
            pressTime             = GetSecs();
            whichResponse         = find(currentResponseByte == response_bytes);
            keyIndex              = response_bytes(whichResponse);
            reactionTime          = pressTime-vb;
            while 1
                checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
                if ~exitmarker
                    break
                end
                %% 
                if GetSecs()-pressTime>=0.7
                    DrawFormattedText2('<color=1.,0.,0.>UZUN BASTINIZ!','win',window, 'sx',xCenter,'sy', yCenter,'xalign','center','yalign','center','xlayout','center','baseColor',[1 0 0]);
                    Screen('Flip',window);   
                    exitKeyReg = 0;
                    WaitSecs(1);
                    break
                else
                releasePortByte        = io64(ioObj,portAddress(2));   % second port address is response input
                checkRelease           = releasePortByte == noPressByte;  % 1 = released the press, 0 = still pressing
                    if checkRelease
                        releaseTime                     = GetSecs();% get the release time 
                        releaseDuration                 = releaseTime-pressTime; % calculate release duration 

                        Pressed=0;
                        isShort = motor_pressVector{2,k}==0.2;
                       
                        if keyIndex == motor_pressVector{1,k}

                                if isShort
                                    isCorrectDuration = releaseDuration <= motor_pressVector{2,k};
                                else
                                    isCorrectDuration = (releaseDuration >= 0.3) && (releaseDuration <= motor_pressVector{2,k});
                                end

                                if isCorrectDuration 
                                    fbIndx=1;
                                    responseText = 'Correct';
                                    if k>motor_trainingLength
                                        sendParallelSignal(portAddress,15,ioObj) % S15 = correct answer port signal
                                        WaitSecs(.005);
                                        endParallelSignal(portAddress,ioObj)
                                    end
                                elseif ~isCorrectDuration && isShort
                                    fbIndx=2;
                                    responseText = 'too_long';
                                elseif ~isCorrectDuration && ~isShort
                                    fbIndx=3;
                                    responseText = 'too_short';
                                end
                        else
                            fbIndx=4;
                            responseText = 'Wrong_Button';
                        end
                        
                        if k<motor_trainingLength
                            if fbIndx==1
                                feedbackColor=[0 0 255];
                            else
                                feedbackColor=[255 0 0];
                            end
                            DrawFormattedText2(motor_feedbackText{fbIndx},'win',window, 'sx',xCenter,'sy', yCenter,'xalign','center','yalign','center','xlayout','center','baseColor',feedbackColor);
                        end
                        Screen('Flip',window);
                        motor_responseTable{k+1,1}=[motor_pressVector{3,k} '_' motor_pressVector{4,k}];
                        motor_responseTable{k+1,2}=response_byte_names{whichResponse}; % accuracy
                        motor_responseTable{k+1,3}=responseText; % keyboard key name
                        motor_responseTable{k+1,4}=reactionTime; % estimated RT  
                        motor_responseTable{k+1,5}=releaseDuration; % release duration                         
                        WaitSecs(1);
                        % draw fixation cross
                        DrawFormattedText2('<color=0.,0.,0.>+','win',window, 'sx',xCenter,'sy', yCenter,'xalign','center','yalign','center','xlayout','center','baseColor',[0 0 0]);
                        Screen('Flip',window);   
                        WaitSecs(1);
                        exitKeyReg = 0;
                        break


                    end                    
                end

            end
        end
    end
end
%% send end of experiment marker = S2
sendParallelSignal(portAddress,81,ioObj)
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)  

%% write data to file
trialName='motorTraining'; 
cd(subjectFolder)
blockFolder = [subjectFolder, '\motorTraining'];
mkdir(blockFolder)
cd(blockFolder)
table_motor = cell2table(motor_responseTable);
writetable(table_motor,'motorTraining.txt')
Screen('TextSize',window,25);
callTextInstruction_Port(window,callExperimenterNotification,xCenter, yCenter,portVariables)
Screen('Close', window);

proceedPrompt = 'Type in <continue> to proceed';
while 1
    proceedAnswer = input(proceedPrompt, 's');
    isContinue = strcmp(proceedAnswer,'continue');
    if isContinue
        isContinue=[];
        break
    end
end
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white); %  ,[0 0 550 550]

