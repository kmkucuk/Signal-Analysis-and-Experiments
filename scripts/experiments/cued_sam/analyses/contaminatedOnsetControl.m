sca;
%% RT EXTRACTION
directoryName = 'D:\MatlabDirectory\MertKucuk\Cued_SAM\Cued_SAM\behavioralData\submdeneme_B_topLeftShort\block_1';
cd(directoryName)
fileName = 'mdeneme_block1_estimatedOnset.txt';
data=readcell(fileName);
data(1,:)=[];
[expProb, gammaDist]            = GammaFit(RTvector);
simulatedRT                     = gamrnd(gammaDist.a,gammaDist.b,[1 1000]);
meanRT                          = mean(simulatedRT);
%% STIMULUS DISPLAY AND DURATIONS
RTvector = [data{2:end,5}].';
colorVector                     = repmat([1 1 1 1 2 2 2 2],[1 4]);
flowVector                      = repmat([1 2 3 4 5 6 7 8],[1,4]);
responseIteration               = [1 3 5 7];
stimVector                      = [165 85 165 85]*2;
stimVector                      = repmat(stimVector,[1 8]);
cumStimTimes                    = cumsum(stimVector);
cumStimTimes                    = cumStimTimes-stimVector(1);
cumStimTimes_tmp                = cumStimTimes;


% check if RT interval encapsulates new stim onset marker 
% cumsum duration by marker + RT = buttonTime 
% [buttonTime - 2 buttonTime - .1];
%
% stimMarkerOfCorect .* wrongCoefficient = stimMarkerOfError
%
% stimMarkerOfCorrect = [1 1] = red top stim     = left short press
%                       [1 -1] = red bottom stim  = left long press
%                       [-1 1] = blue top stim    = right short pres
%                       [-1 -1] = blue bottom stim = right long press 
%
% wrongCoefficient    = [1 1] = correct color/correct position
%                     = [0 -1] = correct color(left-right) / wrong position(duration)
%                     = [-1 0] = wrong color / correct position 
%                     = [-1 -1] = wrong color / wrong position 
%% STIMULUS NAMES AND CORRECT/ERROR RESPONSE PROPERTIES
stimTypeIndx                    = {23, 25, 27, 29; [1 1], [1 -1], [-1 1], [-1 -1];'RED_TOP','RED_BOTTOM','BLUE_TOP','BLUE_BOTTOM';1, 3 , 5, 7}; %INDICES OF THE LAST STIMULUS OF THE FOLLOWING DISPLAY SEQUENCES:  1) R R B B    2) R B B R      3) B B R R      4) B R R B
stimTypeCount                   = length(reversalStimIndx);
stimNames                       = {'RED_TOP','fixation','RED_BOTTOM','fixation','BLUE_TOP','fixation','BLUE_BOTTOM'};
accuracyVector                  = {'Long_Press','Short_Press','WKey_Long_Press','WKey_Short_Press','WKey_Correct_Duration'};
errorTypeIndx                   = {[1 -1],[-1 1],[-1 -1];'Wrong_Duration','Wrong_Button','Wrong_Button_Duration'};
errorTypeCount                  = length(errorTypeIndx);
colors                          = ['r','b'];
ylimit                          = [0 2.5];





