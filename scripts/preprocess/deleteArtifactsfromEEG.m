function EEG=deleteArtifactsfromEEG(EEG,z) %%% EEG = EEG workspace variable with all participant data
                                %%% z = structure field for artifact
                                %%% removal.
participantCount=length(z);                     
for k = 1:participantCount 
    pnameArt = z(k).subject;
    pnameEEG = EEG(k).subject;
    epochVector=z(k).artifactIndex;
    fprintf('\nParticipant: %s_%s \n', EEG(k).subject(1:5),EEG(k).condition(1:9));
    subMatch = ~isempty(regexp(pnameArt,pnameEEG));
    if subMatch
        fprintf('\nMatched');
        if ~isempty(epochVector)
            EEG(k).data(:,:,epochVector)=[];

            fprintf('\nDeleting %d epochs:  ', length(epochVector));
    %         for i = 1:length(epochVector)
    % 
    %             if i == 1
    %                 EEG(k).data(:,:,epochVector)=[];
    %                 fprintf('Deleting epochs: %d ', epochVector(i));            
    %             else 
    %                 EEG(k).data(:,:,epochVector(i)-i+1)=[];
    %                 fprintf(' %d ', epochVector(i)-i+1);
    %             end 

    %         end
        else
            fprintf('No artifacts...');
        end
    else
        fprintf('\NO MATCH: %s      vs.         %s \n', pnameEEG,pnameArt);
    end
            
end



