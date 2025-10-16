%% plot histograms 

% 1) frontal seed weighted wpli (2:4)           - averages wpli at two occipital ROIs
% 2) occipital seed weigted wpli (6:8)          - averages wpli at two frontal ROIs 
% 3) weighted all wpli (3 windows) (9:11)       - averages wpli at all ROIs
% 4) weighted interhemisp wpli (12:14)          - averages wpli at all inter-hemispheric pairs
% 5) weighted left wpli (15:17)                 - averages wpli at all left hemisphere pairs
% 6) weighted right wpli (18:20)                - averages wpli at all right hemisphere pairs
% 7) hubbness occipital (21:23)                 - avareges hubness at two occipital ROIs
% 8) hubbness frontal (24:26)                   - avareges hubness at two frontal ROIs

%% weighted wpli frontal seed
iteration = 1;
subplottitles = {'frontal seed weighted wpli','occipital seed weigted wpli','weighted all wpli',...
    'weighted interhemisp wpli','weighted left wpli','weighted right wpli','hubbness occipital'...
    ,'hubbness frontal '};
for k = 1:3:22
    
    
    
    clims = [min(aging_connectivity_data(:,k)) max(aging_connectivity_data(:,k))];
    figure('NumberTitle', 'off', 'Name', subplottitles{iteration});
    iteration = iteration+1;
    %early
    data = cat(3,aging_connectivity_data(1:13,k));
    data2 = cat(3,aging_connectivity_data(14:26,k));

    % stddata = (std(data)/sqrt(length(data)))*norminv(1-(0.05/168));
    stddata = (std(data))*norminv(1-(0.05/28));
    dataCI = mean(data)+stddata;


    % stddata2 = (std(data2)/sqrt(length(data2)))*norminv(1-(0.05/168));
    stddata2 = std(data2)*norminv(1-(0.05/28));
    data2CI = mean(data2)+stddata2;

    subplot(3,2,1)
    hist(data)
    hold on
    plot([dataCI dataCI],ylim(gca),'k:','linewidth',2)
    title('Older 0-250ms (4-7.5 Hz)');
    set(gca,'xlim',clims)
    subplot(3,2,2)
    hist(data2)
    hold on
    plot([data2CI data2CI],ylim(gca),'k:','linewidth',2)
    title('Young 0-250ms (4-7.5 Hz)');
    set(gca,'xlim',clims)

    clims = [min(aging_connectivity_data(:,k+1)) max(aging_connectivity_data(:,k+1))];
    %middle window 
    data = cat(3,aging_connectivity_data(1:13,k+1));
    data2 = cat(3,aging_connectivity_data(14:26,k+1));

    % stddata = (std(data)/sqrt(length(data)))*norminv(1-(0.05/168));
    stddata = (std(data))*norminv(1-(0.05/28));
    dataCI = mean(data)+stddata;

    % stddata2 = (std(data2)/sqrt(length(data2)))*norminv(1-(0.05/168));
    stddata2 = std(data2)*norminv(1-(0.05/28));
    data2CI = mean(data2)+stddata2;

    subplot(3,2,3)
    hist(data)
    hold on
    plot([dataCI dataCI],ylim(gca),'k:','linewidth',2)
    title('Older 250-500ms (4-7.5 Hz)');
    set(gca,'xlim',clims)

    subplot(3,2,4)
    hist(data2)
    hold on
    plot([data2CI data2CI],ylim(gca),'k:','linewidth',2)
    title('Young 250-500ms (4-7.5 Hz)');
    set(gca,'xlim',clims)

    clims = [min(aging_connectivity_data(:,k+2)) max(aging_connectivity_data(:,k+2))];
    %late window 

    data = cat(3,aging_connectivity_data(1:13,k+2));
    data2 = cat(3,aging_connectivity_data(14:26,k+2));

    % stddata = (std(data)/sqrt(length(data)))*norminv(1-(0.05/168));
    stddata = (std(data))*norminv(1-(0.05/28));
    dataCI = mean(data)+stddata;

    % stddata2 = (std(data2)/sqrt(length(data2)))*norminv(1-(0.05/168));
    stddata2 = std(data2)*norminv(1-(0.05/28));
    data2CI = mean(data2)+stddata2;


    subplot(3,2,5)
    hist(data)
    hold on
    plot([dataCI dataCI],ylim(gca),'k:','linewidth',2)
    title('Older 500-750ms (4-7.5 Hz)');
    set(gca,'xlim',clims)

    subplot(3,2,6)
    hist(data2)
    hold on
    plot([data2CI data2CI],ylim(gca),'k:','linewidth',2)
    title('Young 500-750ms (4-7.5 Hz)');
    set(gca,'xlim',clims)



%     sgtitle( subplottitles{iteration})
end