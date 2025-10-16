%% Between subjects comparisons (occipital z)
     
%early 
spss_early=zeros(26,1);

for k = 1:length(spssStructure_z)
    spss_early(k) = mean(nonzeros(spssStructure_z(k).(dat1names{2})(:,7:8)));
end

%middle 

spss_middle=zeros(26,1);
for k = 1:length(spssStructure2_z)
    spss_middle(k) = mean(nonzeros(spssStructure2_z(k).(dat2names{2})(:,7:8)));
end

%late 
spss_late=zeros(26,1);
for k = 1:length(spssStructure3_z)
    spss_late(k) = mean(nonzeros(spssStructure3_z(k).(dat3names{2})(:,7:8)));
end

groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
for k = 1:26
    analysisStructure(k).subject = spssStructure2(k).subject;
    analysisStructure(k).group = groupnames{k};
    analysisStructure(k).earlycon_z_o = spss_early(k);
    analysisStructure(k).middcon_z_o = spss_middle(k);
    analysisStructure(k).latecon_z_o = spss_late(k);
    
end


%% Between subjects comparisons (frontal z)

%early 
spss_early=zeros(26,1);

for k = 1:length(spssStructure_z)
    spss_early(k) = mean(nonzeros(spssStructure_z(k).(dat1names{2})(1:2,:)));
end

%middle 

spss_middle=zeros(26,1);
for k = 1:length(spssStructure2_z)
    spss_middle(k) = mean(nonzeros(spssStructure2_z(k).(dat2names{2})(1:2,:)));
end

%late 
spss_late=zeros(26,1);
for k = 1:length(spssStructure3_z)
    spss_late(k) = mean(nonzeros(spssStructure3_z(k).(dat3names{2})(1:2,:)));
end

groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
for k = 1:26
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_z_f = spss_early(k);
    analysisStructure(k).middcon_z_f = spss_middle(k);
    analysisStructure(k).latecon_z_f = spss_late(k);
    
end


%% Between subjects comparisons (frontal wpli)

%early 
spss_early=zeros(26,1);

for k = 1:length(spssStructure_z)
    spss_early(k) = mean(nonzeros(spssStructure(k).(dat1names{2})(1:2,:)));
end

%middle 

spss_middle=zeros(26,1);
for k = 1:length(spssStructure2_z)
    spss_middle(k) = mean(nonzeros(spssStructure2(k).(dat2names{2})(1:2,:)));
end

%late 
spss_late=zeros(26,1);
for k = 1:length(spssStructure3_z)
    spss_late(k) = mean(nonzeros(spssStructure3(k).(dat3names{2})(1:2,:)));
end

groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
for k = 1:26
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_wpli_f = spss_early(k);
    analysisStructure(k).middcon_wpli_f = spss_middle(k);
    analysisStructure(k).latecon_wpli_f = spss_late(k);
    
end

%% Between subjects comparisons (occipital wpli)

%early 
spss_early=zeros(26,1);

for k = 1:length(spssStructure_z)
    spss_early(k) = mean(nonzeros(spssStructure(k).(dat1names{2})(:,7:8)));
end

%middle 

spss_middle=zeros(26,1);
for k = 1:length(spssStructure2_z)
    spss_middle(k) = mean(nonzeros(spssStructure2(k).(dat2names{2})(:,7:8)));
end

%late 
spss_late=zeros(26,1);
for k = 1:length(spssStructure3_z)
    spss_late(k) = mean(nonzeros(spssStructure3(k).(dat3names{2})(:,7:8)));
end

groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
for k = 1:26
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_wpli_o = spss_early(k);
    analysisStructure(k).middcon_wpli_o = spss_middle(k);
    analysisStructure(k).latecon_wpli_o = spss_late(k);
    
end

%% 



%% hubbness for statistical analysis (occipital ROIs)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [7 8];
for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));

    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
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
% writetable(struct2table(analysisStructure),'aging_connectivity_hub_occipital.xlsx');
%% hubbness for statistical analysis (central ROIs)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [3 4];
for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));

    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
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
    hubbness = [mean(sum(thresplot,2)) mean(sum(thresplot2,2)) mean(sum(thresplot3,2))]./7 ; % 7 for F4, 6 for F3 = total of 13 channels
    
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_f = hubbness(1);
    analysisStructure(k).middle_hub_f = hubbness(2);
    analysisStructure(k).late_hub_f = hubbness(3);
end


%% hubbness for statistical analysis (left-hemi only)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1 3 5 7];
for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));

    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
   
    thresplot = data(channelInterval,channelInterval);
    thresplot2 = data2(channelInterval,channelInterval);
    thresplot3 = data3(channelInterval,channelInterval);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;

    
    % compute "hubness"
    hubbness = [sum(sum(thresplot,2)) sum(sum(thresplot2,2)) sum(sum(thresplot3,2))]./6 ; % 7 for F4, 6 for F3 = total of 13 channels
    
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_left = hubbness(1);
    analysisStructure(k).middle_hub_left = hubbness(2);
    analysisStructure(k).late_hub_left = hubbness(3);
