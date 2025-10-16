externalDataDir; % get the data folder for Mert multistable folder in external disc 
cd([pwd '\Data_Analysis\Mert_Gamma']);
cd('D:\MatlabDirectory\MertKucuk\2020_MSPAging_EEG_Mert\Data_Mert\Data_Analysis\Mert_Gamma')
exclusionVariable = {1,0,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,1,1,1,1}; % 1s are included and 0s are excluded from analyses
groupingVariable  = [repmat(1,[1,15]) repmat(2,[1,15])]; % grouping variable: 1s are older 2s are younger adults 
groupingVariable  = num2cell(groupingVariable);

timewindows=([1.5 .9 .7 .1])*-1; % time windows for mean gamma extraction

%% ENDOGENOUS GAMMA POWER  EXTRACTION (DOMINANT FREQUENCY - LOW/HIGH)
spss_highGamma_endo=dataFormatting(wholeData,[1 5],[1 2 3 4],'erspAvgROI','pairChans',timewindows,[],15,'highGamma');
spss_lowGamma_endo=dataFormatting(wholeData,[1 5],[1 2 3 4],'erspAvgROI','pairChans',timewindows,[],15,'lowGamma');
[spss_highGamma_endo.usedInAnalysis]    = exclusionVariable{:};
[spss_highGamma_endo.Group]             = groupingVariable{:};
[spss_lowGamma_endo.usedInAnalysis]     = exclusionVariable{:};
[spss_lowGamma_endo.Group]              = groupingVariable{:};

% EXTRACT PEAK PARAMETERS 
[spss_highGamma_endo.usedInAnalysis] = exclusionVariable{:};
[spss_highGamma_endo.Group]              = groupingVariable{:};
[spss_lowGamma_endo.usedInAnalysis]   = exclusionVariable{:};
[spss_lowGamma_endo.Group]               = groupingVariable{:};


writetable(struct2table(spss_highGamma_endo),'spss_highGamma_endo.xlsx');
writetable(struct2table(spss_lowGamma_endo),'spss_lowGamma_endo.xlsx');


%% EXOGENOUS GAMMA POWER EXTRACTION (DOMINANT FREQUENCY - LOW/HIGH)
% timewindows=([1.5 .9 .7 .1]-.2)*-1; % slide windows by 200 ms for exogenous task
spss_highGamma_exo=dataFormatting(wholeData,[3 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,[],15,'highGamma');
spss_lowGamma_exo=dataFormatting(wholeData,[3 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,[],15,'lowGamma');
[spss_highGamma_exo.usedInAnalysis]    = exclusionVariable{:};
[spss_highGamma_exo.Group]             = groupingVariable{:};
[spss_lowGamma_exo.usedInAnalysis]     = exclusionVariable{:};
[spss_lowGamma_exo.Group]              = groupingVariable{:};

writetable(struct2table(spss_highGamma_exo),'spss_highGamma_exo.xlsx');
writetable(struct2table(spss_lowGamma_exo),'spss_lowGamma_exo.xlsx');

%% SINGLE DOMINANT GAMMA POWER EXTRACTION 
spss_wideGamma_endo=dataFormatting(wholeData,[1 5],[1 2 3 4],'erspAvgROI','pairChans',timewindows,[],15,'wideGamma');

% timewindows=([1.5 .9 .7 .1]-.2)*-1; % slide windows by 200 ms for exogenous task
spss_wideGamma_exo=dataFormatting(wholeData,[3 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,[],15,'wideGamma');
[spss_wideGamma_endo.usedInAnalysis]    = exclusionVariable{:};
[spss_wideGamma_endo.Group]             = groupingVariable{:};
[spss_wideGamma_exo.usedInAnalysis]     = exclusionVariable{:};
[spss_wideGamma_exo.Group]              = groupingVariable{:};

writetable(struct2table(spss_wideGamma_endo),'spss_wideGamma_endo.xlsx');
writetable(struct2table(spss_wideGamma_exo),'spss_wideGamma_exo.xlsx');

%% FIXED 40 HZ POWER EXTRACTION 
spss_40Hz_endo  =   dataFormatting(wholeData,[1 5],[1 2 3 4],'erspAvgROI','pairChans',timewindows,40,15);
% timewindows=([1.5 .9 .7 .1]-.2)*-1; % slide windows by 200 ms for exogenous task
spss_40Hz_exo   =   dataFormatting(wholeData,[3 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,40,15);
[spss_40Hz_endo.usedInAnalysis]    = exclusionVariable{:};
[spss_40Hz_endo.Group]             = groupingVariable{:};
[spss_40Hz_exo.usedInAnalysis]     = exclusionVariable{:};
[spss_40Hz_exo.Group]              = groupingVariable{:};

writetable(struct2table(spss_40Hz_endo),'spss_40Hz_endo.xlsx');
writetable(struct2table(spss_40Hz_exo),'spss_40Hz_exo.xlsx');


%% FIXED LOW (34 Hz) GAMMA POWER EXTRACTION
spss_34Hz_endo  =   dataFormatting(wholeData,[1 5],[1 2 3 4],'erspAvgROI','pairChans',timewindows,34,15);
% timewindows=([1.5 .9 .7 .1]-.2)*-1; % slide windows by 200 ms for exogenous task
spss_34Hz_exo   =   dataFormatting(wholeData,[3 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,34,15);

[spss_34Hz_endo.usedInAnalysis]    = exclusionVariable{:};
[spss_34Hz_endo.Group]             = groupingVariable{:};
[spss_34Hz_exo.usedInAnalysis]     = exclusionVariable{:};
[spss_34Hz_exo.Group]              = groupingVariable{:};

writetable(struct2table(spss_34Hz_endo),'spss_34Hz_endo.xlsx');
writetable(struct2table(spss_34Hz_exo),'spss_34Hz_exo.xlsx');

%% FIXED HIGH (44 Hz) GAMMA POWER EXTRACTION
spss_44Hz_endo  =   dataFormatting(wholeData,[1 5],[1 2 3 4],'erspAvgROI','pairChans',timewindows,44,15);
% timewindows=([1.5 .9 .7 .1]-.2)*-1; % slide windows by 200 ms for exogenous task
spss_44Hz_exo   =   dataFormatting(wholeData,[3 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,44,15);

[spss_44Hz_endo.usedInAnalysis]    = exclusionVariable{:};
[spss_44Hz_endo.Group]             = groupingVariable{:};
[spss_44Hz_exo.usedInAnalysis]     = exclusionVariable{:};
[spss_44Hz_exo.Group]              = groupingVariable{:};

writetable(struct2table(spss_44Hz_endo),'spss_44Hz_endo.xlsx');
writetable(struct2table(spss_44Hz_exo),'spss_44Hz_exo.xlsx');


close('all')
