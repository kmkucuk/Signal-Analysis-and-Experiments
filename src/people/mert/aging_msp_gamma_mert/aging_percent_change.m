


% olderbaseline_mean = mean(cat(4,wholeData(14:26).avg_phase_diff_pli),4);
% olderbaseline_mean = mean(olderbaseline_mean(:,baseIndex,:),2);
% 
% olderbaseline_std = cat(4,wholeData(14:26).avg_phase_diff_pli);
% olderbaseline_std = std(mean(olderbaseline_std(:,baseIndex,:,:),2),[],4);
% 
% 
% 
% youngbaseline_mean = mean(cat(4,wholeData(40:52).avg_phase_diff_pli),4);
% youngbaseline_mean = mean(youngbaseline_mean(:,baseIndex,:),2);
% 
% youngbaseline_std = cat(4,wholeData(40:52).avg_phase_diff_pli);
% youngbaseline_std = std(mean(youngbaseline_std(:,baseIndex,:,:),2),[],4);

% frequency selection for baseline correction
freqForCorrection = 5.5;
cycleIndx = findIndices(wholeData(1).convFreqs,freqForCorrection);
cycle = wholeData(1).convCycles(cycleIndx);
srate = 500;
freqcharacteristics=FreqDomainWavelet(freqForCorrection,cycle,srate,0);
foldingTime_multiplied = freqcharacteristics.foldTime;


dist = .025;    
baselineIterations = floor(abs(-.5+foldingTime_multiplied)/dist);
disp(foldingTime_multiplied);
disp(baselineIterations);
pcount=13; 
fieldName = 'avg_phase_diff_pli';
iterateOrNot = 1; % 1 if you want to iterate baseline window with small ms slides
for i = [1:13, 27:39]

%% fixed centre frequency (delta, theta, alpha)
% group-level z score normalization
% if i <27
%     normdata = (wholeData(i).avg_phase_diff_pli -  olderbaseline_mean) ./ olderbaseline_std;
%     normdata(normdata<0)=0;
%     wholeData(i).pli_percent = sqrt(normdata);
% else
%     normdata = (wholeData(i).avg_phase_diff_pli -  youngbaseline_mean) ./ youngbaseline_std;
%     normdata(normdata<0)=0;    
%     wholeData(i).pli_percent = sqrt(normdata);
% end
%

% individual participant SQUARE ROOT z score normalization 
% wholeData(i).pli_percent = (sqrt(wholeData(i).avg_phase_diff_pli) -  mean(sqrt(wholeData(i+pcount).avg_phase_diff_pli(:,timeIndex,:)),2)) ./ std(sqrt(wholeData(i+pcount).avg_phase_diff_pli(:,timeIndex,:)),[],2);

% indivudual participant z score change normalization 
data = wholeData(i).(fieldName);
normalizedData = [];
pooledNormData = zeros([size(data) baselineIterations]);

if baselineIterations <= 1 || iterateOrNot == 0
    window = [-.5 -.5+foldingTime_multiplied];
    baseIndex = findIndices(wholeData(1).times,window);
    baseIndex = baseIndex(1):baseIndex(2);    
    wholeData(i).pli_percent = ((wholeData(i).(fieldName)) -  mean(wholeData(i+pcount).(fieldName)(:,baseIndex,:),2)) ./ std(wholeData(i+pcount).(fieldName)(:,baseIndex,:),[],2);   
    
else
    
    for k = 1:baselineIterations
        window = [-.5 -.5+foldingTime_multiplied] + ((k-1)*dist);
        baseIndex = findIndices(wholeData(1).times,window);
        baseIndex = baseIndex(1):baseIndex(2);
    %     if i ==1
    %         disp(num2str(wholeData(1).times([baseIndex(1) baseIndex(end)])));
    %     end
        basedata = wholeData(i+pcount).(fieldName)(:,baseIndex,:);

        normalizedData = (data - mean(basedata,2)) ./ std(basedata,[],2);
        pooledNormData(:,:,:,k) = normalizedData;
    end
    wholeData(i).pli_percent = median(pooledNormData,4);
    
end

% between groups z score change normalization
% wholeData(i).pli_percent = ((wholeData(i).avg_phase_diff_pli) -  mean(wholeData(i+pcount).avg_phase_diff_pli(:,baseIndex,:),2)) ./ std(wholeData(i+pcount).avg_phase_diff_pli(:,baseIndex,:),[],2);

% normdata = (wholeData(i).avg_phase_diff_pli -  mean(wholeData(i+pcount).avg_phase_diff_pli(:,timeIndex,:),2)) ./ std(wholeData(i+pcount).avg_phase_diff_pli(:,timeIndex,:),[],2);
% normdata(normdata<0)=0;

end