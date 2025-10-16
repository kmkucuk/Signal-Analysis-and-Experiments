%%% Behavioral DATA %%%
% first is mean RT, second STD RT, third Reversal Rate per Minute, fourth
% percentage correct, fifth group (1=old, 2=young)
plotmat=[0.940000000000000,0.200000000000000,3.71000000000000,85.4800000000000,1;0.740000000000000,0.120000000000000,3.59000000000000,100,1;0.540000000000000,0.0800000000000000,1.79000000000000,100,1;0.630000000000000,0.110000000000000,4.11000000000000,95.1600000000000,1;0.740000000000000,0.120000000000000,7.72000000000000,96.7700000000000,1;1.08000000000000,0.190000000000000,2.82000000000000,87.1000000000000,1;0.960000000000000,0.230000000000000,4.70000000000000,80.6500000000000,1;0.680000000000000,0.100000000000000,3.05000000000000,98.7000000000000,1;0.510000000000000,0.120000000000000,8.39000000000000,97.4000000000000,1;0.820000000000000,0.240000000000000,6.18000000000000,90.9100000000000,1;0.770000000000000,0.180000000000000,8.04000000000000,97.4000000000000,1;0.550000000000000,0.0600000000000000,8.60000000000000,100,2;0.660000000000000,0.140000000000000,11.5200000000000,100,2;0.670000000000000,0.110000000000000,6.52000000000000,100,2;0.700000000000000,0.170000000000000,6.35000000000000,100,2;0.640000000000000,0.170000000000000,7.40000000000000,100,2;0.520000000000000,0.130000000000000,7.25000000000000,100,2;0.700000000000000,0.160000000000000,10.5100000000000,97.3700000000000,2;0.580000000000000,0.130000000000000,9.84000000000000,100,2;0.470000000000000,0.100000000000000,6.18000000000000,100,2;0.600000000000000,0.170000000000000,7.90000000000000,98.3900000000000,2;0.530000000000000,0.170000000000000,5.92000000000000,98.3900000000000,2];
% or 
% load('alphaPaper_37Epochs_BehavioralPotData.mat');
fontsize=10;


%% PLOT REVERSAL RATES box plot
splot(1)=subplot(2,2,1);
OmeanRev=mean(plotmat(1:11,3));
YmeanRev=mean(plotmat(12:21,3));
O_95CI_Rev=std(plotmat(1:11,3))/sqrt(11) * 1.64;
Y_95CI_Rev=std(plotmat(12:21,3))/sqrt(11) * 1.64;

barp=bar([OmeanRev YmeanRev],'FaceColor','Flat');
barp.CData(1,:)=[0 0 1];
barp.CData(2,:)=[1 0 0];
hold on
errb=errorbar([1 2],[OmeanRev YmeanRev],[O_95CI_Rev Y_95CI_Rev],[O_95CI_Rev Y_95CI_Rev],'LineStyle','none','Color','k');
set(errb,{'linew'},{2})
%%% CREATE SIGNIFICANT ANNOTATIONS %%%
MaxY=2;
PercAdj=10;
annotateMaxY=MaxY-(MaxY/PercAdj);
annotateG=[OmeanRev+O_95CI_Rev+(MaxY/PercAdj) YmeanRev+Y_95CI_Rev+(MaxY/PercAdj)];
oldAnno=[OmeanRev+O_95CI_Rev+(MaxY/PercAdj) annotateMaxY];
youAnno=[YmeanRev+Y_95CI_Rev+(MaxY/PercAdj) annotateMaxY];
plot([1 1],oldAnno,'k','linewidth',2)
plot([2 2],youAnno,'k','linewidth',2)
plot([1 2],[annotateMaxY annotateMaxY],'k','linewidth',2)
plot([1.5 1.5],[annotateMaxY annotateMaxY]+(MaxY/PercAdj)/2,'k*','MarkerSize',7)
% ylabel('Reversal Rate / minute')
xticklabels({'Older', 'Young'})
% xlabel(' ')
set(gca,'xlim',[0 3],'ylim',[0 12], 'FontName','Helvetica','FontWeight','Bold','FontSize',...
    fontsize,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',4,'box','off',...
    'YTick',[0 4 8 12],'YTickLabel',[],'XTickLabel',[]);


