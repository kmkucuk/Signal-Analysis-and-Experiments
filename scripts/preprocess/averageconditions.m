function newstruct=averageconditions(datastruct,conditions,pairs)

matdata=datastruct;
if isstruct(datastruct)
    matdata=struct2cell(datastruct);
    matdata=reshape(matdata,size(matdata,1),size(matdata,3)).';
    matdata=cell2mat(matdata(:,2:end));
end


condCount=length(conditions);
% fcount=length(fnames);
conditeration=0;

conddata=nan(size(matdata,1),condCount/pairs);

for k = 1:pairs:condCount
    
    fpairs=k:(k+pairs-1);
    conditeration=conditeration+1;
    conddata(:,conditeration)=mean(matdata(:,conditions(fpairs)),2);
end


%%% subj names for new struct
for sbi = 1:size(datastruct,2)
    newstruct(sbi).subject=datastruct(sbi).subject; 
end

%%% cond names for new struct
for i = 1:condCount/pairs
    
    fname=input(['Type in name of condition ' num2str(i)],'s');
    for datai = 1:size(datastruct,2)
    newstruct(datai).(fname)=conddata(datai,i);
    end
    
    
end