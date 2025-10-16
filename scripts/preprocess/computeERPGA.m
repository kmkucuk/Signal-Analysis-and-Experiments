function stats=computeERPGA(EEG,datatype,exclude,pcount)


kk=1;
% 
% includedElderIndx=[1,3,4,5,7,8,10,11,12,13,14,15]; % 2nd 6th and 9th
% 
% includedYoungIndx=[1,2,3,4,5,7,10,11,12,13,14,15]; % 6th, 8th and 9th

% includedElderIndx=[1 2 3];
% includedYoungIndx=[1 2 3];
% includedElderIndx=[1,2,3,4,7,8,10,11,12,13,14,15]; % 5nd 6th and 9th ITC exclusion (check documentation for ERSP exclusion)
% % includedElderIndx=1:pcount;
% includedYoungIndx=[1,2,3,4,8,9,10,11,12,13,14,15]; % 5th, 6th, and 7th ITC exclusion (check documentation for ERSP exclusion)
% % includedYoungIndx=1:pcount;
includedElderIndx=[1,3,4,5,7,8,10,11,12,13,14,15];
includedYoungIndx=[1,2,3,4,5,7,10,11,12,13,14,15];
inclusionCell=[includedElderIndx;includedYoungIndx];


for i = 1:pcount:length(EEG)

    pIndices=[1:pcount]-1;
    if strncmp(EEG(i).subject,'sgo',3) && exclude
        pIndices=includedElderIndx-1;

    elseif strncmp(EEG(i).subject,'sgy',3) && exclude
        pIndices=includedYoungIndx-1;
    end

    disp(pIndices+i);
    stats(kk).group=EEG(i).group;
    stats(kk).condition=EEG(i).condition;
    stats(kk).avgdata=mean(cat(4,EEG(pIndices+i).(datatype)),4);
    stats(kk).STD=std(cat(4,EEG(pIndices+i).(datatype)),0,4)/sqrt(length(pIndices));

    kk=kk+1;    

end

for i = 1:length(stats)
  
   stats(i).times=EEG(i).times;
   stats(i).chaninfo=EEG(i).chaninfo;
   stats(i).srate=EEG(i).srate;
   if i < length(stats)/2
        stats(i).includedParticipants=inclusionCell(1,:); %%% register older excluded participant indices
   else
        stats(i).includedParticipants=inclusionCell(2,:);  %%% register younger excluded participant indices 
   end
end

