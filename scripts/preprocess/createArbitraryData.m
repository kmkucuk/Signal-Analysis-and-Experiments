%%% datalist= cell vector with char participant file names (created by
%%% ****createDataList****)
%%% 
%%% conditions = enter the order of "DATA" for instance,
%%% [1 3] means:
%%% [1=unst_endo 3=unst_exo]- processing data within 1th and 3rd order.
%%% baseconditions = enter the order of "BASELINEDATA" in accordance with
%%% the conditions input. If you want to correct baseline of unst_endo with
%%% stab_endo and also unst_exo with stab_endo then your input for
%%% conditions and base conditions should be in this order: 
%
%       conditions=  [1 3];
%       baseconditions = [2 4];
% this will baseline correct 1 with 2 and 3 with 4. 
%
%%% prepostIndx=[50 900] = 50 points before arbitrary 0 and 900 points
%%% after [1900 ms] will be extracted. 
%%%
%%% datatype= which data 'erspTrials' etc. 
%%%
%%%
%%%
%%%
%%%
%%%

function EEGvar=createArbitraryData(EEG,EEGvar,datalist,conditions,baseconditions,prepostIndx,datatype,baselinePeriod)

% arbitraryTimes=(-preCount/500):.002:(postCount/500);


% cd('G:\Matlab Directory\2020_MSPAging_EEG_Mert\Data_MertVersions\ProcessedData\TrialData\ThetaButton\Denemeler')

allconditions= sort([conditions baseconditions]);

for i = 1:length(datalist)  
    
    % load data from the list
    
    importVar=load(datalist{i});
    importVar=importVar.importVar;
    
    orgtimes=importVar(1).times;
    baseIdx=findIndices(orgtimes,baselinePeriod);
    
    %restructure the data so that channels are not separate cells, convert
    %into 4-D matrices. 1:freqs, 2:times, 3:trials, 4:channels
    
%     for chani= 1:length(allconditions)
%         
%         importVar(allconditions(chani)).erspTrials=cat(4,importVar(allconditions(chani)).erspTrials{1:10});
%         importVar(allconditions(chani)).itpcTrials=cat(4,importVar(allconditions(chani)).itpcTrials{1:10});
%         
%     end
    
    
    % embed arbitrary indx into individual .mat file
    
        for k = 1:length(conditions)
            
            if i < 16
                condScalar=abs(0-i);
            else
                condScalar=abs(15-i)+75;
            end
            
            fprintf('\nProcessing part: %s \n', [importVar(conditions(k)).subject,'-',importVar(conditions(k)).condition(1:4)]);
            
            importVar(conditions(k)).arbitraryIndx=EEG(condScalar+((conditions(k)-1)*15)).arbitraryIndx;
            
            importVar=extractWaveletSeries(importVar,conditions(k),0,prepostIndx(1),prepostIndx(2),datatype);
            
            fieldnames={'erspTrials','itpcTrials','arb_itpcTrials','arb_erspTrials'};
                        
            
            %baseline correction and averaging using baselineconditions
            
%                         for k = 1:length(baseconditions)

                            Baselinenanmean=nanmean(importVar(baseconditions(k)).erspTrials,3);

                            Baselinenanmean=nanmean(Baselinenanmean(:,baseIdx(1):baseIdx(2),1,:),2);

                            Baselinenanmean=reshape(Baselinenanmean,length(importVar(1).convFreqs),10);

                            importVar(conditions(k)).arb_dB=importVar(conditions(k)).arb_erspAvg;
                            
                            % baseline sweep through frequencies and channels
                            
                                        for bchan = 1:10

                                            for freqs = 1:length(importVar(1).convCycles)

                                            importVar(conditions(k)).arb_dB(freqs,:,bchan)= ...
                                                10*log10( importVar(conditions(k)).arb_dB(freqs,:,bchan) / Baselinenanmean(freqs,bchan));

                                            end
                                        end


                                    
            
            
            EEGvar(condScalar+((conditions(k)-1)*15))=rmfield(importVar(conditions(k)),fieldnames);
            
            
        end
                
        
        
        
        %baseline correction and averaging using baselineconditions
        

%     assignin('base','importVar',importVar)
    save([datalist{i},'.mat'], 'importVar')
    
end