cd('E:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\Data_Processed\ConnectivityICON')
load('aging_connectivity_boxplot_data.mat')
aging_connectivity_data = num2cell(aging_connectivity_data);
groupingVariable  = [repmat(1,[1,13]) repmat(2,[1,13])]; % grouping variable: 1s are older 2s are younger adults




fontsize=28;
figure(1)
%% frontal seed weighted wpli 
% datastruct=groupLinePlot(spss_schizo_itpc,[1 2],[1 2 3 4],4,'between','error',2,[0 9],20,groupingVariable,'\surd%\DeltaITC');
subplot(2,2,1)

xaxis = barScatterConditions(aging_connectivity_data,[1 2 3],[13 13],{[],"wPLI"},5,fontsize,[0 .1 .2 .3 .4 .5],{'t1','t2','t3'});
title('Frontal Seed (wPLI)');
%% occipital seed weigted wpli 
subplot(2,2,2)

xaxis = barScatterConditions(aging_connectivity_data,[1 2 3]+3,[13 13],{[],""},5,fontsize,[0 .1 .2 .3 .4 .5],{'t1','t2','t3'});
title('Occipital Seed (wPLI)');

%% hubbness frontal
subplot(2,2,3)

xaxis = barScatterConditions(aging_connectivity_data,[1 2 3]+21,[13 13],{[],"Hubbness"},5,fontsize,[0 .25 .5 .75 1],{'t1','t2','t3'});
xlabel('Time Windows (ms)')
title('Frontal (Hubbness)');

%% hubbness occipital 
subplot(2,2,4)

xaxis = barScatterConditions(aging_connectivity_data,[1 2 3]+18,[13 13],{[],""},5,fontsize,[0 .25 .5 .75 1],{'t1','t2','t3'}); %'0-250','250-500','500-750'
xlabel('Time Windows (ms)')
title('Occipital (Hubbness)');



figure(2)
%% 3 weighted all wpli
subplot(2,2,1)
xaxis = barScatterConditions(aging_connectivity_data,[1 2 3]+6,[13 13],{[],"wPLI"},5,fontsize,[0 .1 .2 .3 .4 .5],{'0-250','250-500','500-750'});
title('wPLI: Grand Averaged ');

%% 4 weighted interhemisp wpli
subplot(2,2,2)
xaxis = barScatterConditions(aging_connectivity_data,[1 2 3]+9,[13 13],{[],"wPLI"},5,fontsize,[0 .1 .2 .3 .4 .5],{'0-250','250-500','500-750'});
title('wPLI: Interhemispheric ');
%% 5 weighted left wpli
subplot(2,2,3)
xaxis = barScatterConditions(aging_connectivity_data,[1 2 3]+12,[13 13],{[],"wPLI"},5,fontsize,[0 .1 .2 .3 .4 .5],{'0-250','250-500','500-750'});
title('wPLI: Left Hemishpere ');
xlabel('Time Windows (ms)')
%% 6 weighted right wpli
subplot(2,2,4)
xaxis = barScatterConditions(aging_connectivity_data,[1 2 3]+15,[13 13],{[],"wPLI"},5,fontsize,[0 .1 .2 .3 .4 .5],{'0-250','250-500','500-750'});
title('wPLI: Right Hemishpere ');
xlabel('Time Windows (ms)')




