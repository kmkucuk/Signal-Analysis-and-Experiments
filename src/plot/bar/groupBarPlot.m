function groupBarPlot(datastruct,condition,ylim)
%% PLOT REVERSAL RATES box plot
OmeanRev=datastruct(1).data(condition);
YmeanRev=datastruct(2).data(condition);
O_95CI_Rev=datastruct(1).error(condition);
Y_95CI_Rev=datastruct(2).error(condition);

barp=bar([OmeanRev YmeanRev],'FaceColor','Flat');
barp.CData(1,:)=[1 0 0];
barp.CData(2,:)=[0 0 1];
hold on
errb=errorbar([1 2],[OmeanRev YmeanRev],[O_95CI_Rev Y_95CI_Rev],[O_95CI_Rev Y_95CI_Rev],'LineStyle','none','Color','k');
set(errb,{'linew'},{2})
%%% CREATE SIGNIFICANT ANNOTATIONS %%%
MaxY=max(ylim);
PercAdj=10;
annotateMaxY=MaxY-(MaxY/PercAdj);
annotateG=[OmeanRev+O_95CI_Rev+(MaxY/PercAdj) YmeanRev+Y_95CI_Rev+(MaxY/PercAdj)];
oldAnno=[OmeanRev+O_95CI_Rev+(MaxY/PercAdj/3) annotateMaxY];
youAnno=[YmeanRev+Y_95CI_Rev+(MaxY/PercAdj/3) annotateMaxY];
plot([1 1],oldAnno,'k','linewidth',2)
plot([2 2],youAnno,'k','linewidth',2)
plot([1 2],[annotateMaxY annotateMaxY],'k','linewidth',2)
plot([1.5 1.5],[annotateMaxY annotateMaxY]+(MaxY/PercAdj)/2,'k*','MarkerSize',7)
% ylabel('Reversal Rate / minute')
% plotOptions.ylim=ylim;
% plotOptions.xlabels={'','Older','Young'};
% plotOptions.xtickCount=2;
% plotOptions.ytickCount=7;
% plotOptions.ytickCount=7;
labels={'','Older','Young'};
formataxes(ylim,[1 2],'normal',2,4,labels);

end

