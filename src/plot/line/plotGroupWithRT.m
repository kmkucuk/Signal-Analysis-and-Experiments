function plotGroupWithRT(stats,datatype,plotIndices,freqsOrTrials,channel,early,late,minVal,maxVal)


plotIteration=length(plotIndices);

linestyles={'k', 'k:','k-','k--','k-.','r', 'r:','r-','r--','r-.','b', 'b:','b-','b--',};

countStyles=length(linestyles);

times=stats(1).times;

%chose datatype


for i = 1:plotIteration
 
  if datatype(1) == 'i' || datatype(1) == 'e'
      
     data_to_plot=stats(plotIndices(i)).(datatype)(freqsOrTrials,:,channel);
     
  elseif datatype(1:3)== 'dat'
      
     data_to_plot=reshape(stats(plotIndices(i)).(datatype)(:,channel,freqsOrTrials),[length(times), length(freqsOrTrials)]);
  
  elseif datatype(1:3)== 'avg'
      
      data_to_plot=stats(plotIndices(i)).(datatype)(:,channel);
  
  end
  
    if plotIteration ==2 
        
        plot(times,data_to_plot,linestyles{i},'linewidth',3); % selects line style and colors from "linestyles" and goes back to first element after reaching the length of this vector. 
    
    else
        
        plot(times,data_to_plot,'k','linewidth',3); 
        
    end
    
hold on

end


set(gca,'box','off');

xlabel('Time (seconds)'),ylabel([datatype ' (baseline normalized)']);

hold on

RTcoordinates=[maxVal maxVal]-.05;

ytickss=linspace(minVal, maxVal, 3);

yLimss=[ytickss(1) ytickss(end)];

if early==late
    set(gca, 'XTick', unique([early 0 -1 1]));
else
    set(gca, 'XTick', unique([early late 0 -1 1]));
end

set(gca, 'YTick', sort(ytickss));

plot([-.879 -.682],RTcoordinates,'r','linewidth',3)

plot([-.638 -.551],RTcoordinates,'r:','linewidth',3)

set(gca,'xlim',[-.1 1.700],'ylim', yLimss, 'ydir','normal',...
    'FontName','Times New Roman','FontSize',20,...
    'TickDir','out','linewidth',4,'XColor',[0 0 0],'YColor',[0 0 0])

plot([0 0],get(gca,'ylim'),'k','linewidth',2)

% plot([late(1) late(1)],get(gca,'ylim'),'b:','linewidth',3)
% 
% plot([late(2) late(2)],get(gca,'ylim'),'b:','linewidth',3)
% 
% plot([early(2) early(2)],get(gca,'ylim'),'b:','linewidth',3)
% 
% plot([early(1) early(1)],get(gca,'ylim'),'b:','linewidth',3)


end

