function EEG=findPeakFreqsEEG(EEG,conditions,freqRange,datatype,chan)

condCount=length(conditions);

for i = 1:condCount
    
    pScalar=(conditions(i)-1)*15;      

        
        for pti = 1:15
            
            pIndx=pti+pScalar;                  
            
            data=EEG(pIndx).(datatype)(:,1);
            
            frex=EEG(pIndx).fourrFreqs;
            
            [maxPower,maxFreq]=findPeakFreqs(data,freqRange,frex);
            
            domname=['dom_theta_' EEG(pIndx).clusterChan{chan}(1)];
            
            EEG(pIndx).(domname) = maxFreq;
            
        end
        
end