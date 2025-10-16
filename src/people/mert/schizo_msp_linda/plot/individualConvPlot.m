% one condition for each subject
figure(1), clf

% connectivity channels below

f4o2 = 13;
f4p4 = 11;
f3p3 = 4;
f3o1 = 6;
fhemi = 1;
chemi = 14;
phemi = 23;
ohemi = 28;
centracorticalRight = [20 22];
centracorticalLeft = [15 17];

ptoO = [25 26 27 24];

phemi = 23;
ohemi = 28;




pIndx=1;
pCount=13;
iteration=0;
clim = [-3 3];
channel = 6;
timeint = [-.2 .5];
freqint = [4 7.5];

timeIndx=findIndices(wholeData(1).times,timeint);
freqIndx=findIndices(wholeData(1).convFreqs,freqint);
freqIndx=freqIndx(1):freqIndx(2);
timeIndx=timeIndx(1):timeIndx(2);

timesPlot = wholeData(1).times(timeIndx);
freqsPlot = wholeData(1).convFreqs(freqIndx);

for i= [[1:13],[27:39]] %pIndx:pCount+pIndx-1
    iteration=iteration+1;
    subplot(ceil(26/pCount),13,iteration)    
    contourf(timesPlot,freqsPlot,wholeData(i).pli_percent(freqIndx,timeIndx,channel),20,'linecolor','none')
    hold on 
    plot([0 0],get(gca,'ylim'),'k','LineWidth',2)
%     plot([100 100],get(gca,'ylim'),'k','LineWidth',2)
%     plot([165 165],get(gca,'ylim'),'k','LineWidth',2)
%     plot([250 250],get(gca,'ylim'),'k','LineWidth',2)
%     plot([500 500],get(gca,'ylim'),'k','LineWidth',2)
    set(gca,'clim',clim) %,'xtick',[],'ytick',[]
    
    axis square
    title([ wholeData(i).subject ])
end
colormap('jet')