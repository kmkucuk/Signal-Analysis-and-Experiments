function EEG=excludeRandomEpochsLinda(EEG,path) 
%%% EEG = workspace variable with all participant data 
%%% path = directory of individual data files of participants 
% cd('F:\EEGserver\Schizo_Linda\Neu_Anpassung_35_Epochen')
cd(path);

pCount = length(EEG);
for pIndx = 1:pCount
    pname = EEG(pIndx).subject;
    condName = EEG(pIndx).condition;
    datasize = size(EEG(pIndx).data,3);
    
    if datasize > 35 % load data only if there are more than 35 epochs
        fprintf('Processing participant: %s\n',pname);
        fprintf('Processing condition: %s\n',condName);
        pVariable=load([pname '.mat']);
        pVariable=pVariable.vp;
        
        if ~isempty(regexp(condName,'instable_endogenous')) || ~isempty(regexp(condName,'instable_exogenous'))
            epochInfo = pVariable.TriggerSweeplisten.triggertab_instabil;
            dataFieldName = 'epochen_instabil';
            
        elseif ~isempty(regexp(condName,'stable_endogenous')) || ~isempty(regexp(condName,'stable_exogenous')) %#ok<*RGXP1>
            epochInfo = pVariable.TriggerSweeplisten.triggertab_stabil;
            dataFieldName = 'epochen_stabil';
        elseif ~isempty(regexp(condName,'trig_corr_exo'))
            epochInfo = pVariable.TriggerSweeplisten.triggertab_exo_trig_corr;
            dataFieldName = 'epochen_exo_trig_corr';
        end
        
        checkIfRandomExclusion = isempty(regexp(epochInfo(1,end),'_max35')); % check if there is a column with randomly excluded epochs 
        if checkIfRandomExclusion % skip to next iteration if there is none
            continue
        end
        

            

    else
        continue
    end

    selectIndices   = regexp(epochInfo(2:end,end),'select');
    selectIndices   = find(~cellfun(@isempty,selectIndices));
    fprintf('Selecting %d epochs: \n',length(selectIndices));
    fprintf('Epoch index: %d \n',selectIndices(:));
    EEG(pIndx).data = pVariable.data.(dataFieldName)(:,:,selectIndices);

end
