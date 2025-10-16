function [EEG,metaMtrx]=clsArtDelete_Mert(groupIdentifier,conditionIdentifier,path,EEG)  %%% x and y are file name markers.
%%% EEG is the generic EEG structure
%%% variable as in EEGLAB etc.
%%% x= Group codes on files (e.g. 'lrk' 'lrp' for linda schizo) elder or young etc
%%% y= condition codes (e.g. 4k_Kn = button endo, 3k_Kn= button exo etc.)

%%% creating participant list from the file names of the directory specified in createDataList function
pList=createDataList(groupIdentifier,conditionIdentifier,path);

%%% initiate metaMtrx for comparison between Bremen and this data

metaMtrx={};

%%% trial names

if conditionIdentifier(1) == '4'  %endo
    tCount=2;
    trialname={'instable_endogenous','stable_endogenous'};
    
elseif conditionIdentifier(1) == '3' % exo
    tCount=3;
    trialname={'instable_exogenous','stable_exogenous','trig_corr_exo'};
    
end

for trialType = 1:tCount        %%% unstable, stable, and triggercorrected trials
        
        for i =  1:length(pList)  %%% participants
                
                pStruct=load(pList{i});

                pStruct=pStruct.vp;
                secTimes=pStruct.Times.Times_alle;
                srate= pStruct.info.samplingfrequenz; 
                if strncmp(pList{i},'lrk',3) || strncmp(pList{i},'nsk',3)
                    groupname='control';
                elseif strncmp(pList{i},'lrp',3) || strncmp(pList{i},'nsp',3)
                    groupname='patient';
                end
                epochinfo=CountSelEp(pStruct,trialType);

                fprintf('Participant %s \n total epochs: %d \n deleted epochs: %d \n',pList{i},epochinfo{trialType,1},epochinfo{trialType,2});
                
                woAdata=deleteArtifacts(pStruct,trialType,epochinfo{trialType,3});                
                
                %%% Registering data info into a matrix for later
                %%% comparison with Bremen Documentation
                
                if trialType==1
                    
                    metaMtrx(i,:)={pList{i},'unstable',epochinfo{trialType,1},epochinfo{trialType,2},...                        
                    epochinfo{trialType,3},epochinfo{trialType,1}-epochinfo{trialType,2}};
                
                elseif trialType==2
                    
                    metaMtrx(i+length(pList),:)={pList{i},'stable',epochinfo{trialType,1},epochinfo{trialType,2},...                        
                    epochinfo{trialType,3},epochinfo{trialType,1}-epochinfo{trialType,2}};   
                
                elseif trialType==3 %%% Just as above, metamatrix first index must be written as
                                    %%% 'i+length(pList)'. However, I am
                                    %%% only interested in trigcorr, so
                                    %%% there won't be previous
                                    %%% registeries. That is why its only
                                    %%% 'i' at the moment.
                    
                    metaMtrx(i+length(pList),:)={pList{i},'trigcorr',epochinfo{trialType,1},epochinfo{trialType,2},...
                        epochinfo{trialType,3},epochinfo{trialType,1}-epochinfo{trialType,2}};                
                end    
                
                %%% Registering artifact free data into EEG structure
                
                    regRow=length(EEG)+1;
                    EEG(regRow).subject=pList{i};
                    EEG(regRow).data=woAdata;
                    EEG(regRow).srate=srate;
                    EEG(regRow).times=secTimes;
                    EEG(regRow).condition=trialname{trialType};
                    EEG(regRow).chaninfo={'F3';'F4';'C3';'C4';'P3';'P4';'FZ';'CZ';'O1';'O2';'EOG';'PZ';'WechsTrig';'Knopf';'leer';'ArtTrigStab'};                                          
                    EEG(regRow).group=groupname;                   
                    
        end
end
