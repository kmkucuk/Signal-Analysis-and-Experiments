% adjust the parameters below to create your own axes
% • I used datacell as data variable which was a rows=participants,
% columns=variableScores cell matrix
% • Adjust the X and Y axis indices, titles, and labels according to your own data. 

variableScalar=1; % 1 reversal rate endo theta // 2 accuracy exo theta // 3 reaction time exo theta 

if variableScalar == 1
    variableIndex = 6;
    additionScalar = 7;
    corrs = {'\bf.491*_{b}  \rm.367_{p}','\bf.495*_{b}  \rm.384_{p}','\bf.588**_{b}  \bf.500*_{p}','\bf.534**_{b}  \bf.476*_{p}'}; % ENDO THETA REVERSAL RATE COEFFICIENTS FOR AGE CONTROLLED
elseif variableScalar == 2
    variableIndex = 4;
    additionScalar = 15;
    corrs = {'\bf.467*_{b}  \rm.317_{p}','\bf.421*_{b}  \rm.246_{p}','\bf.504*_{b}  \rm.360_{p}','\rm.327_{b}  \rm.178_{p}'}; % EXO THETA ACCURACY FOR AGE CONTROLLED 
    
elseif variableScalar == 3
    variableIndex = 5;
    additionScalar = 15;
    corrs = {'-.214_{b}  .011_{p}','-.247_{b}  .015_{p}','-.283_{b}  -.070_{p}','-.224_{b}  -.053_{p}'}; % EXO THETA REACTION TIME FOR AGE CONTROLLED 
elseif variableScalar == 4
    variableIndex = 8;
    additionScalar = 10;   
    corrs = {'',''};
elseif variableScalar == 5
    variableIndex = 16;
    additionScalar = 18;
    corrs = {'',''};
end

chans = {'F','C','P','O'};
xaxisindx = {[0:4:12],[70:15:100],[0:.4:1.2],[0:1:7],[0:1:7]}; %[0:1:7] theta amplitude %[0:3:12] reversal rate / / [75:5:100] % accuracy  / / [0:.3:1.2] % reaction Time 
xaxisindx = xaxisindx{variableScalar};
yaxisindx = [0:1:7]; % theta amplitude mert
textX = ((max(xaxisindx)-min(xaxisindx))*.15)+min(xaxisindx);
higherY   = [max(yaxisindx) max(yaxisindx)];
lowerY    = [max(yaxisindx)*.85 max(yaxisindx)*.85];
chantextY = lowerY;
corrtextY = higherY;
xaxistext = {'Reversals / Minute','Accuracy (%)','Reaction Time (s)','Occipital Amplitude (\muV)','Occipital Amplitude (\muV)'}; % 'Reversals / Minute'     // 'Accuracy (%)   // 'Reaction Time (s)'
xaxistext = xaxistext{variableScalar};
yaxistext = 'Frontal Amplitude (\muV)';


howManyPlots = 4;
figure(2)
for k = 1:howManyPlots
subplot(1,howManyPlots,k)
% SQUARE PLOT AXIS TITLES
% if k==1 
%     axtitles = {'',yaxistext};
% elseif k == 2 
%     axtitles = {'',''};
% elseif k == 3
%     axtitles = {xaxistext,yaxistext};
% elseif k ==4 
%     axtitles = {xaxistext,''};
% end
% COLUMN PLOT AXIS TITLES
if k==1
    axtitles = {xaxistext,yaxistext};
else 
    axtitles = {'',''};
end
scatterPlotMert(datacell,[variableIndex k+additionScalar],[12 12],axtitles,[length(xaxisindx),length(yaxisindx)],16,{xaxisindx,yaxisindx},'yes')
if variableScalar == 2
    xticklabels([0 85 100])
end
% title(chans{k})
text([textX textX],chantextY,chans{k},'Color','k','FontSize',12,'HorizontalAlignment','center')
text([textX textX],corrtextY,corrs{k},'Color','k','FontSize',12,'HorizontalAlignment','left')
end
% han=axes(fig,'visible','off'); 
% han.Title.Visible='on';
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% ylabel(han,yaxistext);
% xlabel(han,xaxistext);
% title(han,'Exogenous Theta');