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
%
% pPerCond = number of participants for each condition within the structure
% variable that you have

% individualFrequency = char vector of the structure field containing the
% individual frequency. Use this if you do not want to use the same
% frequency for each participant. Useful when studying aging.

function EEG=frequencySpecificTimeSeries(EEG,conditions,channels,datatype,channeltype,timePoints,freqPoints,pPerCond,individualFrequencyName)
%% Data structure parameters 
% make the line below a comment if you want to specify frequency for wavelet
% convolution data. Uncomment if you don't want to specify a frequency. 
% freqPoints=[];

 if ~exist('individualFrequencyName','var')
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

condIndx=1;
timeSeriesData=[];
pScalar=(conditions(condIndx)-condIndx)*(pPerCond);

for pti = 1:(pPerCond*condCount)  
         
    if pti == (pPerCond*condIndx)+1 
        condIndx=condIndx+1;        %%% Iterates at every 15th participant so that the condition Index is adjusted for the next experimental condition. Because every condition has "pPerCond" participants in it. 
        pScalar=(conditions(condIndx)-condIndx)*(pPerCond); 

        fprintf('\nProcessing condition & group: %s %s', EEG(pti+pScalar).condition,EEG(pti+pScalar).group);
    elseif pti==1
        fprintf('\nProcessing condition & group: %s %s', EEG(pti+pScalar).condition,EEG(pti+pScalar).group);
    end
    
      
    

    
    fprintf('\nProcessing participant: %s', EEG(pti+pScalar).subject(1:5));
    

        %extract time windows from the whole data
        for timeIndx= 1 : 2 : numel(timeIndices)

            %%%%% IAF COMMENT %%%%%%
            %Individual Peak Frequency line, comment below if you are
            %not using individual peaks
            if individualFreq == 1
                freqPoints = EEG(pti+pScalar).(individualFrequencyName);

                if ~isempty(freqPoints)        
                    freqs=EEG(1).convFreqs;
                    freqIndices=extractDataIndex(freqs,freqPoints);
                else 
                    freqPoints=[];
                end
            end
            %Convolution mean line
            timeSeriesData=EEG(pti+pScalar).(datatype)(freqIndices,:,:);
            if individualFreq == 1
                EEG(pti+pScalar).([individualFrequencyName '_timeseries'])=permute(timeSeriesData,[2 3 1]);
            else
                 EEG(pti+pScalar).(['fixed' num2str(EEG(1).convFreqs(freqIndices)) 'Hz_timeseries'])=permute(timeSeriesData,[2 3 1]);
            end



        end


            
        

        
end
fprintf('\n');
fprintf('Processed channels: '); 
fprintf('%s ', EEG(pti+pScalar).(channeltype){channels});
fprintf('\n');
fprintf('Processed time points: ');
fprintf('%1.2f ', times(timeIndices));
fprintf('\n');
if ~isempty(freqPoints)
fprintf('Processed frequencies: '); 
fprintf('%.2f ', freqs(freqIndices));
end
fprintf('\n');
            
            
            
            