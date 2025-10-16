function [results, finalstruct]=nestedFactorialANOVA(datavariable,wsflevels,bsflevels,pcounts,nestingmatrix,factornames)
%
% EXAMPLE USAGE: [results, finalstruct]=createstatsmatrix(spssStructure,[2 2 4],[12 12],[3 2 5 1],{'Group','Task','Stability','ROI','Subject'}),
%
% datavariable = name of the data variable in the workspace 
% (rows: subjects, columns: datapoints)
%
%
% wsflevels= levels of each within subjects factor in ordered fashion, example:
% [2 2 3 5] means that:
% 1st factor: 2 levels
% 2nd factor: 2 levels
% 3rd factor: 3 levels
% 4th factor: 5 levels
%
%
% ### IMPORTANT, Always enter factor levels starting from the factor that is
% most encompassing to least. for example:
% [2 2 3 4] means that:
%
% 1st factor: 2 levels - group / every group has each task
% 
% 2nd factor: 2 levels - task / every task has each stimulus
% 
% 3rd factor: 3 levels - stimulus / every stim has each of the four
% quadrants (e.g. in a visuo-spatial presentation)
%
% 4th factor: 4 levels - four space quadrants (northwest, northeast,
% southwest, southeast etc.)
%
%
%
% bsflevels = number of participants in each group by a vector. For example:
% [13 13 15]: means that first group n=13, second n=13, and third n=15.
%
%
% nesting = create a vector pairs of nested factors. 
%
% Example: [1 4] would mean first factor is nested under 4th factor
%         [4 2 3 1] would mean 4th nested under 2 AND 3rd nested under 1
%
% factornames= cell array of factor names {'group','drug'} etc.
%
% ### IMPORTANT, if you are using repeated and/or mixed design always enter
% an additional factor at the end for random effects of subjectts.
%    !! This is necessary for designs that include repeated measures !!
%
% for example your factors are: {'group','drug'}
% but you SHOULD enter your factor names as: {'group','drug','subjects'}
%
%
% Created by: Kurtulu? Mert Küçük 03/03/2021. (11/04/2021: github upload)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Converting data variable if the format is not matrix


if isstruct(datavariable)
    matdata=struct2cell(datavariable);
    matdata=reshape(matdata,size(matdata,1),size(matdata,3)).';
    matdata=cell2mat(matdata(:,2:end));
    withinBackup=matdata;
else
    withinBackup=datastruct;
end



wsfactorcount=length(wsflevels);
groupcount=length(bsflevels);

fmatrix={};
for k = 1:wsfactorcount
    fmatrix{k}=[];
end

groupmatrix={};
for k =1:groupcount
    groupmatrix{k}=[];
end

submatrix={};
submatrix{1}=[];

% Creating matrix for dummy coded factors

