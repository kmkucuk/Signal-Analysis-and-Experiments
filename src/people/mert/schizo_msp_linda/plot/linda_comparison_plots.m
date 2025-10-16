load('boxplotdata.mat')
groupingVariable  = [repmat(1,[1,20]) repmat(2,[1,20])]; % grouping variable: 1s are older 2s are younger adults
%% delta 
% datastruct=groupLinePlot(spss_schizo_itpc,[1 2],[1 2 3 4],4,'between','error',2,[0 9],20,groupingVariable,'\surd%\DeltaITC');
figure(1)

xaxis = barScatterConditions(lindadata,[1 2 3 4],[20 20],{[],"\surd\DeltaITC (%)"},5,10,[0 2.5 5 7.5],{'F','C','P','O'});
% to use xaxis in sigAnnottations you have to specify index with
% considering intervals. For instance, below example plots annotation to
% the last two plots of the bar graph. But I had to use 4 8 instead of 7 8
% because that is how barScatterConditions extract indices. .
%within
% sigAnnotations(datastruct,xaxis,{[4 8],[7 8],[6 8],[3 4]},[3 2 2 1],{'**','***','*','*'},'error',[0 9],2,[1 2 3 4]);

% sigAnnotations(datastruct,xaxis,{[1 3],[2 3]},[1 1],{'***','****'},'error',[0 9],2);
%% theta 
% datastruct=groupLinePlot(spss_schizo_itpc,[1 2],[1 2 3 4]+4,4,'between','error',2,[0 9],20,groupingVariable,'\surd%\DeltaITC');
figure(2)
xaxis = barScatterConditions(lindadata,[1 2 3 4]+4,[20 20],{[],"\surd\DeltaITC (%)"},5,10,[0 2.5 5 7.5],{'F','C','P','O'});

% sigAnnotations(datastruct,xaxis,{[2 6],[3 7],[1 2],[1 3],[1 4],[2 3],[5 8],[6 8],[7 8]},[3 3 1 1 1 1 1 2 2 2],{'*','**','****','****','**','*','**','*','**'},'error',[0 9],2,[5 6 7 8]);


% sigAnnotations(datastruct,xaxis,{[2 6],[3 7]},[3 3],{'*','**'},'error',[0 9],2,[5 6 7 8]);

% sigAnnotations(datastruct,xaxis,{[1 2],[1 3],[1 4],[2 3]},[1 1 1 1 1],{'****','****','**','*'},'error',[0 9],2,[5 6 7 8]);


% sigAnnotations(datastruct,xaxis,{[5 8],[6 8],[7 8]},[2 2 2],{'**','*','**'},'error',[0 9],2,[5 6 7 8]);
%% alpha 
figure(3)
barScatterConditions(lindadata,[1 2 3 4]+8,[20 20],{[],"\surd\DeltaITC (%)"},5,10,[0 1 2 3 4 5],{'F','C','P','O'})
%% gamma
figure(4)
barScatterConditions(lindadata,[1 2 3 4]+12,[20 20],{[],"\surd\DeltaITC (%)"},5,10,[0 1 2 3 4 5],{'F','C','P','O'})


%% CONTOUR PLOTS

convolutionPlotSameFigure(convStats,[1 2 3 4],[1 3],'itpcChangeAvg','pairChans',[-200 750],[0 50],[1 4]);
convolutionPlotSameFigure(convStats,[1 2 3 4],[1 3],'itpcChangeAvg','pairChans',[-200 750],[0 30],[4 7]);
convolutionPlotSameFigure(convStats,[1 2 3 4],[1 3],'itpcChangeAvg','pairChans',[-200 750],[0 25],[8 12]);
convolutionPlotSameFigure(convStats,[1 2 3 4],[1 3],'itpcChangeAvg','pairChans',[-200 750],[0 25],[28 48]);
