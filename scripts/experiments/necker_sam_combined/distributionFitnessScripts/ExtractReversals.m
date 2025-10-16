%%% This function extracts the amount of reversals from time series data of
%%% dominance durations. "Duration" Variable defines the duration of the
%%% epoch where reversals are going to be extracted. If duration=90, then
%%% this code will compute the reversal count within the first 90 seconds.


%%% THIS FEATURE IS NOT FUNCTIONAL YET -> Also, this code can extract durations at the last 90 seconds, this
%%% option is the second variable "StartingPoint" = 0 -> first, 1-> last X
%%% seconds. 

cd('D:\Matlab Directory\All Scripts\Mert Küçük\Multistable Experiment\Behavioral Data Preprocess & Fitness Codes\Excel Files Related to Percept Durations\Individual Durations')
DurationTable=readtable('Dominance Durations.xlsx');
DurationTable=table2array(DurationTable);
durationcolumnvector=[12,54;95,150;205,252]; %%% every row corresponds to a figure's different percepts' dominance durations' columns in the excel table. 12-> first horizontal sam duration, 54-> first vertical sam, 95-> First BL_cube, 150-> First TR_Cube, 205-> First TL lattice etc.

[RowCount,ColumnCount]=size(DurationTable);

CubeReversal=0;
LatticeReversal=0;
SamReversal=0;
participantIDs=DurationTable(:,1);
ReversalCountTable=nan(RowCount,4);
ReversalCountTable(:,1)=participantIDs;

for FigNumber = 1:3         %%% FigNumber=1-> SAM, 2-> Cube,3-> Lattice
    
    SumOfDurations=0;               %%% This variable registers the total amount of time that accumulated percept durations create.
    PerA_column_index=durationcolumnvector(FigNumber,1);
    PerB_column_index=durationcolumnvector(FigNumber,2);
    
    for participantNo = 1:RowCount
        
            ReversalCount=0;
            
         for ColumnIteration = 1:70     %%% Number 70 could be anything. I've typed 70 only because it will ensure that the accumulated 70 dominance durations are going to exceed 90 seconds limit.
             
             if isnan(DurationTable(participantNo,PerA_column_index)) | DurationTable(participantNo,PerA_column_index)==0       %%% if there is no duration code skips to next participant
                 break
             end
              
             PerceptA_Duration=DurationTable(participantNo,PerA_column_index);
             PerceptB_Duration=DurationTable(participantNo,PerB_column_index);
             
             PerA_column_index=PerA_column_index+1;
             PerB_column_index=PerB_column_index+1;
             
             if isnan(PerceptB_Duration)                          %%% If second percept duration is NaN then the code skips it. Because total duration becomes NaN in that case. 
                SumOfDurations=PerceptA_Duration+SumOfDurations;
             else
                 SumOfDurations=PerceptA_Duration+PerceptB_Duration+SumOfDurations;
             end
             
             if SumOfDurations>90
                PerA_column_index=durationcolumnvector(FigNumber,1);        %%% Resets column Index before switching to next participant. Otherwise column index will be false because of iterative additions.
                PerB_column_index=durationcolumnvector(FigNumber,2);
                if SumOfDurations-PerceptB_Duration<90
                    ReversalCount=ReversalCount+1;          %%% If PerceptA and sum durations do not exceed 90 secs add another reversal. Otherwise code ignores PerceptA reversal.
                end                
                 SumOfDurations=0;
                 break
             end
             
             ReversalCount=ReversalCount+2;         %%% Add 2 because calculations are made by using two durations, meaning that there are two switches. 
         end
                
             ReversalCountTable(participantNo,FigNumber+1)=ReversalCount;
    end
end