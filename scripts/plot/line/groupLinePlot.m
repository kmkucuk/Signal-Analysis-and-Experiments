function datastruct=groupLinePlot(datastruct,groups,conditions,pairs,design,errortype,colorpalette,yLims,pcount,groupnames,yLabel)
% datastruct: 
% input: either a structure or a numeric matrix variable with subjects in
% rows and datapoints in columns.
% output: data structure variable with mean and std error values used for
% plotting.
%
% conditions: indices of values that will be plotted. Given that you will
% have only mean values, there will be groupXwithinfactors conditions. 
%
% pairs: number of elements in a line pair. It can be at least 2 because
% line graphs need at least two. 
%
% groups = [1 2] if 2, [1 2 3] if three groups etc. 
%
% colorpalette= it can be 1, 2, or 3. Try each to see colors.
%
% yLims= limit of Y axis low and high value, e.g. [0 5] or [-3 3].
%
% errortype = 'within' or 'between': 'within' plots within subjects
% corrected errorbars. Correction depends upon the conditions you have
% entered in 'conditions'.
%
% design= 'within' or 'between'; this adjusts the way line graphs are
% created. 'within' creates separate line plots for each group, 'between' group
% creates lines with values from both groups. 
%   # use 'within' if you want to plot within-subjects interaction.
%   # use 'between' if you want to plot between-subjects interaction. 
%
% Created by: Kurtulu? Mert K���k (11/04/2021 uploaded to github).

linestyles={'-','-','--','-','--','-','--'}; %'-','-',
markerstyles={'o','^','s','h','o','o','o','^','o','^','s','h','o','^','s','h'};

capsize=14;
markersize=10; % bigger sizes overlap with error bars, not recommended
markerline=1;
lineWidth=1;
cpalette=callpalette(colorpalette);
cpalette=[cpalette cpalette];
fnames=fieldnames(datastruct);
fnames=fnames(3:end);
% colors={'r',[0 .5 0],'b','k'};
%%% YOUNG PLOT %%%
    colormultiplieryoung=[1 .7 .4];
    colormultiplierelder=[1 .7 .4];
    
datastruct=customClusteringPlotData(datastruct,conditions,pcount,pairs,groupnames);  
assignin('base','datastruct',datastruct);
condCount=length(conditions);
groupcount=length(groups);
errordata=[];
betweendata=[];
labels={};
legends={};
for grpi= 1:groupcount
    conditeration=0;
    if strncmp(design,'within',6) == 1 
        xlength=condCount;
        labels=[labels fnames];
    elseif strncmp(design,'between',7) == 1 
        xlength=pairs;
        labels=fnames;
    end
    
    xaxis=1:xlength;
    if grpi==1
        zaxis=ones(1,length(xaxis))+1;
    else
        zaxis=ones(1,length(xaxis));
    end
    hplot=plot(xaxis,nan(1,xlength));        
    hold on     
    
    for condi=1:pairs:condCount      
        conditeration=conditeration+1;
        disp(condi)
        plotindx=conditions(condi:(condi+pairs-1));
        legends(conditeration,:)=datastruct(grpi).conditions(plotindx);
        if strncmp(design,'within',6) == 1 
            disp('within')

            colors=cpalette{conditeration}.*colormultiplieryoung;
