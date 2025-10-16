function convolutionPlotSingleTrial(stats,dataindx,dataname,channel,figureName,xlimit,climit)


plotC=length(dataindx);

channame=stats(1).chaninfo{channel};

datSize=size(stats(dataindx).(dataname)(:,:,:,channel));

tCount=datSize(3);

times=stats(1).times;
% 
% savedTimes=-1.5:.010:1.5;

%%% Tick marks for freqs and time

nOfticks=6;

yticks=ceil(logspace(log10(stats(1).convFreqs(1)),log10(stats(1).convFreqs(end)),nOfticks));

% 
% savedTimesIndx=dsearchn(stats(1).times',savedTimes');
% 
% savedTimesIndx=savedTimesIndx';

freqticks=stats(1).convFreqs;



    for i = 1:tCount

        set(gcf,'Name',['ERSP at: ' channame, ' electrode'])

        subplot(ceil(tCount/ceil(sqrt(tCount))),ceil(sqrt(tCount)),i)

        contourf(times,stats(1).convFreqs,stats(dataindx).(dataname)(:,:,i,channel),20,'linecolor','none')

        colormap('jet');

        set(gca,'clim',climit,'yscale','log','xlim', xlimit,'ytick',sort(unique(yticks)));

        title([stats(dataindx).subject(1:5),' chan-',channame, ' trial-',num2str(i)]);

        hold on

        plot(get(gca,'xlim'),[0 0],'k')
        
        plot([0 0],get(gca,'ylim'),'k:')

        xlabel('Time (secs)'), ylabel('Frequencies')

    end
    
    cb=colorbar;
    cbtitle=get(cb,'Title');
    set(cbtitle,'String',"Power (mV^2)")
    set(cbtitle,'fontweight','bold','fontsize',12);
    %set colorbar ticks
    set(cb,'Ticks',linspace(climit(1),climit(2),5))
    %set colorbar position
    hp4=get(subplot(ceil(tCount/ceil(sqrt(tCount))),ceil(sqrt(tCount)),i),'position');
    set(cb,'Position', [hp4(1)+hp4(3)+.04  .35  0.022  hp4(2)+hp4(3)-.015]);
    
%        reply=input('Save figure? y/n','s');
    cycles=stats(1).convCycles(1).*(2*pi*stats(1).convFreqs(1));    
    
    fprintf('\nSaving figure: %s \n', [stats(dataindx).subject,'-',stats(dataindx).condition(1:4)]);
%%%%%%%%%%%% MANUAL ADJUSTMENT FOR STIM/BUTTON CONDITIONS %%%%%%%%%%%%
%         demarcationName='Stim';

        demarcationName='Button';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        

%     if reply=='y'
%         saveas(figureName,[dataname,'-',stats(dataindx).subject,'-',stats(dataindx).condition(1:4),'-',demarcationName,'-' ,channame, '.jpg']);                 
%     else

%         clf;
%     end 
    
    
end