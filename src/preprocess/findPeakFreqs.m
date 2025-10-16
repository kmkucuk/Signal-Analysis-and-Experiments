function [maxPower,maxFreq]=findPeakFreqs(data,freqRange,frex)

freqRange=findIndices(frex,freqRange);

freqRange=freqRange(1):freqRange(2);

data=abs(data)*2;

[maxPower,freqIndx]=findpeaks(data(freqRange),'SortStr','descend','NPeaks',1);

disp(freqIndx);

maxFreq=frex(freqRange(freqIndx));

end

