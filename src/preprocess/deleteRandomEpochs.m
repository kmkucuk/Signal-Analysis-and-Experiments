%%% EEG = Struct variable with all datasets
%%%
%%% conditions = [1 5] etc. enter the condition order. For instance if
%%% stable endo is on the third order (e.g. (15x3)+1 th participant), type
%%% 3. 
%%%
%%% minvalue = 76 or 40 or any desired epoch count for each condition 

function deleteRandomEpochs(EEG,conditions,minvalue,struct,pcount)

conditions=conditions-1;


for i = 1:length(conditions)
    
    conditionScalar=pcount*conditions(i);
    
    
    for k = 1:pcount
        
        sizeEpochs=size(EEG(k+conditionScalar).data,2);
        
        if sizeEpochs>minvalue
            
            removeEpochIndx=randperm(sizeEpochs,sizeEpochs-minvalue);
            
            % Uncomment if you want to delete epochs with this script.
            % Otherwise this only registers the "to-be" removed epochs for
            % stable conditions
            EEG(k+conditionScalar).data(:,removeEpochIndx,:)=[];

            fprintf('Subject: %s \nEpoch count: %d \nDeleted count: %d \nRemaining count: %d \n',...
                EEG(k+conditionScalar).subject(1:5), sizeEpochs, ...
                length(removeEpochIndx), sizeEpochs-length(removeEpochIndx));
            struct(k+conditionScalar).subject=EEG(k+conditionScalar).subject;
            struct(k+conditionScalar).condition=EEG(k+conditionScalar).condition;
            struct(k+conditionScalar).artifactIndex=removeEpochIndx;
            
        end
        

        
        
    end
    
end
assignin('base','EEG',EEG); 
assignin('base','randomDeletedEpochs',struct); 