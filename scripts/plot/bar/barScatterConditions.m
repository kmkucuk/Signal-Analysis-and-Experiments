function xaxis=barScatterConditions(datacell,variableIndex,groupSizes,labels_xy,tickCount_y,fontSize,manualTickMarks_Y,manualTickLabels_X)
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

color1 = [1 1 1];
color2 = [.5 .5 .5];

color1 = [1 0 0];
color2 = [0 0 1];
color3 = [0 1 0];
color4 = [0 .5 .5];
colorVector = [repmat({color1},1,conditionCount) repmat({color2},1,conditionCount)] ;
% colorVector = {[1 0 0],[0 0 1],[0 1 0],[0 0 0],	[1 0 1]};
% colorVector = {[1 0 0],[1 .3 0],[0 0 1],[0 .5 1]};
symbolVector = {'o','+'};
it = 0;
for gri = 1:groupCount
    for condi = 1:conditionCount
        it = it+1;
        plotColors(it,:)   = colorVector{it};
        plotSymbols(gri)  = symbolVector{1};
        markerSizes(gri)  =  10;
    end
end

%% get mean and standard error of data
% assignin('base','data',data)
group1indx = 1:groupSizes(1);
group2indx = groupSizes(1)+1:sum(groupSizes);
assignin('base','data',data);
meanData = mean(data,1);

% stdError = std(data,[],1)/sqrt(length(data)); % std error bars

stdError = std(data,[],1); % 1.5 std deviation bars
%% draw bar graph
% newFormat = [1 5 2 6 3 7 4 8];
meanData = reshape(meanData,conditionCount,groupCount);

% plotColors = plotColors(newFormat,:);
stdError = reshape(stdError,conditionCount,groupCount);


b=bar(meanData,1,'FaceColor','flat','LineWidth',1.5); 

hold on
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(meanData);

% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
xaxis = [];
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, meanData(:,i), stdError(:,i), 'k', 'linestyle', 'none','LineWidth',1.5);
    xaxis = cat(2,xaxis,x);
end

hold off
assignin('base','barvar',b);
for barColorindx = 1:size(b,2)
    if barColorindx == 1
        colors = color1;
    else
        colors = color2;
    end
%     b(barColorindx).CData(:,:) = repmat(colors,3,1);
    b(barColorindx).CData(1,:) = color1; %plotColors(conditionCount+1:end,:);
    b(barColorindx).CData(2,:) = color2; %plotColors(conditionCount+1:end,:);
    b(barColorindx).CData(3,:) = color3; %plotColors(1:conditionCount,:);
    b(barColorindx).CData(4,:) = color4; %plotColors(conditionCount+1:end,:);
end
set(findobj(gca,'type','line'),'linew',1) % line width of boxplot is 1 

% 
% assignin('base','plotColors',plotColors)

%% plot scatters for groups
it = 0;

[ngroups, nbars] = size(data);
for i = 1:nbars
    hold on
    % Calculate center of each bar
    x = repmat(xaxis(i),1,length(data));
%     errorbar(x, meanData(:,i), stdError(:,i), 'k', 'linestyle', 'none');
    scatter(x,data(:,i),70,[0 0 0],symbolVector{mod(i,2)+1},'MarkerFaceAlpha',0.85,'MarkerEdgeColor','k','LineWidth',1,'jitter','on','jitterAmount',0.05); %,'jitter','on','jitterAmount',0.05 <- type in if you want jitter
    
%     scatter(x,data(:,i),[],plotColors(i,:),'filled','MarkerFaceAlpha',0.85,'MarkerEdgeColor','k'); %,'jitter','on','jitterAmount',0.05 <- type in if you want jitter
end


% 
% for gri = 1:groupCount
%     for condi = 1:conditionCount
%         it = it+1;
%         scatter(x,data(:,it),[],plotColors(it,:),'filled','MarkerFaceAlpha',0.85); %,'jitter','on','jitterAmount',0.05 <- type in if you want jitter
%         hold on
%         if condi < conditionCount
%             line([groupArray(:,it) groupArray(:,it+1)]',[data(:,it) data(:,it+1)]','color',[.6 .6 .6],'linewidth',.1)
%         end
%     end
% end

%% labels
if ~isempty(labels_xy{1})
    xlabel(labels_xy{1}) % x label
end

ylabel(labels_xy{2}) % y label

%% format figure 
set(gca,'ylim',yLimits,'FontSize',...
    fontSize,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',1.5,'box','off',...
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