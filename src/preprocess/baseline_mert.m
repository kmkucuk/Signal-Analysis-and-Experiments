%%% baselinePeriod = a time window (e.g. -3 secs to -2.5 secs)
%%% chans = index of channels (e.g. [1 2 3 4])
%%% EEG = EEG struct variable

function [EEG,avg_data, prcssd_data] = baseline_mert(EEG,baselinePeriod) 

secs=EEG(1).times;

[~, minIndx]=min(abs(secs-(baselinePeriod(1))));

[~, maxIndx]=min(abs(secs-(baselinePeriod(2))));

%%% if the length of the baseline period is not even, then decrease maxIndx
%%% by one
if ~mod(maxIndx-minIndx,2)
   maxIndx=maxIndx-1; 
end

prcssd_data = [];
% if data vector with single sweeps, with 2 dimensions this is "1"

for pC = 1:length(EEG)
    
    
    data=EEG(pC).data;
    
    sw = size(data,3);
    
    fprintf('Processing participant: %s \ngroup: %s \ncondition: %s\niteration: %d\n..',...
        EEG(pC).subject, EEG(pC).group,EEG(pC).condition,pC);
    
        for w = 1:sw          
            
            Trialdata = data(:,:,w);
            
            baseline = nan_mean(Trialdata(minIndx:maxIndx,:),1);

            Trialdata= Trialdata(:,:) - baseline;      

            prcssd_data = cat(3,prcssd_data, Trialdata);

        end       
        
        prcssd_data(minIndx:maxIndx,:,:)=[]; %%% Removes baseline timepoints
        
        EEG(pC).times(minIndx:maxIndx)=[];

        EEG(pC).baselineIdx=[minIndx maxIndx];

        EEG(pC).data=prcssd_data;       %%% Will register filtered data into original ALLEEG structure.
        
        avg_data = mean(prcssd_data,3); %%% averages data across trials      
        
        EEG(pC).avgdata=avg_data;       %%% Will register trial-averaged data into original ALLEEG structure.

        avg_data=[];
        
        prcssd_data=[]; 
        
end
