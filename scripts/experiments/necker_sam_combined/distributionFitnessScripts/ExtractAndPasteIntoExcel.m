%%% Dominance Duration Extraction
%%% MATLAB do not regonize xlsx files if it opens it itself. But if you
%%% create an excel spread sheet file with that extension, you can open and
%%% write in it. If you use MATLAB to create a sheet, than you encounter
%%% the problem of EXCEL not recognizing the extension. Best way to solve
%%% it in my knowledge is to create an excel file before hand and then use
%%% it.



cd('D:\Matlab Directory\All Scripts\Mert Küçük\Multistable Experiment\Behavioral Data Preprocess & Fitness Codes\Excel Files Related to Percept Durations\Individual Durations')
PerceptDurations=detectImportOptions('DurationsToExtract2.xlsx');
PerceptDurations.SelectedVariableNames= {'CubeDurations','LatticeDurations','EndoDurations'};
DurationVariables=readtable('DurationsToExtract2.xlsx',PerceptDurations);

CubeDurations=table2array(DurationVariables(:,1));
LatticeDurations=table2array(DurationVariables(:,2));
EndoDurations=table2array(DurationVariables(:,3));

figurevector=[EndoDurations,CubeDurations,LatticeDurations]; %%% combining all duration variables within a variable.
                                                             %%% This way
                                                             %%% is easier to process.
ExcelName='Dominance Durations.xlsx';
sheetnumber=1;
    
%%% Which ROW to start typing variable values? 

WholeExcel=detectImportOptions(ExcelName);        %%% Read original Excel file and then extract first Column, which is Participant ID's, check the length
WholeExcel.SelectedVariableNames='HOR1';
ExcelMatrix=readtable(ExcelName,WholeExcel);
ParticipantVector=table2array(ExcelMatrix(:,1));

for RowIteration = 1:71                             %%% Find appropriate row for entering data
    if isnan(ParticipantVector(RowIteration))
        RowCount=RowIteration+1;
        break
    end
end
CharRow=int2str(RowCount);

%%% All duration vectors are combined within "figurevector" variable. Every
%%% row corresponds to a different duration variable. E.g.
%%% figurevector(:,1) corresponds to CubeDurations while figurevector(:,2)
%%% corresponds to LatticeDurations This way a "for loop" can arithmetically 
%%% execute same operations for all duration variables. 
%%% This saves space and looks better.

for FigNumber = 1:3
    

     
     if FigNumber==1                                   %%% EXCEL'de verinin girilece?i tableri haz?rlama k?sm?
         PerACellRange=['L',CharRow,':BA',CharRow];    %%% Range of ENDO Horizontal Durations
         PerBCellRange=['BB',CharRow,':CP',CharRow];   %%% Range of ENDO Vertical Durations 
     elseif FigNumber==2  
         PerACellRange=['CQ',CharRow,':ES',CharRow];   %%% Range of Cube BL Durations
         PerBCellRange=['ET',CharRow,':GV',CharRow];   %%% Range of Cube TR Durations
     elseif FigNumber==3         
         PerACellRange=['GW',CharRow,':IQ',CharRow];   %%% Range of Lattice TL Durations
         PerBCellRange=['IR',CharRow,':KL',CharRow];   %%% Range of Lattice BR Durations
     end
         
    A_loop=0;                           %%% Loop variables for iteration of next column for registering next
    B_loop=0;                           %%% duration within that percept's vector.  
         
    PerceptA=zeros(1,round(length(figurevector(FigNumber))/2));
    PerceptB=PerceptA;
    
    for i = 1:length(figurevector(:,FigNumber))        
        if mod(i,2)==1
            A_loop=A_loop+1;
            PerceptA(A_loop)=figurevector(i,FigNumber);
        else
            B_loop=B_loop+1;
            PerceptB(B_loop)=figurevector(i,FigNumber);
        end
    end
    
    SADIterationA=length(PerceptA); %%% Iteration lengths for both percepts
    
    SADIterationB=length(PerceptB); 
    
    for SADA = 1:SADIterationA                 %%% SAD-> Search and destroy. Looks for values that are "0" and deletes those columns. 
                                                %%% Matrix bounds' exceeded  hatas? geliyor for kulland???m için. O yüzden iteration variable'? matrixten
                                                %%% büyükse loopu k?rd?r?yorum
       
        if SADA>=SADIterationA
            break
        end
        
        if PerceptA(1,SADA)==0                    %%% Delete the column if value do not exists.
            PerceptA(:,SADA)=[];
            SADIterationA=SADIterationA-1;
        end
    end
    
    for SADB = 1:SADIterationB
        
         if SADB>SADIterationB
            break
        end
        
        if PerceptB(1,SADB)==0
            PerceptB(:,SADB)=[];
            SADIterationB=SADIterationB-1;
        end
        
    end
    
    xlswrite(ExcelName,PerceptA,sheetnumber,PerACellRange);
    xlswrite(ExcelName,PerceptB,sheetnumber,PerBCellRange);
    
    
end  
    

fclose('all');



