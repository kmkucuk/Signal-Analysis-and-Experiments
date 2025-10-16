function EEG=CreateNewOnset(EEG,pInit,pCount,markerchan)

timevector=EEG(1).times;

for i = pInit:(pInit+pCount)
    
    Markerdata=EEG(i).data(:,markerchan,:);
    
   
%     Buttondata=EEG(i).data(:,buttonchan,:);

    EEG(i).arbitraryIndx=zeros(1,size(Markerdata,3));
    EEG(i).arbitraryTimes=zeros(1,size(Markerdata,3));
    
    disp(EEG(i).subject)
    
    for k = 1:size(Markerdata,3)
        
        arbitraryIndx=AssignNewOnset(Markerdata(:,1,k),timevector);
arbitraryIndx                
        EEG(i).arbitraryIndx(k)=arbitraryIndx;
        
        EEG(i).arbitraryTimes(k)=timevector(arbitraryIndx);
        
        disp(k);
    end
    
end

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        %create new time vector
        %arbitraryTimesPos=0:.002:(2500-arbitraryIndx-1)/500;
        
        %arbitraryTimesNeg=-.002:-.002:(-arbitraryIndx/500);
        
        %arbitraryTimes=[flip(arbitraryTimesNeg) arbitraryTimesPos];
        
        