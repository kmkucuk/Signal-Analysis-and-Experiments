%EEG = data structure variable
%
%pCount = how many participants from each group (elderly,young) 1= 1 from
%each, 2 = 2 from each
%
%tCount = how many trials (default 2, 1 from first half of trials, 1 from
%last half of the trials). 1=default, 2=adds 1 to each half (total 4 etc.)
%
%channel = single channel index (e.g. 1 or 2 or 3 etc.)
%
%cScalar = scalar value, one of these0 values: (1,2,3,4). Scales the
%pCount iteration value so that the participants from the desired
%conditions can be plotted. 
% 1=unstable endo, 2 = stable endo, 3 = unstable exo, 4 = stable exo.
%
% initP= "initial participant" specify which participant the plot should
% start
%
% window= time window in seconds e.g. window = [-2 1] or [-.8 09]
%
% manual = specify if you want to check manually or automatic (1=manual
% 0=automatic)
function CalcRT_Stim_Button(DATA,PARA,dataname,window,manual)


times=linspace(-250,750,1024);


breakthrough=0;

standardNoArtifactIndx=[518,520,522,530,532,539,542,544,553,570,580,582,589,598,607,627,636,648,655,657,666,669,679,681,683,688,690,695,698,709,719,741,751,756,761];
standardNoArtifactIndx=standardNoArtifactIndx(standardNoArtifactIndx>0);

fTrials=length(standardNoArtifactIndx);     
disp(fTrials);
rtIndx=0;
noRtIndx=0;


    
    for tIndx=1:fTrials

        channame=PARA.(dataname).text_channel(14,:); % button press which channel? 
        
        buttondata=DATA.(dataname)(standardNoArtifactIndx(tIndx),:,14);   % button data   
        stimdata=DATA.(dataname)(standardNoArtifactIndx(tIndx),:,[1 13]);     % stim data 
        
        timeWindowIx=findIndices(times,window); 
        windowedButtonData=buttondata(timeWindowIx(1):timeWindowIx(2));
        windowedStimData=stimdata(timeWindowIx(1):timeWindowIx(2));
%         windowedSecs=times(timeWindowIx(1):timeWindowIx(2));
        pressIndices=find(windowedButtonData<-20);
        stimIndices=find(windowedStimData< -20);
        
        if isempty(pressIndices) || isempty(stimIndices)
            reactionTime=NaN;
        else
            reactionTime=times(pressIndices(1))-times(stimIndices(1));
        end
        

        if manual
            f=figure(1); clf;  
            plotButton(times,buttondata,stimdata,window,reactionTime,channame)
            
            while 1            
                fprintf('Save reaction time (%.2f ms) of trial %d ?...\n',reactionTime, tIndx);
                reply=input('save? y/n   n=no buttonpress', 's');
                
                if ~isempty(reply) && reply(1)=='y' 
                    rtIndx=rtIndx+1;
                    RTstructure.(dataname).RT(rtIndx)=reactionTime;
                    RTstructure.(dataname).RT_Trials(rtIndx)=standardNoArtifactIndx(tIndx);                
                    assignin('base','RtStructure',RTstructure); 
                    break;
                elseif ~isempty(reply) && reply(1)=='n'
                    rtIndx=rtIndx+1;
                    fprintf('Not saved, no button press \n');
                    RTstructure.(dataname).NoButton_Trials(rtIndx)=standardNoArtifactIndx(tIndx);  
                    break;
                end
                
            end
            

                
        elseif (reactionTime <  .200 || reactionTime > .900) && manual==0 
            
                noRtIndx=noRtIndx+1;
                
                fprintf('Not saved, reaction time is lower than 200 ms: %s trial %d \n',dataname,standardNoArtifactIndx(tIndx));
                RTstructure.(dataname).noButtonTrials(noRtIndx)=standardNoArtifactIndx(tIndx); 
                
        elseif manual==0
            
                rtIndx=rtIndx+1;
                RTstructure.(dataname).RT(rtIndx)=reactionTime;
                RTstructure.(dataname).RT_Trials(rtIndx)=standardNoArtifactIndx(tIndx);
                assignin('base','RtStructure',RTstructure);                
        
                
        end
        
        % proceed to next participant if entry is b
        if breakthrough==1
            breakthrough=0;
            break;
        end           
                
    end
   
assignin('base','RtStructure',RTstructure);

fprintf('Done...');
end
    
