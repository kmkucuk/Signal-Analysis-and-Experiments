%%%
%%% preCount=count of data points before stimulus
%%%
%%% postCount=count of data points after stimulus
%%%
%%% initP = initial participant, row of first participant to process
%%% 
%%% pCount = how many of the subsequent participants to process 
%%%
%%% srate = sampling rate
function pData=extractWaveletSeries(pData,initP,pCount,preCount,postCount,datatype,srate)

arbitraryTimes=(-preCount/srate):(1/srate):(postCount/srate);

for i = initP:(initP+pCount)
    
    
    tCount=length(pData(i).arbitraryIndx);
    
    
    data=zeros(size(pData(i).(datatype),1),preCount+postCount+1,tCount,size(pData(i).(datatype),4));
    
    dataitpc=zeros(size(pData(i).(datatype),1),preCount+postCount+1,tCount,size(pData(i).(datatype),4));
    
    
    
    for k = 1:size(data,3)
        
        % breaks if iteration exceeds the amount of trials within the data
        if k > length(pData(i).arbitraryIndx)
            break;
        end
        
        arbitraryIndx=pData(i).arbitraryIndx(k);
        
        datacounts=(arbitraryIndx-preCount):(arbitraryIndx+postCount);
        
        data(:,:,k,:)=pData(i).(datatype)(:,datacounts,k,:);
        
        dataitpc(:,:,k,:)=pData(i).itpcTrials(:,datacounts,k,:);
        
        % delete excess trials so that the data is not corrupted by NANs
        

    end
        
        

    pData(i).arb_erspTrials=data;


    pData(i).arb_itpcTrials=dataitpc;    
    
    
    % average data according to trial counts
    
    %itpc
    pData(i).arb_itpcAvg=reshape(nanmean(dataitpc,3),...
        size(data,1),length(datacounts),10);
    
    %ersp
    pData(i).arb_erspAvg=reshape(nanmean(data,3),...
        size(data,1),length(datacounts),10);          
    
    
    
    pData(i).timesArbitrary=arbitraryTimes;
end