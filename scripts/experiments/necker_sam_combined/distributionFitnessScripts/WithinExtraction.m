function WithinExtraction(x)

%%% This function extracts every duration of a percept from each
%%% participant. Beware that this script assumes that you already have
%%% Excel files for specific dominance durations. Also, it assumes that
%%% you've named them in the way that the script is written.

%%% 0 -> for left cube dominance durations and 1 -> for right lattice
%%% durations, 2-> for Vertical SAM durations. 3-> for Horizontal SAM
%%% durations. 

%%%Import Excel DATA %%%

if x==0
    name='LeftCube.xlsx';
elseif x==1
    name='RightLattice.xlsx';
elseif x==2
    name='VerticalSAM.xlsx';
elseif x==3
    name='HorizontalSAM.xlsx';
end
disp(['File named ' name, ' is being processed...']);
cd(pwd);
DurationVariables=detectImportOptions(name);
DurationsAndPresses=readtable(name,DurationVariables);

%%% Convert Duration and Press Variables into Arrays %%%

WorkspaceTable=table2array(DurationsAndPresses);

% WorkspaceTable=rmmissing(WorkspaceTable);
subidvariable=WorkspaceTable;
WorkspaceTable(1,:)=[];

assignin('base','SubID',subidvariable);
assignin('base','WithinDurations',WorkspaceTable);
end




