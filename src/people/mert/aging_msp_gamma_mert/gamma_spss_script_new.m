externalDataDir; % get the data folder for Mert multistable folder in external disc 
cd([pwd '\Data_Analysis\Mert_Gamma']);
externalDataDir;
cd([pathname '\Data_Analysis\Mert_Gamma'])
exclusionVariable = {1,0,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,1,1,1,1}; % 1s are included and 0s are excluded from analyses
groupingVariable  = [repmat(1,[1,15]) repmat(2,[1,15])]; % grouping variable: 1s are older 2s are younger adults 
groupingVariable  = num2cell(groupingVariable);

timewindows=([1.5 .9 .7 .1])*-1; % time windows for mean gamma extraction
%% ENDOGENOUS GAMMA POWER  EXTRACTION (DOMINANT FREQUENCY - LOW/HIGH)
spss_highGamma      =   dataFormatting(wholeData,[1 3 5 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,[],15,'highGamma');
spss_lowGamma       =   dataFormatting(wholeData,[1 3 5 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,[],15,'lowGamma');
[spss_highGamma.usedInAnalysis]    = exclusionVariable{:};
[spss_highGamma.Group]             = groupingVariable{:};
[spss_lowGamma.usedInAnalysis]     = exclusionVariable{:};
[spss_lowGamma.Group]              = groupingVariable{:};

% EXTRACT PEAK PARAMETERS 
[spss_highGamma.usedInAnalysis]     = exclusionVariable{:};
[spss_highGamma.Group]              = groupingVariable{:};
[spss_lowGamma.usedInAnalysis]      = exclusionVariable{:};
[spss_lowGamma.Group]               = groupingVariable{:};




%% SINGLE DOMINANT GAMMA POWER EXTRACTION 
timewindows=([1.5 .9 .7 .1])*-1; %
spss_wideGamma     =   dataFormatting(wholeData,[1 3 5 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,[],15,'wideGamma');

[spss_wideGamma.usedInAnalysis]    = exclusionVariable{:};
[spss_wideGamma.Group]             = groupingVariable{:};




%% FIXED 40 HZ POWER EXTRACTION 
timewindows=([1.5 .9 .7 .1])*-1; % time windows for mean gamma extraction
spss_40Hz  =   dataFormatting(wholeData,[1 3 5 7],[1 2 3 4],'erspAvgROI','pairChans',timewindows,40,15);

[spss_40Hz.usedInAnalysis]    = exclusionVariable{:};
[spss_40Hz.Group]             = groupingVariable{:};

% 
% 
% 
% writetable(struct2table(spss_highGamma),'spss_highGamma.xlsx');
% writetable(struct2table(spss_lowGamma),'spss_lowGamma.xlsx');
% writetable(struct2table(spss_wideGamma_endo),'spss_wideGamma.xlsx');
% writetable(struct2table(spss_40Hz),'spss_40Hz.xlsx');


