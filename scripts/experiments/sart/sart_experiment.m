%Before start the experiment upload the order of stimuli(modified_stim_order)
clear all
load('modified_stimulus_order.mat')

PsychDefaultSetup(2); % setup psychtoolbox ettings

initializeParallelPort; % setup port settings
KbName('UnifyKeyNames'); % unify all keyboard keys 

%% participant info 


prompt = {'Subjects ID:', 'age', 'gender',...
    'Handedness (Left(0)/Right(1))'}; % adjust-color position pairs 
defaults = {'sartCheck1', '25', 'Male','0'};
answer = inputdlg(prompt, 'Color Order SAM', 2, defaults);
[subid, subage, gender, handedness] = deal(answer{:}); % all input variables are strings



%% Window
Screen('Preference', 'SkipSyncTests', 0); % screen options
Screen('Preference','TextRenderer',1);
screens=Screen('Screens'); % get screen numbers
SCNM = max(screens); % get the maximum screen number for experiment display

white=WhiteIndex(SCNM); % screen white index: 1 1 1
black=BlackIndex(SCNM); % screen black index: 0 0 0
grey=white/2; % screen grey index .5 .5 .5

% OpenWindow
[window,windowrect]=PsychImaging('OpenWindow',SCNM,black);  %,[700 0 1000 300]

[Xcenter,Ycenter]=RectCenter(windowrect); % center pixel coordinates
centercoordinates=[Xcenter, Ycenter]; 
HideCursor(window);
%% Audio 

InitializePsychSound(1); % 1 initiates lowest possible latency mode, always use it

audioDeviceID = 2;      % 0 and 1 are MME devices which are high latency DO NOT CHOOSE.
                        % 2 Windows WASAPI device: lowest latency possible, ALWAYS CHOOSE THIS
                        % 3 Windows WDM-KS device: low latency but for windows 2000 - vista: DO NOT CHOOSE

audioMode = 1; % if 1, audio driver is opened for playback only. type: "PsychPortAudio Open?" for details

audioLatencyClass = 2; % Take full control over the audio device, even if this causes other sound applications to fail or shutdown.
                       % use 2 if you are not using other audio related apps during the experiment. 
                       
fs = 44100;  %44100 CD quality - also conveniently divisible by 30 and 25

nmbrChannels = 2; % opens 2 audio channels (for stereo: left-right speakers)

% Open audio port for auditory stimulus presentation with the parameters above
audioPortHandle = PsychPortAudio('Open', audioDeviceID, audioMode, audioLatencyClass, fs, nmbrChannels); 
%% Response Variables

% Port Related
noPressByte                     = 120;
leftPressByte                   = 248;
rightPressByte                  = 104; 
portVariables                   = {ioObj,portAddress,noPressByte};
response_bytes                  = [leftPressByte, rightPressByte];
response_byte_names             = {'SOL','SAG'};

% Keyboard Related
pause_key                       = KbName('p');

escape_key                      = KbName('ESCAPE');


%% Port Signals

