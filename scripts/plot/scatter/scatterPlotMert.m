function scatterPlotMert(datacell,variables,groupSizes,labels_xy,tickCount_xy,fontSize,manualTickMarks,fitPlot)
%% DESCRIPTION OF INPUT ARGUMENTS
%       -datacell = cell array of data with one participant in one row (wide
%       format)
%
%       -variables = column index of the desired scores (e.g. [2 3] creates a
%       scatterplot from the scores within second and third columns. Second is
%       plotted to X-axis, third is plotted to Y-axis. 
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
%       -tickCount_xy = how many tick should be on the x and y axis (e.g. [5,4])
%                 [5,4] means that X axis will have 5 ticks, Y will have 4
%                 ticks
%
%       -fontSize = font size of axis labels and tick labels (e.g. [16] = 16
%       punto)
%
%
%       -manualTickMarks = a cell array with X and Y tick marks within each
%       element (e.g. {[1,2,3,4,5],[-13,-8,-3,2]}; first axis is X marks second
%       is Y marks). If empty, tick marks are linearly generated using min*-.15 and max*.15 values. 
%
%       - fitPlot = char vector of 'yes' indicates you want to plot fit
%       line to the scatter plot. 

%% Check Variables
if ~exist('manualTickMarks','var')
    manualTickMarks={[],[]};
end

if ~exist('fitPlot','var')
    fitPlot='';
end

%% FIT OF RT DATA %%%
data1=[datacell{:,variables(1)}];
data2=[datacell{:,variables(2)}];
dataCount = length(data1);
%% set x maximum
if isempty(manualTickMarks{1})
    max_x_axis = max(data1) + (abs(max(data1))*.15); % max of X axis is %15 larger than actual value
else
    max_x_axis = max(manualTickMarks{1});
end
min_x_axis = min(data1); 
%% fit data to linear 
fitLine=polyfit(data1,data2,1);
%% set X minimum
if isempty(manualTickMarks{1})
    if min_x_axis < 0 % if min of X axis is lower than 0 
        min_x_axis = min_x_axis * .85; % min if X axis is %15 lower than actual value
    else % if min x axis is positive 
        min_x_axis = 0;
    end
else
     min_x_axis = min(manualTickMarks{1});
end
%% set Y maximum
if isempty(manualTickMarks{2})
    max_y_axis = max(data2) + (abs(max(data2))*.15); % max of X axis is %15 larger than actual value
else
    max_y_axis = max(manualTickMarks{2});
end

%% set Y minimum
min_y_axis = min(data2); 
if isempty(manualTickMarks{2})
    if min_y_axis < 0 % if min of X axis is lower than 0 
        min_y_axis = min_y_axis * .85; % min if X axis is %15 lower than actual value
    else % if min x axis is positive 
        min_y_axis = 0;
    end
else
    min_y_axis = min(manualTickMarks{2});
end

%% Y limits

yLimits = [min_y_axis max_y_axis];
%% create Fit line
xAxisFit=linspace(min_x_axis,max_x_axis,ceil(dataCount)); % increase the number of dots for fit line to 5 times more than actual data points for smooting
fitPredicted=polyval(fitLine,xAxisFit);
%% GROUP INDEX EXTRACTION
groupCount=length(groupSizes);
groupIndices={};
groupArray= [];

for k = 1:groupCount
    if k == 1
        groupIndices{k} = 1:groupSizes(k);
    else
        
        groupIndices{k} = groupSizes(k-1)+1:(groupSizes(k-1)+groupSizes(k));
    end
    groupArray(groupIndices{k}) = k;
end


%% PLOT SCATTERS WITH GROUP COLORS
colorVector = {'r','b','g','k','m'};
symbolVector = {'o','*'};

for i = 1:groupCount
    plotColors(i)   = colorVector{i};
    plotSymbols(i)  = symbolVector{1};
    markerSizes(i)  =  5;
end

hScatterGroup= gscatter(data1,data2,groupArray,plotColors,plotSymbols,markerSizes);

legend('off')
for z = 1:length(hScatterGroup)
    set(hScatterGroup(z),'LineWidth',1)
end

if ~isempty(regexp(fitPlot,'yes'))
    hold on
    lsline
%     plot(xAxisFit,fitPredicted,'k','LineWidth',3);
end

xlabel(labels_xy{1}) % x label
ylabel(labels_xy{2}) % y label
if isempty(manualTickMarks{1})
    xTickMarks = round(linspace(min_x_axis,max_x_axis,tickCount_xy(1)),1);
else
    xTickMarks = manualTickMarks{1};
end

if isempty(manualTickMarks{2})
    yTickMarks = round(linspace(min_y_axis, max_y_axis,tickCount_xy(2)),1);
else
    yTickMarks = round(manualTickMarks{2},1);
end

set(gca,'xlim',[min_x_axis max_x_axis],'ylim',yLimits, 'FontName','Arial','FontWeight','Bold','FontSize',...
    fontSize,'tickdir','out','XColor',[0 0 0],'YColor',[0 0 0],'linewidth',5,'box','off',...
    'YTick',yTickMarks,'XTick',xTickMarks);
hold off
