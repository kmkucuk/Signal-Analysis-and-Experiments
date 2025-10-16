function ValidDurationPlot(X1, YMatrix1)
hold on


% Create figure
figure1 = figure('Name','Dominance Durations Histogram');

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.168763048474569 0.3778125 0.756236951525431]);
hold(axes1,'on');

plot1 = plot(X1,YMatrix1,'LineWidth',0.8,'Color',[0 0 0]);
set(plot1(1),'DisplayName','Expected Lognormal Distribution',...
    'LineStyle','--');
set(plot1(2),'DisplayName','Expected Gamma Distribution');

% Create ylabel
ylabel('Probability Density Function','FontName','Times New Roman');

% Create xlabel
xlabel('Normalized Dominance Durations','FontName','Times New Roman');

% Set the remaining axes properties
set(axes1,'TickDir','out','TickLength',[0.005 0.01],'XTick',[0 1 2 3 4 5],...
    'XTickLabel',{'','1','2','3','4','5'},'YTick',...
    [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8],'ZTick',[-1 0 1]);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.340229907440731 0.732463295269168 0.147395829732219 0.140872462355242],...
    'FontSize',12);
end