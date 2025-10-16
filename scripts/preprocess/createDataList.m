%%% x and y can be any file name identifiers.
%%% For example: in Aging Bremen data, participants have file names like:
%%% 'sgy013_Kn.mat' or 'sgo034_Kn.mat'
%%% this particular coding is as follows:
%%%
%%%
%%% -> 3_Kn = exogenous, 4_Kn = endogenous multistable stimuli. 
%%% Therefore
%%% x can be, x = 'sgy'
%%% y can be, y = '4_Kn' 
%%% If you input x and y as such, list of file names would include only
%%% young participants data in endogenous stimulus condition.
%%%
%%% 'sg' = project name
%%%
%%% 'y' or 'o' = young or older part. group
%%%
%%% '01' or '03' = participant code
%%%
%%% '3_Kn' or '4_Kn' = experimental condition
%%%
%%% Having two identifiers would suffice for most experiments.
%%% Kurtulu? Mert Küçük, 24/05/2020, IEU, Izmir


function [partList]=createDataList(x,y,path) 

cd(path)

list=ls;
Exolist={};
listMrk=0;

%%% create a cell vector from files that include 3_Kn characters (exo
%%% condition)
for i = 1:length(list)
    
    idxMatch=regexp(list(i,:),x);
    
    if idxMatch > 0
        listMrk=listMrk+1;
        Exolist{listMrk}=list(i,:);
        
    end
    
end

listMrk=0;
vExolist={};
for i = 1:length(Exolist)
    
    idxMatch=regexp(Exolist{i},y);
    
    if idxMatch > 0
        listMrk=listMrk+1;
        vExolist{listMrk}=Exolist{i};
        
    end
    
end

%%% these names include a lot of space '  ' when first created. below
%%% deletes all space characters. 

for i = 1:length(vExolist)   
    
    vExolist{i}=strrep(vExolist{i},' ',[]);         
    vExolist{i}=strrep(vExolist{i},'.mat',[]);
end
partList=vExolist;
end

