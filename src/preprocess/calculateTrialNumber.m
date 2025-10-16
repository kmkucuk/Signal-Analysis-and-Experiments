function [TrialCounts,TrialStats]=calculateTrialNumber (EEG, conditions)


includedElderIndx=[1,2,3,4,5,7,8,10,11,12,13,14,15]; % 2nd 6th and 9th

includedYoungIndx=[1,2,3,4,5,7,10,11,12,13,14,15]; % 6th, 8th and 9th

TrialCounts=[];
TrialStats=[];

condcount=length(conditions);

for i = 1:condcount
        t=conditions(i);
        if t < 6

            pIndx=includedElderIndx;

            for k = 1:length(pIndx)

            TrialCounts(k+((t-1)*12),1)=size(EEG(pIndx(k)+((t-1)*15)).data,3);
            TrialCounts(k+((t-1)*12),2)=t;
            end

        else

            pIndx=includedYoungIndx;

            for k = 1:length(pIndx)

            TrialCounts(k+((t-1)*12),1)=size(EEG(pIndx(k)+((t-1)*15)).data,3);      
            TrialCounts(k+((t-1)*12),2)=t;
            end
            
        end
        
        
            
            
            TrialStats(t,1)=mean(TrialCounts((1+((t-1)*12)):((t)*12),1));
            
            TrialStats(t,2)=std(TrialCounts((1+((t-1)*12)):((t)*12),1));
            
end