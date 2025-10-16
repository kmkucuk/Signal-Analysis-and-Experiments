
%% 'dataFormatting' function do not work with multiple time windows for connectivity analyses. So use one time window at a time 
% and then combine the resulting matrices manually. 

frequencyRange=[4 7.5];
pvaluedenominator = 28*3*2; % what to divide .05 with (channels * time * group or something similar)
fieldName = 'avg_phase_diff_pli';

spssStructure=dataFormatting(wholeData,[1 3],[1:8],fieldName,'chaninfo',[0 .25],frequencyRange,13,[],'mean');
spssStructure2=dataFormatting(wholeData,[1 3],[1:8],fieldName,'chaninfo',[.25 .5],frequencyRange,13,[],'mean');
spssStructure3=dataFormatting(wholeData,[1 3],[1:8],fieldName,'chaninfo',[.5 .75],frequencyRange,13,[],'mean');
% spssStructure_all=dataFormatting(wholeData,[1 3],[1:8],'avg_phase_diff_pli','chaninfo',[0 .75],frequencyRange,13,[],'mean');

dat1names = fieldnames(spssStructure);
dat2names = fieldnames(spssStructure2);
dat3names = fieldnames(spssStructure3);
% dat4names = fieldnames(spssStructure_all);
baselinecorrectedFieldName = 'pli_percent';
spssStructure_z=dataFormatting(wholeData,[1 3],[1:8],baselinecorrectedFieldName,'chaninfo',[0 .25],frequencyRange,13,[],'mean');
spssStructure2_z=dataFormatting(wholeData,[1 3],[1:8],baselinecorrectedFieldName,'chaninfo',[.25 .5],frequencyRange,13,[],'mean');
spssStructure3_z=dataFormatting(wholeData,[1 3],[1:8],baselinecorrectedFieldName,'chaninfo',[.5 .75],frequencyRange,13,[],'mean');
% spssStructure_all_z=dataFormatting(wholeData,[1 3],[1:8],'pli_percent','chaninfo',[0 .75],frequencyRange,13,[],'mean');

disp('data extracted')
%% remove the diagonal 1
for k = 1:length(spssStructure)
spssStructure(k).(dat1names{3}) = spssStructure(k).(dat1names{3})-eye(8,8);
spssStructure_z(k).(dat1names{3}) = spssStructure_z(k).(dat1names{3})-eye(8,8);
end

for k = 1:length(spssStructure2)
spssStructure2(k).(dat2names{3}) = spssStructure2(k).(dat2names{3})-eye(8,8);
spssStructure2_z(k).(dat2names{3}) = spssStructure2_z(k).(dat2names{3})-eye(8,8);
end

for k = 1:length(spssStructure3)
spssStructure3(k).(dat3names{3}) = spssStructure3(k).(dat3names{3})-eye(8,8);
spssStructure3_z(k).(dat3names{3}) = spssStructure3_z(k).(dat3names{3})-eye(8,8);
end

% for k = 1:length(spssStructure_all)
% spssStructure_all(k).(dat4names{3}) = spssStructure_all(k).(dat4names{3})-eye(8,8);
% spssStructure_all_z(k).(dat4names{3}) = spssStructure_all_z(k).(dat4names{3})-eye(8,8);
% end

disp('diagonal removed')
%% plot participant matrices for control - raw data
clims = [0 7.5];

% early window
figure(1)
set(gcf,'NumberTitle','off','Name','Older 0-250ms (4-7.5 Hz)');
for k = 1:13
    subplot(4,4,k)
    imagesc(spssStructure(k).(dat1names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')    
end
% xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
% yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});


