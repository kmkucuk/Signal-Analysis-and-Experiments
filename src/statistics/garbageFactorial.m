% while 1 
%    counter=counter+1;
%    factormatrix(counter,:)= repmat([ones(1,pcount*2^(factorcount+1-counter)) ones(1,pcount*2^(factorcount+1-counter))+1],1,2^(counter-1));  
%    analyzematrix=[analyzematrix factormatrix(counter,:)];
factorcount=3;
pcount=12;
    group        =[repmat(ones(1,12),1,2^(factorcount)) repmat(ones(1,12)+1,1,2^(factorcount))];
    task         =repmat([ones(1,pcount*2^(factorcount-1)) ones(1,pcount*2^(factorcount-1))+1],1,2);
    stability    =repmat([ones(1,pcount*2^(factorcount-2)) ones(1,pcount*2^(factorcount-2))+1],1,4);
    ROI          =repmat([ones(1,pcount*2^(factorcount-3)) ones(1,pcount*2^(factorcount-3))+1],1,8);
    
%     if counter==factorcount
%         break
%     end
% end
submatrix{1}=repmat(submatrix{1},1,prod(bsflevels(1:bsfi-1)));
% analyzematrix=[analyzematrix subj];


includedElderIndx=[1,3,4,5,7,8,10,11,12,13,14,15]; % ERSP exclusion
includedYoungIndx=[1,2,3,4,5,7,10,11,12,13,14,15]+15; % ERSP exclusion
includearray=[includedElderIndx includedYoungIndx];
pcount=length(includearray)/2;
spssStructure=spssStructure(includearray);
fnames=fieldnames(spssStructure);
fnames=fnames(2:end);