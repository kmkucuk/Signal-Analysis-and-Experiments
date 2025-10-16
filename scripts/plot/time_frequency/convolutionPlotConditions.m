function convolutionPlotConditions(stats,channel,cond2plot,figNum)

plotC=length(cond2plot);

channame=stats(1).chaninfo{channel};

num_frex=length(stats(1).convFreqs);

figure(figNum), clf

set(gcf,'Name',['ERSP at ' channame, ' electrode']);

clim=[-3 3];
    for i = 1:plotC    

                subplot(ceil(plotC/ceil(sqrt(plotC))),ceil(sqrt(plotC)),i)

                contourf(stats(1).timesArbitrary,stats(1).convFreqs,stats(cond2plot(i)).erspdata(:,:,1,channel),100,'linecolor','none')

                colormap('jet');

                set(gca,'clim',clim,'yscale','log','xlim', [-.1 2],'ylim',[4 8])

                set(gca,'ytick',[4 5 6 7 8]);
                %ceil(logspace(log10(1),log10(num_frex),8))
                title([stats(cond2plot(i)).group, ' ', stats(cond2plot(i)).condition,' channel:',channame]);

                hold on

                plot(get(gca,'xlim'),[0 0],'k') %%% draw dashed line at button press, x = zero 
                
                plot([0 0],get(gca,'ylim'),'k:')

                xlabel('Time (ms)'), ylabel('Frequencies')            
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
end


