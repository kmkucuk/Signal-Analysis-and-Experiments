%%% Parameters:
%%% EEG = dataset structure
%%% freq_range = frequency range to be plotted
%%% freqsteps = desired frequency interval between frequencies
%%%         e.g. =.25 >>> 4-4.25-4.5 ... =2 >>> 4-6-8...
%%% channels = which channels as in integer vector e.g. [1:10] = first 10
%%% cycles = cycle range 
%%%
%%% conditions = [1 2 3 4] etc. 1-endo_ins 2-endo_stb 3-exo-ins 4-exo_stb
%%% etc... Does not have to be in this order, just match the condition count
%%% in the dataset. Always enter double integers, for instance: 
%%% 1 for the data 2 for the baseline data(stable epochs) OR 3 for the data
%%% 4 for the baseline (stable epochs). This will depend on your structure
%%% variable and its order. Ignore the participant group (elder&young),
%%% code always takes two participants group into account.
%%%
%%% Ngroup = number of participants for each group, group sizes must be
%%% equal. 
%%%
%%%baselinePeriod= specify the baseline in seconds
%%%convWindow = specify convolution window in seconds

function [wholeData, GAdata]=convolveCrossConditionBaseline(EEG,freq_range,freqsteps,channels,cycles,baselinePeriod,conditions,Ngroup) 
%% Manual checking parameters:
% freq_range=[2 48];
% freqcount=94;
% channels=1:10;
% cycles=[3 7];
% baselinePeriod=[-.750  .05];

% convolution and baseline time windows

times=EEG(1).times;  %%% time points within a data
convPnts=length(times);
%% check if times is in seconds or ms 
maxtime=abs(max(times));
if maxtime/100 < 1
    seconds = 1;
else
    seconds = 0;
end

baseIdx=findIndices(times,baselinePeriod);

% frequency parameters
freqcount=((freq_range(2)-freq_range(1))/freqsteps)+1;

frex = linspace(freq_range(1),freq_range(2),freqcount);

%cycle parameters

%%% below are the cycles for specific frequency intervals
if length(cycles) <= 2
    cycles = logspace(log10(cycles(1)),log10(cycles(end)),freqcount);
    s = cycles ./ (2*pi*frex);
else
    s = cycles ./ (2*pi*frex);
end

%wavelet parameters
% if seconds == 1
    wavtime = -2:1/EEG(1).srate:2;
% else
%     wavtime = (-2:1/EEG(1).srate:2).*1000;
% end

half_wave = (length(wavtime)-1)/2;

% FFT parameters

nWave = length(wavtime);

chanCount=length(channels); 

pCount=length(EEG);         %%% subjects count * condition count (every participant is registered again per condition)


% initialize output time-frequency data according to convolution period and
% frequency vector 
condCount=length(conditions);
tf = zeros(length(frex),convPnts,condCount);
itpc= zeros(length(frex),convPnts,condCount);

MemoryconvData=nan(length(frex),convPnts,condCount,length(channels)); % 4 here is  the conditions that I had in my MSP experiment. Endo(stable*instable) + Exo(stable*instable)

% Trial registery is in cell format because trial counts do not match.
MemoryTrialData={nan(length(channels),condCount)};
load('chanLocations_8.mat')
convData=MemoryconvData;
itpcData=MemoryconvData;

trialErspData=MemoryTrialData;
trialItpcData=MemoryTrialData;

erspTrials=nan(length(frex),length(condCount));
itpcTrials=nan(length(frex),length(condCount));

% Data storage variables
tCounts=zeros(1,condCount);
nData=zeros(1,condCount);
tPoints=[];
pScalar=0;
externalDataDir;
groupSampleSize=pCount/(condCount*2); %participant count in each group/condition assuming equal sample sizes

for pti = 1:pCount/condCount
    
    if pti<groupSampleSize+1
        
    elseif pti==groupSampleSize+1 % this condition requires that you only have two participant groups. Condition within those groups can be of any number.
        pScalar=(condCount-1)*(groupSampleSize);
    end
    
    
    % data time series parameters for each condition of a particant
    
    for condi=1:condCount                
        tCounts(condi)=size(EEG(pti+pScalar+((condi-1)*Ngroup)).data,3);         
        nData(condi) = length(times) * tCounts(condi); %%% calculates the length of concatenated data         
    
    end
    
    % below creates the matrices for trial by trial convolution data. It
    % iterates for each participant because each of them have different
    % trial counts. It also uses the highest trial count among all
    % conditions. Afterwards excess NaN's will be deleted.
    erspTrials=nan(length(frex),length(times),max(tCounts),condCount);
    itpcTrials=nan(length(frex),length(times),max(tCounts),condCount);
    
    
    % calculate length of the concatenated trials of every condition
    nConv = nWave + sum(nData) - 1;
