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
%This function registers all the figures created, and does not show them.
%If you want to plot and inspect your data you should use convolutionPlotConditions.

function convolutionPlotMultChannel_Save(convStats,channel,cond2plot,datatype,chanfield,time2plot,clim) 


externalDataDir;

channame=convStats(1).(chanfield){channel};

times=convStats(1).times;
% num_frex=length(stats(1).convFreqs);
nOfticks=convStats(1).convFreqs(end)-convStats(1).convFreqs(1)+2;
plotC=length(cond2plot);
% adjust scaling according to type data type: ERSP or ITPC 
% if datatype(1)=='e'
%     clim=[-3 3];
% else
%     clim=[0 .3];
% end
kk=0;

while 1

    kk=kk+1;

    if kk==length(channel)+1 
        break;
    end
     
    for i = 1:plotC  
                f=figure(1);
%                 channame=convStats(1).clusterChan{channel(kk)}; % Use this for clustered channels F-C-P-O
                channame=convStats(1).(chanfield){channel(kk)}; % Use this for regular 10 channels F3,F4,C3....
                disp(channame);
                set(gcf,'Name',[datatype,' at: ', channame, ' electrode'])
                
                subplot(ceil(plotC/ceil(sqrt(plotC))),ceil(sqrt(plotC)),i)
                    
                    if datatype(1)== 'e' || datatype(1)== 'n'
                        contourf(times,convStats(1).convFreqs,convStats(cond2plot(i)).(datatype)(:,:,channel(kk))...
                            ,100,'linecolor','none')
                    elseif datatype(1)== 'i'                        
                        contourf(times,convStats(1).convFreqs,convStats(cond2plot(i)).(datatype)(:,:,channel(kk))...
                            ,100,'linecolor','none')
                    end
                    
                colormap('jet');
                
                yticks=unique(ceil(linspace(convStats(1).convFreqs(1),convStats(1).convFreqs(end),nOfticks)));
                
                set(gca,'clim',clim,'yscale','log','xlim', time2plot,...
                    'ytick',yticks,'XColor', [0 0 0], 'YColor', [0 0 0], 'linewidth', 3.5);
                title([convStats(cond2plot(i)).group, ' ', convStats(cond2plot(i)).condition,' channel: ',channame]);
                
                if i==plotC
                    xlabel('Time (secs)'), ylabel('Frequencies')
                    set(gca,'FontName','Times New Roman','FontSize',20);
                end
                
                hold on

%                 plot(get(gca,'xlim'),[0 0],'k')
                
                plot([0 0],get(gca,'ylim'),'k','LineWidth',3)
                
                
                
    end
    % colorbar properties
    %title        
    cb=colorbar;
    cbtitle=get(cb,'Title');
    set(cbtitle,'String',"dB")
    set(cbtitle,'fontweight','bold','fontsize',12);
    %set colorbar ticks
    set(cb,'Ticks',linspace(clim(1),clim(2),5))
    %set colorbar position
    hp4=get(subplot(ceil(plotC/ceil(sqrt(plotC))),ceil(sqrt(plotC)),i),'position');
    set(cb,'Position', [hp4(1)+hp4(3)+.015  .35  0.022  hp4(2)+hp4(3)-.15]);
    %set DB title position
%     set(cbtitle,'position',[21.9500   56.2500 0]) % a little right and a little below of the color bar (example from: visual Gonogo elder study)
%     
    reply=input('Save figure? y/n','s');
    cycles=convStats(1).convCyles(1).*(2*pi*convStats(1).convFreqs(1));    
    if reply=='y'
        saveas(f,[datatype, '-' ,num2str(convStats(1).convFreqs(1))...
            '-' num2str(convStats(1).convFreqs(end)),'Hz', num2str(cycles),...
            'Cycles-', channame, '.emf']);                
    else
        fprintf('Current clim is: %d\n', clim);
        clim=input('Enter new clim [x y]\n', 's');
        clim=str2num(clim);
        kk=kk-1;
        clf;
    end
    
    
end
fprintf('Done...');
close all;