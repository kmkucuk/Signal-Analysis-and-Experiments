function findAvgPeakLatency(EEG,twindow,conditions,channel,datatype,freq)

secs=EEG(1).times;
height=[];

% adjust freq to all frequencies in the data if freq input is
% specified as empty 

if ~exist('freq','var')
    sizedat=size(EEG(1).(datatype),1);
    sizedat=1:sizedat;
    freq=sizedat;                  
end

allPeakParameters=[];
for i = 1:length(conditions)
    
    pScalar=(conditions(i)-1)*1;   
    
    for pti = 1:2
        
        pIndx=pti+pScalar;
        
        data=EEG(pIndx).(datatype);
        
        dataDim=size(data);
        
        if datatype(1)=='e' || datatype(1)=='i'
            
            data=data(freq,:,:,channel);
            tCount=1;
            
        else
            %% if data is averaged, there are no trials
            if length(dataDim)<3
                
                data=EEG(pIndx).(datatype)(:,channel);
                tCount=1;
                
            else
                
                data=EEG(pIndx).(datatype)(:,channel,:);
                tCount=size(data,3);
            end
        
        end
        
        peakStructure(pIndx).subject=EEG(pIndx).group;
        peakStructure(pIndx).condition=EEG(pIndx).condition; %#ok<*AGROW>
            
        if tCount<=1
            
            [peakIndx,peakValue,peakValIndx,height]=findPeakInTimeWindow(data,twindow,secs,datatype);
            peakStructure(pIndx).peakValue=peakValue;
            peakStructure(pIndx).height=height;
            peakStructure(pIndx).peakLatency=secs(peakIndx);
        
        else
            
            for ti = 1:tCount
                
                datatrial=data(:,:,ti);
                
                [peakIndx,peakValue,peakValIndx,height]=findPeakInTimeWindow(datatrial,twindow,secs,datatype);     
                
                peakSeconds=secs(peakIndx);
                
                peakParameters=[peakValue;peakSeconds;height];
                
                allPeakParameters=cat(2,allPeakParameters,peakParameters);
                
            end
            meanPeakParameters=mean(allPeakParameters,2);            
            peakStructure(pIndx).peakValue=meanPeakParameters(1);
            peakStructure(pIndx).peakLatency=meanPeakParameters(2);
            peakStructure(pIndx).peakHeight=meanPeakParameters(3);
            peakStructure(pIndx).singleSweepPeakParameters=allPeakParameters;
            allPeakParameters=[];
        end
        
        if  datatype(1)=='e' && exist('sizedat','var') 
            peakStructure(pIndx).peakFreq=EEG(pIndx).convFreqs(peakValIndx);
        elseif ~exist('sizedat','var') && datatype(1)=='e' 
%             peakStructure(pIndx).peakFreq=EEG(pIndx).convFreqs(freq(peakValIndx));
        end
        
        
    end
    
    
end

assignin('base','peakStructure',peakStructure);
        
        