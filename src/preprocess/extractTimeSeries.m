%%%
%%% preCount=count of data points before stimulus
%%%
%%% postCount=count of data points after stimulus
%%%
%%% initP = initial participant, row of first participant to process
%%% 
%%% pCount = how many of the subsequent participants to process 
%%%
%%%
function EEG=extractTimeSeries(EEG,initP,pCount,preCount,postCount,datatype)

arbitraryTimes=(-preCount/500):.002:(postCount/500);

for i = initP:(initP+pCount)
    
    data=zeros(preCount+postCount+1,size(EEG(i).(datatype),2),size(EEG(i).(datatype),3));
        
    for k = 1:size(data,3)
        
        arbitraryIndx=EEG(i).arbitraryIndx(k);
        
        datacounts=(arbitraryIndx-preCount):(arbitraryIndx+postCount);
        
        data(:,:,k)=EEG(i).(datatype)(datacounts,:,k);
        
    end
    
    EEG(i).arbitraryData=data;
    
    EEG(i).timesArbitrary=arbitraryTimes;
end
    