end

%% hubbness for statistical analysis (right-hemi only)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1 3 5 7]+1;

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));

    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
   
    thresplot = data(channelInterval,channelInterval);
    thresplot2 = data2(channelInterval,channelInterval);
    thresplot3 = data3(channelInterval,channelInterval);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;

    
    % compute "hubness"
    hubbness = [sum(sum(thresplot,2)) sum(sum(thresplot2,2)) sum(sum(thresplot3,2))]./6 ; % 7 for F4, 6 for F3 = total of 13 channels
    
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_right = hubbness(1);
    analysisStructure(k).middle_hub_right = hubbness(2);
    analysisStructure(k).late_hub_right = hubbness(3);
end

%% weighted WPLI with significant networks for statistical analysis (inter-hemispheric)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval1 = [1 3 5 7];
channelInterval2 = [2 4 6 8];
for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
%% threshold 
    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
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
%% wpli data 
    data = spssStructure(k).(dat1names{2});
    data2 = spssStructure2(k).(dat2names{2});
    data3 = spssStructure3(k).(dat3names{2});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';    
    
    data = data(channelInterval1,channelInterval2);
    data2 = data2(channelInterval1,channelInterval2);
    data3 = data3(channelInterval1,channelInterval2);
    
    % compute weighted wpli (within-subject channel count correction)
    wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 
    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./16 ; 
    
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_wwpli_hemi = wwpli(1);
    analysisStructure(k).middle_hub_wwpli_hemi = wwpli(2);
    analysisStructure(k).late_hub_wwpli_hemi = wwpli(3);
end

%% weighted WPLI with significant networks for statistical analysis (right-hemispheric)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1 3 5 7]+1;

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
%% threshold 
    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
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
%% wpli data 
    data = spssStructure(k).(dat1names{2});
    data2 = spssStructure2(k).(dat2names{2});
    data3 = spssStructure3(k).(dat3names{2});
    
    data = data(channelInterval,channelInterval);
    data2 = data2(channelInterval,channelInterval);
    data3 = data3(channelInterval,channelInterval);
        
    % compute weighted wpli (within-subject channel count correction)
    
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./6 ; 
    
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_wwpli_right = wwpli(1);
    analysisStructure(k).middle_hub_wwpli_right = wwpli(2);
    analysisStructure(k).late_hub_wwpli_right = wwpli(3);
end

%% weighted WPLI with significant networks for statistical analysis (left-hemispheric)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1 3 5 7];

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
%% threshold 
    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
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
%% wpli data 
    data = spssStructure(k).(dat1names{2});
    data2 = spssStructure2(k).(dat2names{2});
    data3 = spssStructure3(k).(dat3names{2});
    
    data = data(channelInterval,channelInterval);
    data2 = data2(channelInterval,channelInterval);
    data3 = data3(channelInterval,channelInterval);
    
    % compute weighted wpli (within-subject channel count correction)
    
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./6 ; 
    
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_wwpli_left = wwpli(1);
    analysisStructure(k).middle_hub_wwpli_left = wwpli(2);
    analysisStructure(k).late_hub_wwpli_left = wwpli(3);
end

%% weighted WPLI with significant networks for statistical analysis (all connectivity-3windows)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = 1:8;

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
%% threshold 
    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
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
%% wpli data 
    data = spssStructure(k).(dat1names{2});
    data2 = spssStructure2(k).(dat2names{2});
    data3 = spssStructure3(k).(dat3names{2});
    
    data = data(channelInterval,channelInterval);
    data2 = data2(channelInterval,channelInterval);
    data3 = data3(channelInterval,channelInterval);
    
    % compute weighted wpli (within-subject channel count correction)
    
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./28 ;     
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_wwpli_all = wwpli(1);
    analysisStructure(k).middle_hub_wwpli_all = wwpli(2);
    analysisStructure(k).late_hub_wwpli_all = wwpli(3);
end


%% weighted WPLI with significant networks for statistical analysis (all connectivity-wide window 0 750 ms)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1:8];

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
%% threshold 
    data = spssStructure_all_z(k).(dat4names{2});

    
    data = triu(data)+triu(data,1)';
    
    thresplot = data(channelInterval,channelInterval);
    
    thresplot = thresplot > dataCI;
    
    plotchan=length(find(thresplot==1))/2;

%% wpli data 
    data = spssStructure_all(k).(dat4names{2});
    
    data = data(channelInterval,channelInterval);
    
   
    % compute weighted wpli (within-subject channel count correction)
    
    wwpli = sum(data(thresplot))/plotchan;  

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = (sum(data(thresplot)))./28 ; 
    
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).wide_hub_wwpli_all = wwpli;

end
cd('E:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\Data_Processed\ConnectivityICON')
writetable(struct2table(analysisStructure),'aging_connectivity_statistics.xlsx');