figure(2)
set(gcf,'NumberTitle','off','Name','Young 0-250ms (4-7.5 Hz)');
for k = 14:26
    subplot(4,4,k-13)
    imagesc(spssStructure(k).(dat1names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')    
end


% middle window
figure(3)
set(gcf,'NumberTitle','off','Name','Older 250-500ms (4-7.5 Hz)');
for k = 1:13
    subplot(4,4,k)
    imagesc(spssStructure2(k).(dat2names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')        
end



figure(4)
set(gcf,'NumberTitle','off','Name','Young 250-500ms (4-7.5 Hz)');
for k = 14:26
    subplot(4,4,k-13)
    imagesc(spssStructure2(k).(dat2names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')        
end


% late window
figure(5)
set(gcf,'NumberTitle','off','Name','Older 500-750ms (4-7.5 Hz)');
for k = 1:13
    subplot(4,4,k)
    imagesc(spssStructure3(k).(dat3names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')        
end


figure(6)
set(gcf,'NumberTitle','off','Name','Young 500-750ms (4-7.5 Hz)');
for k = 14:26
    subplot(4,4,k-13)
    imagesc(spssStructure3(k).(dat3names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')        
end

%% plot participant matrices for control - z score data
clims = [0 4];

% early window
figure(1)
set(gcf,'NumberTitle','off','Name','Older 0-250ms (4-7.5 Hz)');
for k = 1:13
    subplot(4,4,k)
    imagesc(spssStructure_z(k).(dat1names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')    
end
% xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
% yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});


figure(2)
set(gcf,'NumberTitle','off','Name','Young 0-250ms (4-7.5 Hz)');
for k = 14:26
    subplot(4,4,k-13)
    imagesc(spssStructure_z(k).(dat1names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')    
end


% middle window
figure(3)
set(gcf,'NumberTitle','off','Name','Older 250-500ms (4-7.5 Hz)');
for k = 1:13
    subplot(4,4,k)
    imagesc(spssStructure2_z(k).(dat2names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')        
end



figure(4)
set(gcf,'NumberTitle','off','Name','Young 250-500ms (4-7.5 Hz)');
for k = 14:26
    subplot(4,4,k-13)
    imagesc(spssStructure2_z(k).(dat2names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')        
end


% late window
figure(5)
set(gcf,'NumberTitle','off','Name','Older 500-750ms (4-7.5 Hz)');
for k = 1:13
    subplot(4,4,k)
    imagesc(spssStructure3_z(k).(dat3names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')        
end


figure(6)
set(gcf,'NumberTitle','off','Name','Young 500-750ms (4-7.5 Hz)');
for k = 14:26
    subplot(4,4,k-13)
    imagesc(spssStructure3_z(k).(dat3names{3})); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    set(gca,'clim',clims)
    colormap('jet')        
end
%% plot histograms for connectivity bins - raw connectivity data
figure(7)
%early
data = nonzeros(cat(3,spssStructure(1:13).(dat1names{3})));

data2 = nonzeros(cat(3,spssStructure(14:26).(dat1names{3})));
% mean
% data = mean(nonzeros(cat(3,spssStructure(1:13).(dat1names{3}))),3);
% 
% data2 = mean(nonzeros(cat(3,spssStructure(14:26).(dat1names{3}))),3);

subplot(3,2,1)
hist(data)
hold on
plot([median(data) median(data)],ylim(gca),'k')
title('Older 0-250ms (4-7.5 Hz)');
set(gca,'xlim',[0.1 0.6])
subplot(3,2,2)
hist(data2)
hold on
plot([median(data2) median(data2)],ylim(gca),'k')
title('Young 0-250ms (4-7.5 Hz)');
set(gca,'xlim',[0.1 0.6])
%middle
data = nonzeros(cat(3,spssStructure2(1:13).(dat2names{3})));

data2 = nonzeros(cat(3,spssStructure2(14:26).(dat2names{3})));
% mean
% data = mean(nonzeros(cat(3,spssStructure2(1:13).(dat2names{3}))),3);
% 
% data2 = mean(nonzeros(cat(3,spssStructure2(14:26).(dat2names{3}))),3);


subplot(3,2,3)
hist(data)
hold on
plot([median(data) median(data)],ylim(gca),'k')
title('Older 250-500ms (4-7.5 Hz)');
set(gca,'xlim',[0.1 0.6])

subplot(3,2,4)
hist(data2)
hold on
plot([median(data2) median(data2)],ylim(gca),'k')
title('Young 250-500ms (4-7.5 Hz)');
set(gca,'xlim',[0.1 0.6])


%late
data = nonzeros(cat(3,spssStructure3(1:13).(dat3names{3})));
data2 = nonzeros(cat(3,spssStructure3(14:26).(dat3names{3})));

% mean
% data = mean(nonzeros(cat(3,spssStructure3(1:13).(dat3names{3}))),3);
% 
% data2 = mean(nonzeros(cat(3,spssStructure3(14:26).(dat3names{3}))),3);
subplot(3,2,5)
hist(data)
hold on
plot([median(data) median(data)],ylim(gca),'k')
title('Older 500-750ms (4-7.5 Hz)');
set(gca,'xlim',[0.1 0.6])

subplot(3,2,6)
hist(data2)
hold on
plot([median(data2) median(data2)],ylim(gca),'k')
title('Young 500-750ms (4-7.5 Hz)');
set(gca,'xlim',[0.1 0.6])



sgtitle('Connectivity Bins')
%% plot histograms for connectivity bins - z normalized- connectivity data
clims = [0 10];
figure(8)
grandstddata = norminv(1-(0.05/(28*2*3)));
%early
data = nonzeros(cat(3,spssStructure_z(1:13).(dat1names{3})));
data2 = nonzeros(cat(3,spssStructure_z(14:26).(dat1names{3})));

data = mean((cat(3,spssStructure_z(1:13).(dat1names{3}))),3);
data2 = mean((cat(3,spssStructure_z(14:26).(dat1names{3}))),3);

% stddata = (std(data)/sqrt(length(data)))*norminv(1-(0.05/168));
stddata = (std(data))*norminv(1-(0.05/28));
dataCI = mean(data)+stddata;


% stddata2 = (std(data2)/sqrt(length(data2)))*norminv(1-(0.05/168));
stddata2 = std(data2)*norminv(1-(0.05/28));
data2CI = mean(data2)+stddata2;

subplot(3,2,1)
hist(data)
hold on
plot([grandstddata grandstddata],ylim(gca),'k:','linewidth',2)
title('Older 0-250ms (4-7.5 Hz)');
set(gca,'xlim',clims)
subplot(3,2,2)
hist(data2)
hold on
plot([grandstddata grandstddata],ylim(gca),'k:','linewidth',2)
title('Young 0-250ms (4-7.5 Hz)');
set(gca,'xlim',clims)
%middle
data = nonzeros(cat(3,spssStructure2_z(1:13).(dat2names{3})));
data2 = nonzeros(cat(3,spssStructure2_z(14:26).(dat2names{3})));

data = mean((cat(3,spssStructure2_z(1:13).(dat2names{3}))),3);
data2 = mean((cat(3,spssStructure2_z(14:26).(dat2names{3}))),3);
% stddata = (std(data)/sqrt(length(data)))*norminv(1-(0.05/168));
stddata = (std(data))*norminv(1-(0.05/28));
dataCI = mean(data)+stddata;

% stddata2 = (std(data2)/sqrt(length(data2)))*norminv(1-(0.05/168));
stddata2 = std(data2)*norminv(1-(0.05/28));
data2CI = mean(data2)+stddata2;

subplot(3,2,3)
hist(data)
hold on
plot([grandstddata grandstddata],ylim(gca),'k:','linewidth',2)
title('Older 250-500ms (4-7.5 Hz)');
set(gca,'xlim',clims)

subplot(3,2,4)
hist(data2)
hold on
plot([grandstddata grandstddata],ylim(gca),'k:','linewidth',2)
title('Young 250-500ms (4-7.5 Hz)');
set(gca,'xlim',clims)


%late
data = nonzeros(cat(3,spssStructure3_z(1:13).(dat3names{3})));
data2 = nonzeros(cat(3,spssStructure3_z(14:26).(dat3names{3})));


data = mean((cat(3,spssStructure3_z(1:13).(dat3names{3}))),3);
data2 = mean((cat(3,spssStructure3_z(14:26).(dat3names{3}))),3);
% stddata = (std(data)/sqrt(length(data)))*norminv(1-(0.05/168));
stddata = (std(data))*norminv(1-(0.05/28));
dataCI = mean(data)+stddata;

% stddata2 = (std(data2)/sqrt(length(data2)))*norminv(1-(0.05/168));
stddata2 = std(data2)*norminv(1-(0.05/28));
data2CI = mean(data2)+stddata2;


subplot(3,2,5)
hist(data)
hold on
plot([grandstddata grandstddata],ylim(gca),'k:','linewidth',2)
title('Older 500-750ms (4-7.5 Hz)');
set(gca,'xlim',clims)

subplot(3,2,6)
hist(data2)
hold on
plot([grandstddata grandstddata],ylim(gca),'k:','linewidth',2)
title('Young 500-750ms (4-7.5 Hz)');
set(gca,'xlim',clims)



sgtitle('Connectivity Bins')

%% Within Subjects Statistics 

%% for actual data plotting

%early to middle change 

older_early_late = mean(cat(3,spssStructure2(1:13).(dat2names{3})) - cat(3,spssStructure(1:13).(dat1names{3})),3);
young_early_late = mean(cat(3,spssStructure2(14:26).(dat2names{3})) - cat(3,spssStructure(14:26).(dat1names{3})),3);

older_early_late = triu(older_early_late)+triu(older_early_late,1)';
young_early_late = triu(young_early_late)+triu(young_early_late,1)';

%middle to late change 

older_middle_late = mean(cat(3,spssStructure3(1:13).(dat3names{3})) - cat(3,spssStructure2(1:13).(dat2names{3})),3);
young_middle_late = mean(cat(3,spssStructure3(14:26).(dat3names{3})) - cat(3,spssStructure2(14:26).(dat2names{3})),3);

older_middle_late = triu(older_middle_late)+triu(older_middle_late,1)';
young_middle_late = triu(young_middle_late)+triu(young_middle_late,1)';

%middle to late change 

older_late_early = mean(cat(3,spssStructure3(1:13).(dat3names{3})) - cat(3,spssStructure(1:13).(dat1names{3})),3);
young_late_early = mean(cat(3,spssStructure3(14:26).(dat3names{3})) - cat(3,spssStructure(14:26).(dat1names{3})),3);

older_late_early = triu(older_late_early)+triu(older_late_early,1)';
young_late_early = triu(young_late_early)+triu(young_late_early,1)';


allData = {older_early_late, young_early_late, older_middle_late,young_middle_late,older_late_early,young_late_early};


maxDat = max(max([allData{:}]));
minDat = min(min(nonzeros([allData{:}])));
%% for thresholding 
%early 
olderData_earlyz = mean(cat(3,spssStructure_z(1:13).(dat1names{3})),3);
youngData_earlyz = mean(cat(3,spssStructure_z(14:26).(dat1names{3})),3);

olderData_earlyz = triu(olderData_earlyz)+triu(olderData_earlyz,1)';
youngData_earlyz = triu(youngData_earlyz)+triu(youngData_earlyz,1)';

%middle 
olderData_middlez = mean(cat(3,spssStructure2_z(1:13).(dat2names{3})),3);
youngData_middlez = mean(cat(3,spssStructure2_z(14:26).(dat2names{3})),3);

olderData_middlez = triu(olderData_middlez)+triu(olderData_middlez,1)';
youngData_middlez = triu(youngData_middlez)+triu(youngData_middlez,1)';

%late 
olderData_latez = mean(cat(3,spssStructure3_z(1:13).(dat3names{3})),3);
youngData_latez = mean(cat(3,spssStructure3_z(14:26).(dat3names{3})),3);

olderData_latez = triu(olderData_latez)+triu(olderData_latez,1)';
youngData_latez = triu(youngData_latez)+triu(youngData_latez,1)';

allDataz = {olderData_earlyz, youngData_earlyz, olderData_middlez,youngData_middlez,olderData_latez,youngData_latez};

maxZ = max(max([allDataz{:}]));
minZ = min(min(nonzeros([allDataz{:}])));
groupText = {'Older','Young','Older','Young','Older','Young'};
timeText = {'t1: middle-early','t1: middle-early','t2: late-middle','t2: late-middle','t3: late-early','t3: late-early'};
%% matrix plot
pvaluedenominator = 28; 
grindx = 0;
timeidx = 0;
clims = [-1 1];
figure(9)
set(gcf,'NumberTitle','off','Name','Significant Connectivity Relative to Baseline');
for k = 1:length(allDataz)
    
    grindx=grindx+1;
    timeidx=timeidx+1;
    subplot(3,2,k)    
    
    %% data plot
    dataplot = allData{k};
    imagesc(dataplot); axis xy 
    
    %% contour plot
    dataCI = 1;
    % for shading insignificant cells 
    thresplot = allDataz{k};
    thresplot(thresplot<dataCI & thresplot>0 )=0.01;
    thresplot(thresplot>=dataCI)=1;
    [maxRows, maxCols] = find(thresplot == 0.01); % not zero because upper part of the matrix is all zeros, then it shades those with white as well. 
    % for boxing significant cells
    thresplot2 = allDataz{k};
    thresplot2(thresplot2<dataCI)=0;
    thresplot2(thresplot2>=dataCI)=1;
    [maxRows2, maxCols2] = find(thresplot2 == 1); % not zero because upper part of the matrix is all zeros, then it shades those with white as well.
    
    hold on
    %significant squares
    lineWidth = 2;
    for p = 1 : length(maxRows)

      % shading the  insignificant cells 
      y1 = maxRows(p);
      y2 = maxRows(p);
      x1 = maxCols(p);
      x2 = maxCols(p);  

      Xcap = mean([x1 x2])-.5;
      Ycap = mean([y1 y2])-.5;
      % Now finally plot the box around this pixel.
      
      rectangle('Position', [Xcap, Ycap, 1, 1], ...
          'EdgeColor', [1, 1, 1, 0.7],...
                'FaceColor', [1, 1, 1, 0.6]);   
    end
    % outline for significant cells 
    for p = 1 : length(maxRows2)
      
      y11 = maxRows2(p);
      y22 = maxRows2(p);
      x11 = maxCols2(p);
      x22 = maxCols2(p);  

      Xcap2 = mean([x11 x22])-.5;
      Ycap2 = mean([y11 y22])-.5;     
      rectangle('Position', [Xcap2, Ycap2, 1, 1], ...
          'EdgeColor', [0, 0, 0, 0.7],'linewidth',2);             
    end

%     contour(1:8,1:8,thresplot,[1],'linecolor','k'); axis xy
    
    
    title([groupText{grindx},' ',timeText{timeidx},'']); % (4-7.5 Hz)
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    
    cb=colorbar;
    cbtitle=get(cb,'Title');
    set(cbtitle,'String',"wPLI")  %    \surd%\DeltaITC
    %set colorbar ticks
        set(cb,'Ticks',linspace(clims(1),clims(2),3))  
        set(gca,'clim',clims)
        colormap('jet')        
    
end
% sgtitle("Significant Increases in wPLI Relative to Baseline")
%% Topographic line plot
pvaluedenominator = 28; 
grindx = 0;
timeidx = 0;
figure(11)
plotorder = [1 3 5 2 4 6]; % used for horizontal-time subplots
for k = 1:length(allDataz)
    grindx=grindx+1;
    timeidx=timeidx+1;

    % threshold
    dataCI = norminv(1-(0.05/pvaluedenominator));
  
    thresplot = allDataz{plotorder(k)};
    
    nch = 8; %take care of this variable (nch must be according to matrix size you want to plot it)
    p = 1;   %proportion of weigthed links to keep for.
    aij = threshold_proportional(thresplot, p); %thresholding networks due to proportion p
    
    % for significant cells
    aij(aij<dataCI)=0;
    ijw = adj2edgeL(triu(aij));     %passing from matrix form to edge list form

    n_features = sum(aij, 2);       % in this case the feature is the Strenght
    cbtype = 'ncb';                 % colorbar for weigth

%     figure(k)
    subplot(2,3,k)
    if ~isempty(ijw)
        f_PlotEEG_BrainNetwork(nch, ijw, 'w_intact', n_features, 'n_fixed', cbtype,[dataCI maxZ]);
    end
    if k <4
%         title([groupText{plotorder(k)},' ',timeText{plotorder(k)},'']); % (4-7.5 Hz)
        title(timeText{plotorder(k)}); % (4-7.5 Hz)
        set(gca,'FontSize',30)
    end

end

%% colormap for topog plot

contourf(allDataz{1})

% colormap defined below
cmaps = [0 0 0; 0.25 0 0; 0.500000000000000,0,0;0.562500000000000,0,0;0.625000000000000,0,0;0.687500000000000,0,0;0.750000000000000,0,0;0.812500000000000,0,0;0.875000000000000,0,0;0.937500000000000,0,0;1,0,0;1,0.0625000000000000,0;1,0.125000000000000,0;1,0.187500000000000,0;1,0.250000000000000,0;1,0.312500000000000,0;1,0.375000000000000,0;1,0.437500000000000,0;1,0.500000000000000,0;1,0.562500000000000,0;1,0.625000000000000,0;1,0.687500000000000,0;1,0.750000000000000,0;1,0.812500000000000,0;1,0.875000000000000,0;1,0.937500000000000,0;1,1,0;0.937500000000000,1,0.0625000000000000;0.875000000000000,1,0.125000000000000;0.812500000000000,1,0.187500000000000;0.750000000000000,1,0.250000000000000;0.687500000000000,1,0.312500000000000;0.625000000000000,1,0.375000000000000;0.562500000000000,1,0.437500000000000;0.500000000000000,1,0.500000000000000;0.437500000000000,1,0.562500000000000;0.375000000000000,1,0.625000000000000;0.312500000000000,1,0.687500000000000;0.250000000000000,1,0.750000000000000;0.187500000000000,1,0.812500000000000;0.125000000000000,1,0.875000000000000;0.0625000000000000,1,0.937500000000000;0,1,1;0,0.937500000000000,1;0,0.875000000000000,1;0,0.812500000000000,1;0,0.750000000000000,1;0,0.687500000000000,1;0,0.625000000000000,1;0,0.562500000000000,1;0,0.500000000000000,1;0,0.437500000000000,1;0,0.375000000000000,1;0,0.312500000000000,1;0,0.250000000000000,1;0,0.187500000000000,1;0,0.125000000000000,1;0,0.0625000000000000,1;0,0,1;0,0,0.937500000000000;0,0,0.875000000000000;0,0,0.812500000000000;0,0,0.750000000000000;0,0,0.687500000000000;0,0,0.625000000000000;0,0,0.562500000000000];
cmaps(28:end,:)=[];


% colorbar properties
cb=colorbar;
cbtitle=get(cb,'Title');
colormap(cmaps)
colormap(flip(cmaps))
set(gca,'clim',[dataCI maxZ])
set(cb,'Ticks',linspace(dataCI,maxZ,3))
set(cbtitle,'String',"Z(wPLI)")


% sgtitle('Significant Increases in wPLI Relative to Baseline')
%% hubbness plot
figure(11)
grindx = 0;
timeidx = 0;
if ~exist('chanlocs','var')
    load('chanLocations_8.mat')
end
for k = 1:length(allDataz)
    grindx=grindx+1;
    timeidx=timeidx+1;
    

    subplot(3,2,k)   
    
    
    data = nonzeros(allDataz{k});
%     stddata = (std(data)/sqrt(length(data)))*norminv(1-(0.05/168));
%     dataCI = mean(data)+stddata;
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
    
    thresplot = allDataz{k};
    thresplot = thresplot > dataCI;
%     plotdata(plotdata<dataCI)=0;
%     plotdata(plotdata>=dataCI)=1;  
    
    % compute "hubness"
    hubness = sum(thresplot) /7;


    % some visualizations
    topoplotIndie(hubness,chanlocs,'numcontour',0);
    
    title([groupText{grindx},' ',timeText{timeidx},' (4-7.5 Hz)']);

    set(gca,'clim',[0 1])
    colormap('jet')        
end



%%%
%%%
%%% DATA EXTRACTION FOR ANALYSES BELOW %%%
%%%
%%%


% parantheses indicate the columns of the extracted scores
% three columns indicate: early (0 250), middle (250 500), and late windows (500 750)

% 1) frontal seed weighted wpli (2:4)           - averages wpli at two occipital ROIs
% 2) occipital seed weigted wpli (6:8)          - averages wpli at two frontal ROIs 
% 3) weighted all wpli (3 windows) (9:11)       - averages wpli at all ROIs
% 4) weighted interhemisp wpli (12:14)          - averages wpli at all inter-hemispheric pairs
% 5) weighted left wpli (15:17)                 - averages wpli at all left hemisphere pairs
% 6) weighted right wpli (18:20)                - averages wpli at all right hemisphere pairs
% 7) hubbness occipital (21:23)                 - avareges hubness at two occipital ROIs
% 8) hubbness frontal (24:26)                   - avareges hubness at two frontal ROIs



%% 1 weighted WPLI with significant networks for statistical analysis (frontal seed connectivity)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1 2];

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
% threshold 
    data = spssStructure_z(k).(dat1names{3});
    data2 = spssStructure2_z(k).(dat2names{3});
    data3 = spssStructure3_z(k).(dat3names{3});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';
    
    thresplot = data(channelInterval,:);
    thresplot2 = data2(channelInterval,:);
    thresplot3 = data3(channelInterval,:);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;
    
    plotchan=length(find(thresplot==1))/2;
    plotchan2=length(find(thresplot2==1))/2;
    plotchan3=length(find(thresplot3==1))/2;
    
% SELECT DATA TYPE ACCORDING TO YOUR PREFERENCE; comment undesirable
% wpli data 
    data = spssStructure(k).(dat1names{3});
    data2 = spssStructure2(k).(dat2names{3});
    data3 = spssStructure3(k).(dat3names{3});
% z data
%     data = spssStructure_z(k).(dat1names{3});
%     data2 = spssStructure2_z(k).(dat2names{3});
%     data3 = spssStructure3_z(k).(dat3names{3});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';    
    
    
    data = data(channelInterval,:);
    data2 = data2(channelInterval,:);
    data3 = data3(channelInterval,:);
    
    % compute pli from all pairs of the seed 
%     wwpli = [sum(data(:)) sum(data2(:)) sum(data3(:))]./14; 
    
    % compute weighted wpli (within-subject channel count correction)
    
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./14 ;     
    
    wwpli(isnan(wwpli))=0;
    analysisStructure(k).subject = spssStructure2(k).subject;
    analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_wwpli_f = wwpli(1);
    analysisStructure(k).middle_wwpli_f = wwpli(2);
    analysisStructure(k).late_wwpli_f = wwpli(3);
    
    
end

%% 2 weighted WPLI with significant networks for statistical analysis (occipital seed connectivity)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [7 8];

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
% threshold 
    data = spssStructure_z(k).(dat1names{3});
    data2 = spssStructure2_z(k).(dat2names{3});
    data3 = spssStructure3_z(k).(dat3names{3});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';
    
    thresplot = data(channelInterval,:);
    thresplot2 = data2(channelInterval,:);
    thresplot3 = data3(channelInterval,:);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;
    
    plotchan=length(find(thresplot==1))/2;
    plotchan2=length(find(thresplot2==1))/2;
    plotchan3=length(find(thresplot3==1))/2;
% SELECT DATA TYPE ACCORDING TO YOUR PREFERENCE    
% wpli data 
    data = spssStructure(k).(dat1names{3});
    data2 = spssStructure2(k).(dat2names{3});
    data3 = spssStructure3(k).(dat3names{3});
% z data
%     data = spssStructure_z(k).(dat1names{3});
%     data2 = spssStructure2_z(k).(dat2names{3});
%     data3 = spssStructure3_z(k).(dat3names{3});
    
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';    
    
    
    data = data(channelInterval,:);
    data2 = data2(channelInterval,:);
    data3 = data3(channelInterval,:);
    
    % compute pli from all pairs of the seed 
%     wwpli = [sum(data(:)) sum(data2(:)) sum(data3(:))]./14; 
    
    % compute weighted wpli from significant ones (within-subject channel count correction)
    
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./14;     
    
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_wwpli_o = wwpli(1);
    analysisStructure(k).middle_wwpli_o = wwpli(2);
    analysisStructure(k).late_wwpli_o = wwpli(3);
    
    
end

%% 



%% 3 weighted WPLI with significant networks for statistical analysis (all connectivity-3windows)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = 1:8;

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
% threshold 
    data = spssStructure_z(k).(dat1names{3});
    data2 = spssStructure2_z(k).(dat2names{3});
    data3 = spssStructure3_z(k).(dat3names{3});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';
    
    thresplot = data(channelInterval,channelInterval);
    thresplot2 = data2(channelInterval,channelInterval);
    thresplot3 = data3(channelInterval,channelInterval);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;
    
    plotchan=length(find(thresplot==1))/2;
    plotchan2=length(find(thresplot2==1))/2;
    plotchan3=length(find(thresplot3==1))/2;
% SELECT DATA TYPE ACCORDING TO YOUR PREFERENCE; comment undesirable
% wpli data 
    data = spssStructure(k).(dat1names{3});
    data2 = spssStructure2(k).(dat2names{3});
    data3 = spssStructure3(k).(dat3names{3});
% % z data
%     data = spssStructure_z(k).(dat1names{3});
%     data2 = spssStructure2_z(k).(dat2names{3});
%     data3 = spssStructure3_z(k).(dat3names{3});
        
    
    data = data(channelInterval,channelInterval);
    data2 = data2(channelInterval,channelInterval);
    data3 = data3(channelInterval,channelInterval);
    
    % compute pli from all pairs of the seed 
%     wwpli = [sum(data(:)) sum(data2(:)) sum(data3(:))]./14;     
    
    % compute weighted wpli (within-subject channel count correction)
    
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./28 ;     
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_wwpli_all = wwpli(1);
    analysisStructure(k).middle_wwpli_all = wwpli(2);
    analysisStructure(k).late_wwpli_all = wwpli(3);
end

%%




%% 4 weighted WPLI with significant networks for statistical analysis (inter-hemispheric)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval1 = [1 3 5 7];
channelInterval2 = [2 4 6 8];
for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
% threshold 
    data = spssStructure_z(k).(dat1names{3});
    data2 = spssStructure2_z(k).(dat2names{3});
    data3 = spssStructure3_z(k).(dat3names{3});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';
    
    thresplot = data(channelInterval1,channelInterval2);
    thresplot2 = data2(channelInterval1,channelInterval2);
    thresplot3 = data3(channelInterval1,channelInterval2);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;
    
    plotchan=length(find(thresplot==1));
    plotchan2=length(find(thresplot2==1));
    plotchan3=length(find(thresplot3==1));
% SELECT DATA TYPE ACCORDING TO YOUR PREFERENCE; comment undesirable
% wpli data 
    data = spssStructure(k).(dat1names{3});
    data2 = spssStructure2(k).(dat2names{3});
    data3 = spssStructure3(k).(dat3names{3});
% z data
%     data = spssStructure_z(k).(dat1names{3});
%     data2 = spssStructure2_z(k).(dat2names{3});
%     data3 = spssStructure3_z(k).(dat3names{3});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';    
    
    data = data(channelInterval1,channelInterval2);
    data2 = data2(channelInterval1,channelInterval2);
    data3 = data3(channelInterval1,channelInterval2);
    
    % compute pli from all pairs of the seed 
%     wwpli = [sum(data(:)) sum(data2(:)) sum(data3(:))]./16; 
    
    % compute weighted wpli (within-subject channel count correction)
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 
    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./16 ; 
    
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_wwpli_hemi = wwpli(1);
    analysisStructure(k).middle_wwpli_hemi = wwpli(2);
    analysisStructure(k).late_wwpli_hemi = wwpli(3);
end
%%




%% 5 weighted WPLI with significant networks for statistical analysis (left-hemispheric)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1 3 5 7];

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
% threshold 
    data = spssStructure_z(k).(dat1names{3});
    data2 = spssStructure2_z(k).(dat2names{3});
    data3 = spssStructure3_z(k).(dat3names{3});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';
    
    thresplot = data(channelInterval,channelInterval);
    thresplot2 = data2(channelInterval,channelInterval);
    thresplot3 = data3(channelInterval,channelInterval);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;
    
    plotchan=length(find(thresplot==1))/2;
    plotchan2=length(find(thresplot2==1))/2;
    plotchan3=length(find(thresplot3==1))/2;
% SELECT DATA TYPE ACCORDING TO YOUR PREFERENCE; comment undesirable
% wpli data 
    data = spssStructure(k).(dat1names{3});
    data2 = spssStructure2(k).(dat2names{3});
    data3 = spssStructure3(k).(dat3names{3});
% z data
%     data = spssStructure_z(k).(dat1names{3});
%     data2 = spssStructure2_z(k).(dat2names{3});
%     data3 = spssStructure3_z(k).(dat3names{3});
    
    data = data(channelInterval,channelInterval);
    data2 = data2(channelInterval,channelInterval);
    data3 = data3(channelInterval,channelInterval);
    
    % compute pli from all pairs of the seed 
%     wwpli = [sum(data(:)) sum(data2(:)) sum(data3(:))]./6; 
    
    % compute weighted wpli (within-subject channel count correction)
    
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./6; 
    
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_wwpli_left = wwpli(1);
    analysisStructure(k).middle_wwpli_left = wwpli(2);
    analysisStructure(k).late_wwpli_left = wwpli(3);
end

%%





%% 6 weighted WPLI with significant networks for statistical analysis (right-hemispheric)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1 3 5 7]+1;

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
% threshold 
    data = spssStructure_z(k).(dat1names{3});
    data2 = spssStructure2_z(k).(dat2names{3});
    data3 = spssStructure3_z(k).(dat3names{3});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';
    
    thresplot = data(channelInterval,channelInterval);
    thresplot2 = data2(channelInterval,channelInterval);
    thresplot3 = data3(channelInterval,channelInterval);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;
    
    plotchan=length(find(thresplot==1))/2;
    plotchan2=length(find(thresplot2==1))/2;
    plotchan3=length(find(thresplot3==1))/2;
% SELECT DATA TYPE ACCORDING TO YOUR PREFERENCE; comment undesirable
% wpli data 
    data = spssStructure(k).(dat1names{3});
    data2 = spssStructure2(k).(dat2names{3});
    data3 = spssStructure3(k).(dat3names{3});
% z data
%     data = spssStructure_z(k).(dat1names{3});
%     data2 = spssStructure2_z(k).(dat2names{3});
%     data3 = spssStructure3_z(k).(dat3names{3});
    
    data = data(channelInterval,channelInterval);
    data2 = data2(channelInterval,channelInterval);
    data3 = data3(channelInterval,channelInterval);
        
    % compute pli from all pairs of the seed 
%     wwpli = [sum(data(:)) sum(data2(:)) sum(data3(:))]./6;     
    % compute weighted wpli (within-subject channel count correction)
    
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./6; 
    
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_wwpli_right = wwpli(1);
    analysisStructure(k).middle_wwpli_right = wwpli(2);
    analysisStructure(k).late_wwpli_right = wwpli(3);
end


%% 7 hubbness for statistical analysis (occipital ROIs)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [7 8];
for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));

    data = spssStructure_z(k).(dat1names{3});
    data2 = spssStructure2_z(k).(dat2names{3});
    data3 = spssStructure3_z(k).(dat3names{3});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';
    
    thresplot = data(channelInterval,:);
    thresplot2 = data2(channelInterval,:);
    thresplot3 = data3(channelInterval,:);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;

    
    % compute "hubness"
    hubbness = [mean(sum(thresplot,2)) mean(sum(thresplot2,2)) mean(sum(thresplot3,2))]./7 ; 
    
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_o = hubbness(1);
    analysisStructure(k).middle_hub_o = hubbness(2);
    analysisStructure(k).late_hub_o = hubbness(3);
end
%%





%% 8 hubbness for statistical analysis (frontal ROIs)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1 2];
for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));

    data = spssStructure_z(k).(dat1names{3});
    data2 = spssStructure2_z(k).(dat2names{3});
    data3 = spssStructure3_z(k).(dat3names{3});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';
    
    thresplot = data(channelInterval,:);
    thresplot2 = data2(channelInterval,:);
    thresplot3 = data3(channelInterval,:);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;

    
    % compute "hubness"
    hubbness = [mean(sum(thresplot,2)) mean(sum(thresplot2,2)) mean(sum(thresplot3,2))]./7 ; 
    
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_f = hubbness(1);
    analysisStructure(k).middle_hub_f = hubbness(2);
    analysisStructure(k).late_hub_f = hubbness(3);
end


cd('F:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\Data_Processed\ConnectivityICON')
writetable(struct2table(analysisStructure),'aging_connectivity_statistics.xlsx');

% transform struct variable for further processing (e.g. plotting etc.)

aging_connectivity_data=struct2cell(analysisStructure);

aging_connectivity_data=reshape(aging_connectivity_data,size(aging_connectivity_data,1),size(aging_connectivity_data,3)).';
aging_connectivity_data = aging_connectivity_data(:,3:end);
% aging_connectivity_data=cell2mat(aging_connectivity_data(:,3:end)); % 3rd column to end because 1st and 2nd columns are subjects and groups, respectively


