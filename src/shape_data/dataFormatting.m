%%% EEG = structure variable of the whole data
%%%
%%% conditions = [1 2 3 4] etc. enter a vector of the desired condition
%%% numbers according to their order within the "EEG" structure's rows. 
%%%
%%% channels = [1 2 6 7] vector of the channel Indices. 
%%%
%%% datatype = char vector of the data field (e.g. if EEG.erspdata =
%%% 'erspdata', if EEG.data = 'data', etc. 
%%%
%%%
%%% timePoints = vector values of the desired time points [-1.8 -.8 0 1]
%%% etc. 
%%%
%%% freqPoints = vectore values of the desired frequencies [4 6] etc. 
%%%
%%% pPerCond = number of participants for each condition within the structure
%%% variable that you have
%%%
%%% individualFrequencyName = a field that contains individual peak
%%% frequencies of a frequency band (e.g. 'lowgamma' or 'alphafreq' etc.)
%%% this is used for extracting dominant frequency response parameters
%%% instead of extraction from single frequency.
%%%
%%%
%%% method = character variable stating the extraction method (e.g.
%%% 'mean', 'maximum', 'peak2peak' etc.) 
%%% values can be extracted from window averages, maximum value within windows etc... 

%%% individualFrequency = char vector of the structure field containing the
%%% individual frequency. Use this if you do not want to use the same
%%% frequency for each participant. Useful when studying aging.


%%% Output
%%% spssStructure = a struct variable with extracted values for analysis
%%% latencyStructure = a struct variable containing latency values of
%%% extracted 'maximum' values. Not applicable to mean extraction. 

function [spssStructure, latencyStructure]=dataFormatting(EEG,conditions,channels,datatype,channeltype,timePoints,freqPoints,pPerCond,individualFrequencyName,method)
%% Data structure parameters 
% make the line below a comment if you want to specify frequency for wavelet
% convolution data. Uncomment if you don't want to specify a frequency. 
% freqPoints=[];

 if ~exist('individualFrequencyName','var') || isempty(individualFrequencyName)
     % third parameter does not exist, so default it to something
      individualFrequencyName = [];
      individualFreq = 0;
 else
     individualFreq = 1;
 end

times=EEG(1).times;

pCount=length(EEG); % participant count (participants are iterated for every condition = condCount*2*15) 

condCount=length(conditions);  % condition count

chanCount=length(channels);

groupCount=2;
%% participant code registry
pindices = [];
for i = 1:length(conditions)
    % find the p names for each condition
    pindices = [pindices (((conditions(i)-1)*pPerCond)+1):((conditions(i)*pPerCond))];  
end
pIDs={EEG(pindices).subject}.'
% exclusionIndices = {EEG(pindices).usedInAnalysis}.';
groupNames = {EEG(pindices).group}.';
% exclusionIndices = find([exclusionIndices{:}] > 0)
% exclusionIndices = find(~cellfun(@isempty,exclusionIndices))
groupNames = [groupNames(1:pPerCond);groupNames(end-pPerCond+1:end)]; %%% assuming the last 15 participants are in a different group than the first 15 participants.
pIDs=[pIDs(1:pPerCond);pIDs(end-pPerCond+1:end)]; %%% assuming the last 15 participants are in a different group than the first 15 participants.
%% SPSS STRUCTURE VARIABLE IS CREATED IN THIS SECTION WITH participant names

[spssStructure(1:(pPerCond*groupCount)).subject]=pIDs{1:end};
[spssStructure(1:(pPerCond*groupCount)).group]=groupNames{1:end};
% [spssStructure(1:(pPerCond*groupCount)).exclusion]=exclusionIndices{1:end};

% [latencyStructure(1:(pPerCond*groupCount)).subject]=pIDs{1:end};
%% Extract time & frequency indices 

timeIndices=findIndices(times,timePoints);

disp(times(timeIndices))
disp(EEG(1).times(timeIndices))
%%%%% IAF COMMENT %%%%%%
%%% Uncomment below if you are not using individual peak frequencies. Check
%%% line 107 below for further information.
if ~isempty(freqPoints)      
    freqs=EEG(1).convFreqs;
    freqIndices=findIndices(freqs,freqPoints);
else 
    freqPoints=[];
end

iteration=0;
condIndx=1;
timeMeanData=[];
pScalar=(conditions(condIndx)-condIndx)*(pPerCond);
% freqs=EEG(1).convFreqs;
peakanalysis=0;
for pti = 1:(pPerCond*condCount)  
         
    if pti == (pPerCond*condIndx)+1 
        condIndx=condIndx+1;        %%% Iterates at every pPerCondth participant so that the condition Index is adjusted for the next experimental condition. Because every condition has "pPerCond" participants in it. 
        pScalar=(conditions(condIndx)-condIndx)*(pPerCond);

        fprintf('\nProcessing condition & group: %s %s', EEG(pti+pScalar).condition,EEG(pti+pScalar).group);
    elseif pti==1
        fprintf('\nProcessing condition & group: %s %s', EEG(pti+pScalar).condition,EEG(pti+pScalar).group);
    end
    
   
    % find participant index
    
    subName=EEG(pti+pScalar).subject(1:end); 
    pIndx   = regexp(pIDs,subName);
    pIndx   = find(~cellfun(@isempty,pIndx)); 
    [~, pIndx]=max(strncmp(pIDs,subName,5));
    
% %     pti+pScalar
% %     pIndx
% %     pIDs
    
    %create condition name 
    charIndx=ismember(EEG(pti+pScalar).condition,'o');
    [~,charIndx]=max(charIndx);
    condName=EEG(pti+pScalar).condition(1:end);
    
    fprintf('\nProcessing participant: %s', EEG(pti+pScalar).subject(1:end));
    
%     if EEG(pti+pScalar).usedInAnalysis==0
%         fprintf('\nParticipant excluded from analysis: %s', EEG(pti+pScalar).subject(1:5));
%         spssStructure(pIndx) = [];
%         WaitSecs(.4);
%         continue;
%     end

%      % condition below checks if this is a connectivity related data
%      extraction. Because electrodePairs field is only present in
%      connectivity structure variables. 
        connectivity = ~isempty(find(contains( fieldnames( EEG ) , 'electrodePairs' )==1));
        if connectivity
            chanCountInConnectivity = length(unique((EEG(1).electrodePairs)));
            connectivitymatrix = eye(chanCountInConnectivity,chanCountInConnectivity);
            frequencymatrix = eye(chanCountInConnectivity,chanCountInConnectivity);
            electrodePairs = EEG(pti+pScalar).electrodePairs;
        end
        
        for ci = 1:chanCount            
            
            %add channelname to condition name
            
                channame=EEG(pti+pScalar).(channeltype){channels(ci)}; 
                
%                 channame=num2str(ci);
                condNameChans=[condName '_' channame];
     
            
            %extract time windows from the whole data
            for timeIndx= 1 : 2 : numel(timeIndices)
                noSymbol = times(timeIndices(timeIndx));
                if noSymbol <0
                    signname='_minus';
                else
                    signname='_';
                end
                maxTime = max(times(timeIndices));
                if maxTime < 100 % add some numbers if TIMES is in seconds format
                    condNameReg=[condNameChans signname num2str(round(abs(times(timeIndices(timeIndx)))*1000))...
                        ,'to',num2str(round(abs(times(timeIndices(timeIndx+1)))*1000))];
                else
                    condNameReg=[condNameChans signname num2str(round(abs(times(timeIndices(timeIndx)))))...
                        ,'to',num2str(round(abs(times(timeIndices(timeIndx+1)))))];
                end
                %% extracting dominant frequency if demanded
                %%%%% IAF COMMENT %%%%%%
                %Individual Peak Frequency line, comment below if you are
                %not using individual peaks
                
%                 if individualFreq == 1
%                     freqPoints = EEG(pti+pScalar).(individualFrequencyName);
%                 
%                     if ~isempty(freqPoints)        
%                         freqs=EEG(1).convFreqs;
%                         freqIndices=extractDataIndex(freqs,freqPoints);
%                         
%                     else 
%                         freqPoints=[];
%                     end
%                 end
                
                %% different data extraction methods
                if ~isempty(regexp(method,'mean')) %#ok<*RGXP1>
%                     disp('mean')
                    %Convolution mean line
                    if connectivity
                        
                       [pairIndx a]= find(EEG(pti+pScalar).electrodePairs==channels(ci));
                       pairIndx = sort(pairIndx);
                       timeMeanData=mean(EEG(pti+pScalar).(datatype)(:,timeIndices(timeIndx):timeIndices(timeIndx+1),pairIndx),2);
                       size(timeMeanData);
                    else
                        
                       timeMeanData=mean(EEG(pti+pScalar).(datatype)(:,timeIndices(timeIndx):timeIndices(timeIndx+1),channels(ci)),2);
                        
                    end
                    
                    
                    
                elseif ~isempty(regexp(method,'maximum'))
                    disp('\n max')
                    if connectivity
                        
                       [pairIndx a]= find(EEG(pti+pScalar).electrodePairs==channels(ci));
                       pairIndx = sort(pairIndx);
                       [timeMeanData timeIndx]  =max(EEG(pti+pScalar).(datatype)(:,timeIndices(timeIndx):timeIndices(timeIndx+1),pairIndx),[],2);
                       
                    else
                        %Convolution max value
                        [timeMeanData timeIndx]=max(EEG(pti+pScalar).(datatype)(:,timeIndices(timeIndx):timeIndices(timeIndx+1),channels(ci)),[],2);                        
                        
                    end                    

                elseif ~isempty(regexp(method,'peak2peak'))
                    disp('peak2peak')
                    %Peak2Peak line
                    peaks=[];
                    trialcount=size(EEG(pti+pScalar).(datatype),3);
                    for ti = 1:trialcount
                        peakanalysis=1;
                        timeMeanData=peak2peak(EEG(pti+pScalar).(datatype)(timeIndices(timeIndx):timeIndices(timeIndx+1),channels(ci),ti,1));
                        peaks=[peaks timeMeanData];
                    end
                    size(peaks)
                elseif ~isempty(regexp(method,'rms'))
                    disp('rms')
                    %RootMeanSquared line
                    timeMeanData=rms(EEG(pti+pScalar).(datatype)(timeIndices(timeIndx):timeIndices(timeIndx+1),channels(ci),:),1);
                end
                
                %% averaging over time windows and/or frequencies
% numel(freqIndices)
                    
% ~isempty(freqPoints)
                    if ~isempty(freqPoints) && numel(freqIndices)>1
                        % IF POWER = compute freq range average if freq
                        % ranges were specified, IF CONNEC = Get max freq
                            
                            medianFreqName = median(freqs(freqIndices(1):freqIndices(2)));
                            condNameRegFreq=[condNameReg '_' num2str(round(medianFreqName)),'Hz'];
                            
                            if connectivity
                                for k = 1:length(pairIndx)
                                    % get the frequency with highest value
                                    
                                    [maxData, freqIndex] = max(timeMeanData(freqIndices(1):freqIndices(2),:,k));
                                    
                                    
                                    assignin('base','timeMeanData',timeMeanData);
                                    
                                    
%                                     [values, freqIndex]  = max(maxData);
%                                     values = permute(values,[1 3 2]);  
%                                     maxValueChans = max(values,[],2);
%                                     [maxval,freqIndex] = max(maxValueChans,[],1); 

                                    
                                    
%                                     disp([electrodePairs(pairIndx(k),1) electrodePairs(pairIndx(k),2)])
%                                     if ci == k
%                                         connectivitymatrix(ci,k) = 0;
%                                         frequencymatrix(ci,k) = 0;
%                                     else

                                        connectivitymatrix(electrodePairs(pairIndx(k),1),electrodePairs(pairIndx(k),2)) = maxData;
                                        frequencymatrix(electrodePairs(pairIndx(k),1),electrodePairs(pairIndx(k),2)) = freqs(freqIndex+freqIndices(1)-1);
%                                     end
                                    
                                end

                            else
                                
                            %Convolution mean
                            
                            spssStructure(pIndx).(condNameRegFreq)=mean(timeMeanData(freqIndices(fi):freqIndices(fi+1),:,:),1);

                            %Convolution max
%                             spssStructure(pIndx).(condNameRegFreq) = maxval;
%                             spssStructure(pIndx).(condNameRegFreq)=max(timeMeanData(freqIndices(fi):freqIndices(fi+1),:,:),[],2);

                            condNameRegFreq=[]; %#ok<*NASGU>
                            end
                           
                        

                    elseif ~isempty(freqPoints)&& numel(freqIndices)==1%% if there is only one frequency instead of a range (i.e. centre frequency)
                        %%%%% IAF COMMENT %%%%%%
                        %uncomment below if you are not using individual
                        %peak frequencies
                        if individualFreq == 1
                            condNameRegFreq=[condNameReg '_' individualFrequencyName]; 
                        else
                            condNameRegFreq=[condNameReg '_' num2str(round(freqs(freqIndices))),'Hz']; 
                        end
                       
                        %Get data value
                        fprintf('\nP indx: %s \nfreqIndices: %s \ncondNameRegFreq: %s \n',num2str(pIndx),num2str(pIndx),num2str(condNameRegFreq));
%                         pIndx
%                         freqIndices
%                         size(timeMeanData)
%                         condNameRegFreq
                        spssStructure(pIndx).(condNameRegFreq)=mean(timeMeanData(freqIndices,:,:),1);
                        %Get latency value
                        if ~isempty(regexp(method,'maximum'))
                            latencyStructure(pIndx).(['latency_' condNameRegFreq])=times(timeIndices(1)+mean(timeIndx(freqIndices,:,:),1));
                        end
                        %Convolution max
%                         spssStructure(pIndx).(condNameRegFreq)=max(timeMeanData(EEG(pIndx).maxThetaFreqIndex,:,:,:),[],1);

                        condNameRegFreq=[];
                        
                    elseif isempty(freqPoints)
                        
                        if peakanalysis==0
                            spssStructure(pIndx).(condNameReg)=mean(timeMeanData,3);
                        elseif peakanalysis==1 && ~isempty(peaks)
                            spssStructure(pIndx).(condNameReg)=mean(peaks,2);
                        else
                            spssStructure(pIndx).(condNameReg)=0;
                        end
                    end
                
%                 
            if ~connectivity
                condNameReg=[]; %#ok<*NASGU>
            end
            end
            
            if ~connectivity 
                condNameChans=[];
            end
            
            
        end
        if connectivity 
            spssStructure(pIndx).(condNameRegFreq) = connectivitymatrix;
            spssStructure(pIndx).([condNameRegFreq '_freq']) = frequencymatrix;
            condNameReg=[]; %#ok<*NASGU>
            condNameChans=[];
        end
        condName=[];
        
        
end
fprintf('\n');
fprintf('Processed channels: '); 
% fprintf('%s ', EEG(pti+pScalar).(channeltype){channels});
fprintf('\n');
fprintf('Processed time points: ');
fprintf('%1.2f ', times(timeIndices));
fprintf('\n');
if ~isempty(freqPoints)
fprintf('Processed frequencies: '); 
fprintf('%.2f ', freqs(freqIndices));
end
fprintf('\n');
            
            
            
            