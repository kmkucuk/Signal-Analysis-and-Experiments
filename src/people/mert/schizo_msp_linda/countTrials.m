
healthyExclusionIndex = [6 17];
patientExclusionIndex = [15 17];
removeVector = [];
for k = 1:length(EEG)
    EEG(k).data = EEG(k).data(:,[1 2 3 4 5 6 9 10],:);
    EEG(k).chaninfo = EEG(k).chaninfo([1 2 3 4 5 6 9 10]);
    EEG(k).srate = 125;
   if EEG(k).usedInAnalysis == 0
       removeVector = [removeVector k];
   end
   
end
EEG(removeVector)=[];



removeVector = [];
for k = 1:length(ALLEEG)
    
   if ALLEEG(k).usedInAnalysis == 0
       removeVector = [removeVector k];
   end
   
end
ALLEEG(removeVector)=[];

pCount = 20;
trialmatrix=nan(4,pCount);
for j = 1:4
    trialvector = [];
    conditionIndex = (1+((j-1)*pCount));
    for k = conditionIndex:(conditionIndex+pCount-1)
        trialvector = [trialvector size(EEG(k).data,3)];
    end
    trialmatrix(j,:) = trialvector;
end

newtrialmatrix=nan(2,2);
it=0;
for ki=1:2
    for ji = 1:2
        it=it+1;
        newtrialmatrix(ki,ji)=mean(trialmatrix(it,:),2)';
        
    end
end


%% Unnecessary exclusion below
% 
% 
% removeVector2=[];
% for k = 1:length(EEG)
%     name = EEG(k).subject(1:5);
% 
%     check = ~isempty(regexp('nsp20',name)); % low exo stable epoch = 11
%     check2 = ~isempty(regexp('lrp14',name)); % low exo stable epoch = 12 
%     check3 = ~isempty(regexp('nsk05',name)); % low endo uns epoch = 15 
%     check4 = ~isempty(regexp('nsk02',name)); % low endo uns epoch = 14
%     if check || check2 || check3 || check4
%         removeVector2=[removeVector2 k];
%     end
% end
% EEG(removeVector2)=[];
% 
% 
% 
% pCount = 19;
% trialmatrix2=nan(8,pCount);
% for j = 1:8
%     trialvector = [];
%     conditionIndex = (1+((j-1)*pCount));
%     for k = conditionIndex:(conditionIndex+pCount-1)
%         trialvector = [trialvector size(EEG(k).data,3)];
%     end
%     trialmatrix2(j,:) = trialvector;
% end
% newtrialmatrix2=nan(2,4)
% it=0;
% for ki=1:2
%     for ji = 1:4
%         it=it+1;
%         newtrialmatrix2(ki,ji)=mean(trialmatrix2(it,:),2)'
% 
%     end
% end