gnumbers=0;
prevcounts=[];
for bsfi=1:groupcount
    
    if bsfi==1
        ipcounts=pcounts(1:bsflevels(bsfi));
        
    else
        gnumbers=sum([gnumbers bsflevels(bsfi-1)]);
        ipcounts=pcounts(gnumbers+1:gnumbers+bsflevels(bsfi));
    end
    prevcounts=[prevcounts ipcounts];
    pnumbers=0;        
    
        for gri=1:bsflevels(bsfi)
            
            % SUBJECT CODE GENERATION
            subvector=[];     %#ok<*NASGU>     
            if bsfi==groupcount
                
                if gri==1 
                    subvector=repmat(1:ipcounts(gri),1,prod(wsflevels));
                elseif gri~=1
                    pnumbers=sum([pnumbers ipcounts(gri-1)]);
                    subvector=repmat(pnumbers+1:pnumbers+ipcounts(gri),1,prod(wsflevels));
                end
                
                submatrix{1}=[submatrix{1} subvector];
                backupsubmatrix=submatrix;
                
                    if gri==bsflevels(bsfi) && groupcount>1
                        for subi=1:prod(bsflevels(1:end-1))-1
                            
                            submatrix{1}=[submatrix{1} backupsubmatrix{1}+sum(prevcounts(1:subi))];
                        end
                    end
                    
            end
                
            % GROUP CODE GENERATION  
            
            betweensublevels=prod(wsflevels);    
            groupvector=[];
            bsfmarkerlength=ipcounts(gri)*betweensublevels;
            groupvector=repmat(ones(1,bsfmarkerlength)+gri-1,1,1);
            groupmatrix{bsfi}=[groupmatrix{bsfi} groupvector];  
            
            if gri==bsflevels(bsfi) && groupcount>1 && bsfi>1
                groupmatrix{bsfi}=repmat(groupmatrix{bsfi},1,prod(bsflevels(1:bsfi-1)));
            end
                
            fprintf('Variable %s is processed \n repeating code length: %d \n total vector length: %d\n\n', factornames{bsfi},bsfmarkerlength,length(groupvector))
        end            
            
        
        if bsfi==groupcount
            % Within subjects factor code generation
            for ci=1:wsfactorcount   
                fvector=[];
                    if ci==wsfactorcount
                        sublevels=1;
                    else
                        sublevels=prod(wsflevels(ci+1:end));
                    end
                        for li=1:wsflevels(ci)        
                            fmarker=li-1;                
                            wsfmarkerlength=ipcounts(gri)*sublevels; 
                            fvector=[fvector repmat(ones(1,wsfmarkerlength)+fmarker,1,1)];                
                        end
                    if ci==1 && length(bsflevels)> 1
                        fvector=repmat(fvector,1,prod(bsflevels));  
                    else                
                        fvector=repmat(fvector,1,prod(bsflevels)*prod(wsflevels(1:ci-1)));
                    end
                fprintf('Variable %s is processed \n repeating code length: %d \n vector length for each group: %d\n\n', factornames{ci+groupcount},wsfmarkerlength,length(fvector))
                fmatrix{ci}=[fmatrix{ci} fvector];            
            end
        end
end

dummycodesize = sum(cellfun('prodofsize', submatrix));
nesting=zeros(length(factornames),length(factornames));
if exist('nestingmatrix','var')
    for nesti=1:2:length(nestingmatrix)
        nesting(nestingmatrix(nesti),nestingmatrix(nesti+1))=1;  
    end
end

datamatrix=nan(1,dummycodesize);
conditeration=0;

pcounts=pcounts(end-bsflevels(end)+1:end);
% *prod(bsflevels(1:end-1))
groupiteration=0;
for remgr=1:prod(bsflevels(1:end-1))
    disp(remgr)
    for gi=1:bsflevels(end)
        disp(gi)
        groupiteration=groupiteration+1;
        for k = 1:prod(wsflevels)
            
%             disp(1+((conditeration-1)*pcounts(gi)));
            disp(1+(remgr-1)*pcounts(gi)+((gi-1)*pcounts(gi)):gi*pcounts(gi)+(remgr-1)*pcounts(gi));
            disp(1+(groupiteration-1)*pcounts(gi):(groupiteration)*pcounts(gi))
            conditeration=conditeration+1;

            datamatrix(1,(1+((conditeration-1)*pcounts(gi)):((conditeration)*pcounts(gi))))...
                = matdata(1+(groupiteration-1)*pcounts(gi):(groupiteration)*pcounts(gi),k);

        end
        
    end
end


size(nesting)
size(datamatrix)
assignin('base','datamatrix',datamatrix);
assignin('base','fmatrix',fmatrix);
assignin('base','gmatrix',groupmatrix);
assignin('base','submatrix',submatrix);


[p, table, stats]=anovan(datamatrix,[groupmatrix fmatrix submatrix],...
    'model','full',...
    'random',length(factornames),...
    'nested',nesting,...
    'varnames',factornames,...
    'sstype','h');  
results={p table stats};    