%             colors=[0 0 0];
            if pairs >= 4
                markerstyles = {'s','s','s','s'};
            end
            
            if grpi == 1 % Red for older and blue for young group
                colors=[1 0 0];
                xSlide=-.125;
            else
                colors=[0 0 1];
                xSlide=.125;
            end
            %plotindx2=(1+(grpi-1)*pairs:(grpi*pairs)); % for separating groups AND within factors.
            plotindx2=(condi:(condi+pairs-1)); % separating only the WITHIN factors, groups are plotted on the same points for each within factor.
            errorbar(xaxis(plotindx2)+xSlide,datastruct(groups(grpi)).data(plotindx),datastruct(groups(grpi)).(errortype)(plotindx),...
                'linewidth',lineWidth,'CapSize',capsize,'Color',colors,'linestyle',linestyles{grpi});
            for modi=1:pairs
                hplot(conditeration)=plot3(xaxis(plotindx2(modi))+xSlide,datastruct(groups(grpi)).data(plotindx(modi)),zaxis(plotindx2(modi)),[markerstyles{modi}]...
                    ,'MarkerSize',markersize,'Color',colors,'linewidth',markerline,'MarkerFaceColor',[1 1 1]);%
            end
            

            
        elseif strncmp(design,'between',7) == 1 
            disp('between')

            disp(plotindx)
            
            xaxisindx=1:(pairs);
            
%             if length(conditions)/pairs>1
%                 colors1=[cpalette{conditeration}].*colormultiplieryoung;
% %                 colors1=[0 0 0];
%             else
%                 colors1=[cpalette{3}].*colormultiplieryoung;
%             end             
            if pairs >= 4
                markerstyles = {'s','s','s','s'};
            end
            if grpi == 1 % Red for older and blue for young group
                colors1=[1 0 0];
                xSlide=-.125;
            else
                colors1=[0 0 1];
                xSlide=.125;
            end
            
            betweendata=datastruct(grpi).data(plotindx);
            errordata=datastruct(grpi).(errortype)(plotindx);
            errorbar(xaxis(xaxisindx)+xSlide,betweendata,errordata,...
                'linewidth',lineWidth,'CapSize',capsize,'Color',colors1,'linestyle',linestyles{conditeration});
            hplot(conditeration)=plot3(xaxis(xaxisindx)+xSlide,betweendata,zaxis(xaxisindx),[markerstyles{conditeration}],...
                'MarkerSize',markersize,'Color',colors1,'linewidth',markerline,'MarkerFaceColor',[1 1 1]);%,'MarkerFaceColor',colors1
 
                   
        end
    end
end


% legends={'Older','Young'}; %{'Left Hemisphere','Right Hemisphere'}; % %{'','        Frontal','','        Central','','        Parietal','','          Occipital'}
% SETUP LABELS
%
% 1) Works for theta paper:
% {'            Frontal','            Central','            Parietal','            Occipital'}
if pairs == 2
    labels = {'Frontal','Central','Parietal','Occipital'};
    ytickcount = 5;
    xtickcount = 4;
elseif pairs == 4
    labels = {'','-1500 to -900 ms','','','','-700 to -100 ms',''}; % labels = {'F','C','P','O'};
    ytickcount = 5;
    xtickcount = 7;
else
    ytickcount = 5;
    xtickcount = 4;    
end
%% Schizo paper
if pairs == 2
    labels = {'Frontal','Central','Parietal','Occipital'};
elseif pairs == 4
    if conditions(1) == 1
        labels = {'F','C','P','O'}; %,'F4','C4','P4','O2'}; %labels = {'Frontal','Central','Parietal','Occipital'}; % labels = {'F','C','P','O'};
    else
        labels = {'F4','C4','P4','O2'}; %,'F4','C4','P4','O2'}; %labels = {'Frontal','Central','Parietal','Occipital'}; % labels = {'F','C','P','O'};
    end
    
    ytickcount = 4;
    xtickcount = 4;
else
    ytickcount = 5;
    xtickcount = 4;    
end 

%;%{'','Pre-Rev','           Reversal' ,'','   Post-Rev'} % {'','               Left Frontal','','              Right Frontal',''} {'','Pre-Rev','            Reversal' ,'','   Post-Rev'} %{'','','Frontal','','','Central','','','Parietal','','','Occipital',''}; % {'F','C','P','O'} {'            Frontal','','            Central','','            Parietal','','            Occipital'};
formataxes(yLims,xaxis,'normal',xtickcount,ytickcount,labels,yLabel);

% 
% legend(hplot,legends,'Location','northeastoutside');  %,'Location','northeastoutside'
% legend('boxoff');