%Response related
% pressedStimMarker   = 10; % response marker 
targetStimMarker    = 21; % 
nonTargetStimMarker = 22; %
correctRejectionMarker   = 9;  % S9 when correct response finalized (lift finger from resp)
correctHitMarker = 10;
comissionMarker     = 8;  % S8 when erroneous response occur (pressed when shouldn't)
omissionMarker      = 7;  % S8 when no response occur during non-target


%% Instructions 
importInstructionVisuals(window,'D:\MatlabDirectory\AllScripts\ZehraUlgen\SART\experimentMaterials\initial_instruction','JPG')

fixationCross = '+';
% sartInstructionText = ['Degerli Katilimci, \nBu deneyde size farklı uzunlukta sesler dinleteceğiz.',...
%     '\nSizden istediğimiz tüm sesleri dikkatlice takip etmeniz ve kısa seslere araştırmacının size gösterdiği butona basarak tepki vermenizdir.', ... 
%     '\nUzun sesleri duyduğunuzda ise butona basmamanız gerekmektedir. Şimdi kısa bir deneme yapacağız.\n'];
% practiceFinishedTxt = 'alistirma bitti, arastirmaci yaniniza gelecek';


%% Parameters for sound stimuli


% ISI_dur= 1; %ISI duration in seconds
ramp_dur=.010; %ramp duration in seconds (rise and fall)
% ISI=zeros(ISI_dur*fs,1);   %generate ISI 

stim_dur_t=.300; %duration in seconds (target)
stim_dur_nt=.100; %duration in seconds (Non-target)
t1=0:1/fs:stim_dur_t-1/fs;
t2=0:1/fs:stim_dur_nt-1/fs;            

%Frequency Types  
f1 = 1400;                % 1400 Hz Tone 
f2 = 1420;
f3 = 1440;
f4 = 1460;
f5 = 1480;               % Sampling Frequency must be greater than fx2=2800

% stimfreqs=[f1,f2,f3,f4,f5];
% stimfreqs = [stimfreqs,stimfreqs];
%create signals
xt1 = sin(2*pi*f1*t1);  %1400    Radian Value To Create 1400 Hz Tone (target)
xt2 = sin(2*pi*f2*t1);  %1420
xt3 = sin(2*pi*f3*t1);  %1440
xt4 = sin(2*pi*f4*t1);  %1460
xt5 = sin(2*pi*f5*t1);  %1480

xnt6 = sin(2*pi*f1*t2);  %1400    Radian Value for Non-target Stimuli
xnt7 = sin(2*pi*f2*t2);  %1420
xnt8 = sin(2*pi*f3*t2);  %1440
xnt9 = sin(2*pi*f4*t2);  %1460
xnt10 = sin(2*pi*f5*t2); %1480

%setup ramp(Target)
rampSamps = floor(fs*ramp_dur);
audioWindow=hanning(2*rampSamps)'; %hanning window is cosine^2 this will change depending on the kind of ramp you want
w1=audioWindow(1:ceil((length(audioWindow))/2)); %use the first half of hanning function for onramp
w2=audioWindow(ceil((length(audioWindow))/2)+1:end); %use second half of hanning function of off ramp
w1 = [w1 ones(1,length(xt1)-length(w1))];
w2 = [ones(1,length(xt1)-length(w2)) w2];

%setup ramp(Non-Target)
rampSamps = floor(fs*ramp_dur);
audioWindow=hanning(2*rampSamps)'; %hanning window is cosine^2 this will change depending on the kind of ramp you want
w3=audioWindow(1:ceil((length(audioWindow))/2)); %use the first half of hanning function for onramp
w4=audioWindow(ceil((length(audioWindow))/2)+1:end); %use second half of hanning function of off ramp
w3 = [w3 ones(1,length(xnt6)-length(w3))];
w4 = [ones(1,length(xnt6)-length(w4)) w4];

%ramp stimuli (Target)
xt1_ramped = xt1.*w1.*w2;  %1400 Hz 300ms
xt2_ramped = xt2.*w1.*w2;  %1420 Hz 300ms
xt3_ramped = xt3.*w1.*w2;  %1440 Hz 300ms
xt4_ramped = xt4.*w1.*w2;  %1460 Hz 300ms
xt5_ramped = xt5.*w1.*w2;  %1480 Hz 300ms

%ramp stimuli (Non-Target)
xnt6_ramped = xnt6.*w3.*w4;    %1400 Hz 100ms
xnt7_ramped = xnt7.*w3.*w4;    %1420 Hz 100ms
xnt8_ramped = xnt8.*w3.*w4;    %1440 Hz 100ms
xnt9_ramped = xnt9.*w3.*w4;    %1460 Hz 100ms
xnt10_ramped = xnt10.*w3.*w4;  %1480 Hz 100ms

Target_Tones(1,1:13230) = xt1_ramped;
Target_Tones(2,1:13230) = xt2_ramped;
Target_Tones(3,1:13230) = xt3_ramped;
Target_Tones(4,1:13230) = xt4_ramped;
Target_Tones(5,1:13230) = xt5_ramped;



NonTarget_Tones(1,1:4410) = xnt6_ramped;
NonTarget_Tones(2,1:4410) = xnt7_ramped;
NonTarget_Tones(3,1:4410) = xnt8_ramped;
NonTarget_Tones(4,1:4410) = xnt9_ramped;
NonTarget_Tones(5,1:4410) = xnt10_ramped;


%%

frequencyRowCorrespondance = [1,2,3,4,5;1400,1420,1440,1460,1480];


%% create time points in a given sampling freq
samplingFreq                = 500; % IEU 
samplingFreqCorrection      = 1000/500; % divide 1 sec in msecs to sampling freq



experimental_trials = stimulus_order_modified(:,2:end);

motor_responseTable             = cell(length(experimental_trials),5);
motor_responseTable(1,:)        = {'Stimulus_Type','Stimulus_Frequency','Accuracy','RT','stimTimeInSeconds'};

stimOnsetRegistery = nan(length(experimental_trials),1);
% initialize response variables for errors 
exitKeyReg=1;
reactionTime=[];
respAccuracy=[];
accuracyPortMarker=[];
PressedPort=[];
PressedKeyboard = [];
exitmarker=1;
pressedButtonThisTrial = 0;
interStimInterval = 1; % 1 sec ISI during practice trials   
% initialize keyboard press registry
KbQueueCreate; KbQueueStart;
driveToDeviceDelay = nan(length(experimental_trials),1);
startToStopDelay = nan(length(experimental_trials),1);

Screen('TextSize',window,75); % feedback and stimuli have 25 punto

%% first instruction
callImageInstruction_Port(window,instructionTesting_Texture,portVariables)
% send experiment start signal after instructions
sendParallelSignal(portAddress,1,ioObj)
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)  

