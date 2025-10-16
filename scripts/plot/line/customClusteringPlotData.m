% Created by: Kurtulu? Mert K���k (11/04/2021 uploaded to github).
function [stats,withinData]=customClusteringPlotData(datastruct,conditions,pcount,pairs,groupnames)
fnames=fieldnames(datastruct);
groupIndx = find(~cellfun(@isempty,regexp(fnames,'subject')))+1;
if isstruct(datastruct)
    matdata=struct2cell(datastruct);
    matdata=reshape(matdata,size(matdata,1),size(matdata,3)).';
    matdata=cell2mat(matdata(:,groupIndx:end));
    withinBackup=matdata;
else
    withinBackup=datastruct;
end

condLength=length(conditions);
%used only for within-error bar correction

% conditions = column indices in the data matrix
% ERSP Exclusion Indices:
%Older=[1,3,4,5,7,8,10,11,12,13,14,15];  % ERSP exclusion ThetaPaper/Thesis
%Young=[1,2,3,4,5,7,10,11,12,13,14,15]; % ERSP exclusion ThetaPaper/Thesis

% ITC Exclusion Indices:
%Older=[1,2,3,4,7,8,10,11,12,13,14,15]; % 5nd 6th and 9th ITC exclusion (check documentation for ERSP exclusion)
%Young=[1,2,3,4,8,9,10,11,12,13,14,15]; % 5th, 6th, and 7th ITC exclusion (check documentation for ERSP exclusion)

includedElderIndx=[1 2 4 7 8 10 11 12 13 14 15]; % ERSP exclusion ENDOGENOUS 37 Trial alpha paper of K. Mert K���k
includedYoungIndx=[1 2 3 4 6 7 9 10 13 14 15]; % ERSP exclusion 37 Trial alpha paper of K. Mert K���k

includedElderIndx=[1,3,4,5,7,8,10,11,12,13,14,15];  % ERSP exclusion ThetaPaper/Thesis
includedYoungIndx=[1,2,3,4,5,7,10,11,12,13,14,15]; % ERSP exclusion ThetaPaper/Thesis

% 
% includedElderIndx=[1,2,3,4,7,8,10,11,12,13,14,15]; % 5nd 6th and 9th ITC exclusion (check documentation for ERSP exclusion)
% includedYoungIndx=[1,2,3,4,8,9,10,11,12,13,14,15]; % 5th, 6th, and 7th ITC exclusion (check documentation for ERSP exclusion)

kk=1;
pIndices=[1:20]-1;
for i = 1:pcount:length(datastruct)  
    
    if strncmp(datastruct(i).subject,'lrk',3) || strncmp(datastruct(i).subject,'nsk',3) %datastruct(i).group == 1 % uncomment after process
%         pIndices=includedElderIndx-1;
        group='Control';
    elseif strncmp(datastruct(i).subject,'lrp',3) || strncmp(datastruct(i).subject,'nsp',3)
%         pIndices=includedYoungIndx-1;
        group='Patient';
    end
%     pIndices=includedYoungIndx-1; % remove after process 
%     disp(pIndices+i);
    
    stats(kk).group=groupnames{i};
    stats(kk).conditions=fnames(groupIndx:end);
    stats(kk).data=mean(matdata(pIndices+i,:),1);
    disp(mean(matdata(pIndices+i,:),1));
    stats(kk).error=(std(matdata(pIndices+i,:),0,1)/sqrt(length(pIndices))); %*abs(norminv(.025));     % *abs(norminv(.05))
    kk=kk+1;    
    
    
end


withinData=nan(size(withinBackup));
for k = 1:size(withinBackup,1)
    
    if strncmp(datastruct(k).subject,'lrk',3) || strncmp(datastruct(k).subject,'nsk',3)
        groupidx=1;
    elseif strncmp(datastruct(k).subject,'lrp',3) || strncmp(datastruct(k).subject,'nsp',3)
        groupidx=2;
    end
    
    conditeration=-1;
    for j = 1:pairs:condLength
        conditeration=conditeration+1;
        grandavg=mean(stats(groupidx).data(conditions(j:(j+pairs-1))),2);
        
        stats(groupidx).grandAvg=grandavg;
        subjavg=mean(withinBackup(k,conditions(j:(j+pairs-1))),2);        
        for z = 1:pairs
            oldvalue=withinBackup(k,conditions(z+(pairs*(conditeration))));   
            newvalue=oldvalue-subjavg+grandavg;
            withinData(k,conditions(z+(pairs*(conditeration))))=newvalue;            
        end
    end
end


kk=1;

for i = 1:pcount:length(datastruct)  
    
    if strncmp(datastruct(i).subject,'sgo',3)
        pIndices=includedElderIndx-1;
        group='Older';
    elseif strncmp(datastruct(i).subject,'sgy',3)
        pIndices=includedYoungIndx-1;
        group='Young';
    end
    
    disp(pIndices+i);
    
    stats(kk).withinerror=std(withinData(pIndices+i,:),0,1)/sqrt(length(pIndices));
    stats(kk).CIs=stats(kk).withinerror*abs(norminv(.025)); %95 CI= 1.96    %98.75 CI= 2.5 (Theta ITC)      %99.80 CI = 2.8782 (for alpha paper desynch/rebound)
    kk=kk+1;    
    

end

assignin('base', 'withinData', withinData)

    
    
