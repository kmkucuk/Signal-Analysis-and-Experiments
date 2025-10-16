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
function RTplot(EEG,pCount,initP,window,manual)
disp("afhba")
pCount=pCount-1;
secs=EEG(1).times.';

chans=EEG(1).chaninfo;
breakthrough=0;

markerChan = 13;
buttonChan = 14; 

for pIndx = initP:(initP+pCount)
    
    fTrials=size(EEG(pIndx).data,3);         
    disp(fTrials);
    rtIndx=0;
    noRtIndx=0;
    artStructure(pIndx).subject=EEG(pIndx).subject;
    artStructure(pIndx).condition=EEG(pIndx).condition;
    
    for tIndx=1:fTrials

        channame=EEG(pIndx).chaninfo{markerChan};
        
        stimdata=EEG(pIndx).data(:,markerChan,tIndx);   
        buttondata=EEG(pIndx).data(:,buttonChan,tIndx);      

        timeWindowIx=findIndices(secs, window); 
        
        windowedButtonData=buttondata(timeWindowIx(1):timeWindowIx(2));
        
        windowedStimData=stimdata(timeWindowIx(1):timeWindowIx(2));
                
        windowedSecs=secs(timeWindowIx(1):timeWindowIx(2));
        
        pressIndices=find(windowedButtonData<-20);
        
        stimIndices=find(windowedStimData<-2, 1);
        
        
            
            
        if isempty(pressIndices) || isempty(stimIndices)
            reactionTime=NaN;
        else
%             reactionTime=windowedSecs(pressIndices(1));
            reactionTime=windowedSecs(pressIndices(1))-windowedSecs(stimIndices(1));
        end
        

        if manual
            f=figure(pCount); clf;  
            plotButton(secs,buttondata,stimdata,window,reactionTime,channame)
            
            while 1            
                fprintf('Save reaction time (%.2f seconds) of trial %d ?...\n',reactionTime, tIndx);
                reply=input('save? y/n   n=no buttonpress', 's');
                
                if ~isempty(reply) && ~isempty(regexp(reply,'y1'))
                    rtIndx=rtIndx+1;
                    RTstructure(pIndx).subject=EEG(pIndx).subject;
                    RTstructure(pIndx).reactionTime1(rtIndx)=reactionTime;
                    RTstructure(pIndx).trialNo1(rtIndx)=tIndx;                
                    assignin('base','artf2Structure',RTstructure); 
                    break;
                elseif ~isempty(reply) && ~isempty(regexp(reply,'y2'))
                    rtIndx=rtIndx+1;
                    RTstructure(pIndx).subject=EEG(pIndx).subject;
                    RTstructure(pIndx).reactionTime2(rtIndx)=reactionTime;
                    RTstructure(pIndx).trialNo2(rtIndx)=tIndx;                
                    assignin('base','artf2Structure',RTstructure); 
                    break;                    
                elseif ~isempty(reply) && reply(1)=='n'
                    rtIndx=rtIndx+1;
                    fprintf('Not saved, no button press \n');
                    RTstructure(pIndx).subject=EEG(pIndx).subject;
                    RTstructure(pIndx).noButtonTrials(rtIndx)=tIndx;   
                    break;
                elseif ~isempty(reply) && reply(1)=='d'
                    rtIndx=rtIndx+1;
                    fprintf('Not saved, no button press \n');
                    RTstructure(pIndx).subject=EEG(pIndx).subject;
                    RTstructure(pIndx).noButtonTrials(rtIndx)=tIndx;   
                    break;                    
                elseif ~isempty(reply) && reply(1)=='b'
                    breakthrough=1;
                    fprintf('Not saved')
                    fprintf('Switching to next participant: %s ... \n',EEG(pIndx+1).subject);
                    break;    
                    
                end
                
            end
            
        elseif reactionTime>0 && manual==0
            
                rtIndx=rtIndx+1;
                RTstructure(pIndx).subject=EEG(pIndx).subject;
                RTstructure(pIndx).reactionTime(rtIndx)=reactionTime;
                RTstructure(pIndx).trialNo(rtIndx)=tIndx;                
                assignin('base','artf2Structure',RTstructure);
                
        elseif reactionTime<.250 && manual==0
            
                noRtIndx=noRtIndx+1;
                RTstructure(pIndx).subject=EEG(pIndx).subject;
                fprintf('Not saved, no button press: %s trial %d \n',EEG(pIndx).subject,tIndx);
                RTstructure(pIndx).noButtonTrials(noRtIndx)=tIndx;                  
        end
        
        % proceed to next participant if entry is b
        if breakthrough==1
            breakthrough=0;
            break;
        end           
                
    end
   fprintf('Switching to next participant: %s ... \n',EEG(pIndx+1).subject);

end
    

    
assignin('base','artf2Structure',RTstructure);

fprintf('Done...');