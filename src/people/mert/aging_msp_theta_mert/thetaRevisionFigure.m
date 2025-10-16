%  load('F:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\ProcessedData\TrialData\ThetaButton\sgo153_Kn_trials.mat')
oldP=8;
oldDataRev = EEG_theta(oldP).data; 
oldDataStab = EEG_theta(oldP+15).data; 
% load('F:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\ProcessedData\TrialData\ThetaButton\sgy013_Kn_trials.mat')
youngP=31;
youngDataRev = EEG_theta(youngP).data; % first young sgy01 works fine at +17 additional trials
youngDataStab = EEG_theta(youngP+15).data;
oldContinuous = [];
youngContinuous = [];
trials = 2;
for k = 1:trials 
    additionyoung = 5;
    additionold = 0; % 6 works ok for sgo01 endo
    %old 
    oldContinuous = cat(1,oldContinuous,oldDataStab(:,2,k+additionold)); % stable
    oldContinuous = cat(1,oldContinuous,oldDataRev(:,2,k+additionold)); % unstable
    % young
    youngContinuous = cat(1,youngContinuous,youngDataStab(:,2,k+additionyoung)); % stable
    youngContinuous = cat(1,youngContinuous,youngDataRev(:,2,k+additionyoung)); % unstable 
end

oldContinuous   = smoothdata(oldContinuous);
youngContinuous = smoothdata(youngContinuous);
maxval= max([max(youngContinuous) max(oldContinuous)]);
ylim = [-maxval maxval]*1.15;

concatenateTimes = 0:.002:((trials*10)-.002);

markerColors = repmat({'k:','k'},1,trials);
areaColors  = repmat([.6 .6 .6; .8 .8 .8],trials,1);
markerY     = repmat([ylim]*.85,trials*2,1);
markers     = [3:5:(trials*10)].';
markerSeconds = repmat(markers,1,2);
% subplot(2,1,1)
for z = 1:length(markerSeconds)
hold on
plot(markerSeconds(z,:),markerY(z,:),markerColors{z},'linewidth',4)
area(markerSeconds(z,:)-[.55 0], [16 -16; 16 -16])
colororder(areaColors)
area(markerSeconds(z,:)-[.55 0], [-16 16; -16 16])
colororder(areaColors)
end
plot(concatenateTimes,oldContinuous,'r','linewidth',2)

% plot(markerSeconds-[.55 0],abs(markerY(z,:)),markerColors{z},'linewidth',4)
set(gca,'ylim',ylim, 'FontName','Helvetica','FontWeight','Bold','FontSize',...
    12,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',5,'box','off','visible','off');
subplot(2,1,2)
for z = 1:length(markerSeconds)
hold on
plot(markerSeconds(z,:),markerY(z,:),markerColors{z},'linewidth',4)
area(markerSeconds(z,:)-[.55 0], [16 -16; 16 -16])
colororder(areaColors)
area(markerSeconds(z,:)-[.55 0], [-16 16; -16 16])
colororder(areaColors)
end
plot(concatenateTimes,youngContinuous,'b','linewidth',2)

set(gca,'ylim',ylim, 'FontName','Helvetica','FontWeight','Bold','FontSize',...
    12,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',5,'box','off','visible','off');
hold off