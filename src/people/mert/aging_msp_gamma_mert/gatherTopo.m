function gatherPeakData = gatherTopo(data,conditions,pPerCondition,whichBand)
% whichBand = {'wide','low','high'};
% data = EEG structure
% condition = 1 3 5 7 etc. 
% pPerCondition = how many participants in each condition (must be equal) 
headerNames     = {'subject';'group';'condition';'frequencyInterval';'peakFrequency';'peakChannel';'peakProminence';'peakValue';'peakLatency';'peakWidth';'frontalCount';'centralCount';'parietalCount';'occipitalCount';'usedInAnalysis'};
gatherPeakData = cell(pPerCondition*length(conditions)+1,15);
gatherPeakData(1,:)=headerNames;

exclusionVariable = {1,0,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,1,1,1,1}; % 1s are included and 0s are excluded from analyses (theta MSP paper and thesis exclusion)
fnames = fieldnames(data); % field names of structure variable 
%% FIND FIELD COLUMNS THAT CORRESPOND TO PARAMETERS 
% dominant Hz column
dominantHzFieldName = [whichBand 'Gamma']; 
findPeakHz = regexp(fnames,dominantHzFieldName);
peakHzColumn = find(~cellfun(@isempty,findPeakHz));

if strcmp(whichBand,'wide')
    freqinterval=1;
elseif strcmp(whichBand,'low')
     freqinterval=2;

elseif strcmp(whichBand,'high')
    freqinterval=3;
end
% Topographical parameters
findPeakTopoField = regexp(fnames,'peakTopoDistribution');
peakTopoColumn = find(~cellfun(@isempty,findPeakTopoField));

% Peak parameters: latency, prominence etc. 
findPeakField = regexp(fnames,'peakParameters');
peakParamsColumn = find(~cellfun(@isempty,findPeakField));

% Dominant Freq Channel 
findPeakChannel = regexp(fnames,'peakChan');
peakChannelColumn = find(~cellfun(@isempty,findPeakChannel));

data = permute(struct2cell(data),[3 1 2]);

pScalar = 1;
for ci= conditions
    
    for k = 2:pPerCondition+1 % we start by +1 because the first row is column names 
        pScalar = pScalar+1;
        
        pScalarDat = k-1 + (pPerCondition * (ci-1));
        %% PARTICIPANT ID, GROUP, AND CONDITION
        for varIndx = 1:6
            
            if varIndx == 2
                
                if strcmp(data{pScalarDat,varIndx},'older')
                    gatherPeakData{pScalar,varIndx} = 1;
                else
                    gatherPeakData{pScalar,varIndx} = 2;
                end
            else
                gatherPeakData{pScalar,varIndx} = data{pScalarDat,varIndx};
            end
            
            if varIndx == 3
                
                if strcmp(data{pScalarDat,varIndx},'instable_endogenous')
                    gatherPeakData{pScalar,varIndx} = 1;
                elseif strcmp(data{pScalarDat,varIndx},'instable_exogenous')
                    gatherPeakData{pScalar,varIndx} = 2;
                end
                
            end            
            
            % register which band interval was taken
            if varIndx == 4
                 gatherPeakData{pScalar,varIndx} = freqinterval;
            end
            
            % register dominant frequency
            if varIndx == 5
                gatherPeakData{pScalar,varIndx} = data{pScalarDat,peakHzColumn};
            end
            
            % dominant frequency channel 
            if varIndx == 6
                gatherPeakData{pScalar,varIndx} = data{pScalarDat,peakChannelColumn};
            end
            
        end
        
        %% DOMINANT PEAK PARAMETERS: LATENCY, PROMINENCE, CHANNEL, HZ ETC.
        for varIndx = 7:10
            gatherPeakData{pScalar,varIndx} = data{pScalarDat,peakParamsColumn}(varIndx-6);
            
        end
        %% Channel Distribution of Peak Frequencies 
        for varIndx = 11:14
            
            cellIndx = varIndx -10;
            gatherPeakData{pScalar,varIndx} = data{pScalarDat,peakTopoColumn}(2,cellIndx);
            
        end
        
        gatherPeakData{pScalar,15} = data{pScalarDat,12}; 
    end
    
end