%%
 
    
        for ci = 1:chanCount
        fprintf('\nProcessing participant: %s', EEG(pti+pScalar).subject(1:5));
        fprintf('\nProcessing channel: %s', EEG(pti+pScalar).chaninfo{channels(ci)});
        %concatenate every condition's trials and create 1 variable out of
        %it. new variable = (timesXtrial)xCondition
            grandData=[];
            for cond2i=1:condCount
                
                data=EEG(pti+pScalar+((cond2i-1)*Ngroup)).data; % EEG(pti+pScalar+((cond2i-1)*Ngroup)).data(:,channels(ci),:);
                %%laplacian   c  x ti  x  tr
                data = laplacian_perrinX(permute(data,[2 1 3])  ,[chanlocs.X],[chanlocs.Y],[chanlocs.Z]);
                data = permute(data,[2 1 3]);                
                data = data(:,channels(ci),:);

%                 data = EEG(pti+pScalar+((cond2i-1)*Ngroup)).data(:,channels(ci),:);    
                currentdatashape=reshape(data ,1,[]);
                fprintf('\nConditions: %s', EEG(pti+pScalar+((cond2i-1)*Ngroup)).condition);
                grandData= cat(2,grandData,currentdatashape);   

            end
        fprintf('\nData length: %d \n.', size(grandData,2));
        % now compute the FFT of all trials concatenated
            

        dataX = fft(grandData ,nConv);

        % loop over frequencies

            for fi=1:length(frex)  
                    
                % create wavelet and get its FFT
                % the wavelet doesn't change on each trial...
                wavelet  = exp(2*1i*pi*frex(fi).*wavtime) .* exp(-wavtime.^2./(2*(s(fi)^2)));
                
                waveletX = fft(wavelet,nConv);

                waveletX = waveletX ./ max(waveletX);       %%% amp normalization to max=1

                % now run convolution in one step
                as = ifft(waveletX .* dataX);

                as = as(half_wave+1:end-half_wave);
%%
                % and reshape back to time X trials we need a for loop for
                % this because we have 4 conditions concatenated and they
                % do not have equal trial counts
                
                    for cond3i=1:condCount                       
                        
                            if cond3i==1
                                
                                conditiondata=as( 1 : nData(cond3i));
                                
                            else
                                tPoints=sum([tPoints nData(cond3i-1)]); %calculates which time point this condition starts
                                conditiondata=as( tPoints+1 : tPoints+nData(cond3i) ); % starts at 1 point above the time points of the previous trial. 
                                                                                                           % Counts until the timepoints of the previous + current trial.
                            %fprintf('\nCondition''S data points: %d\nnecessary time point range: %d : %d', nData(cond3i),tPoints+1, tPoints+nData(cond3i));
                            end
                        
                        % clear RAM by deleting temporary data storage
                        % variables:                            

                        
                        
                        % and reshape back to time X trials   
                        conditiondata = reshape( conditiondata, length(times), tCounts(cond3i) );
                        
                        
                        % store trial-by-trial power and ITPC 
%                         tbytPower=abs(conditiondata).^2;
%                         
%                         tbytItc=exp(1i*angle(conditiondata));                       
                        
                        
%                         erspTrials(fi,:,1:tCounts(cond3i),cond3i)=tbytPower;
%                         
%                         itpcTrials(fi,:,1:tCounts(cond3i),cond3i)=tbytItc;
                        
                        
                        
                        %compute inter-trial phase clustering
                        tmpitpc=abs(mean(exp(1i*angle(conditiondata)),2));
                        
                        % compute power and average over trials
                        tmpavg = mean(abs(conditiondata).^2 ,2);
                        
                        % gather averaged power data into one matrix
                        tf(fi,:,cond3i)=tmpavg;
                        
                        % gather phase cluster data into one matrix ***
                        % BEWARE AND CHANGE THIS. THIS IS MODIFIED FOR NON
                        % NORMALIZED ERSP DATA AT THE MOMENT. YOU CAN TELL
                        % THAT IF "itpc()=tmpavg" is writtenbelow. That is
                        % the raw data. comment that section if you want to
                        % obtain actual "itpc" data. Actual ITPC measure
                        % is: abs(mean(exp(1i*angle(conditiondata)),2))
                        %
                        itpc(fi,:,cond3i)=tmpitpc;                        
                        
                    end
                    
                    % clear RAM by deleting temporary data storage
                    % variables:
                    conditiondata=[];
                    as=[];
                    
                    %Baseline correction using stable periods of exogenous
                    %and endogenous stimuli. Second condition is stable
                    %endogenous and fourth condition is stable exogenous.
                    tPoints=[];
                    for i = 1:2:condCount
                        BaselineMean=mean(tf(fi,baseIdx(1):baseIdx(2),i+1),2);
                        % Logarithmic Baseline %
                        tf(fi,:,i)= 10*log10( tf(fi,:,i) / BaselineMean);
                        % Percent Baseline %
