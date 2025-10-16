% stats = structure variable that contains grand averaged data across
% participants for each condition.
%
%channel = channel vector e.g. [1 3 5 10]
%
%cond2plot = array vector [1 3 4] etc. chose conditions from stats
%structure variable and then type in the numbers as a vector. (e.g.
%exogenous, endogenous etc.) 
%
%datatype= 'itpc' or 'ersp'. 
%
%time2plot= specify the time range you want to plot e.g. -1 1 plots -1
%seconds to 1 seconds around the zero 
%
%freqlim= limits of frequencies [8 14] alpha freq etc.
%
%This function registers all the figures created, and does not show them.
%If you want to plot and inspect your data you should use convolutionPlotConditions.

function convolutionPlotSameFigure(convStats,channel,cond2plot,datatype,chanfield,time2plot,clim,freqlim) 


externalDataDir;
if ~isempty(freqlim)        
    freqs=convStats(1).convFreqs;
    freqIndices=findIndices(freqs,freqlim);
else 
    freqPoints=[];
end
freqIndices

chanCount=length(channel);
times=convStats(1).times;
% num_frex=length(stats(1).convFreqs);
% nOfticks=convStats(1).convFreqs(end)-convStats(1).convFreqs(1)+2;
nOfticks=6;
plotC=length(cond2plot);
% adjust scaling according to type data type: ERSP or ITPC 
% if datatype(1)=='e'
%     clim=[-3 3];
% else
%     clim=[0 .3];
% end
kk=0;
pindx=0;
while 1

    kk=kk+1;

    if kk==length(channel)+1 
        break;
    end
     
    for i = 1:plotC  
        pindx=pindx+1;
        
                channame=convStats(cond2plot(i)).(chanfield){channel(kk)}; % Use this for regular 10 channels F3,F4,C3....
%                 channame=convStats(cond2plot(i)).(chanfield)(channel(kk)).labels; % Use this for regular 10 channels F3,F4,C3....
                disp(channame);
%                 set(gcf,'Name',[datatype,' at: ', channame, ' electrode'])
                % for group comps
                splots(pindx)=subplot(chanCount,plotC,pindx);
                % for pair-wise channels (f3-f4 (left/right)...)
%                 splots(pindx)=subplot(chanCount/2,2,pindx);  
%                     if datatype(1)== 'e' || datatype(1)== 'n'
                        contourf(times,convStats(cond2plot(i)).convFreqs(freqIndices(1):freqIndices(2)),convStats(cond2plot(i)).(datatype)(freqIndices(1):freqIndices(2),:,channel(kk))...
                            ,40,'linecolor','none')
%                     elseif datatype(1)== 'i'                        
                        contourf(times,convStats(cond2plot(i)).convFreqs(freqIndices(1):freqIndices(2)),convStats(cond2plot(i)).(datatype)(freqIndices(1):freqIndices(2),:,channel(kk))...
                            ,40,'linecolor','none')
%                     end
                    
                colormap('jet');
%                 yticks=[4 5 6 7 8];
                yticks=unique(ceil(linspace(convStats(1).convFreqs(freqIndices(1)),convStats(1).convFreqs(freqIndices(2)),nOfticks)));
                xticks=unique([sort([linspace(time2plot(1),time2plot(2),5)]),0]);
%                 xticks=[-250 0  250 500 750];
%                 xticks=[-1.5 -1 -.5 0];
%                 yticks=[1 4 7 8 12 20 28 40 48];
%                 xticks=[-200 0 250 500 750 1000]; %,'yscale','log'
                set(gca,'clim',clim,'ytick',yticks,'xlim',time2plot,'xtick',xticks,'yscale','linear',... %
                    'XColor', [0 0 0], 'YColor', [0 0 0], 'linewidth', 3.5,'tickdir','out');
%                 title([convStats(cond2plot(i)).group(1:3), ' ', convStats(cond2plot(i)).condition,' ', channame]);
                title(['cond: ' convStats(cond2plot(i)).condition ' chan:' channame]);
%                 title([convStats(cond2plot(i)).group(1:3), ' ', convStats(cond2plot(i)).condition(1:3),' ',convStats(cond2plot(i)).condition(10:13),' ', channame]);
% 
%                 if pindx <=2
%                     title([convStats(cond2plot(i)).group, ' ', convStats(cond2plot(i)).condition(1:3),' ',convStats(cond2plot(i)).condition(10:13)]);
%                 end
                xticklabels({''});
                yticklabels({''});
%                 if pindx == 1
%                     text([-.9 -.9],[13.5 13.5],channame,'Color','k','FontSize',15,'FontWeight','bold','HorizontalAlignment','center')
%                 elseif mod(pindx,length(channel))==1 || mod(pindx,length(channel))== 3
%                     text([-.9 -.9],[13.5 13.5],channame,'Color','k','FontSize',15,'FontWeight','bold','HorizontalAlignment','center')
%                 end
%%% UNCOMMENT BELOW %%%
%                 if pindx+1>=chanCount*plotC
%                     if kk==1
%                         title([convStats(cond2plot(i)).condition])
                    if kk==length(channel) 
%                         if pindx == 8
                            xlabel('Time (ms)'), ylabel('Frequency (Hz)')
%                         end
                        set(gca,'clim',clim,'ytick',yticks,'xtick',xticks,'yscale','linear','xlim', time2plot,...
                    'tickdir','out','XColor',[0 0 0], 'YColor', [0 0 0], 'linewidth', 3.5);
%                     xticklabels({'-1','-.5','0'});
                    yticklabels({yticks});
                    xticklabels({xticks});
%                     xticklabels({'-200','0','250','500','750'});
                    end
                    set(gca,'FontName','Arial','FontSize',12);
%
%                     set(gca,'clim',clim,'yscale','log','xlim', time2plot,...
%                     'tickdir','out','XColor',[0 0 0], 'YColor', [0 0 0], 'linewidth', 3.5);

%                 end
                
%%%
                hold on

%                 plot(get(gca,'xlim'),[0 0],'k')
                
                plot([0 0],get(gca,'ylim'),'k','LineWidth',3)
%                 plot([-1.5 -1.5],get(gca,'ylim'),'k:','LineWidth',3)
%                 plot([-1  -1],get(gca,'ylim'),'k:','LineWidth',3)
%                 plot([-.5 -.5],get(gca,'ylim'),'k:','LineWidth',3)
                
                
                
    end
      

end
    cb=colorbar;
%     cbtitle=get(cb,'Title');
%     set(cbtitle,'String',"db")  %    \surd%\DeltaITC
%     set(cbtitle,'fontweight','bold','fontsize',12);
    %set colorbar ticks
    set(cb,'Ticks',linspace(clim(1),clim(2),3))
    %set colorbar position
    hp4=get(splots(end),'Position');
    set(cb,'Position', [hp4(1)+hp4(3)+.03  .25  0.022  0.5]); %  .35   hp4(2)+hp4(3)-.15
%     set DB title position
    set(cbtitle,'position',[5 175 0]) % a little right and a little below of the color bar (example from: visual Gonogo elder study)
  
    
fprintf('Done...');
% close all;