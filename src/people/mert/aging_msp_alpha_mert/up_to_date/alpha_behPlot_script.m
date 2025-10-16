

load('E:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\Data_Analysis\Mert_ThetaArticle\Theta\Revision_New\Behavioral_Neural_Correlations\thetaBehavioralNeuralCorrelations.mat')
figure(1)
boxScatterPlotMert(datacell,4,[12 12],{[],'Accuracy (%)'},5,12,[75:5:100],{'Older','Young'})
figure(2)
boxScatterPlotMert(datacell,6,[12 12],{[],'Reversals / Minute'},5,12,[0:3:12],{'Older','Young'})
figure(3)
boxScatterPlotMert(datacell,5,[12 12],{[],'Mean Reaction Time (s)'},5,12,[0:.3:1.2],{'Older','Young'})