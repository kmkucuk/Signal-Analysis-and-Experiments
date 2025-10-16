B = regexp(markerVariable,'\S+','match');
T = cell2table([B{:}].');
S = groupsummary(T,'Var1')