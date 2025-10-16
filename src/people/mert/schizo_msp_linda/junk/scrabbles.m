figure(3)    
contourf(timesPlot,freqsPlot,wholeData(93).erspAvgROI(freqIndx,timeIndx,channel),40,'linecolor','none')
set(gca,'clim',[-1 1],'xtick',[],'ytick',[])
axis square
title([ 's' num2str(i-pIndx+1) ])
colormap('jet')
