cd('E:\MATLAB 2018a\bin\MATLAB_Files\DESIGNS AND SCRIPTS\Bistable Perception Experiment\Data Fitness & Outliers\Dominance Durations')

ParticipantInfo=detectImportOptions('Total Data Participants Excluded.xlsx');
ParticipantInfo.SelectedVariableNames= {'subid','LatticePressCount','CubePressCount','EndoPressCount'...
    ,'LatticeRepeat','CubeRepeat','EndoRepeat','SessionOrder','MirrorCondition'};
ParticipantVariables=readtable('Total Data Participants Excluded.xlsx',ParticipantInfo);

ExcelName='Dominance Durations.xlsx';
sheetnumber=1;

subid=table2array(ParticipantVariables(:,1));
LatticePressCount=table2array(ParticipantVariables(:,2));
CubePressCount=table2array(ParticipantVariables(:,3));
EndoPressCount=table2array(ParticipantVariables(:,4));
LatticeRepeat=table2array(ParticipantVariables(:,5));
CubeRepeat=table2array(ParticipantVariables(:,6));
EndoRepeat=table2array(ParticipantVariables(:,7));
SessionOrder=table2array(ParticipantVariables(:,8));
MirrorCondition=table2array(ParticipantVariables(:,9));


xlswrite(ExcelName,subid,sheetnumber,'A6:A76');
xlswrite(ExcelName,LatticePressCount,sheetnumber,'B6:B76');
xlswrite(ExcelName,CubePressCount,sheetnumber,'C6:C76');
xlswrite(ExcelName,EndoPressCount,sheetnumber,'D6:D76');
xlswrite(ExcelName,LatticeRepeat,sheetnumber,'E6:E76');
xlswrite(ExcelName,CubeRepeat,sheetnumber,'F6:F76');
xlswrite(ExcelName,EndoRepeat,sheetnumber,'G6:G76');
xlswrite(ExcelName,SessionOrder,sheetnumber,'H6:H76');
xlswrite(ExcelName,MirrorCondition,sheetnumber,'I6:I76');

    