%% weighted WPLI with significant networks for statistical analysis (Fronto-central connectivity)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = 1:4;

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
%% threshold 
    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
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
%% wpli data 
    data = spssStructure(k).(dat1names{2});
    data2 = spssStructure2(k).(dat2names{2});
    data3 = spssStructure3(k).(dat3names{2});
    
    data = data(channelInterval,channelInterval);
    data2 = data2(channelInterval,channelInterval);
    data3 = data3(channelInterval,channelInterval);
    
    % compute weighted wpli (within-subject channel count correction)
    
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./6 ;     
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_wwpli_fc = wwpli(1);
    analysisStructure(k).middle_hub_wwpli_fc = wwpli(2);
    analysisStructure(k).late_hub_wwpli_fc = wwpli(3);
end

%% weighted WPLI with significant networks for statistical analysis (anterior-posterior connectivity)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval1 = [1 2];
channelInterval2 = [5 6 7 8];
for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
%% threshold 
    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
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
%% wpli data 
    data = spssStructure(k).(dat1names{2});
    data2 = spssStructure2(k).(dat2names{2});
    data3 = spssStructure3(k).(dat3names{2});
    
    data = triu(data)+triu(data,1)';
    data2 = triu(data2)+triu(data2,1)';
    data3 = triu(data3)+triu(data3,1)';    
    
    data = data(channelInterval1,channelInterval2);
    data2 = data2(channelInterval1,channelInterval2);
    data3 = data3(channelInterval1,channelInterval2);
    
    % compute weighted wpli (within-subject channel count correction)
%     wwpli = [sum(data(thresplot))/plotchan sum(data2(thresplot2))/plotchan2 sum(data3(thresplot3))/plotchan3] ; 
    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    wwpli = [sum(data(thresplot)) sum(data2(thresplot2)) sum(data3(thresplot3))]./8 ; 
    
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_wwpli_ap = wwpli(1);
    analysisStructure(k).middle_hub_wwpli_ap = wwpli(2);
    analysisStructure(k).late_hub_wwpli_ap = wwpli(3);
end




%% weighted WPLI with significant networks for statistical analysis (all connectivity-wide window 0 750 ms)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1:8];

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));
%% threshold 
    data = spssStructure_all_z(k).(dat4names{2});

    
    data = triu(data)+triu(data,1)';
    
    thresplot = data(channelInterval,channelInterval);
    
    thresplot = thresplot > dataCI;
    
    plotchan=length(find(thresplot==1))/2;

%% wpli data 
    data = spssStructure_all(k).(dat4names{2});
    
    data = data(channelInterval,channelInterval);
    
   
    % compute weighted wpli (within-subject channel count correction)
    
    wwpli = sum(data(thresplot))/plotchan;  

    % compute weighted wpli (between-subject channel count correction: divide by the number of all possible pairs)
    
    wwpli = (sum(data(thresplot)))./28 ; 
    
    wwpli(isnan(wwpli))=0;
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).wide_hub_wwpli_all = wwpli;

end




%% hubbness for statistical analysis (left-hemi only)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1 3 5 7];
for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));

    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
   
    thresplot = data(channelInterval,channelInterval);
    thresplot2 = data2(channelInterval,channelInterval);
    thresplot3 = data3(channelInterval,channelInterval);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;

    
    % compute "hubness"
    hubbness = [sum(sum(thresplot,2)) sum(sum(thresplot2,2)) sum(sum(thresplot3,2))]./6 ; % 7 for F4, 6 for F3 = total of 13 channels
    
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_left = hubbness(1);
    analysisStructure(k).middle_hub_left = hubbness(2);
    analysisStructure(k).late_hub_left = hubbness(3);
end

%% hubbness for statistical analysis (right-hemi only)
groupnames=repmat({'Older'},13,1);
groupnames(end+1:end+13)=repmat({'Young'},13,1);
channelInterval = [1 3 5 7]+1;

for k = 1:26
    
    dataCI = norminv(1-(0.05/pvaluedenominator));

    data = spssStructure_z(k).(dat1names{2});
    data2 = spssStructure2_z(k).(dat2names{2});
    data3 = spssStructure3_z(k).(dat3names{2});
    
   
    thresplot = data(channelInterval,channelInterval);
    thresplot2 = data2(channelInterval,channelInterval);
    thresplot3 = data3(channelInterval,channelInterval);
    
    thresplot = thresplot > dataCI;
    thresplot2 = thresplot2 > dataCI;
    thresplot3 = thresplot3 > dataCI;

    
    % compute "hubness"
    hubbness = [sum(sum(thresplot,2)) sum(sum(thresplot2,2)) sum(sum(thresplot3,2))]./6 ; % 7 for F4, 6 for F3 = total of 13 channels
    
%     analysisStructure(k).subject = spssStructure2(k).subject;
%     analysisStructure(k).group = groupnames{k};
    analysisStructure(k).early_hub_right = hubbness(1);
    analysisStructure(k).middle_hub_right = hubbness(2);
    analysisStructure(k).late_hub_right = hubbness(3);
end
