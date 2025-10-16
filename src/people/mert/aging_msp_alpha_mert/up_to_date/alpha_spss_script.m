%% Load data
% cd('F:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\Data_Processed\AlphaPaper')
load('alpha_7Cycles_thesisEpochs.mat')

%% set directory
externalDataDir; % get the data folder for Mert multistable folder in external disc 
cd([pwd '\Data_Analysis\Mert_AlphaArticle\Alpha_Birgit']);

%% exluded participants and group names
exclusionVariable = {1,0,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,1,1,1,1}; % 1s are included and 0s are excluded from analyses
groupingVariable  = [repmat(1,[1,15]) repmat(2,[1,15])]; % grouping variable: 1s are older 2s are younger adults 
groupingVariable  = num2cell(groupingVariable); 
%% ENDOGENOUS 
% REVERSAL 
timewindows=([-.35 -.05]); % time windows for mean extraction
spss_endo_reversal   = dataFormatting(wholeData,[1 5],[1 2 3 4],'erspAvgROI','pairChans',timewindows,11,15,[],'mean');

[spss_endo_reversal.usedInAnalysis]    = exclusionVariable{:};
[spss_endo_reversal.Group]             = groupingVariable{:};
writetable(struct2table(spss_endo_reversal),'spss_endo_reversal.xlsx');
% NON-REVERSAL
timewindows=([-.5 0]); % time windows for mean extraction
spss_endo_nonReversal   = dataFormatting(wholeData,[2 6],[1 2 3 4],'erspAvgROI','pairChans',timewindows,11,15);

[spss_endo_nonReversal.usedInAnalysis]    = exclusionVariable{:};
[spss_endo_nonReversal.Group]             = groupingVariable{:};
writetable(struct2table(spss_endo_nonReversal),'spss_endo_nonReversal.xlsx');

%% EXOGENOUS

% REVERSAL
timewindows=([-.95 -.65 -.35 -.05])+.1; 
spss_exo_reversal    = dataFormatting(wholeData,[3 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,11,15);
[spss_exo_reversal.usedInAnalysis]    = exclusionVariable{:};
[spss_exo_reversal.Group]             = groupingVariable{:};
writetable(struct2table(spss_exo_reversal),'spss_exo_reversal.xlsx');

% NON-REVERSAL
timewindows=([-.5 0]); % time windows for mean extraction
spss_exo_nonReversal   = dataFormatting(wholeData,[4 8],[1 2 3 4],'erspAvgROI','pairChans',timewindows,11,15);

[spss_exo_nonReversal.usedInAnalysis]    = exclusionVariable{:};
[spss_exo_nonReversal.Group]             = groupingVariable{:};
writetable(struct2table(spss_exo_nonReversal),'spss_exo_nonReversal.xlsx');









