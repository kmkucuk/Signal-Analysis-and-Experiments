function VariableExtraction
%%%Import Excel DATA %%%
folder=pwd;
cd(folder);
DurationVariables=detectImportOptions('Exclusion Variables Used Data.xlsx');
DurationVariables.SelectedVariableNames= {'TL_Lattice', 'BR_Lattice', ...
    'BL_Cube', 'TR_Cube','Hor_endo','Ver_endo','EndoPressCount','LatticePressCount','CubePressCount'};
DurationsAndPresses=readtable('Exclusion Variables Used Data.xlsx',DurationVariables);

%%% Convert Duration and Press Variables into Arrays %%%

Lat_L=table2array(DurationsAndPresses(:,1));
Lat_R=table2array(DurationsAndPresses(:,2));
Cub_L=table2array(DurationsAndPresses(:,3));
Cub_R=table2array(DurationsAndPresses(:,4));
End_Hori=table2array(DurationsAndPresses(:,5));
End_Vert=table2array(DurationsAndPresses(:,6));
Press_End=table2array(DurationsAndPresses(:,7));
Press_Lat=table2array(DurationsAndPresses(:,8));
Press_Cub=table2array(DurationsAndPresses(:,9));

%%%Exclude Missing Values From Arrays %%%

Lat_L=Lat_L(Lat_L<999);Lat_R=Lat_R(Lat_R<999);Cub_L=Cub_L(Cub_L<999);Cub_R=Cub_R(Cub_R<999);
End_Hori=End_Hori(End_Hori<999);End_Vert=End_Vert(End_Vert<999);Press_End=Press_End(Press_End<999);Press_Lat=Press_Lat(Press_Lat<999);
Press_Cub=Press_Cub(Press_Cub<999);

save

end




