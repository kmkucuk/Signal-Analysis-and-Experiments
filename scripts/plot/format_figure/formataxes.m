function formataxes(yLims,xAxes,ydir,xtickCount,ytickCount,xlabels,yLabel)
%
%
%
% Example use : formataxes([-1.5 1.5],[-1.5 .5],'normal',6,5,sort(unique([linspace(-1.5,.5,5),0])));
%
%
% if ~exist('ylabel','var') 
%     ylabels=[];
% end
% 
% if ~exist('xlabel','var') 
%     xlabels=[];
% end


hold on

% plot(xAxes(1):xAxes(end),yLims(1):yLims(end),'k:','linewidth',3);
plot3([xAxes(1)-1 xAxes(end)+1],[0 0],[-1 -1],'k:','linewidth',3); % z= -1 -1 because 0 line has to be behind data lines
set(gca,'xlim',[xAxes(1)-1 xAxes(end)+1],'ylim', [yLims(1) yLims(2)], 'ydir',ydir,... 
    'FontName','Helvetica','FontSize',18,...
    'TickDir','out','linewidth',4,'XColor',[0 0 0],'YColor',[0 0 0]) %%[xAxes(1)-1 xAxes(end)+1]
set(gca,'box','off'); 
xtickss=sort(unique(linspace(xAxes(1),xAxes(end),xtickCount)));
% x ticks with 0 is below
% xtickss=sort(unique([linspace(xAxes(1),xAxes(end),xtickCount),0]));
% xtickss=[]; % comment this is if you want tickmarks 
if abs(max(yLims))<1 && abs(max(yLims))>0
    ytickss=round(sort(unique([linspace(yLims(1),yLims(2),ytickCount),0])),2);
else
    ytickss=round(sort(unique([linspace(yLims(1),yLims(2),ytickCount),0])),1);
end
set(gca, 'XTick',xtickss,'YTick',ytickss);
ylabel(yLabel); % 'Theta Amplitude (\muV)'
% xlabel(xlabels);
xticklabels(xlabels);
xtickangle(0)
end

