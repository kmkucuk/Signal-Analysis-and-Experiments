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
% buttonThreshold = time point where a blue vertical line is drawn that marks the
% closest button press that is acceptable
%
% artifactThreshold = time point where a red vertical line is drawn that marks the
% closest artifact that is acceptable

function ArtifactRejectionPlot(EEG,initP,pCount,ylim,xlim,buttonThreshold,artifactThreshold)
scale=100;
halfscale=scale/2;
secs=EEG(1).times;
EOGchan=13;
Buttonchan=14;
Markerchan=12;
chans=EEG(1).chaninfo;
breakthrough=0;

for pIndx = initP:(initP+pCount)    
    
    fTrials=size(EEG(pIndx).data,3);         
    disp(fTrials);
    artfIndx=0;
    artStructure(pIndx).subject=EEG(pIndx).subject;
    artStructure(pIndx).condition=EEG(pIndx).condition;
    
    for tIndx=1:fTrials
        
      f=figure(pCount); clf;
      
        for chanidx=1:13
%             subplot(12,1,chanidx);            

            channame=EEG(pIndx).chaninfo{chanidx};
            data=(EEG(pIndx).data(:,chanidx,tIndx)*(halfscale/ylim(2)))+(chanidx-1)*scale;
                        
            if chanidx==12 % EOG
                channame=EEG(pIndx).chaninfo{EOGchan};  
                maxval=max(abs(EEG(pIndx).data(:,EOGchan,tIndx)));
                maxval=maxval+maxval/5;
                normalizedMax=(ylim(2)/maxval);
                plot(secs,(EEG(pIndx).data(:,EOGchan,tIndx)*(halfscale/ylim(2)))+(scale*(chanidx-1)),'r','linew',1.1);
%                 set(gca,'xlim',xlim,'ylim', [-maxval maxval], 'ydir','reverse');
                
            elseif chanidx==11 % Button Press
                
                channame=EEG(pIndx).chaninfo{Buttonchan};                
                maxval=max(abs(EEG(pIndx).data(:,Buttonchan,tIndx)));
                maxval=maxval+maxval/5;
                normalizedMax=(ylim(2)/maxval);
%                 set(gca,'xlim',xlim,'ylim', [-maxval maxval+.001], 'ydir','reverse','xtick',[]);
                plot(secs,(EEG(pIndx).data(:,Buttonchan,tIndx)*normalizedMax*(halfscale/ylim(2))+(scale*(chanidx-1))),'b','linew',1.5);
            
            elseif chanidx==13 % Stim Marker
                
                channame=EEG(pIndx).chaninfo{Markerchan};                
                maxval=max(abs(EEG(pIndx).data(:,Markerchan,tIndx)));
                maxval=maxval+maxval/5;
                normalizedMax=(ylim(2)/maxval);
%                 set(gca,'xlim',xlim,'ylim', [-maxval maxval+.001], 'ydir','reverse','xtick',[]);
                plot(secs,(EEG(pIndx).data(:,Markerchan,tIndx)*normalizedMax*(halfscale/ylim(2))+(scale*(chanidx-1))),'k','linew',3);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%% UNCOMMENT IF YOU ARE CHECKING ARBITRARY ONSET %%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 hold on 
%                 xdata=zeros(2500,1);
%                 xdata(EEG(pIndx).arbitraryIndx(tIndx))=-100;
%                 plot(secs,(xdata*normalizedMax*(halfscale/ylim(2))+(scale*(chanidx-1))),'r','linew',3.5);
                
            elseif chanidx<11 
                plot(secs,data,'k','linew',1);
                
            end               
            
            hold on
            plot([buttonThreshold buttonThreshold],get(gca,'ylim'),'b')
            plot([artifactThreshold artifactThreshold],get(gca,'ylim'),'r')
            plot([-1000 -1000],get(gca,'ylim'),'k')
            plot([1000 1000],get(gca,'ylim'),'k')
%             ylabel(channame);
               
                if  chanidx==12 
                   set(gca,'xlim',xlim,'ylim',[ylim(1)-scale/2 ylim(2)+(scale*12.5)],'tickdir','out','ydir','reverse','FontSize',35);
                   yticks([0:scale:(scale*12)])
                   yticklabels({'F3','F4','C3','C4','P3', 'P4', 'T5', 'T6', 'O1', 'O2', 'Button-Press','Stim-Onset','EOG'});
                   xlabel('Time (ms)')
                   plot([0 0],get(gca,'ylim'),'k:','linewidth',2);
                   plot([.5 .5],get(gca,'ylim'),'k:','linewidth',2);
                   plot([1 1],get(gca,'ylim'),'k:','linewidth',2);
%                    ylabel('Channels')
                end

                if chanidx==1
                    title(['Trial: ' num2str(tIndx) ' of  part:', EEG(pIndx).subject(1:5),EEG(pIndx).condition]);
                else               
                    
                end

        end  
        
        while 1
            reply=input('remove? y/n', 's');
            
            if ~isempty(reply) && reply(1)=='y' 
                artfIndx=artfIndx+1;
                artStructure(pIndx).artifactIndex(artfIndx)=tIndx;               
                fprintf('Trial %d is an artifact',tIndx);                
                fprintf('Saving trial info...');
                assignin('base','artfStructure',artStructure); 
                break;
            elseif ~isempty(reply) && reply(1)=='n'
                break;
            elseif ~isempty(reply) && reply(1)=='b'
                breakthrough=1;
                break;                
            end
        end
        % proceed to next participant if entry is b
        if breakthrough==1
            breakthrough=0;
            break;
        end
            
        
        
    end
   

end
    

    


fprintf('Done...');