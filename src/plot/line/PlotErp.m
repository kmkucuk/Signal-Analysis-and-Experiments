% stats = structure variable that contains grand averaged data across
% participants for each condition.
%
%channel = which channel to plot, integer according to channel order
%
%cond2plot = array vector [1 3 4] etc. chose conditions from stats
%structure variable and then type in the numbers as a vector. 
%
%singleT= single trial or averaged plots. 0=averaged, 1=single trials
%
function PlotErp(stats,channel,cond2plot,timewin,amp,datatype) 
    
plotC=length(cond2plot);

% prepare X-ticks
if ~isempty(timewin)
        whichZero=abs(0-timewin);
else
    timewin=[secs(751) secs(1551)];
    whichZero=abs(0-timewin);
end
% create x-ticks with linspace using the timewindow
if whichZero(1)<whichZero(2)
    xTicks=linspace(0,timewin(2),(whichZero(2)/.250)+1);
else
    xTicks=linspace(timewin(1),0,(whichZero(1)/.250)+1);
end

%prepare max value 


channame=stats(1).chaninfo{channel};

f=figure('units','normalized','outerposition',[0 0 .5 1]);, clf

set(gcf,'Name',['Grand averaged ERPs of ' channame, ' electrode'])

for i = 1:plotC    
    
            twindow=findIndices(stats(cond2plot(i)).times,timewin);
            
%             for ki = 1:plotC

            maxval=max(abs(stats(cond2plot(i)).(datatype)(twindow(1):twindow(2),channel)));

%             end

            maxval=max(maxval);
            disp(maxval)
            maxval=maxval/7+maxval;
    
    
            subplot(plotC,1,i)
    
            %subplot(ceil(plotC/ceil(sqrt(plotC))),ceil(sqrt(plotC)),i)

            plot(stats(cond2plot(i)).times,stats(cond2plot(i)).(datatype)(:,channel),'k','linew',1.5);

            

            title([stats(cond2plot(i)).group, ' ', stats(cond2plot(i)).condition,' ',' channel:',channame]);

            hold on

            plot(get(gca,'xlim'),[0 0],'k')

            plot([0 0],get(gca,'ylim'),'k:')

            xlabel('Time (ms)'), ylabel('\muV')  
            
            set(gca,'xlim',timewin,'ylim',[-maxval maxval],'tickdir','out', 'ydir','reverse','box','off','XColor',[0 0 0],'YColor',[0 0 0],'linewidth', 1.5);
            
            yTicks=(linspace(-maxval,maxval,5));
            
            xticks(xTicks);
        
            yticks(yTicks);
            
end

end

