function clsArtDelete(x,y)  %%% x and y are file name markers.
                                %%% EEG is the generic EEG structure
                                %%% variable as in EEGLAB etc.
                                %%% x=3 or 4_K
                                %%% y= elder or young etc

                                %%% creating participant list from the file names of the directory
%%% specified in createDataList function
EEG=[];
pList=createDataList(x,y);

%%% initiate metaMtrx for comparison between Bremen and this data

metaMtrx={};

%%% trial names

if x(1) == '4' 
    tCount=2;
    trialname={'instable_endogenous','stable_endogenous'};
    
else 
    tCount=3;
    trialname={'instable_exogenous','stable_exogenous','trig_corr_exo'};
    
end

%%% group names, defined by the input one has to hard code this


%%% time points for EEG, hard coded will vary according to seconds and
%%% sampling rate.  For Samira Gross' data, srate=500 and time point start
%%% from -3 to 2

secTimes=-3:.002:1.998;

for trialType = 1:tCount        %%% unstable, stable, and triggercorrected trials
        
        for i =  1:length(pList)  %%% participants
                
                pStruct=load(pList{i});

                pStruct=pStruct.vp;
                if strncmp(pList{i},'sgo',3)
                    groupname='older';
                elseif strncmp(pList{i},'sgy',3)
                    groupname='younger';
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
                    EEG(regRow).srate=500; %sampling rate is hard coded
                    EEG(regRow).times=secTimes;
                    EEG(regRow).condition=trialname{trialType};
                    EEG(regRow).chaninfo={'F3';'F4';'C3';'C4';'P3';'P4';'T5';'T6';'O1';'O2';'leer';'leer';'WechsTrig';'Knopf';'ArtTrigStab';'EOG'};
                    EEG(regRow).group=groupname;                   
                    
        end
end

assignin('base','ALLEEG',EEG);
assignin('base','comparisonMtrx',metaMtrx);