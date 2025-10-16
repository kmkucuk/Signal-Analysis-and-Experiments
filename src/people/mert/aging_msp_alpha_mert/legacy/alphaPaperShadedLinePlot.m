externalFiguresDir;

    f=figure(2); clf;
    channel=4;
    shadedErrorBar(convStats(1).times,convStats(3).erspAvgROI(41,:,channel),convStats(3).STD(41,:,channel),'lineProps','r');
    hold on
    shadedErrorBar(convStats(1).times,convStats(7).erspAvgROI(41,:,channel),convStats(7).STD(41,:,channel),'lineProps','b');
    set(gca,'xlim',[-1.5 1],'ylim',[-2 2], 'ydir','normal','FontName','Helvetica','FontSize',8,...
    'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',4);
%     set(f,'PaperUnits','centimeters','PaperPosition',[7.7920 10.9670 6.0060 6.0060],'PaperSize',[6 6])
    ylabel('Alpha Modulation (dB)')
    xlabel('Time (seconds)')
    hold on
    plot([-1.5 1],[0 0],'k:','linewidth',3);
    plot([0 0],get(gca,'ylim'),'k','linewidth',2);
%     saveas(f,['shadedError_',convStats(1).pairChans{i},'_exo.jpg']);  
%     saveas(f,['shadedError_',convStats(1).pairChans{i},'_exo.fig']);  

% hold on
%  plot([-.95 -.95],get(gca,'ylim'),'k','linewidth',2)
%  plot([-.65 -.65],get(gca,'ylim'),'k','linewidth',2)
%  
%  plot([-.35 -.35],get(gca,'ylim'),'k','linewidth',2)
%  plot([-.05 -.05],get(gca,'ylim'),'k','linewidth',2)
%  
%  
%  plot([.3 .3],get(gca,'ylim'),'k','linewidth',2)
%  plot([.6 .6],get(gca,'ylim'),'k','linewidth',2)