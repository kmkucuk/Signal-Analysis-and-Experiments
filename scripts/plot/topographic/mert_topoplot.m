%method = average or MAX plot. (e.g. 'mean' OR 'max')
%
%groupText = cell vector containing first three letters of groups (e.g.
%patient = 'pat', control = 'con' OR older = 'old', young = 'you'
%
% pCount = use if you are using 'max' which requires wholeData structure
% with all participant's data.
%
% maxFreqField = it is the structure field that contains maximum frequency (e.g. 'lowbeta').
% 
function mert_topoplot(convStats,conditions,chans,timewins,freqs,datatype,ylims,method,groupText,pCount,maxFreqField,chaninfovariable)
if ~exist('chaninfovariable','var')
    load 10chanlocs.mat
end
if ~exist('chans','var')
    chans=1:length(convStats(1).chaninfo);
end
times=convStats(1).times;



plotC=length(conditions);

plotT=length(timewins)/2;
actualFreqs = freqs;
if ~isempty(freqs)
    freqs=findIndices(convStats(1).convFreqs,freqs);
end

 
timeindx=findIndices(times,timewins);


data=[];
for i = 1:plotC
    if plotC > 1
        pIndices = (((conditions(i)-1)*pCount)+1) : (conditions(i)*pCount)
    else 
        pIndices = 1;
    end
    j=i;
    timeIndx=0;
    for k = 1:2:length(timewins)      
    timeIndx=timeIndx+1;
    plotIndx = timeIndx+((j-1)*plotT);
        if ~isempty(freqs)
            if ~isempty(regexp(method,'mean'))
                data=squeeze(mean(convStats(conditions(pIndices)).(datatype)(freqs,timeindx(k):timeindx(k+1),chans),2)); % FOR ERSP 
                assignin('base','data',data);
%                 titleText=[groupText{i},'  ' ,num2str(actualFreqs),'Hz'];
                if timewins(1) < 0
                    titleText=['pre-video' ,'  ' ,num2str(actualFreqs),'Hz'];
                else
                    titleText=['during video' ,'  ' ,num2str(actualFreqs),'Hz'];
                end
            else

                if freqs == 999
                    for pindex = pIndices
                        freqIndex = findIndices(convStats(1).convFreqs,convStats(pindex).(maxFreqField));
                        data = cat(4,data,convStats(pindex).(datatype)(freqIndex,:,:));
                    end
                    data=mean(max(data(:,timeindx(k):timeindx(k+1),chans,:,:),[],2),4); % FOR ERSP 
                else
                    data=cat(4,convStats(pIndices).(datatype));
                    data=mean(max(data(freqs,timeindx(k):timeindx(k+1),chans,:),[],2),4); % FOR ERSP 
                end
                titleText=[groupText{i},' frequency: ' ,num2str(actualFreqs),'Hz'];
            end
        else
            if ~isempty(regexp(method,'mean'))
                data=mean(convStats(conditions(i)).(datatype)(timeindx(k):timeindx(k+1),chans),2); % FOR ERSP 
                titleText=[groupText{i} ,' frequency: ' ,num2str(actualFreqs),'Hz'];
            else
                data=cat(3,convStats(i).(datatype)(timeindx(k):timeindx(k+1),chans));
                data=mean(max(data,[],1),3);     
                titleText=[groupText{i}  ,' frequency: ' ,num2str(freqs),'Hz'];
%                 titleText=convStats(pIndices(1)).group;
            end        

        end
    %data2=max(convStats(conditions(i)).(datatype)(freqs,timeindx(k):timeindx(k+1),chans),[],2); % FOR ITC ANALYSES
 

%         if strncmp(convStats(conditions(i)).group,groupText{1},3)
%             rowidx=1;
%         elseif strncmp(convStats(conditions(i)).group,groupText{2},3)
%             rowidx=2;
%         end

%     subplot(plotT,plotC,plotIndx);    
    size(data)
    size(chaninfovariable)
    topoplot(data,chaninfovariable,'maplimits',ylims);
    set(gca,'ylim',ylims,'ytick',yticks,'xtick',xticks,'xlim', xlimits,...
'tickdir','out','XColor',[0 0 0], 'YColor', [0 0 0],'FontSize',14,'box','off');  
    title(titleText)
        if i==plotC
            cb=colorbar;
            cb.Position = cb.Position  + [.1 0 0 0];
            cbtitle=get(cb,'Title');
            set(cbtitle,'String',"dB")
            set(cb,'fontweight','bold','fontsize',8);
            cbticks=linspace(ylims(1),ylims(2),3);
            % %set colorbar ticks
            set(cb,'Ticks',cbticks);
            cb.Ruler.TickLabelFormat = '%.2f';
        end
    end
    
end
% 
% colorbar properties
% title   


% %set colorbar position
% hp4=get(subplot(plotC,plotT,j),'position');
% set(cb,'Position', [hp4(1)+hp4(3)+.015  .35  0.022  hp4(2)+hp4(3)-.15]);



    
