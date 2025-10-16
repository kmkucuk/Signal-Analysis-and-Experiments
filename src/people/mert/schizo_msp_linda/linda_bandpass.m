load('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\data\raw\linda_final_stimOnset_baseline.mat')
frequency = [8 12];

EEG2=filtering_mert(EEG, [1:8],'data', 'bp',frequency, 125,1);

convStats=computeERPGA(EEG2,'avgdata',1,20);
%% plot
timewindow = [-200 1000];
amplitude = [-1 1];
channel = 8;
conditions = [1 3];
PlotTimeDom(convStats,'avgdata',channel,conditions,amplitude,timewindow);



% gamma F4 are similar with linda even though artifact rejection etc were
% different. 