% load('F:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\Data_Processed\GammaPaper\gamma_20cyc_30epochs_buttonAverage.mat')

wholeData=findMaxFreq(wholeData,'erspAvgROI',[-1.5 0],[1 2 3 4],[28 48],'peak','wideGamma');
peakData_wideGamma = gatherTopo(wholeData,[1 3 5 7],15,'wide');
wholeData=findMaxFreq(wholeData,'erspAvgROI',[-1.5 0],[1 2 3 4],[28 37],'peak','lowGamma');
peakData_lowGamma = gatherTopo(wholeData,[1 3 5 7],15,'low');
wholeData=findMaxFreq(wholeData,'erspAvgROI',[-1.5 0],[1 2 3 4],[38 48],'peak','highGamma');
peakData_highGamma = gatherTopo(wholeData,[1 3 5 7],15,'high');

% 
% wholeData=findMaxFreq(wholeData,'erspdata',[-1.5 0],[1 2 3 4 5 6 9 10],[28 48],'peak','wideGamma');
% peakData_wideGammaStab = gatherTopo(wholeData,[2 4 6 8],15,'wide');
% 
% wholeData=findMaxFreq(wholeData,'erspdata',[-1.5 0],[1 2 3 4 5 6 9 10],[28 37],'peak','lowGamma');
% peakData_lowGammaStab = gatherTopo(wholeData,[2 4 6 8],15,'low');
% 
% wholeData=findMaxFreq(wholeData,'erspdata',[-1.5 0],[1 2 3 4 5 6 9 10],[38 48],'peak','highGamma');
% peakData_highGamma = gatherTopo(wholeData,[1 3 5 7],15,'high');

peakData_allIntervals = cell(181,15);

peakData_allIntervals(1,:) = peakData_highGamma(1,:);

peakData_allIntervals(2:61,:) = peakData_wideGamma(2:end,:);

peakData_allIntervals(62:121,:) = peakData_lowGamma(2:end,:);

peakData_allIntervals(122:end,:) = peakData_highGamma(2:end,:);
deletionInterval=[];
for k = 2:length(peakData_allIntervals)
    if peakData_allIntervals{k,15} == 0
        deletionInterval = [deletionInterval k]; 
    end
end
peakData_allIntervals(deletionInterval,:)=[];
externalDataDir;
cd([pathname '\Data_Analysis\Mert_Gamma'])
writetable(cell2table(peakData_allIntervals),'peakData.xlsx')