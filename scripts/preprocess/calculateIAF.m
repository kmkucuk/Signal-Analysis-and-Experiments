function EEG=calculateIAF(EEG,conditions,pcount)

condCount=length(conditions);

for i = 1:condCount    
    
    pScalar=(conditions(i)-1)*15;
    
    for pti = 1:pcount
        
        pIndx=pti+pScalar;
        disp(pIndx);
        domFreq=EEG(pIndx).dominantAFC;
                
        EEG(pIndx).lowerAlpha1=[domFreq-4 domFreq-2];
        EEG(pIndx).lowerAlpha2=[domFreq-2 domFreq];
        EEG(pIndx).upperAlpha2=[domFreq domFreq+2];
        
    end
        
    
end