% PLOT RT Variability Box Plot
splot(2)=subplot(2,2,3);
hbox=boxplot(plotmat(:,2),plotmat(:,5),'Colors',[0 0 1;1 0 0],'labels',{'Older', 'Young'});
set(hbox,{'linew'},{2})
% ylabel('RT STD (s)')
% xlabel(' ')
set(gca,'xlim',[0 3],'ylim',[0 .3], 'FontName','Helvetica','FontWeight','Bold','FontSize',...
    fontsize,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',4,'box','off',...
    'YTick',[0 .1 .2 .3],'YTickLabel',[],'XTickLabel',[]);

%% PLOT MEAN RT Box Plot
OmeanRT=mean(plotmat(1:11,1));
YmeanRT=mean(plotmat(12:21,1));
O_95CI_RT=std(plotmat(1:11,1,1))/sqrt(11) * 1.64;
Y_95CI_RT=std(plotmat(12:21,1,1))/sqrt(11) * 1.64;
splot(3)=subplot(2,2,2);
barp=bar([OmeanRT YmeanRT],'FaceColor','Flat');
barp.CData(1,:)=[0 0 1];
barp.CData(2,:)=[1 0 0];

% barp(1).FaceColor=[0 0 1];
% barp(2).FaceColor=[1 0 0];

hold on
errb=errorbar([1 2],[OmeanRT YmeanRT],[O_95CI_RT Y_95CI_RT],[O_95CI_RT Y_95CI_RT],'LineStyle','none','Color','k');
set(errb,{'linew'},{2})
% ylabel('Mean RT (s)')
% yticklabels({'0', '.25',  '.50',  '.75', '1'})
xticklabels({'Older', 'Young'})
set(gca,'xlim',[0 3],'ylim',[0 1.2], 'FontName','Helvetica','FontWeight','Bold','FontSize',...
    fontsize,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',4,'box','off',...
    'YTick',[0 .4 .8 1.2],'YTickLabel',[],'XTickLabel',[]);

%%% CREATE SIGNIFICANT ANNOTATIONS %%%
MaxY=1.2;
PercAdj=10;
annotateMaxY=MaxY-(MaxY/PercAdj);
oldAnno=[OmeanRT+O_95CI_RT+(MaxY/PercAdj) annotateMaxY];
youAnno=[YmeanRT+Y_95CI_RT+(MaxY/PercAdj) annotateMaxY];
plot([1 1],oldAnno,'k','linewidth',2)
plot([2 2],youAnno,'k','linewidth',2)
plot([1 2],[annotateMaxY annotateMaxY],'k','linewidth',2)
plot([1.5 1.5],[annotateMaxY annotateMaxY]+(MaxY/PercAdj)/2,'k*','MarkerSize',7)



%% FIT OF RT DATA %%%
oldIndx=1:11;
youngIndx=12:22;
fitOlder=polyfit(plotmat(oldIndx,2),plotmat(oldIndx,1),1);
fitYoung=polyfit(plotmat(youngIndx,2),plotmat(youngIndx,1),1);

xAxisFit=linspace(0,.3,200);

fitPredOld=polyval(fitOlder,xAxisFit);
fitPredYoung=polyval(fitYoung,xAxisFit);
splot(4)=subplot(2,2,4);
hScatterGroup= gscatter(plotmat(:,2),plotmat(:,1),plotmat(:,5),'br','oo',[10 10]);
legend('off')
set(hScatterGroup(1),'LineWidth',2)
set(hScatterGroup(2),'LineWidth',2)
hold on
plot(xAxisFit,fitPredOld,'b','LineWidth',3);
plot(xAxisFit,fitPredYoung,'r','LineWidth',3);
% ylabel('Mean RT (s)')
% xlabel('RT STD (s)')

set(gca,'xlim',[0 .3],'ylim',[0 1.2], 'FontName','Helvetica','FontWeight','Bold','FontSize',...
    fontsize,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',4,'box','off',...
    'YTick',[0 .4 .8 1.2],'XTick',[0 .1 .2 .3],'XTickLabel',[],'YTickLabel',[]);

posLine=get(splot(4),'Position');
% set(splot(4),'Position',[posLine(1) posLine(2) posLine(3) posLine(4)])