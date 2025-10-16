it=0;
pcount=13;
writingIndx = 56;
timeIndex = findIndices(wholeData(1).times,[-.400 0]);
timeIndex = timeIndex(1):timeIndex(2);

for i = [[1:13],[27:39]]
it=it+1;

%% fixed centre frequency (delta, theta, alpha)
wholeData(i).pli_percent = (wholeData(i).avg_phase_diff_pli -  mean(wholeData(i+pcount).avg_phase_diff_pli(:,timeIndex,:),2)) ./ std(wholeData(i+pcount).avg_phase_diff_pli(:,timeIndex,:),[],2);

% 
% %% low beta dominant frequency
% freqIndex1 = findIndices(wholeData(1).convFreqs,wholeData(i).lowbeta);
% freqIndex2 = findIndices(wholeData(1).convFreqs,wholeData(i+20).lowbeta);
% 
% wholeData(it+80).itpc_lap_lowbeta   =  100.*(max(wholeData(i).itpc_lap(freqIndex2,timeIndex,:),[],2) - max(wholeData(i+20).itpc_lap(freqIndex1,timeIndex,:),[],2)) ./ max(wholeData(i+20).itpc_lap(freqIndex1,timeIndex,:),[],2);
% 
% %% high beta dominant frequency
% freqIndex1 = findIndices(wholeData(1).convFreqs,wholeData(i).highbeta);
% freqIndex2 = findIndices(wholeData(1).convFreqs,wholeData(i+20).highbeta);
% 
% wholeData(it+80).itpc_lap_highbeta   =  100.*(max(wholeData(i).itpc_lap(freqIndex2,timeIndex,:),[],2) - max(wholeData(i+20).itpc_lap(freqIndex1,timeIndex,:),[],2)) ./ max(wholeData(i+20).itpc_lap(freqIndex1,timeIndex,:),[],2);
% 
% 
% %% low gamma dominant frequency
% 
% freqIndex1 = findIndices(wholeData(1).convFreqs,wholeData(i).lowgamma);
% freqIndex2 = findIndices(wholeData(1).convFreqs,wholeData(i+20).lowgamma);
% 
% wholeData(it+80).itpc_lap_lowgamma   =  100.*(max(wholeData(i).itpc_lap(freqIndex2,timeIndex,:),[],2) - max(wholeData(i+20).itpc_lap(freqIndex1,timeIndex,:),[],2)) ./ max(wholeData(i+20).itpc_lap(freqIndex1,timeIndex,:),[],2);
% 
% 
% %% high gamma dominant frequency
% 
% freqIndex1 = findIndices(wholeData(1).convFreqs,wholeData(i).highgamma);
% freqIndex2 = findIndices(wholeData(1).convFreqs,wholeData(i+20).highgamma);
% 
% wholeData(it+80).itpc_lap_highgamma   =  100.*(max(wholeData(i).itpc_lap(freqIndex2,timeIndex,:),[],2) - max(wholeData(i+20).itpc_lap(freqIndex1,timeIndex,:),[],2)) ./ max(wholeData(i+20).itpc_lap(freqIndex1,timeIndex,:),[],2);



end