%% display fixation cross 
DrawFormattedText(window,fixationCross,'center', 'center',[1 1 1],120,[],[],1.25);
Screen('Flip',window);    
WaitSecs(2);
startOfExp = GetSecs();
expOnset = GetSecs();
%% start experimental loop with the for loop below
for k = 1:length(experimental_trials)
    
    checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
    if ~exitmarker
        break
    end
    
    % define frequency of the current stimulus
    whichFrequency = experimental_trials{2,k};
    [aud_row, aud_column]=find(frequencyRowCorrespondance==whichFrequency);
    frequencyIndex = frequencyRowCorrespondance(1,aud_column);
    

    
    % check if it is a target or non-target tone
    isNonTarget = regexp(experimental_trials{3,k},'non-target'); % 1 if it is a non-target, 0 if it is a target trial
    
    if ~isempty(isNonTarget)
        % define non-target sound        
        stimDur = 0.1;
        currentStimulus = NonTarget_Tones(frequencyIndex,:);   
        stimulusPortMarker = nonTargetStimMarker;
    else
        % define target sound
        stimDur = 0.3;
        currentStimulus = Target_Tones(frequencyIndex,:);   
        stimulusPortMarker = targetStimMarker;
    end
    % prepare the auditory stimulus for presentation 
    PsychPortAudio('Fillbuffer',audioPortHandle,[currentStimulus; currentStimulus]); % we have opened two audio channels
                                                                                     % therefore we need to type in two audio data one row per channel
                                                                                     % this is why we use [currentStimulus; currentStimulus] as input
    
   %% fixation cross
% 
%     % experimental trial beginning instruction 
%     DrawFormattedText(window,fixationCross,'center','center',[1 1 1],120,[],[],1.25);
%     Screen('Flip',window);    
%     WaitSecs(2);
       
    %% play audio of current stimulus  
    
    tic;
    stimTime = PsychPortAudio('Start', audioPortHandle, 1, 0, 1);
    % send stimulus marker to brain vision recorder 
    devDelay = toc;
    driveToDeviceDelay(k) = devDelay;
    %disp('start tick')    
    sendParallelSignal(portAddress,stimulusPortMarker,ioObj)  % send parallel port signal for stimulus marker right after speakers 
                                                              % give out the sound
    WaitSecs(.005);
    endParallelSignal(portAddress,ioObj) 
    %toc;
    %disp('start tick after sending port signal')
    PsychPortAudio('Stop', audioPortHandle, 1);  % 1 waits for auditory stim to finish playing (non-target=100 ms wait; target = 300 ms wait)
    stopDelay = toc;
    startToStopDelay(k) = stopDelay;
%     disp('stop tock')    
    
    %toc;
    %disp('stop tock after ending port signal')
    stimulusOnset = stimTime-startOfExp;
    stimOnsetRegistery(k) = stimulusOnset;  
    
    if k == 1 
        % register first experimental stim onset in seconds
        expOnset = stimTime;
        % send port signal after instruction to signal thes start of experimental trials 
        sendParallelSignal(portAddress,52,ioObj) % S52 = start of experimental trials 
        WaitSecs(.005);
        endParallelSignal(portAddress,ioObj)            
    end
    

    % initialize resp variables at each trial 
    exitKeyReg=1;
    reactionTime=[];
    respAccuracy=[];
    accuracyPortMarker=[];
    pressedButtonThisTrial = 0;
    while exitKeyReg
    checkPauseOrExitKeys; % checks for 'p' or 'ESCAPE' presses and pauses or terminates the experiment, respectively. 
        if ~exitmarker
            break
        end
    %%
    timeElapsed = GetSecs() - stimTime;
     
        if timeElapsed > interStimInterval % 1 sec during experimental, 2 sec during practice trials 
            
            if  ~pressedButtonThisTrial &&  isempty(isNonTarget)
                % if no press + target stim = correct (nogo trials)
                respAccuracy = 1;
                reactionTime = [];
                accuracyPortMarker = correctRejectionMarker;
                feedbackTexture = feedbackcorrect_Texture;

                
            elseif ~pressedButtonThisTrial &&  ~isempty(isNonTarget)
                % if no press + non target = omission (in go trials)
                feedbackTexture = feedbackwrongOmission_Texture;
                respAccuracy = 0;
                reactionTime = [];     
                accuracyPortMarker = omissionMarker;
                
            end
            
            % register keyboard responses into a variable
            motor_responseTable{k+1,1} = experimental_trials{3,k}; % target or non target
            motor_responseTable{k+1,2} = experimental_trials{2,k}; % frequency of stimuli
            motor_responseTable{k+1,3} = respAccuracy; % keyboard key name
            motor_responseTable{k+1,4} = reactionTime; % estimated RT
            motor_responseTable{k+1,5} = stimulusOnset; % release duration
            
            % print out current responses
                        fprintf('\nStimulus Type: %s\nStimFreq: %f\nAccuracy: %f\nReaction Time: %f\nstimTimeInSeconds: %f\n Trial No: %f\n', ...
            motor_responseTable{k+1,1},...
            motor_responseTable{k+1,2},...
            motor_responseTable{k+1,3},...
            motor_responseTable{k+1,4},...
            motor_responseTable{k+1,5},...
            k);  
        
            %send port signal for the response accuracy (correct, omission, comission) 
            sendParallelSignal(portAddress,accuracyPortMarker,ioObj)
            WaitSecs(.005);
            endParallelSignal(portAddress,ioObj)
            break
        end    
    %%
    currentResponseByte = io64(ioObj,portAddress(2));   % second port address is response input
    PressedPort  = noPressByte ~= currentResponseByte;
        if PressedPort && ~pressedButtonThisTrial
            pressedButtonThisTrial = 1; 
            % send response marker to brain vision recorder // deleted this because of the R1 marker that is sent by the press device
            pressTime             = GetSecs();
