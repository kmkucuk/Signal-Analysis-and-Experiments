function computeConvolutionGA(EEG,datatype,chanfield,pCount,exclude)        % exclude=1 means participant exclusion will be used.
% pCount= participant count in each group (must be equal). 
% chanfield = name of the channel information field (e.g. chaninfo or
% pairChans)
% datatype= name of the data field (e.g. 'erspdata', 'erspAvgROI' etc.)


%% Participant Exclusion
% excludedelder=[];
% excludedyoung=[];
% for i =1:15
%     excludedelder(i)=EEG(i).usedInAnalysis;
%     excludedyoung(i)=EEG(i+length(EEG)/2).usedInAnalysis;
% end
% 
% includedElderIndx=find(excludedelder==1);
% 
% includedYoungIndx=find(excludedyoung==1);
% 
% randIncludedCount=abs(length(includedYoungIndx)-length(includedElderIndx));

%Shuffles the order of indices of the young participants. This way we get a
%random ordered participant indices and deleting the first "randomExcludedCount" indices
%means we will exclude "randomExcludedCount" number of participants
%randomly. Uncomment this section if you want to randomize participants
%again.
%
%includedYoungIndx=shuffle(includedYoungIndx); 
%includedYoungIndx(1:randIncludedCount)=[];  
%
%After the first randomization the indices of included participants are
%below. Beware that these are not original subject numbers, just the order
%of the participants from 1 to 15 in alphabetical order.
%
% ERSP Exclusion Indices: % for MSc Thesis and Theta paper of K. Mert K���k
%Older=[1,3,4,5,7,8,10,11,12,13,14,15];
%Young=[1,2,3,4,5,7,10,11,12,13,14,15];
%
% ITC Exclusion Indices:  % for MSc Thesis and Theta paper of K. Mert K���k
%Older=[1,2,3,4,7,8,10,11,12,13,14,15]; % 5nd 6th and 9th ITC exclusion (check documentation for ERSP exclusion)
%Young=[1,2,3,4,8,9,10,11,12,13,14,15]; % 5th, 6th, and 7th ITC exclusion (check documentation for ERSP exclusion)

% includedElderIndx=1:14; % ITPC stim onset exclusion alpha paper of K. Mert K���k, no exclusions
% 
% includedYoungIndx=1:14; % ITPC stim onset exclusion alpha paper of K. Mert K���k, no exclusions
% 
% includedElderIndx=[1 2 4 7 8 10 11 12 13 14 15]; % ERSP exclusion 37 Trial alpha paper of K. Mert K���k
% includedYoungIndx=[1 2 3 4 6 7 9 10 13 14 15]; % ERSP exclusion 37 Trial alpha paper of K. Mert K���k
if exclude == 1
    
    includedElderIndx=[1,3,4,5,7,8,10,11,12,13,14,15];
    includedYoungIndx=[1,2,3,4,5,7,10,11,12,13,14,15];
else
    pIndices = 1:length(EEG);
end

% inclusionCell=[includedElderIndx;includedYoungIndx];

% assignin('base','excell',inclusionCell);

% iteration marker for registry to a struct
kk=1;
%% Computing and Registering ERSP/ITPC Grand averages
for i = 1:pCount:length(EEG)  
    pIndices=[1:pCount]-1;
    if strncmp(EEG(i).subject,'sgo',3) && exclude
        pIndices=includedElderIndx-1;

    elseif strncmp(EEG(i).subject,'sgy',3) && exclude
        pIndices=includedYoungIndx-1;
    end
%     pIndices=includedElderIndx-1;
    disp(pIndices+i);
    stats(kk).group=EEG(i).group;
    stats(kk).condition=EEG(i).condition;
    stats(kk).(datatype)=mean(cat(5,EEG(pIndices+i).(datatype)),5);
    stats(kk).STD=std(cat(5,EEG(pIndices+i).(datatype)),0,5)/sqrt(length(pIndices));
%     stats(kk).erspAvgROI_AnteriorPosterior=mean(cat(5,EEG(pIndices+i).erspAvgROI_AnteriorPosterior),5);
%     stats(kk).itpcdata=mean(cat(5,EEG(pIndices+i).itpcdata),5);
    
    %stats for arbitraryOnset - COMMENT IF YOU DO NOT USE ARB_ONSET
%     concatRT=cat(2,EEG(pIndices+i).arbitraryIndx);
%     statsOnset={mean(concatRT),std(concatRT),length(concatRT)};
%     stats(kk).RTarray=concatRT;
%     stats(kk).RTstats=statsOnset;
    
    kk=kk+1;    
    

end
            
%% Registering parameters in a structure variable              
for i = 1:length(stats)
   
%    stats(i).baselinePeriod=EEG(i).baselinePeriod; 
   stats(i).times=EEG(i).times; % BEWARE OF THIS, CORRECT IF YOU ARE NOT USING ARBITRARY ONSET MARKERS.
   stats(i).convFreqs=EEG(i).convFreqs;
   stats(i).convCycles=EEG(i).convCycles;
   stats(i).(chanfield)=EEG(i).(chanfield);
%    stats(i).srate=EEG(i).srate;
%    if i < length(stats)/2
%         stats(i).includedParticipants=inclusionCell(1,:); %%% register older excluded participant indices
%    else
%         stats(i).includedParticipants=inclusionCell(2,:);  %%% register younger excluded participant indices 
%    end
end

assignin('base','convStats',stats);
