function reversalArea=topographicalGIF(convStats,conditions,timewins,freqs,datatype,ylims)

load 10chanlocs.mat

times=convStats(1).times;

chans=[1 2 3 4 5 6 9 10];

plotC=length(conditions)+2;

plotT=length(timewins)/2;
freqs=findIndices(convStats(1).convFreqs,freqs);
timeindx=findIndices(times,timewins);

plotTimes=timewins;
areaIndices=findIndices(times,[-1.5 -1 -1 -.55 -.55 0]);
% subplotIndx=[4 2  ];
h = figure('units','normalized','outerposition',[0 0 1 1]);
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'topoGIFalphaSlow.gif';
externalDataDir;

periodDuration=diff(timewins);

xtickmarks = times(areaIndices([1 2 4 6]));


times(areaIndices)
for k = 1:2:length(timewins)

data1=mean(convStats(conditions(1)).(datatype)(freqs,timeindx(k):timeindx(k+1),chans),2); % FOR ERSP 
data2=mean(convStats(conditions(2)).(datatype)(freqs,timeindx(k):timeindx(k+1),chans),2); % FOR ERSP 
%dataITC=max(convStats(conditions(i)).(datatype)(freqs,timeindx(k):timeindx(k+1),chans),[],2); % FOR ITC ANALYSES


firstPlot = subplot(plotC,2,1);    
posFirstPlot=firstPlot.Position;
firstPlot.Position = posFirstPlot+[0 -.3 0 .300];

topoplot(data1,EEG.chanlocs,'maplimits',ylims,'style','map');

secondPlot = subplot(plotC,2,2);  
postSecondPlot=secondPlot.Position;
secondPlot.Position = postSecondPlot+[0 -.3 0 .300];

topoplot(data2,EEG.chanlocs,'maplimits',ylims,'style','map');


if k == 1
    lastPlot=subplot(plotC,1,[3 4]);  
    positionlastPlot=lastPlot.Position;
    lastPlot.Position = positionlastPlot+[0 .1 0 -.300];
end

axes(lastPlot)
loadingBar=area([plotTimes(1) plotTimes(k+1)],[0 .25;0 .25],'FaceColor',[.7 .7 .7]);
hold on
set(gca,'ylim',[0 1],'ytick',[],'tickdir','out','XColor', [0 0 0],'xtick',xtickmarks, 'YColor', [0 0 0], 'linewidth', 2,'box','off','FontSize',30);

if k == 1 
    stabilityArea           = area([times(areaIndices(1)) times(areaIndices(2))],[.25 1 ;.25 1],'FaceColor',[1 1 1],'EdgeColor',[0 0 0]);
    destabilizationArea     = area([times(areaIndices(3)) times(areaIndices(4))],[.25 1 ;.25 1],'FaceColor',[1 1 1],'EdgeColor',[0 0 0]);
    reversalArea            = area([times(areaIndices(5)) times(areaIndices(6))],[.25 1 ;.25 1],'FaceColor',[1 1 1],'EdgeColor',[0 0 0]);
    set(gca,'ylim',[0 1],'ytick',[],'XColor', [0 0 0], 'YColor', [0 0 0], 'linewidth', 2,'box','off','FontSize',30);
    text(0,1.2,'BUTTON PRESS','Color','k','FontSize',20,'HorizontalAlignment','center');
    text(times(ceil(mean(areaIndices(1:2)))),.625,'NON-REVERSAL WINDOW','Color','k','FontSize',18,'HorizontalAlignment','center');
    text(times(ceil(mean(areaIndices(3:4)))),.625,'DESTABILIZATION ONSET','Color','k','FontSize',18,'HorizontalAlignment','center');
    text(times(ceil(mean(areaIndices(5:6)))),.625,'MAX DESTABILIZATION + REVERSAL','Color','k','FontSize',18,'HorizontalAlignment','center');
    reversalArea(1,1).FaceAlpha=0.8;
    reversalArea(1,2).FaceAlpha=0.8;    
    
end

plot([0 0],[0 1],'k','linewidth',5);

% loadingBar.FaceAlpha=0.8;
% destabilizationArea.FaceAlpha=.9;


xlabel('1.5 seconds before the button press >>>>')
drawnow 

      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if k == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.3); 
      end 

end

% 
% % colorbar properties
% %title        
% cb=colorbar;
% cbtitle=get(cb,'Title');
% set(cbtitle,'String',"dB")
% set(cbtitle,'fontweight','bold','fontsize',12);
% cbticks=linspace(ylims(1),ylims(2),5);
% %set colorbar ticks
% set(cb,'Ticks',cbticks);
% %set colorbar position
% hp4=get(subplot(plotC,plotT,j),'position');
% set(cb,'Position', [hp4(1)+hp4(3)+.015  .35  0.022  hp4(2)+hp4(3)-.15]);



    
