%%% Extracting total data spread sheet for descriptive analyses

function DescpExtraction
cd('E:\MATLAB 2018a\bin\MATLAB_Files\DESIGNS AND SCRIPTS\Bistable Perception Experiment\Data Fitness & Outliers\Excel Files Related to Percept Durations');
DescpTable=readtable('MergingSessions.xlsx');

assignin('base','TotalTable',DescpTable);

    for i=1:width(DescpTable)    
        varname=['var',int2str(i)]; %#ok<*NASGU>
        var=table2array(DescpTable(:,i));
        assignin('base',varname,var);
    end

end