%                         tf(fi,:,i)= 100*(  tf(fi,:,i)-BaselineMean)./ BaselineMean;
                    end
            end
            
            itpcData(:,:,:,channels(ci))=itpc;
            convData(:,:,:,channels(ci))=tf;           
%             for condTrialidx=1:condCount
%                 
%                 trialErspData{channels(ci),condTrialidx}=erspTrials(:,:,:,condTrialidx);
%                 trialItpcData{channels(ci),condTrialidx}=itpcTrials(:,:,:,condTrialidx);
%             
%             end
            
            
        end
        
        for cond4i = 1:condCount    
            registerIndx=pti+pScalar+((cond4i-1)*Ngroup);
            wholeData(registerIndx).subject=EEG(registerIndx).subject;
            wholeData(registerIndx).group=EEG(registerIndx).group;
            wholeData(registerIndx).condition=EEG(registerIndx).condition;
            wholeData(registerIndx).chaninfo=EEG(1).chaninfo;
            wholeData(registerIndx).times=times;
            wholeData(registerIndx).srate=EEG(1).srate;
%             wholeData(registerIndx).filterProperties=EEG(1).filterProperties;
%             wholeData(registerIndx).notch=EEG(1).notch;
            wholeData(registerIndx).erspdata=reshape(convData(:,:,cond4i,:),size(convData,1),size(convData,2),size(convData,4),1);
            wholeData(registerIndx).itpcdata=reshape(itpcData(:,:,cond4i,:),size(itpcData,1),size(itpcData,2),size(itpcData,4),1);
%             wholeData(registerIndx).erspTrials=trialErspData(:,cond4i);
%             wholeData(registerIndx).itpcTrials=trialItpcData(:,cond4i);
            wholeData(registerIndx).convFreqs=frex;
            wholeData(registerIndx).convCycles=cycles;            
            wholeData(registerIndx).baselinePeriod=baselinePeriod;
%             wholeData(registerIndx).usedInAnalysis=EEG(registerIndx).usedInAnalysis;
            
        end
        
        
        % trial by trial .mat file saving 
        
%         for condSaveIdx=1:condCount
%             pData(condSaveIdx).subject=EEG(pti+pScalar+((condSaveIdx-1)*15)).subject;
%             pData(condSaveIdx).group=EEG(pti+pScalar+((condSaveIdx-1)*15)).group;
%             pData(condSaveIdx).condition=EEG(pti+pScalar+((condSaveIdx-1)*15)).condition;   
%             pData(condSaveIdx).chaninfo=EEG(1).chaninfo;
%             pData(condSaveIdx).times=times;
%             pData(condSaveIdx).srate=EEG(1).srate;
%             pData(condSaveIdx).erspTrials=trialErspData(:,condSaveIdx);
%             pData(condSaveIdx).itpcTrials=trialItpcData(:,condSaveIdx);
%             pData(condSaveIdx).convFreqs=frex;
%             pData(condSaveIdx).convCycles=s;            
%             pData(condSaveIdx).baselinePeriod=baselinePeriod;
%             pData(condSaveIdx).usedInAnalysis=EEG(pti+pScalar+((condSaveIdx-1)*15)).usedInAnalysis;
%         end
%         
%         TrialFileName=[EEG(pti+pScalar+((condSaveIdx-1)*15)).subject '_trials.mat'];
        
%         fprintf(['\n.\n.Saving %s \n.\n.' TrialFileName]);   
        
%         save(TrialFileName,'pData');
        
        pData=[];
        
        convData=MemoryconvData;
        itpcData=MemoryconvData;
        trialErspData=MemoryTrialData;
        trialItpcData=MemoryTrialData;        
end

% GAdata=computeConvolutionGA(wholeData);
fprintf('\nDone...\n');


%% end