clc
clear

%% structuring wavelet data
pathdir = uigetdir([],'select the data folder you want to import');
cd(pathdir);
datasets = ls;

%% remove dots from the file list
datasets(1:2,:)=[];

%% initialize structure variable
EEG = struct();

%% what is the index of participant code in the .mat file?
subidIndx = 1:4; % first four characters is the subject ID


for k = 1:size(datasets,1)
    %% dataset info 
    % stimulus type
    isNT  = ~isempty(regexp(datasets(k,:),'nontarget'));
    if isNT
        stimulusType = 'nontarget';
    else
        stimulusType = 'target';
    end
    % block
    blockTextIndx = regexp(datasets(k,:),'block');
    isBlock = ~isempty(blockTextIndx);
    if isBlock
        blockText = datasets(k,blockTextIndx:blockTextIndx+5);
    else
        blockText = 'all_blocks';
    end
    % dataset type (wavelet, or regular untransformed EEG)
    dataTypeIndx = regexp(datasets(k,:),'wavelet');
    isErsp = ~isempty(dataTypeIndx);
    if isErsp
        dataName = 'ersp';
    else
        dataName = 'data';
    end
    
    %% load dataset
    currData = load([pathdir,'\',datasets(k,:)]);
    %% get channels
    channelNames = {currData.Channels(3:end).Name}; % ignore the first two because those are EOGH, EOGV
    data = [];
    %% import data and create a 3-D matrix
    for chani = 1:length(channelNames)
        data = cat(3,data,currData.(channelNames{chani}));
    end
    %% enter dataset values into a structure variable
    EEG(k).subject = datasets(k,subidIndx);
    EEG(k).block = blockText;
    EEG(k).stimulus = stimulusType;
    EEG(k).(dataName) = data;
    EEG(k).times = currData.t;
    EEG(k).chaninfo = channelNames;
    EEG(k).srate = currData.SampleRate;
    EEG(k).markers = currData.Markers;
    
    
    
    
end

    
    
    
    
    
    
    
    
    
    
    
    
