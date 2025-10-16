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
%cScalar = scalar value, one of these values: (1,2,3,4). Scales the
%pCount iteration value so that the participants from the desired
%conditions can be plotted. 
% 1=unstable endo, 2 = stable endo, 3 = unstable exo, 4 = stable exo.
%
function PlotSingleSweeps(EEG,pCount,tCount,cScalar,channel,datatype,window,ylims)

    

secs=EEG(1).times;

% randParticipant=randperm(15,pCount); 
randParticipant=[15];
randParticipant=[randParticipant randParticipant];
% multiply condition scalar for reaching the participants in the desired
% conditions.
cScalar=cScalar-1; % minus 1 from the scalar to make condition indexing more intutive. Otherwise one had to type 0 instead of 1 for unstable endo etc. 
condition=cScalar*15;

randParticipant=condition+randParticipant;

externalFiguresDir;

for i = 1:pCount*2     
    
    if i == (length(randParticipant)/2)+1   % switch to young participants when reached half of the participant count,
                                            % meaning that elderly are completed because they consist half of the length 
                                            % of participant vector.
        
        randParticipant=randParticipant+75; % CHANGE HERE ACCORDING TO THE CONDITION COUNT (partInEachGroup*CoundCount)
        
    end
    

    pIndx=randParticipant(i);
        disp(randParticipant);
    disp(randParticipant(i));
    f=figure('visible','off','units','normalized','outerposition',[0 0 .5 1]); clf;
    
    tRange=size(EEG(pIndx).data,3);
    
%     disp(tRange);
    
    if tCount==0
        tCount=floor(tRange/2);
    end
    
    fTrials=[randperm(floor(tRange),tCount)]; 
    fTrials=sort(fTrials);
%     disp(fTrials);
    
    channame=EEG(1).chaninfo{channel};  
    
    for kk = 1:length(fTrials)        
%         subplot(ceil(sqrt(length(fTrials))),ceil(length(fTrials)/ceil(sqrt(length(fTrials)))),kk)

        subplot(length(fTrials),1,kk);
%         axes1 = axes('Parent',f);        
        data=EEG(pIndx).(datatype)(:,channel,fTrials(kk));
        plot(secs,data,'k','linew',2);
     
        
%         data=EEG(pIndx).data(:,channel,fTrials(kk));
        if kk==length(fTrials)
         set(gca,'xlim',window,'ylim', ylims, 'ydir','reverse','FontName','Times New Roman','FontSize',18,'TickDir','out',...
                'XColor',[0 0 0],'YColor',[0 0 0],'box','off','linewidth',2);
            set(gca, 'YTick', ylims);
        else
%                      set(gca,'xlim',[-1.5 .1],'ylim', [-30 30], 'ydir','reverse','FontName','Times New Roman','FontSize',18,'TickDir','out',...
%                 'XColor',[0 0 0],'YColor',[0 0 0],'box','off','linewidth',3);
            set(gca,'xlim',window,'ylim', ylims,'ydir','reverse','XColor','none','YColor','none'); 
            set(gcf, 'color','none');%%% remove axes
        end
%         title([EEG(pIndx).subject(1:5),'-',EEG(pIndx).condition(1:9),channame,'trial: ',num2str(fTrials(kk))]);
%         title([channame,'trial: ',num2str(fTrials(kk))])
        hold on
        
%         plot(get(gca,'xlim'),[0 0],'k')        
        twindow=window;
        
        IndxMax=findPeakInTimeWindow(data,twindow,secs);
        
%         plot(secs(IndxMax),data(IndxMax),'ko','linew',1.4,'MarkerSize',15)
        
        plot([0 0],get(gca,'ylim'),'k','linew',1.4)

        xlabel('Time (seconds)'), ylabel('Amplitude') 
        


%         structureVar(kk+(regGroupIndx*length(fTrials))).subject=EEG(pIndx).subject;
%         structureVar(kk+(regGroupIndx*length(fTrials))).data=data.';
%         structureVar(kk+(regGroupIndx*length(fTrials))).trialNo=fTrials(kk);
%         structureVar(kk+(regGroupIndx*length(fTrials))).times=secs;
        
    end

        % Set the remaining axes properties
%         if i ==1 && secs(IndxMax)> -.500
            saveas(f,[EEG(pIndx).subject,'-',  EEG(pIndx).condition,'.jpg']);
%         elseif secs(IndxMax)> -.300
%             saveas(f,[EEG(pIndx).subject,'-',  EEG(pIndx).condition,'_trial',num2str(length(fTrials)),'.jpg']);
%         end
        clf;
      
end
close all
% assignin('base','singleTrialData',structureVar);
fprintf('Done...');