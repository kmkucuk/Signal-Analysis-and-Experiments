close all;
clear all; %#ok<CLALL>
sca;

Screen('Preference', 'SkipSyncTests', 0);
PsychDefaultSetup(2);
KbName('UnifyKeyNames'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Login prompt and open file for writing data out %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prompt = {'Outputfile', 'Subject''s number:', 'age', 'gender', 'group','Without Training=1, With Training=2','Only SAM=1, Only Necker=2, Combined=3','1=CubeMirror,2=LatticeMirror,3=LatCubex2,4=CubeLatx2'};
defaults = {'Bistable', '300', '55', 'F','E','2','1',''};
answer = inputdlg(prompt, 'Bistable', 2, defaults);
[output, subid, subage, gender, group, trainingOrNot, blockingType,NeckerOrder] = deal(answer{:}); % all input variables are strings

if blockingType == '1'
    outputname = [output gender '_' subid '_' subage '_' group '_SAM' '.xls'];
elseif blockingType == '2'
    outputname = [output gender '_' subid '_' subage '_' group '_Necker' '.xls'];
elseif blockingType == '3'
    outputname = [output gender '_' subid '_' subage '_' group '_Combined' '.xls'];
end
    
trainingOrNot=str2num(trainingOrNot); %#ok<*ST2NM>
blockingType=str2num(blockingType);
NeckerOrder=str2num(NeckerOrder);

% blockingType       %% If 1=Only SAM, If 2=Only Necker, If 3=SAM & NECKER
% trainingOrNot      %% if 1, there are no trainings. If 2 there are trainings

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NeckerOrder %%%                                                      %
%%%%%%%%%%%%%%%%%%%                                                      %
%                                                                        %
% Defines the matrix of "trialOrderNecker" variable                      %
% 1 == [1,2] [2,1] == Cube Mirror //                                     %
% 2 == [2,1] [1,2] == Lattice Mirror //                                  %
% 3 == [1,2] [1,2] == Lat-Cube Lat-Cube                                  %
% 4 == [2,1] [2,1] == Cube-Lat Cube-Lat                                  %
%                                                                        %
% As you can see, order is reversed between training and trial in 1 and 2%
% but not in 3 and 4 values. This will allow us to use                   %
% "if NeckerOrder<3"->"Reverse(NeckerOrder) in test trial" solution.     %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist(outputname)==2 %#ok<EXIST> % check to avoid overiding an existing file
    
fileproblem = input('That file already exists! Append a .x (1), overwrite (2), or break (3/default)?');

    if isempty(fileproblem) | fileproblem==3 
        return;
    elseif fileproblem==1
        outputname = [outputname '.x'];
    end
end
cd('E:\Backups\Matlab Directory\ieu_directory\scripts\experiments\necker_sam_combined');
outfile = fopen(outputname,'w'); % open a file for writing data out

fprintf(outfile, 'subid\t subage\t gender\t group\t Block_Type\t blockNumber\t Press_Array\t Pressed_Key\t Press_Time\t Reaction_Time\t Exo_Switch_Time\t \n');

%%Window%%

screens=Screen('Screens');
SCNM=max(screens);


white=WhiteIndex(SCNM);
black=BlackIndex(SCNM);


grey=white/2;

%OpenWindow

[window,windowrect]=PsychImaging('OpenWindow',SCNM,black,[0 0 1366 768]);%[700 0 1000 300]

[Xcenter,Ycenter]=RectCenter(windowrect);
centercoordinates=[Xcenter, Ycenter];

%RefreshRate

ifi=Screen('GetFlipInterval',window);
waitframes=1;
screenwait=(waitframes-0.5)*ifi;

%PrioritizeWindow

toppriorityLevel=MaxPriority(window);

numSecs=1;
numFrames=round(numSecs/ifi);

waitframes=1;
HideCursor();


%%%strings%%%
instructionstring=['Bu sirada kurallara tekrar goz atin:\n \n'...
        '1) Sekillere bakarken pasif bir tutum izleyiniz, gorunumlerini sabit tutmaya ya da degistirmeye \ncalismayiniz.\n\n'...
        '2) Gecisleri farkettiginiz anda hemen gerekli tusa basiniz.\n\n'...
        '3) Gozlerinizi az kirpmaya calisip, olabildigince az hareket ediniz.'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Importing Instruction and Stimuli Visuals %%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

importInstructionVisuals(window,'E:\Backups\Matlab Directory\ieu_directory\scripts\experiments\necker_sam_combined\materials\Instructions');

importStimuliVisuals(window,'E:\Backups\Matlab Directory\ieu_directory\scripts\experiments\necker_sam_combined\materials\Stimuli');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Vector for gif-like WHILE Loop of SAM%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samvector=[fix_sam_Texture,samsecond_Texture,samfirst_Texture,samthird_Texture];   
fixationlatency=.085; targetlatency=.165; 
stimulusduration=[fixationlatency,targetlatency];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EXO SAM LOOP VECTORS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sam_hor_vector=[fix_sam_Texture,sam_hor1_Texture,fix_sam_Texture,sam_hor2_Texture];   
sam_ver_vector=[fix_sam_Texture,sam_ver1_Texture,fix_sam_Texture,sam_ver2_Texture]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  KeyCodes for SAM  %%%%%%%%%%%% KeyCodes for Necker %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samkey_vertical=KbName('8');            neckerleft=KbName('7');
samkey_horizontal=KbName('7');          neckerright=KbName('8');
escapekey=KbName('ESCAPE');             exitkey=KbName('p');

BlockOrder=[1 2];               %%% First element --> SAM / Second element --> NECKER

trialOrderSam=[1 2];            %%% First element --> EXO SAM / Second element --> ENDO SAM 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Necker Stimuli Presentation Order %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if blockingType ~=1
     if isempty(NeckerOrder)
        sca;
        errordlg('Please type in a valid number for the order of Necker stimuli', 'Invalid Necker Stimuli Parameter');   
    elseif NeckerOrder==1 || NeckerOrder==3
        trialOrderNecker=[1,2];         
    elseif NeckerOrder==2 || NeckerOrder==4
        trialOrderNecker=[2,1];
    else
        sca;
        errordlg('Please type in a valid number for the order of Necker stimuli', 'Invalid Necker Stimuli Parameter');
    end
end

numberblock=0;
exitmarker=0;

for trialsequence = 1:trainingOrNot
    
    rng('default');
    
    if exitmarker==1
        break;
    end
        
        if  trainingOrNot==2 & trialsequence==1      %%%If there is a training session and experiment hasn't finished the training phase. 
      
            interTrialInterval=30;              %%% ITI is 30 seconds in training
            saveCondition="training";           %%% Adds condition name to save file: subid_training ---> 001_training    
            trialduration=90;                   %%% Trainings are 90 seconds

       else
            interTrialInterval=120;             %%% ITI is 120 seconds in testing
            saveCondition="test";               %%% Adds condition name to save file: subid_test ---> 001_test
            trialduration=240;                  %%% Trials are 240 seconds
        
        end
    
         if trainingOrNot==2 & trialsequence==2 & NeckerOrder<3 %%%If there is a training session and experiment finished the training phase. Also NeckerOrder has to be smaller than 3, because only then stimulus presentation order changes. This is detailed at the beginning @NeckerOrder.
            
            trialOrderNecker=flip(trialOrderNecker);             %%% Flips the order of presentation 
         end
        
        if trialsequence==1     %%% Show initial instruction / if-> first iteration

            CallInstruction(window,Initial_Texture);            

        end
             
    for betweensequence=1:2
        
            if exitmarker==1
                 break;
            end
            
            if betweensequence==2 && blockingType==3 %%% IF ITERATES SAM and NECKER are presented together, initiates INTER BLOCK INTERVAL
                
                KbQueueCreate;    KbQueueStart;                
                ITI_Start=GetSecs();
                TimerCountDown=interTrialInterval;
                 for timerCD = 1:interTrialInterval
                     
                     [Pressed, PressedButton]=KbQueueCheck();     
                     if Pressed 
                         KeyboardReg(PressedButton,ITI_Start,[],[],1);
                         
                         if KbName(Key_Code)==escapekey
                             
                            break;
                            
                         elseif KbName(Key_Code)==exitkey
                             
                            exitmarker=1;
                            
                            break;
                            
                         end
                         
                     end 
                     
                    TimerCountDown=TimerCountDown-1;
                    textString=[num2str(TimerCountDown) ' SANIYE SONRA DENEY DEVAM EDECEK'];
                    DrawFormattedText(window,textString,'center',Ycenter-20,white);
                    DrawFormattedText(window,instructionstring,Xcenter/3,(Ycenter+40),white*5/6);
                    Screen('Flip',window);
                    WaitSecs(1);                    
                 end
                    KbQueueFlush;
                    KbQueueRelease;                
            end
               
            if (blockingType==1 | blockingType==3) && betweensequence==BlockOrder(1)%#ok<*OR2>
                
                for withinsequence=1:2      %%%Iterations for SAM trials
                     
                    if exitmarker==1
                        break;
                     end
                    
                    numberblock=numberblock+1;
                    
                    if withinsequence == 2 | (trialsequence==2 & withinsequence==1)
                        
                            if trialsequence==2 & withinsequence==1
                                interTrialInterval=30;                               %%% ITI between SAM
                            elseif trialsequence==2 & withinsequence==2              %%% If switched from training to trial-> Set ITI as 30 secs not 120.
                                interTrialInterval=120;
                            end
                        
                        KbQueueCreate;    KbQueueStart;    
                        ITI_Start=GetSecs();                        
                        TimerCountDown=interTrialInterval;
                        
                        for timerCD = 1:interTrialInterval
                            
                             [Pressed, PressedButton]=KbQueueCheck();     
                             
                             if Pressed 
                                 
                                 %%%
                                 KeyboardReg(PressedButton,ITI_Start,[],[],1);
                                 %%%
                                 
                                 if KbName(Key_Code)==escapekey
                                    break;
                                 elseif KbName(Key_Code)==exitkey
                                    exitmarker=1;
                                    break;
                                 end
                             end            
                             
                            TimerCountDown=TimerCountDown-1;
                            textString=[num2str(TimerCountDown) ' SANIYE SONRA DENEY DEVAM EDECEK'];
                            DrawFormattedText(window,textString,'center',Ycenter-20,white);
                            DrawFormattedText(window,instructionstring,Xcenter/3,(Ycenter+40),white*5/6);
                            Screen('Flip',window);
                            WaitSecs(1);

                        end
                            KbQueueFlush;
                            KbQueueRelease;
                    end                            
                            
                        if withinsequence==trialOrderSam(1)                      %%% EXO SAM
                            
                            %%%%%%%%%%%%%%%%
                            % Instructions %
                            %%%%%%%%%%%%%%%%
                            
                            
                            if trialsequence==1 & trainingOrNot==2              %%% TRAINING INSTRUCTIONS - EXO SAM
                                
                                CallInstruction(window,Prac4_Texture); 
                                blocktype="TRAINING-EXOSAM";
                                
                            else
                                CallInstruction(window,Test4_Texture);          %%% EXPERIMENT INSTRUCTIONS -- EXO SAM                                
                                blocktype="TRIAL-EXOSAM";                                
                                
                            end
                            
                            %%%%%%%% EXO SAM TRIAL %%%%%%%
                            %%%  EXO EXO EXO EXO EXO  %%%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            endorev_rate=8;
                            endorev_int=60/endorev_rate;
                            
                            Priority(toppriorityLevel);
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%%%%%%Response & Timer Sheets%%%%%%%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                            exoResponse=zeros(1,100);
                            exoTime=zeros(1,100);
                            RTvectorExo=zeros(1,100);
                            exoExp_sam_printtime=nan(240,6);
                            SwitchTimeStamp=nan(1,100);
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%% Sheets for Jitter Percentage Calculation %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            ExoVerJitter=nan(1,100);
                            ExoHorJitter=nan(1,100);


                            %%%%%%%%%%%%%%%%%%%%%%%%
                            %%% KbQueue Initiate %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%
                            
                            WaitSecs(2);
                            KbQueueCreate;    KbQueueStart;

                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%% Loop % Response Iteration Marker %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            exoLoopmarker=0;
                            exoFliptimer=1;
                            sheetmarker=0;
                            Screen('FillRect',window,white);
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%% Loop Start & Flip Start Timer %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            exo_samtimer=tic;    exo_vb=Screen('Flip',window);
                            
                            exorunaway=0; %%% Variable for breaking loops if ESCAPE is pressed or trial duration is elapsed %%%
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%%% SAM-GIF Start & Response Recordings %%%%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            for exp_reversal = 1:((endorev_rate)*(trialduration/60))+1 %%% Create 8 * Trial duration in minutes reversals. In other words, 
                                                                                       %%% It will create 8*(240/60) exo reversals via a "for" loop. 
                                
                                    if exorunaway==1
                                        break;
                                    end
                                    
                                Exorandomjitter=0.8+(1.2-0.8).*rand; %%% Adding randomized Stimulus durations 20% below and above the mean of endo durations
                                   
                                    if mod(exp_reversal,2)==1           %%% This condition registers the durations of each EXO percepts within Exo****Jitter variables. 
                                                                        %%% Jitter is calculated in every iteration by the first line of code below.
                                                                        
                                        Exoreversaljitter=(endorev_int)*Exorandomjitter;
                                        ExoHorJitter(1,exp_reversal)=Exoreversaljitter;
                                        
                                    elseif mod(exp_reversal,2)==0
                                        Exoreversaljitter=(endorev_int)*Exorandomjitter;
                                        ExoVerJitter(1,exp_reversal)=Exoreversaljitter;
                                    end
                                    
                                rotationduration=tic;
                                gettimestamp=1; %%% Used for stamping first flash of the new switch for RT calculation
                                    
                                    while 1
                                        
                                        if toc(rotationduration)>Exoreversaljitter
                                            break;
                                        elseif toc(exo_samtimer)>trialduration
                                            exorunaway=1;
                                            break;
                                        end
                                        
                                        exoLoopmarker=exoLoopmarker+1;
                                        
                                        if mod(exp_reversal,2)==1
                                            
                                            Screen('DrawTexture',window,sam_hor_vector(exoLoopmarker));
                                            Screen('DrawingFinished',window);
                                            previousflip=exo_vb;
                                            exo_vb=Screen('Flip',window,exo_vb+stimulusduration((mod(exoLoopmarker,2)+1)));         
                                            flipcounter=exo_vb-previousflip; 
                                            
                                        elseif mod(exp_reversal,2)==0
                                            
                                            Screen('DrawTexture',window,sam_ver_vector(exoLoopmarker));
                                            Screen('DrawingFinished',window);
                                            previousflip=exo_vb;
                                            exo_vb=Screen('Flip',window,exo_vb+stimulusduration((mod(exoLoopmarker,2)+1)));         
                                            flipcounter=exo_vb-previousflip;
                                            
                                        end
                                        
                                        exoExp_sam_printtime(exoFliptimer,exoLoopmarker)=flipcounter;
                                        
                                        if gettimestamp==1          %%% Stamps the first flash of new EXOSAM motion direction. "gettimestamp" becomes zero after the new direction switch. Then becomes "1" again with every direction switch.  
                                            if exp_reversal==1
                                                exoSam_start=exo_vb;
                                            end
                                            
                                            switchRTstamp=exo_vb;
                                            SwitchTimeStamp(1,exp_reversal)=switchRTstamp-exoSam_start;                                            
                                        end                                        
                                        
                                        gettimestamp=0;
                                        
                                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                        %%%%%Keyboard Input Check, Response & Reaction Time Save%%%%%%
                                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                        
                                        [exoPressed, exoFirstPress]=KbQueueCheck();                     %%%If button pressed before switching or expStart timer it is not recorded
                                        
                                        if exoPressed & exoFirstPress(exoFirstPress>0)>exoSam_start
                                            
                                            %%%     %%%     %%%     %%%
                                            KeyboardReg(exoFirstPress,exoSam_start,sheetmarker,switchRTstamp,0);
                                            %%%     %%%     %%%     %%%
                                            
                                            fprintf(outfile, '%s\t %s\t %s\t %s\t %s\t %d\t %d\t %s\t %6.2f\t %6.3f\t %6.2f\t \n', subid, ...,
                                            subage, gender, group, blocktype, numberblock, sheetmarker, Key_Code, PressTime,exoRT, SwitchTimeStamp(1,exp_reversal));
                                            
                                            if KbName(Key_Code)==escapekey
                                                
                                                exorunaway=1;
                                                
                                                break;
                                                
                                            elseif KbName(Key_Code)==exitkey
                                                
                                                exorunaway=1;
                                                
                                                exitmarker=1;
                                                
                                                break;
                                            end
                                                    
                                            KbQueueFlush;                                                    
                                        end
                                        
                                        if exoLoopmarker==4
                                            exoLoopmarker=0;
                                            exoFliptimer=exoFliptimer+1;
                                        end
                                        
                                    end
                            end
                            
                            Key_Code=[];
                            KbQueueFlush;
                            KbQueueRelease;
                            
                            DUR_exo_exp_SAM=toc(exo_samtimer);

                            %%% Jitter Calculation %%%
                            
%                             CalculateExoJitter(horjit,verjit);
                            
                            Screen('FillRect',window,black);

                        elseif withinsequence==trialOrderSam(2)                 %%% ENDO SAM
                        
                            
                            %%%%%%%%%%%%%%%%%%%%
                            %%% Instructions %%%
                            %%%%%%%%%%%%%%%%%%%%
                            
                                
                                if trialsequence==1 & trainingOrNot==2          %#ok<*AND2> %%% TRAINING INSTRUCTIONS -- ENDO SAM
                                    CallInstruction(window,Prac2_Texture);                                   
                                    blocktype="TRAINING-ENDOSAM";                                        
                                else                                                %%% TRIAL INSTRUCTIONS -- ENDO SAM
                                    CallInstruction(window,Test2_Texture);                                    
                                    blocktype="TRIAL-ENDOSAM";
                                end
                            
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%%%%%%  ENDO SAM TRIAL  %%%%%%
                            %%% ENDO ENDO ENDO ENDO ENDO %%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            Priority(toppriorityLevel);
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%% Response & Timer Variables %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            response_sheet=zeros(1,100);
                            time_sheet=zeros(1,100);
                            printtime=nan(240,6);
                            loopmarker=0;
                            fliptimermark=1;
                            sheetmarker=0;
                            WaitSecs(2);
                            KbQueueCreate;
                            KbQueueStart;
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%% Loop Start & Flip Start Timer %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            Screen('FillRect',window,white);
                            vb=Screen('Flip',window);
                            experiment_start=GetSecs;
                            samtimer=tic;
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%% SAM-GIF Start & Response Recordings %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                                while toc(samtimer)<trialduration
                                    
                                    loopmarker=loopmarker+1;
                                    Screen('DrawTexture',window,samvector(loopmarker));
                                    Screen('DrawingFinished',window,2);
                                    previousflip=vb;
                                    vb=Screen('Flip',window,vb+stimulusduration((mod(loopmarker,2)+1)));         
                                    flipcounter=vb-previousflip;
                                    printtime(fliptimermark,loopmarker)=flipcounter;                    
                                    
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %%% Keyboard Input Check, Response & Reaction Time Save %%%
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    
                                    [pressed, firstPress]=KbQueueCheck(); 
                                    if pressed & firstPress(firstPress>0)>experiment_start      %%% If a button pressed before the first flip of ENDO SAM, it is not recorded.
                                        
                                        %%%     %%%     %%%     %%%
                                        
                                        KeyboardReg(firstPress,experiment_start,sheetmarker,[],1);
                                        
                                        %%%     %%%     %%%     %%%
                                        
                                        response_sheet(1,sheetmarker)=1;
                                        time_sheet(1,sheetmarker)=PressTime;
                                        
                                        
                                        fprintf(outfile, '%s\t %s\t %s\t %s\t %s\t %d\t %d\t %s\t %6.2f\t \n', subid, ...,
                                        subage, gender, group, blocktype, numberblock, sheetmarker, Key_Code, PressTime);
                                    
                                        if KbName(Key_Code)==escapekey
                                            
                                            break;
                                            
                                        elseif KbName(Key_Code)==exitkey
                                            
                                            exitmarker=1;
                                            
                                            break;
                                            
                                        end
                                        
                                        KbQueueFlush;
                                    end
                                    if loopmarker==4
                                       loopmarker=0;
                                       fliptimermark=fliptimermark+1;
                                    end
                                end
                                
                            Key_Code=[];
                            sam_combined_sheet=[response_sheet;time_sheet];
                            KbQueueFlush;
                            KbQueueRelease;
                            END_expSAM=toc(samtimer);
                            DUR_expSAM=END_expSAM-experiment_start;                   
                            
                        end
                        Screen('Flip',window);
                        Priority(0);
                        
                        Screen('FillRect',window,black);
                end

           


            elseif (blockingType==2 | blockingType==3) && betweensequence==BlockOrder(2)
                
                for withinsequence=1:2      %%% Iterations for NECKER trials
                    
                        if exitmarker==1
                            
                            break;
                            
                        end

                        numberblock=numberblock+1;
                    
                    if withinsequence == 2 | (trialsequence==2 & withinsequence==1)
                        
                            if trialsequence==2 & withinsequence==1

                                interTrialInterval=30;                               %%% ITI between NECKER

                            elseif trialsequence==2 & withinsequence==2              %%% If switched from training to trial-> Set ITI as 30 secs not 120.

                                interTrialInterval=120;
                            end
                        
                            KbQueueCreate;  KbQueueStart;
                            TimerCountDown=interTrialInterval;                        
                            ITI_Start=GetSecs();                        

                            for timerCD = 1:interTrialInterval

                                 [Pressed, PressedButton]=KbQueueCheck();     
                             
                                     if Pressed 
                                         KeyboardReg(PressedButton,ITI_Start,[],[],1);

                                         if KbName(Key_Code)==escapekey
                                            break;
                                         elseif KbName(Key_Code)==exitkey
                                            exitmarker=1;
                                            break;
                                         end

                                     end            

                                TimerCountDown=TimerCountDown-1;
                                textString=[num2str(TimerCountDown) ' SANIYE SONRA DENEY DEVAM EDECEK'];
                                DrawFormattedText(window,textString,'center',Ycenter-20,white);
                                DrawFormattedText(window,instructionstring,Xcenter/3,(Ycenter+40),white*5/6);
                                Screen('Flip',window);
                                WaitSecs(1);

                            end
                                KbQueueFlush;
                                KbQueueRelease;
                    end

                        if withinsequence==trialOrderNecker(1)                   %%% LATTICE
                            
                           %%%%%%%%%%%%%%%%%%%%
                           %%% Instructions %%%
                           %%%%%%%%%%%%%%%%%%%%
                            
                            if trainingOrNot==2 & trialsequence==1              %%% TRAINING INSTRUCTIONS -- NECKER LATTICE
                                CallInstruction(window,Prac1_Texture);                                
                                blocktype="TRAINING-LATTICE"; 
                                
                            else                                                %%% EXPERIMENTAL INSTRUCTIONS -- NECKER LATTICE 
                                CallInstruction(window,Test1_Texture);
                                blocktype="TRIAL-LATTICE";
                            end
                            
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%%%%%%%%  NECKER LATTICE TRIAL %%%%%%%%%%
                            %%%%% LATTICE LATTICE LATTICE LATTICE %%%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            Priority(toppriorityLevel);
                            WaitSecs(2);
                            nc_exp_start=tic; necker_responsetime=nan;

                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%% Data Sheet Variables %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            trial_nc_matrix=nan(2,trialduration);
                            necker_exp_button=nan;
                            ncbreaker=true;   
                            sheetmarker=0;
                            KbQueueCreate;
                            KbQueueStart;
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%% First Flip and Trial Initiation Timer %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            Screen('DrawTexture',window,Lattice_Texture);
                            nc_exp_start_time=Screen('Flip',window);    
                                while toc(nc_exp_start)<trialduration 

                                    [pressed, necker_exp_button]=KbQueueCheck();

                                    if pressed

                                        %%%     %%%     %%%     %%%                                    
                                        KeyboardReg(necker_exp_button,nc_exp_start_time,sheetmarker,[],1);
                                        %%%     %%%     %%%     %%%                          

                                        fprintf(outfile, '%s\t %s\t %s\t %s\t %s\t %d\t %d\t %s\t %6.2f\t \n', subid, ...,
                                        subage, gender, group, blocktype, numberblock,  sheetmarker, Key_Code, PressTime);

                                        KbQueueFlush;

                                                if KbName(Key_Code)==escapekey

                                                    break;

                                                elseif KbName(Key_Code)==exitkey

                                                    exitmarker=1;

                                                    break;

                                                end

                                    end
                                end
                                KbQueueFlush;
                                KbQueueRelease;
                                END_expNC=toc(nc_exp_start);
                                DUR_expNC=END_expNC-nc_exp_start_time;    
                            
                        elseif withinsequence==trialOrderNecker(2)              %%% NECKER CUBE
                            
                          %%%%%%%%%%%%%%%%%%%%
                          %%% Instructions %%%
                          %%%%%%%%%%%%%%%%%%%%
                            
                            if trainingOrNot==2 & trialsequence==1              %%% TRAINING INSTRUCTIONS -- CUBE
                                
                                CallInstruction(window,Prac3_Texture);
                                
                                blocktype="TRAINING-CUBE";
                                
                            else                                                %%% EXPERIMENTAL INSTRUCTIONS -- CUBE
                                
                                CallInstruction(window,Test3_Texture);
                                
                                blocktype="TRIAL-CUBE"; %#ok<*NASGU>
                               
                            end                            
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%%%%    NECKER CUBE TRIAL   %%%%%
                            %%%% CUBE CUBE CUBE CUBE CUBE %%%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            Priority(toppriorityLevel);
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%% Data sheet for Necker Trial  %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            sheetmarker=0;
                            exp_NCube_matrix=nan(2,120);

                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %%% Timers for trial duration and response timing %%%
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            WaitSecs(2);
                            exp_NCube_block=tic;
                            
                            KbQueueCreate;
                            KbQueueStart;
                            
                            Screen('DrawTexture',window,Cube_Texture);
                            exp_NCube_start=Screen('Flip',window);

                            while toc(exp_NCube_block)<trialduration    
                                
                                    [pressed, NCube_exp_button]=KbQueueCheck(); 
                                    
                                        if pressed           
                                            
                                            %%%     %%%     %%%     %%%                                            
                                            KeyboardReg(NCube_exp_button,exp_NCube_start,sheetmarker,[],1);                                                                                
                                            %%%     %%%     %%%     %%%                 
                                            
                                            fprintf(outfile, '%s\t %s\t %s\t %s\t %s\t %d\t %d\t %s\t %6.2f\t \n', subid, ...,
                                            subage, gender, group, blocktype, numberblock, sheetmarker, Key_Code, PressTime);
                                        
                                            KbQueueFlush;         

                                                if KbName(Key_Code)==escapekey                                            
                                                    break;                                     

                                                elseif KbName(Key_Code)==exitkey

                                                    exitmarker=1;                                            
                                                    break;                                            
                                                end
                                        end
                            end
                            
                            KbQueueFlush;
                            KbQueueRelease;                            
                        end
                        Screen('Flip',window);
                        Priority(0);
                end
            end            
    end
    %%% Save workspace both in training and in Trials
    %%% It will not save images and AlexNet Workspace variables because they are both unnecessary and big
    
    cd('E:\Backups\Matlab Directory\ieu_directory\scripts\experiments\necker_sam_combined');
    WSFileName=sprintf('%s_%s',subid,saveCondition);
    save(WSFileName, '-regexp', '^(?!(Initial_Ins_img|Prac_1_Ins_img|Prac_2_Ins_img|Prac_3_Ins_img|Prac_4_Ins_img|Test_1_Ins_img|Test_2_Ins_img|Test_3_Ins_img|Test_4_Ins_img|Thanks_Ins_img|net)$).');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Thanks_Ins %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exitmarker==0
    CallInstruction(window,Thanks_Texture);
end
fclose('all');
Screen('CloseAll');
Priority(0);
KbQueueRelease;
sca;