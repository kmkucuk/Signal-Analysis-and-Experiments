cycles = [repmat(3,1,6) repmat(6,1,8) repmat(7,1,12) repmat(12,1,28) repmat(14,1,41)]; % for delta, theta, alpha, beta, and gamma respectively for each repmat
load('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\data\raw\lindaSchizo_newArtfRejection.mat')
%% Synchrony
% remove participants with low epochs etc. 
removeVector = [];
for k = 1:length(ALLEEG)
    
   if ALLEEG(k).usedInAnalysis == 0
       removeVector = [removeVector k];
   end
   
end
ALLEEG(removeVector)=[];

% remove channels for laplacian and connectivity
for k = 1:length(ALLEEG) %[1:20,41:60]
ALLEEG(k).data = ALLEEG(k).data(:,[1 2 3 4 5 6 9 10],:);
end

for k = 1:length(ALLEEG)
ALLEEG(k).chaninfo = ALLEEG(k).chaninfo([1 2 3 4 5 6 9 10]);
end

timeIndx = dsearchn(ALLEEG(1).times',[-.5 1.5]');
timeIndx = timeIndx(1):timeIndx(2);
for k = 1:length(ALLEEG)
ALLEEG(k).data = ALLEEG(k).data(timeIndx,:,:);
ALLEEG(k).times = ALLEEG(k).times(timeIndx);
end




for k = 1:length(wholeData)
wholeData(k).chaninfo = wholeData(k).chaninfo([1 2 3 4 5 6 9 10]);
end



%% for condition averaged baseline
for k = 22:22+20
EEG(k).data=cat(3,EEG(k).data,EEG(k+42).data);
end
for k = 106:106+20
EEG(k).data=cat(3,EEG(k).data,EEG(k+42).data);
end


% wholeData=convolveCrossConditionBaseline(EEG,[1 48],[.5],[1 2 3 4 5 6 9 10],cycles,[-1000 0],[1 3],21);
wholeData=convolveCrossConditionBaseline(EEG,[1 48],[.5],[1 2 3 4 5 6 9 10],cycles,[-1000 0],[1 3 5 7],21);

wholeData=averageROIs(wholeData,[1 2 3 4 5 6 9 10],2,'erspdata','erspAvgROI');

computeConvolutionGA(wholeData,'erspAvgROI','pairChans',21,0)
%% PLOTS
%% PLOT OPTIONS
stylename='MultiLinda';
sOption= hgexport('readstyle',stylename);
sOption.Format='tiff';

 
%% ENDOGENOUS
figure(1)
convolutionPlotSameFigure(convStats,[1 2 3 4],[1 5],'erspAvgROI','pairChans',[-1000 200],[-2 2],[1 8]);
cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')
hgexport(gcf,'deltaTheta_endo.tiff',sOption);


figure(2)
convolutionPlotSameFigure(convStats,[1 2 3 4],[1 5],'erspAvgROI','pairChans',[-1000 200],[-1.5 1.5],[8 14]);
cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')
hgexport(gcf,'alpha_endo.tiff',sOption);

figure(3)
convolutionPlotSameFigure(convStats,[1 2 3 4],[1 5],'erspAvgROI','pairChans',[-1000 200],[-1 1],[14 28]);
cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')

hgexport(gcf,'beta_endo.tiff',sOption);

figure(4)
convolutionPlotSameFigure(convStats,[1 2 3 4],[1 5],'erspAvgROI','pairChans',[-1000 200],[-1 1],[28 48]);
cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')

hgexport(gcf,'gamma_endo.tiff',sOption);

figure(5)
convolutionPlotSameFigure(convStats,[1 2 3 4],[1 5],'erspAvgROI','pairChans',[-1000 200],[-1 1],[1 48]);
cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')

hgexport(gcf,'full_endo.tiff',sOption);

%% EXOGENOUS

figure(6)
convolutionPlotSameFigure(convStats,[1 2 3 4],[3 7],'erspAvgROI','pairChans',[-1000 200],[-2 2],[1 8]);
cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')

hgexport(gcf,'deltaTheta_exo.tiff',sOption);
figure(7)
convolutionPlotSameFigure(convStats,[1 2 3 4],[3 7],'erspAvgROI','pairChans',[-1000 200],[-1.5 1.5],[8 14]);
cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')

hgexport(gcf,'alpha_exo.tiff',sOption);
figure(8)
convolutionPlotSameFigure(convStats,[1 2 3 4],[3 7],'erspAvgROI','pairChans',[-1000 200],[-1 1],[14 28]);
cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')

hgexport(gcf,'beta_exo.tiff',sOption);

figure(9)
convolutionPlotSameFigure(convStats,[1 2 3 4],[3 7],'erspAvgROI','pairChans',[-1000 200],[-.5 .5],[28 48]);
cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')

hgexport(gcf,'gamma_exo.tiff',sOption);

figure(10)
convolutionPlotSameFigure(convStats,[1 2 3 4],[3 7],'erspAvgROI','pairChans',[-1000 200],[-1 1],[1 48]);
cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')

hgexport(gcf,'full_exo.tiff',sOption);

close('all')