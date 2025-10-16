function behavioralParameters=matchOnsets(onset_responseTable,no_onset_responseTable,enableOnsetEstimation,enableReversalRateEstimation,exo_endo)
% onset_responseTable    = ACTUAL       stimulus-onset based response registry for exogenous trials 
% no_onset_responseTable = ESTIMATED    stimulus-onset based response registry for exogenous and endogenous trials both

% condition = 0 endogenous reversal rate estimation (no RT)
% condition = 1 endogenous trial onset estimation 
% condition = 2 exogenous trial onset estimation 

parameters = [];


backupOnset         = no_onset_responseTable;
respOnsetReversals  = backupOnset(:,7);
respOnset_correct   = regexp(backupOnset(:,3),'Correct');
respOnset_correct   = find(~cellfun(@isempty,respOnset_correct));

% if there is no reversal rate or Onset estimation, just compute exogenous
% RTs. Otherwise either (i) calculate total reversals or (ii) estimate
% onsets and related behavioral parameters 
if ~isempty(respOnset_correct) || (~enableOnsetEstimation && ~enableReversalRateEstimation)
    
            if enableReversalRateEstimation
                reversalRate            = length(respOnset_correct); % calculate reversal rate per minute 
                parameters              = reversalRate;
            end


            if exo_endo == 1  % run an onset matching algorithm if trial is exogenous and also onset estimation is enabled 
                backupResponse = onset_responseTable;

                stimOnsetReversals = backupResponse(:,7);

                trialCount          = length(find(~cellfun(@isempty,backupResponse(:,3))))-1;

                stimOnset_correct   = regexp(backupResponse(:,3),'Correct');
                stimOnset_correct   = find(~cellfun(@isempty,stimOnset_correct));

                stimOnset_wrong     = regexp(backupResponse(:,3),'Wrong');
                stimOnset_wrong     = find(~cellfun(@isempty,stimOnset_wrong));

                stimOnset_omission  = regexp(backupResponse(:,3),'Omission');
                stimOnset_omission  = find(~cellfun(@isempty,stimOnset_omission));    

                stimOnset_release   = regexp(backupResponse(:,3),'Failed_Release');
                stimOnset_release   = find(~cellfun(@isempty,stimOnset_release));

                actual_mean_RT      = nanmean(cell2mat(backupResponse(stimOnset_correct,5)));    
                actual_accuracy     = length(stimOnset_correct)/trialCount; 
                parameters = [parameters, actual_mean_RT, actual_accuracy];
            end

            if enableOnsetEstimation && exo_endo == 1
                matchReg=[];

                        for k= 1:length(stimOnset_correct)
                            for i = 1:length(respOnset_correct)
                                stimIndx=stimOnset_correct(k);
                                respIndx=respOnset_correct(i);
                                matchOrNot=stimOnsetReversals{stimIndx}==respOnsetReversals{respIndx};
                                if matchOrNot
                                matchReg=[matchReg,[stimOnsetReversals{stimIndx};stimIndx;respIndx]];

                                break
                                end
                            end
                        end
                        correctEstimationPercentage     =length(matchReg)/length(stimOnset_correct);         
                        currentDate                     = datetime;
                        currentpath=pwd;
                        cd(currentpath)
                        onsetMatchFolder = [currentpath, '\coloredOnsetMatching'];
                        mkdir(onsetMatchFolder)
                        cd(onsetMatchFolder)
                        if ~isfile('estimationControlRegistry.txt')  
                            outfile = fopen('estimationControlRegistry.txt','w'); % open a file for writing data out
                            fprintf(outfile, 'controlDate\t stimCorrectCount\t responseCorrectCount\t matchedCorrectCount\t correctEstimationPercentage\t stimWrongCount\t stimOmissionCount\t stimFailedRelease\t trialCount\t\n');
                            fprintf(outfile, '%s\t  %d\t %d\t %d\t %6.2f\t  %d\t  %d\t  %d\t %d\t \n',...
                                currentDate,length(stimOnset_correct),length(respOnset_correct),...
                                length(matchReg),correctEstimationPercentage,length(stimOnset_wrong),...
                                length(stimOnset_omission),stimOnset_release,trialCount);
                        else
                            outfile = fopen('estimationControlRegistry.txt','a+'); % open a file for writing data out
                            fprintf(outfile, '%s\t  %d\t %d\t %d\t %6.2f\t  %d\t  %d\t  %d\t %d\t \n',...
                                currentDate,length(stimOnset_correct),length(respOnset_correct),...
                                length(matchReg),correctEstimationPercentage,length(stimOnset_wrong),...
                                length(stimOnset_omission),stimOnset_release,trialCount);
                        end
                        fclose('all');
                estimated_mean_RT     = nanmean(cell2mat(backupOnset(respOnset_correct,5))); % get mean of estimated RTs    
                parameters=[parameters, estimated_mean_RT];

            end


        behavioralParameters=parameters;    
else
    behavioralParameters=[];

end









