gnames=repmat({'Older'},15,1);
gnames(end+1:end+15)=repmat({'Young'},15,1);


datastruct=groupLinePlot(spss_lowGamma,[1 2],[1 3 5 7 2 4 6 8]+8,4,'within','error',2,[-1 1],15,gnames,'Low Gamma Modulation (dB)')

datastruct=groupLinePlot(spss_lowGamma,[1 2],[1 3 5 7 2 4 6 8],4,'within','error',2,[-1 1],15,gnames,'Low Gamma Modulation (dB)')

datastruct=groupLinePlot(spss_highGamma,[1 2],[1 3 5 7 2 4 6 8],4,'within','error',2,[-1 1],15,gnames,'High Gamma Modulation (dB)')

datastruct=groupLinePlot(spss_highGamma,[1 2],[1 3 5 7 2 4 6 8]+8,4,'within','error',2,[-1 1],15,gnames,'High Gamma Modulation (dB)')

datastruct=groupLinePlot(spss_40Hz,[1 2],[1 3 5 7 2 4 6 8],4,'within','error',2,[-1 1],15,gnames,'Gamma Modulation (dB)')

datastruct=groupLinePlot(spss_40Hz,[1 2],[1 3 5 7 2 4 6 8]+8,4,'within','error',2,[-1 1],15,gnames,'Gamma Modulation (dB)')


%% LINE PLOT OF EACH FREQ
% three lines below are used to extract individual frequency specific time series data
wholeData=frequencySpecificTimeSeries(wholeData,[1 2 3 4 5 6 7 8],[1 2 3 4],'erspAvgROI','pairChans',[-1.5 .2],40,15);
wholeData=frequencySpecificTimeSeries(wholeData,[1 2 3 4 5 6 7 8],[1 2 3 4],'erspAvgROI','pairChans',[-1.5 .2],[],15,'wideGamma');
wholeData=frequencySpecificTimeSeries(wholeData,[1 2 3 4 5 6 7 8],[1 2 3 4],'erspAvgROI','pairChans',[-1.5 .2],[],15,'lowGamma');
wholeData=frequencySpecificTimeSeries(wholeData,[1 2 3 4 5 6 7 8],[1 2 3 4],'erspAvgROI','pairChans',[-1.5 .2],[],15,'highGamma');

% compute grand averages: ts stands for time series
ts_40Hz = computeERPGA(wholeData,'fixed40Hz_timeseries',1,15);
ts_wide = computeERPGA(wholeData,'wideGamma_timeseries',1,15);
ts_low  = computeERPGA(wholeData,'lowGamma_timeseries',1,15);
ts_high = computeERPGA(wholeData,'highGamma_timeseries',1,15);


chanIndices = [4];
subplotIndices = [1 3 5 7; 2 4 6 8];
for conds = [1 3]
    iteration = 0; 

    for chans = 1:length(chanIndices)       
         iteration = iteration +1;
        if conds == 1 
            subplot(length(chanIndices),2,subplotIndices(1,iteration))
            plot(ts_40Hz(1).times,ts_40Hz(conds).avgdata(:,chans),'r')
%             shadedErrorBar(ts_40Hz(1).times,ts_40Hz(conds).avgdata(:,chans),ts_40Hz(conds).STD(:,chans),'lineProps','k','patchSaturation',[0.1],'transparent',1)
            hold on
%             shadedErrorBar(ts_40Hz(1).times,ts_40Hz(conds+4).avgdata(:,chans),ts_40Hz(conds+4).STD(:,chans),'lineProps','b','patchSaturation',[0.1])
            
%             shadedErrorBar(ts_wide(1).times,ts_wide(conds).avgdata(:,chans),ts_wide(conds).STD(:,chans),'lineProps','r','patchSaturation',[0.1])
%             shadedErrorBar(ts_wide(1).times,ts_wide(conds+4).avgdata(:,chans),ts_wide(conds+4).STD(:,chans),'lineProps','r:','patchSaturation',[0.1])

            plot(ts_low(1).times,ts_low(conds).avgdata(:,chans),'r:')
