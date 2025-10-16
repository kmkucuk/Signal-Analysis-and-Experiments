
includedElderIndx=[1,2,3,4,7,8,10,11,12,13,14,15]; % ERSP Exclusion Indices: % for MSc Thesis and Theta paper of K. Mert K���k
includedYoungIndx=[1,2,3,4,5,7,10,11,12,13,14,15]; % ERSP Exclusion Indices: % for MSc Thesis and Theta paper of K. Mert K���k
includedElderIndx=[includedElderIndx includedElderIndx+15 includedElderIndx+30 includedElderIndx+45 includedElderIndx+60];
includedYoungIndx=[includedYoungIndx includedYoungIndx+15 includedYoungIndx+30 includedYoungIndx+45 includedYoungIndx+60]+75;
allPIndx = [includedElderIndx includedYoungIndx];
epochCount={};
iter=0;
for k = allPIndx
    iter=iter+1;
    epochCount{iter,1}=EEG(k).subject;
    epochCount{iter,2}=EEG(k).condition;
    epochCount{iter,3}=EEG(k).group;
    epochCount{iter,4}=size(EEG(k).data,3);
end
epochAverage=[];
iter=0;
for k = 13:12:119
iter=iter+1;
epochAverage(iter,1)=mean(epochCount((k-12):k-1));
epochAverage(iter,2)=std(epochCount((k-12):k-1),[],2);
end

cd('F:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\Data_Analysis\Mert_ThetaArticle\Theta\Revision_New')
writetable(cell2table(epochCount),'epochCounts.xlsx')