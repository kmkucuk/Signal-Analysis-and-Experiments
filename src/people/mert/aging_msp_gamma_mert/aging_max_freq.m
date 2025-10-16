
%% 'dataFormatting' function do not work with multiple time windows for connectivity analyses. So use one time window at a time 
% and then combine the resulting matrices manually. 
spssStructure=dataFormatting(wholeData,[1 3],[1:8],'avg_phase_diff_pli','chaninfo',[0 .25],[4 7.5],13,[],'mean');
spssStructure2=dataFormatting(wholeData,[1 3],[1:8],'avg_phase_diff_pli','chaninfo',[.25 .5],[4 7.5],13,[],'mean');
spssStructure3=dataFormatting(wholeData,[1 3],[1:8],'avg_phase_diff_pli','chaninfo',[.5 .75],[4 7.5],13,[],'mean');

%% remove the diagonal 1
for k = 1:length(spssStructure)
spssStructure(k).trig_corr_exo_8_minus0to250_6Hz = spssStructure(k).trig_corr_exo_8_minus0to250_6Hz-eye(8,8);
end

for k = 1:length(spssStructure2)
spssStructure2(k).trig_corr_exo_8_minus250to500_6Hz = spssStructure2(k).trig_corr_exo_8_minus250to500_6Hz-eye(8,8);
end

for k = 1:length(spssStructure3)
spssStructure3(k).trig_corr_exo_8_minus500to750_6Hz = spssStructure3(k).trig_corr_exo_8_minus500to750_6Hz-eye(8,8);
end


%% plot participant matrices for control 
% early window
figure(1)
set(gcf,'NumberTitle','off','Name','Older 0-250ms (4-7.5 Hz)');
for k = 1:13
    subplot(4,4,k)
    imagesc(spssStructure(k).trig_corr_exo_8_minus0to250_6Hz); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
end
% xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
% yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
set(gca,'clim',[0 .4])
colormap('jet')

figure(2)
set(gcf,'NumberTitle','off','Name','Young 0-250ms (4-7.5 Hz)');
for k = 14:26
    subplot(4,4,k-13)
    imagesc(spssStructure(k).trig_corr_exo_8_minus0to250_6Hz); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
end
set(gca,'clim',[0 .4])
colormap('jet')

% middle window
figure(3)
set(gcf,'NumberTitle','off','Name','Older 250-500ms (4-7.5 Hz)');
for k = 1:13
    subplot(4,4,k)
    imagesc(spssStructure2(k).trig_corr_exo_8_minus250to500_6Hz); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
end
% xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
% yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
set(gca,'clim',[0 .4])
colormap('jet')

figure(4)
set(gcf,'NumberTitle','off','Name','Young 250-500ms (4-7.5 Hz)');
for k = 14:26
    subplot(4,4,k-13)
    imagesc(spssStructure2(k).trig_corr_exo_8_minus250to500_6Hz); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
end
set(gca,'clim',[0 .4])
colormap('jet')


% late window
figure(5)
set(gcf,'NumberTitle','off','Name','Older 500-750ms (4-7.5 Hz)');
for k = 1:13
    subplot(4,4,k)
    imagesc(spssStructure3(k).trig_corr_exo_8_minus500to750_6Hz); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
end
% xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
% yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
set(gca,'clim',[0 .4])
colormap('jet')

figure(6)
set(gcf,'NumberTitle','off','Name','Young 500-750ms (4-7.5 Hz)');
for k = 14:26
    subplot(4,4,k-13)
    imagesc(spssStructure3(k).trig_corr_exo_8_minus500to750_6Hz); axis xy
    yticks(1:8)
    xticks(1:8)
    xticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
    yticklabels({'F3','F4','C3','C4','P3', 'P4','O1', 'O2'});
end
set(gca,'clim',[0 .4])
colormap('jet')