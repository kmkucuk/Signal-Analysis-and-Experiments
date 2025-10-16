function boxScatterPlotMert(datacell,variableIndex,groupSizes,labels_xy,tickCount_y,fontSize,manualTickMarks_Y,manualTickLabels_X)
%% DESCRIPTION OF INPUT ARGUMENTS
%       -datacell = cell array of data with one participant in one row (wide
%       format)
%
%       -variableIndex = column index of the desired data(e.g. [2 3 4])
%
%      -groupSizes = array of sample sizes for each group e.g. [11 12]. 11 is the
%       first 11 rows, 12 is the subsequent 12 rows of the wide format data.
%       Group information is only used to color the scatter dots, has no effect
%       on the fit
%
%       -yLims = limits of Y axis 
%
%       -labels_xy = cell array of label text (e.g. {'Age','Reaction Time'}; 
%               'Age' is X axis label, 'Reaction Time' is Y axis label.
%
%       -tickCount_y = how many tick should be on the Y axis (e.g. [5])
%                 [5] means that Y axis will have 5 ticks.
%
%       -fontSize = font size of axis labels and tick labels (e.g. [16] = 16
%       punto)
%
%
%       -manualTickMarks_Y = a numeric array with Y tick marks (e.g. [1,2,3,4,5]); 
% 
%       -manualTickMarks_X = a cell array with X tick mark labels for your conditions (e.g. {'Frontal','Central','Parietal','Occipital'}); 
% 
%
% Example use: boxScatterPlotMert(thetaCorrelations,7,[12 12],{[],'Reversal Rate'},5,12,[0:3:12],{'Older','Young'})
%               # datacell, variableIndex = uses 7th column of thetaCorrelations as the data. 
%               # groupSizes              = There are 12 participants in Older and Young adults
%               # labels_xy               = Y-axis label is Reversal Rate;
%                                           X-axis label is empty, so no labels. 
%               # tickCount_y             = There are 5 tick marks on Y axis 
%               # fontSize                = Punto is 12 for text on the graph
%               # manualTickMarks_Y       = Y axis tick marks are [0 3 6 9 12]
%               # manualTickLabels_X      = X axis group labels are Older and Young

%% Check Variables
if ~exist('manualTickMarks_Y','var')
    manualTickMarks_Y=[];
end


%% GROUP INDEX EXTRACTION
groupCount=length(groupSizes);
dataLength = length(datacell);
conditionCount = length(variableIndex);
groupIndices={};
groupArray= [];
data = nan(max(groupSizes),groupCount); 
it = 0;
backuplabels = repmat(manualTickLabels_X,1,groupCount);
for k = 1:groupCount
    
    if k == 1
        groupIndices{k} = 1:groupSizes(k);
        
    else
        
        groupIndices{k} = groupSizes(k-1)+1:(groupSizes(k-1)+groupSizes(k));
    end
    

    
    
    for condi = 1:length(variableIndex)
        it = it+1;

        %% create grouped x axes
        groupArray(1:groupSizes(k),it) = it;
        
        %% extract Data by groups
        data(1:groupSizes(k),(condi+((k-1)*conditionCount))) = [datacell{groupIndices{k},variableIndex(condi)}];
    end
end

%% set Y maximum
if isempty(manualTickMarks_Y)
    maxData = max(data,[],'all');
    max_y_axis = maxData + (abs(maxData)*.15); % max of X axis is %15 larger than actual value
else
    max_y_axis = max(manualTickMarks_Y);
end

%% set Y minimum
min_y_axis = min(data); 
if isempty(manualTickMarks_Y)
    if min_y_axis < 0 % if min of X axis is lower than 0 
        min_y_axis = min_y_axis * .85; % min if X axis is %15 lower than actual value
    else % if min x axis is positive 
        min_y_axis = 0;
    end
else
    min_y_axis = min(manualTickMarks_Y);
end
%% Y limits
yLimits = [min_y_axis max_y_axis];

%% create tick marks

if isempty(manualTickMarks_Y)
    yTickMarks = round(linspace(min_y_axis, max_y_axis,tickCount_y),2);
else
    yTickMarks = manualTickMarks_Y;
end

%% PLOT SCATTERS WITH GROUP COLORS

color1 = [1 0 0];
color2 = [0 0 1];
colorVector = [repmat({color1},1,conditionCount) repmat({color2},1,conditionCount)] ;
% colorVector = {[1 0 0],[0 0 1],[0 1 0],[0 0 0],	[1 0 1]};
% colorVector = {[1 0 0],[1 .3 0],[0 0 1],[0 .5 1]};
symbolVector = {'o','*'};
it = 0;
for gri = 1:groupCount
    for condi = 1:conditionCount
        it = it+1;
        plotColors(it,:)   = colorVector{it};
        plotSymbols(gri)  = symbolVector{1};
        markerSizes(gri)  =  10;
    end
end



% hold on;


%% plot scatters for groups
it = 0;
for gri = 1:groupCount
    for condi = 1:conditionCount
        it = it+1;
        scatter(groupArray(:,it),data(:,it),[],plotColors(it,:),'filled','MarkerFaceAlpha',0.85); %,'jitter','on','jitterAmount',0.05 <- type in if you want jitter
        hold on
        if condi < conditionCount
            line([groupArray(:,it) groupArray(:,it+1)]',[data(:,it) data(:,it+1)]','color',[.6 .6 .6],'linewidth',.1)
        end
    end
end
%% draw box plot

boxplot(data,'Colors','k', 'symbol','');
set(findobj(gca,'type','line'),'linew',2) % line width of boxplot is 1 
%% labels
if ~isempty(labels_xy{1})
    xlabel(labels_xy{1}) % x label
end

ylabel(labels_xy{2}) % y label

%% format figure 
set(gca,'ylim',yLimits,'FontSize',...
    fontSize,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',1,'box','off',...
    'YTick',yTickMarks);
if exist('manualTickLabels_X','var')
   xticklabels(backuplabels); 
end
hold off


% load carsmall MPG 
% figure; 
% MPG(:,2)=MPG(:,1).*2;
% MPG(:,3)=MPG(:,1).*3;
% boxplot(MPG); 
% hold on;
% x=repmat(1:groupCount,length(MPG),1);
% scatter(x(:),MPG(:),'filled','MarkerFaceAlpha',0.6','jitter','on','jitterAmount',0.15);