%             sendParallelSignal(portAddress,pressedStimMarker,ioObj) % S10 = pressed a button 
%             WaitSecs(.005);
%             endParallelSignal(portAddress,ioObj)
            
            
            whichResponse         = find(currentResponseByte == response_bytes);
            keyIndex              = response_bytes(whichResponse);
            reactionTime          = pressTime-stimTime;

            if  ~isempty(isNonTarget)
                % if pressed during non-target = correct
%                 disp('correct non target')
                feedbackTexture = feedbackcorrect_Texture;
                respAccuracy = 1;      
                accuracyPortMarker = correctHitMarker;
            else
                % if pressed during target = comission
%                 disp('comission during target')
                feedbackTexture = feedbackwrongComission_Texture;
                respAccuracy = 0;           
                accuracyPortMarker = comissionMarker;
            end
            

        end
    end
end
expEnd = GetSecs;
experimentDuration = expEnd - expOnset;

% send port signal when experiment is finished
sendParallelSignal(portAddress,53,ioObj) % S53 = end of experimental trials - exp finished 
WaitSecs(.005);
endParallelSignal(portAddress,ioObj) 

% get experiment ended instructions 
callImageInstruction_Port(window,instructionFinish_Texture,portVariables)

        
timePointCorrectedOnsets    =   (round((stimOnsetRegistery-expOnset)/samplingFreqCorrection,3)+.001)*1000; % correct screen onset times into sampling rate corrected time points (1 256... 1325 etc.)        

experimental_trials(:,2:end+1) = experimental_trials; % shift trial matrix by one column to free space for headers for data registry
experimental_trials(:,1) = stimulus_order_modified(:,1); % get the headers from original trial matrix
experimental_trials = experimental_trials'; % transpose the matrix so that it is in long format
stimulus_Table = experimental_trials; % replicate 
stimulus_Table{1,6} = 'stimOnsetInSeconds'; % add stimulus onset column to the trial matrix
stimulus_Table(2:end,6) = num2cell(stimOnsetRegistery'); % add stimulus onset vector to the trial matrix


% create a folder with the participant ID
dataFolder =['D:\MatlabDirectory\AllScripts\ZehraUlgen\SART\rawDataFolder\' subid];
mkdir(dataFolder);
cd(dataFolder);
% get participant info and experiment duration
participantInfo = ['participant code: ' subid,' age: ' subage,' gender: ' gender,' handedness: ' handedness,' experiment duration: ' num2str(experimentDuration)];
% convert stimulus and response registries to table for writing
table_motor = cell2table(motor_responseTable(2:end,:));
table_stim = cell2table(stimulus_Table(2:end,:));
table_motor.Properties.VariableNames = motor_responseTable(1,:);
table_stim.Properties.VariableNames = stimulus_Table(1,:);

pInfoFile = fopen([subid '_info.txt'],'w');
fprintf(pInfoFile,participantInfo);
writetable(table_motor,[subid '_behavioralData.txt'])
writetable(table_stim,[subid '_stimulusTable.txt'])

%% send end of experiment marker = S2
sendParallelSignal(portAddress,2,ioObj)
WaitSecs(.01);
endParallelSignal(portAddress,ioObj)  

fclose('all');
sca;