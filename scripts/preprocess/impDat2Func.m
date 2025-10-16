function impDat2Func(x)


variableF=importdata(x{1});

dataIns=variableF.data.epochen_instabil;

assignin('base','expInsdata',dataIns);

end