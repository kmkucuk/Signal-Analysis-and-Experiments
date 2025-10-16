% adjust the parameters below to create your own axes
% • I used datacell as data variable which was a rows=participants,
% columns=variableScores cell matrix
% • Adjust the X and Y axis indices, titles, and labels according to your own data. 
dwell_alpha_scatter=permute(struct2cell(dwell_alpha),[3 1 2]);
variableScalar=1; % 1 reversal rate endo theta // 2 accuracy exo theta // 3 reaction time exo theta 

variableIndex = 8;
corrs = {'\color{red}R^2 = .36*\newline\color{blue}R^2 = .19','\color{red}\rmR^2 = .12\newline\color{blue}R^2 = .72**'}; % ENDO THETA REVERSAL RATE COEFFICIENTS FOR AGE CONTROLLED

  
chans = {'F','C','P','O'};
xaxisindx = {linspace(.5,2,4)}; % dwell time x axis linspace(0,1.6,5) [.7 1 1.3 1.6]; % (.5 to 4 in log corresponds to 3 seconds to 40 seconds in dwell time
xaxisindx = xaxisindx{variableScalar};
yaxisindx = [-6:3:3]; % alpha power modulation relative to baseline 
textX = ((max(xaxisindx)-min(xaxisindx))*.15)+min(xaxisindx);
higherY   = [max(yaxisindx) max(yaxisindx)];
lowerY    = [max(yaxisindx)*.95 max(yaxisindx)*.95];
chantextY = lowerY;
corrtextY = higherY;
xaxistext = {'Log Dwell Time (s)','Accuracy (%)','Reaction Time (s)'}; % 'Reversals / Minute'     // 'Accuracy (%)   // 'Reaction Time (s)'
xaxistext = xaxistext{variableScalar};
yaxistext = 'Alpha Modulation (dB)';

variables = [2 5];
countVars = length(variables);
for k = 1:countVars
subplot(1,countVars,k)

if k==1
    axtitles = {xaxistext,yaxistext};
else 
    axtitles = {'',''};
end
scatterPlotMert(dwell_alpha_scatter,[variableIndex variables(k)],[12 12],axtitles,[length(xaxisindx),length(yaxisindx)],16,{xaxisindx,yaxisindx},'yes')

% title(chans{variables(k)-1})
text([textX textX]-.1,corrtextY-.2,chans{variables(k)-1},'Color','k','FontSize',12,'HorizontalAlignment','center')
text([textX textX]+.6,corrtextY-.7,corrs{k},'Color','k','FontSize',12,'HorizontalAlignment','left')
end
% han=axes(fig,'visible','off'); 
% han.Title.Visible='on';
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% ylabel(han,yaxistext);
% xlabel(han,xaxistext);
% title(han,'Exogenous Theta');