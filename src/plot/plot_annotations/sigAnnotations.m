% variable descriptions
%
%       datastruct = is the structure variable you obtain with groupLinePlot()
%                    function
%
%       xaxis               = is the xaxis vector created in groupLinePlot() function
%
%       sig_xaxis           = is the xaxis points that you want to create annotation lines
%                                   example: sig_xaxis= {[1,2],[2,3],[1 5]}
%
%       sig_groups          = is the marker for which group you want to plot the annotations
%                               this works together with sig_xaxis. 
%                                   example: sig_groups= [ 1  ,  2  ,  1] matches the elements in sig_xaxis
% 
%
%       annotationSymbols   = enter annotation symbols in the order of sig_xaxis 
%                                   example: pValue={'*','**','***'}111121
% 
%   EXAMPLE USAGE IN THETA EXOGENOUS:     PLOT: datastruct=groupLinePlot(spssStructure,[1 2],[6 2 7 3 8 4 9 5]+7,2,'within','CIs',2,[0 5],15,gnames)
%                                  ANNOTATIONS: sigAnnotations(datastruct,{[1 2]+7,[3,4]+7,[5,6]+7,[7,8]+7,[1 2]+7,[3,4]+7,[5,6]+7,[7,8]+7},[1,1,1,1,2,2,2,2],{'**','***','**','*','**','**','***','***'},'CIs',[0 5])
% 
%   EXAMPLE USAGE IN THETA ENDOGENOUS:     PLOT: datastruct=groupLinePlot(spssStructure,[1 2],[6 2 7 3 8 4 9 5]-1,2,'within','CIs',2,[0 5],15,gnames)
%                                  ANNOTATIONS: sigAnnotations(datastruct,{[5,6],[7,8],[1 2],[3,4],[5,6],[7,8]},[1,1,2,2,2,2],{'*','*','*','*','**','*'},'CIs',[0 5])




function sigAnnotations(datastruct,xaxisvalues,sig_xaxis,sig_groups,annotationSymbols,errortype,yLims,howManyGroups,conditions)

percAdj=10;
groups =  unique(sig_groups);
allAxisIndices = unique([sig_xaxis{:}]);
% subtractionScalar = min(allAxisIndices);
% subtractionScalar = subtractionScalar-1
subtractionScalar=0;
maxValMean = [];
maxValCI   = [];
%% linda data
for fi = 1:howManyGroups
    maxValMean  =cat(2,maxValMean,datastruct((fi)).data(conditions));
    maxValCI    =cat(2,maxValCI,datastruct((fi)).(errortype)(conditions));
end
%% legacy specific group
% for fi = 1:howManyGroups
%     maxValMean  =cat(2,maxValMean,datastruct(groups(fi)).data(allAxisIndices));
%     maxValCI    =cat(2,maxValCI,datastruct(groups(fi)).(errortype)(allAxisIndices));
% end
[maxValMean,maxidx]= max(maxValMean);
maxValCI   = maxValCI(maxidx);
maxVal=maxValMean+maxValCI;
maxY=max(yLims);
plotInterval=maxY-maxVal;
disp(plotInterval)
barHeight=(plotInterval*percAdj/5)/100;
blankHeight=(plotInterval*(percAdj*1.5))/100;
disp(blankHeight)
disp(barHeight)
iterationX=0;
 
for k = 1:length(sig_xaxis)
    iterationX=iterationX+1;   
    currentplotinterval = sig_xaxis{k};
    currentplotinterval = currentplotinterval(1):currentplotinterval(2);
    
    current_xaxis=xaxisvalues(sig_xaxis{k}); % x axis for plotting, starting from 1th data point (hence -subtractionScalar if required, if not it is 0)
    
    aggregateMatch=[];
    if k > 1
        for checkPlotted = 1:k-1 % check the previous plots and exclude current plotted axis for comparisons 
%             a=sig_xaxis{checkPlotted}
            
%             a=xaxisvalues(sig_xaxis{checkPlotted})
%             b=current_xaxisc
            previousPlot = sig_xaxis{checkPlotted};
            
            for cplot = 1:length(currentplotinterval)
                check1 = currentplotinterval(cplot) == previousPlot(1);
                check2 = currentplotinterval(cplot) == previousPlot(2);
                if check1 || check2
                    aggregateMatch = [aggregateMatch 1];
                    break
                end
            end
%             check = strfind(sig_xaxis{checkPlotted},currentplotinterval);
%             checkIfPlottedBefore1 = double(sig_xaxis{checkPlotted}==(sig_xaxis{k}));
%             checkIfPlottedBefore2 = double(sig_xaxis{checkPlotted}==flip(sig_xaxis{k}));
%             checkIfPlottedBefore = sum(checkIfPlottedBefore1) + sum(checkIfPlottedBefore2);
%             checkMatch = sum(checkIfPlottedBefore,'omitnan'); % sum all elements and if there is a 0 then it is not previously plotted and will not be counted. 
%             if checkMatch>0 
%                 aggregateMatch = [aggregateMatch checkMatch];
%             end
        end
    end
    howManyBarsToAdjust = length(aggregateMatch);
    if howManyBarsToAdjust > 0 
        currentY=maxVal+(blankHeight*(howManyBarsToAdjust+1.25))+(barHeight*(howManyBarsToAdjust)); % add blank space in between the annotations that are on the same axis. 
                                                                                                   % this addition is as follows: blank space + PreviousBars * ((blank space) + %20 of blank space) + annotation bar height 
    else
        currentY=maxVal+(blankHeight)+(barHeight);
    end
    
    if sig_groups(k)==1
         
        grColor='r';
%         current_xaxis=current_xaxis-.125;
    elseif sig_groups(k)==2
%         current_xaxis=current_xaxis+.125;
        grColor='b';
    else
        grColor='k';
    end    
    hold on

    plot([current_xaxis(1) current_xaxis(1)],[currentY currentY+barHeight],grColor,'linewidth',1)

    plot([current_xaxis(2) current_xaxis(2)],[currentY currentY+barHeight],grColor,'linewidth',1)

    plot([current_xaxis(1) current_xaxis(2)],[currentY+barHeight currentY+barHeight],grColor,'linewidth',1)

    middlePoint=mean(current_xaxis);
    if isempty(regexp(annotationSymbols{k},'p'))
%         fontSize = 8;
%         textY=[currentY currentY]+ (3*barHeight);        
        textY=[currentY currentY]+ (2*barHeight);
        fontSize = 8;
    else
        fontSize = 8;
        textY=[currentY currentY]+ (3*barHeight);
        
    end
    text([middlePoint middlePoint],textY,annotationSymbols{k},'Color',grColor,'FontSize',fontSize,'HorizontalAlignment','center')

end