for accuracyType = accuracyVector
    accuracyType  = accuracyType{:};
    figure(response)
    response
    
        
    
    for respondedStim = 1:stimTypeCount
        
        actualStimIndx        = stimTypeIndx{1,respondedStim};
        actualStimCoefficient   = stimTypeIndx{2,respondedStim};
        actualStimName          = stimTypeIndx{3,respondedStim};
        
        for errorType = 1:errorTypeCount
           
            errorCoefficient        = errorTypeIndx{1,errorType};
            errorName               = errorTypeIndx{2,errorType};
            errorStimCoefficient    = actualStimCoefficient .* errorCoefficient;
            for tmpIndx = 1:4
                tmp = stimTypeIndx{2,tmpIndx};
                matchOrNot = strfind(tmp, errorStimCoefficient);
                if matchOrNot == 1
                    errorStimIndx = tmpIndx;
                    break
                end
            end
            
            errorStimIndx           = stimTypeIndx{1,errorStimIndx};
            errorStimName           = stimTypeIndx{3,errorStimIndx};
            errorStimMarker         = stimTypeIndx{4,errorStimIndx};
            for RTval = simulatedRT
                
                buttonTime                          = RTval + cumStimTimes(actualStimIndx);                
                onsetInterval                       = [buttonTime-2500 buttonTime-100];
                unrelatedOnsets                     = find(flowVector~=errorStimMarker);
                cumStimTimes_tmp(unrelatedOnsets)   = NaN;                
                
                indx1=findIndices(cumStimTimes_tmp,onsetInterval);
                interval=indx1(1):indx1(2);
                indx2=find(flowVector(interval)==errorStimMarker);
                indx2=interval(1)+indx2-1;    
                
                deleteIndex=[];
                registeredOnsets=[];
                
                    for checkOnsets = indx2
                          % Check if estimated onsets exceed the [response - .25/.15 to 2.5] sec threshold 
                          if exo_endo == 2
                              lowThreshold = .15;
                          else
                              lowThreshold = .25;
                          end
                          highThreshold = 2.5;
                            if buttonTime-cumStimTimes_tmp(checkOnsets)>lowThreshold && buttonTime-cumStimTimes_tmp(checkOnsets)<highThreshold
                                registeredOnsets=[registeredOnsets checkOnsets];                                                    %#ok<*AGROW>
                            end                                   
                    end

                    if ~isempty(registeredOnsets)
                        onsetIndex                          = registeredOnsets(findIndices(specificOnsets(registeredOnsets),referencePoint)); % find the index of the closest stimulus onset 
                        % -1 because durations are cumulative
                        % and onsets correspond to index before
                        % the actual one 
                        screenStimOnset                    = stimOnsetRegistery(onsetIndex); % get the exact display time of estimated stimulus onset                                                     
                        estimated_RT                       = pressTime - screenStimOnset; % calculated estimated RT            
                    end
                
            end
            
            
            
            
        end
        
        if respondedStim == 23 
            responseType = 'Short_Press';
            stimMarkerOfCorrect = [1 1];
        elseif respondedStim == 27
            responseType = 'Long_Press';
            stimMarkerOfCorrect = [1 -1];
        elseif respondedStim == 25 
            responseType = 'Short_Press';
            stimMarkerOfCorrect = [-1 1];
        elseif respondedStim == 29
            responseType = 'Long_Press';
            stimMarkerOfCorrect = [-1 -1];
        end
        if strcmp(accuracyVector, 'Wrong_Duration')
            wrongCoefficient = [1 -1];
        elseif strcmp(accuracyVector, 'Wrong_Button')
            wrongCoefficient = [1 1];
        elseif strcmp(accuracyVector, 'Wrong_Button_Duration')
            wrongCoefficient = [-1 -1];
        end
                
            
        if strcmp(accuracyType,responseType) % if press requirement (e.g. short_press) and press error (e.g. short_press) are the same, it is not an error, continue to next stimulus onset
            continue
        end
        


        for RTindx = simulatedRT
        responseTime=RTindx;
        
       
        hold on
        area(stimInterval,[ylimit;ylimit],'FaceColor',[.7 .7 .7])

        plot([responseTime responseTime],ylimit,'k','linewidth',3)
        text(responseTime+150,ylimit(2)+.5,[stimNames{response},' BUTTON'],'Color','k','FontSize',9,'HorizontalAlignment','center')
            for k = 1:80
                if k == 1 
                 sumval=0;
                else
                 sumval=sum(stimVector(1:k-1));
                end
                plotval=sumval+stimVector(k);
                if mod(k,2)==0
                    pHeight=1;
                else
                    pHeight=2;
                end
        %         disp(sumval:plotval)
                plot([sumval plotval],[pHeight pHeight],colors(colorVector(k)),'linewidth', 3.5)
                hold on
                if flowVector(k)== response
                    indx1=findIndices(cumStimTimes_tmp,stimInterval);
                    interval=indx1(1):indx1(2);
                    indx2=find(flowVector(interval)==response);
                    indx2=interval(1)+indx2-1;

                    middlepoint=[sumval+plotval,sumval+plotval]/2;
                    text(middlepoint,[pHeight pHeight]+.2,stimNames{response},'Color','k','FontSize',9,'HorizontalAlignment','center')
                    if sumval>stimInterval(1) && sumval<stimInterval(2)
                        text(middlepoint+150,[pHeight pHeight]-.2,num2str(responseTime-sumval),'Color','k','FontSize',12,'HorizontalAlignment','center')
                    end

                    for j=1:length(indx2)
                        if cumStimTimes(indx2(j))>stimInterval(1) && cumStimTimes(indx2(j))<stimInterval(2)
                            plot([cumStimTimes(indx2(j)) cumStimTimes(indx2(j))],[1.5 2],'k','linewidth', 3.5)
                        end
                    end
        %             plot([cumStimTimes(intervalIndx(2)),cumStimTimes(intervalIndx(2))],[1.5 2],'linewidth', 3.5)

                end
            end
        set(gca,'ylim',[0 ylimit(2)+1],'XColor', [0 0 0], 'YColor', [0 0 0], 'linewidth', 2,'box','off','FontSize',16);
        yticklabels({'fixation','double dot','',''});

        end
    

xlabel('Time (milliseconds)')
    end
end

% extract red first from the data




