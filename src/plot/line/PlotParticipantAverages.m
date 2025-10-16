% stats = structure variable that contains grand averaged data across
% participants for each condition.
%
%channel = channel vector e.g. [1 3 5 15]
%
%cond2plot = which conditions to plot e.g. =4 or =3. (scales with 15,
%because I had 15 participants in each group; adjust if necessary)  
%
%Beware that I've deleted stable trials from the EEG structure variable
%when I was plotting via this script. This means that there were only 60
%datasets within the EEG variable. Whole code is based on the absence of
%stable trials both in endo and exo conditins
%
%structure variable and then type in the numbers as a vector. (e.g.
%exogenous, endogenous etc.) 
%
%This function registers all the figures created, and does not show them.
%If you want to plot and inspect your data you should use PlotErp.
%
% timewin= e.g. [-1 .5] -1000 ms to +500 ms time window plot
function PlotParticipantAverages(EEG,channels,cond2plot,pcount,timewin,amp,datatype) 
% 
% secs=-3:1/500:2;
% % secs(:,end)=[];
% % secs(:,EEG(1).baselineIdx(1):EEG(1).baselineIdx(2))=[];
secs=EEG(1).times;
plotC=length(cond2plot);

% time window adjustment, enter empty vector if you do not want to specify a time window, then the
% scrip will use every time point

    if ~isempty(timewin)
        whichZero=abs(0-timewin);
    else
        timewin=[secs(751) secs(1551)];
        whichZero=abs(0-timewin);
    end
    
    if whichZero(1)<whichZero(2)
        xTicks=linspace(0,timewin(2),(whichZero(2)/.250)+1);
    else
        xTicks=linspace(timewin(1),0,(whichZero(1)/.250)+1);
    end

externalFiguresDir;

grandData=[];
prtcolor=[];
lgndarray=[]; 
%%% assign RGB color for each of 30 participants 

for i = 1:30
    prtcolor(i,:)=rand(1,3);
end

for i = 1:plotC  
    
    f=figure('visible','off'); clf;
    
    itsc=cond2plot(i)-1;    %%% -1 is required, otherwise script starts from the subsequent condition instead of the specified one.
    


    for ci = 1:length(channels)
        
        if exist('datatype','var') && datatype(1)=='c'

            channame=EEG(cond2plot(i)*15).clusterChan{channels(ci)};  

        else

            channame=EEG(cond2plot(i)*15).chaninfo{channels(ci)};  

        end 
    
%         subplot(ceil(length(channel)/ceil(sqrt(length(channel)))),ceil(sqrt(length(channel))),kk)        
        
        set(gcf,'Name',['Participant averages (' channame, ') electrode'])  
        
        for prt = 1:15   
            
            disp(prt+(itsc*15))
            % uncomment below conditions if you want to exclude people
            if EEG(prt+(itsc*15)).usedInAnalysis==1
                data=EEG(prt+(itsc*15)).(datatype)(10,:,channels(ci));
                
                plot(secs,data,'k','linew',1.1,'color', [.6 .6 .6]);
                
                grandData=cat(3,grandData,data);
%                 if i<plotC/2+1
%                     pp.Color=prtcolor((prt),:);
%                 else                        
%                     pp.Color=prtcolor(prt+15,:);
%                 end                   

                hold on
            end
        end
              grandData=mean(grandData,3);
              plot(secs,grandData,'k','linew',1.3,'color', [0 0 0]);
%         for li = 1:15
%             
%             if i<plotC/2+1 && EEG(li+(itsc*15)).usedInAnalysis==1
%                
%                 lgndarray=[lgndarray;EEG(li).subject(1:5)]; 
%                
%             elseif EEG(li+(itsc*15)).usedInAnalysis==1
%                 
%                 lgndarray=[lgndarray;EEG(li+(length(EEG)/plotC)).subject(1:5)];
%                 
%             end
%             
%         end
%         
%         legend1=legend(lgndarray);
%         posleg1=get(legend1,'position');
%         posleg1(1)=posleg1(1)+.1;
%         set(legend1,'position',posleg1);
%         lgndarray=[];
%         

        
        yTicks=(linspace(amp(1),amp(2),5));
        
        set(gca,'xlim',[timewin],'ylim', amp,'tickdir','out', 'ydir','reverse','box','off','XColor',[0 0 0],'YColor',[0 0 0],'linewidth', 1.3);
        
        xticks(xTicks);
        
        yticks([yTicks]);
        
                
        
        title([EEG(cond2plot(i)*15).group(1:2), ' ', EEG(cond2plot(i)*15).condition(1:5),' ',...
      'channel: ',channame]);
  
%         title([EEG(plotC*15).group, ' ', EEG(plotC*15).condition,' ',...
%       'channel: ',channame]);

        hold on

%         plot(get(gca,'xlim'),[0 0],'k')

        plot([0 0],get(gca,'ylim'),'k:','linew',1.2)


        xlabel('Seconds'), ylabel('\muV')                       
        
        saveas(f,['ParticipantAverages_',EEG(cond2plot(i)*15).condition(1:5),'_',EEG(cond2plot(i)*15).condition(9:13),'_',channame,num2str(i), '.jpg']);
        
        clf;  
    end
    grandData=[];

end

close all;