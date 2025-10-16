% stats = structure variable that contains grand averaged data across
% participants for each condition.
%
%channel = channel vector e.g. [1 3 5 10]
%
%cond2plot = array vector [1 3 4] etc. chose conditions from stats
%structure variable and then type in the numbers as a vector. (e.g.
%exogenous, endogenous etc.) 
%
%time2plot = specify the seconds you want to plot e.g. [-2 1]
%This function registers all the figures created, and does not show them.
%If you want to plot and inspect your data you should use PlotErp.
%
% amp = y limits
function PlotTimeDom(stats,dataname,channel,cond2plot,amp,time2plot) 

times=stats(1).times;

% externalFiguresDir;

plotC=length(cond2plot);
set(0,'DefaultAxesColor','none')
for kk = 1:length(channel)
            
    f=figure(2); clf
    
    for i = 1:plotC  
        
                channame=stats(1).chaninfo{channel(kk)};
                
                set(gcf,'Name',['Alpha' channame, ' electrode'])
                
                subplot(ceil(plotC/ceil(sqrt(plotC))),ceil(sqrt(plotC)),i)
%                 subplot(1,3,i)
                plot(stats(cond2plot(i)).times,stats(cond2plot(i)).(dataname)(:,channel(kk),1),'Color',hex2rgb('#ED7D31'),'linew',2);
                title([stats(cond2plot(i)).condition,' ',...
                    stats(cond2plot(i)).condition(1:3),' ',channame]);
                
%                 title([stats(cond2plot(i)).group, ' ', stats(cond2plot(i)).condition,' ',...
%                     stats(cond2plot(i)).condition(1:3),' channel: ',channame]);
set(gca,'color','none')
                hold on
                set(gca,'xlim',time2plot,'ylim', amp, 'ydir','reverse','FontSize',10,...
    'TickDir','out','linewidth',4,'XColor',[0 0 0],'YColor',[0 0 0],'box','off');
                set(gca, 'XTick', sort(unique([linspace(time2plot(1),time2plot(2),5),0])));
                set(gca, 'YTick', sort([amp 0]));
%                 plot(get(gca,'xlim'),[0 0],'k','linewidth',1.5)
% 
%                 plot([0 0],get(gca,'ylim'),'k:','linewidth',2)
% 
%                 xlabel('Zaman (saniye)'), ylabel('Genlik')
%                 
    end
%     while 1 
%         y=input('continue? Y/N','s');
%         if y == 'y'
%             break;
%         else
%         end
%     end
%     saveas(f,[stats(cond2plot(i)).condition(1:10) '_TimeDom_' channame '_' stats(cond2plot(i)).group(1:3) '.jpg']);

end

% close all;