%             plot(ts_low(1).times,ts_low(conds+4).avgdata(:,chans),'r')
%             shadedErrorBar(ts_low(1).times,ts_low(conds).avgdata(:,chans),ts_low(conds).STD(:,chans),'lineProps','r','patchSaturation',[0.1],'transparent',1)
%             shadedErrorBar(ts_low(1).times,ts_low(conds+4).avgdata(:,chans),ts_low(conds+4).STD(:,chans),'lineProps','b:','patchSaturation',[0.1])
            plot(ts_high(1).times,ts_high(conds).avgdata(:,chans),'r--')
%             shadedErrorBar(ts_high(1).times,ts_high(conds).avgdata(:,chans),ts_high(conds).STD(:,chans),'lineProps','b','patchSaturation',[0.1],'transparent',1)
%             shadedErrorBar(ts_high(1).times,ts_high(conds+4).avgdata(:,chans),ts_high(conds+4).STD(:,chans),'lineProps','b:','patchSaturation',[0.1])            
            set(gca,'ylim',[-1 1],'xlim',[-1.5 .2],'FontName','Helvetica','FontWeight','Bold','FontSize',...
                12,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',1,'box','off');
            title('Older Group')
            xlabel('Time (seconds)')
            ylabel('Occipital Gamma Modulation (dB)')
        else       
            conds=1+4;
            subplot(length(chanIndices),2,subplotIndices(2,iteration))
            plot(ts_40Hz(1).times,ts_40Hz(conds).avgdata(:,chans),'b')
%             shadedErrorBar(ts_40Hz(1).times,ts_40Hz(conds).avgdata(:,chans),ts_40Hz(conds).STD(:,chans),'lineProps','k','patchSaturation',[0.1],'transparent',1)
            hold on
%             shadedErrorBar(ts_40Hz(1).times,ts_40Hz(conds+4).avgdata(:,chans),ts_40Hz(conds+4).STD(:,chans),'lineProps','b','patchSaturation',[0.1])
            
%             shadedErrorBar(ts_wide(1).times,ts_wide(conds).avgdata(:,chans),ts_wide(conds).STD(:,chans),'lineProps','r','patchSaturation',[0.1])
%             shadedErrorBar(ts_wide(1).times,ts_wide(conds+4).avgdata(:,chans),ts_wide(conds+4).STD(:,chans),'lineProps','r:','patchSaturation',[0.1])

            plot(ts_low(1).times,ts_low(conds).avgdata(:,chans),'b:')
%             plot(ts_low(1).times,ts_low(conds+4).avgdata(:,chans),'r')
%             shadedErrorBar(ts_low(1).times,ts_low(conds).avgdata(:,chans),ts_low(conds).STD(:,chans),'lineProps','r','patchSaturation',[0.1],'transparent',1)
%             shadedErrorBar(ts_low(1).times,ts_low(conds+4).avgdata(:,chans),ts_low(conds+4).STD(:,chans),'lineProps','b:','patchSaturation',[0.1])
            plot(ts_high(1).times,ts_high(conds).avgdata(:,chans),'b--')
%             shadedErrorBar(ts_high(1).times,ts_high(conds).avgdata(:,chans),ts_high(conds).STD(:,chans),'lineProps','b','patchSaturation',[0.1],'transparent',1)
%             shadedErrorBar(ts_high(1).times,ts_high(conds+4).avgdata(:,chans),ts_high(conds+4).STD(:,chans),'lineProps','b:','patchSaturation',[0.1])            
            set(gca,'ylim',[-1 1],'xlim',[-1.5 .2],'FontName','Helvetica','FontWeight','Bold','FontSize',...
                12,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',1,'box','off');
            title('Young Group')
        end
       
    end
    
end