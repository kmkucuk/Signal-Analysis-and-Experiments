% calculates: mean and standard deviation of a field in a struct.

% EEG: struct variabe.

% fieldname: fieldname of the struct variable. 



function calculateParameters(EEG,initP,pCount,fieldname)

pCount=pCount-1; 
data=cat(2,EEG(initP:(initP+pCount)).(fieldname));

fieldMean=mean(data);

fieldSD=std(data);

meanname=[fieldname 'Mean'];

sdname=[fieldname 'SD'];

% fieldCount=find(data.noButtonTrials);
% NoPressCountName=[fieldname 'NoPressCount'];


assignin('base',[fieldname 'Mean'],fieldMean);

assignin('base',[fieldname 'SD'],fieldSD);
    
    
    
end
    



