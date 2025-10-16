function data=findMaxFreq(data,dataname,timewindow,channels,freqs,maxOrPeak,missingFreqValue,outputFieldName)
% data = your structure variable with participant data

% dataname = your data field in character 'erspdata'

% timewindow = the time window you want to extract most responsive
% frequency (e.g. [0 1] = zero and 1 second)

% channels = channel indices you want to make extraction (e.g. [1 2 3 4 5])

% freqs = frequency range that you want to extract the most responsive
% frequency from (e.g. [4 8] Hz)

% maxOrPeak = 'max' or 'peak' selects the method in which the most
% responsive frequency is extracted. 

% missingFreqValue = it is the individual frequency if there are no clear
% peaks (e.g. 11 Hz for alpha or 40 Hz for gamma)

% outputFieldName = a char vector with the new field name
% (e.g. 'lowGammaFrequency')

timeIndices=findIndices(data(1).times,timewindow);
freqIndices=findIndices(data(1).convFreqs,freqs);
missingIndex=findIndices(data(1).convFreqs,missingFreqValue);

timeInterval = timeIndices(1):timeIndices(2);
freqInterval = freqIndices(1):freqIndices(2);
ps = length(data);

if strcmp(maxOrPeak,'max') % max values
    method = 1;
elseif strcmp(maxOrPeak,'peak') % peaks
    method = 2;
elseif strcmp(maxOrPeak,'maxmin') % difference between max and min values
    method = 3;
elseif strcmp(maxOrPeak,'mean') % difference between max and min values
    method = 4;
else 
    disp('Please enter a correct method for extraction: max or peak')
    return
end

for k = 1:ps
    addFreqIndex = freqInterval(1)-1; 
    addTimeIndex = timeInterval(1)-1; 
    if isempty(data(k).(dataname))
        continue
    else
        if method == 1

        values=max(data(k).(dataname)(freqInterval,timeInterval,channels),[],2);
        values = permute(values,[1 3 2]);    

        maxValueChans = max(values,[],2);
        [maxval,freqIndex] = max(maxValueChans,[],1);    
        data(k).([outputFieldName '_val']) = maxval;
        data(k).(outputFieldName) = data(k).convFreqs(freqIndex+addFreqIndex);
        elseif method == 2
            maxPeaks = nan(length(freqInterval),length(channels),4);
            for chanIndx = 1:length(channels)
                for freqIndx = freqInterval

                    [tmpPeak, peakTime, peakWidth, peakHeight]=findpeaks(data(k).(dataname)(freqIndx,timeInterval,channels(chanIndx)),'SortStr','descend');

                    [~, largestIndx] = max(peakHeight);
                    if isempty(largestIndx)
                        maxPeaks(freqIndx,chanIndx,1)=nan;
                        maxPeaks(freqIndx,chanIndx,2)=nan;
                        maxPeaks(freqIndx,chanIndx,3)=nan;
                        maxPeaks(freqIndx,chanIndx,4)=nan;
                    else
                        tmpPeak          = tmpPeak(largestIndx);
                        peakTime         = peakTime(largestIndx);
                        peakWidth        = peakWidth(largestIndx);
                        peakHeight       = peakHeight(largestIndx);
                        maxPeaks(freqIndx,chanIndx,1)=peakHeight;
                        maxPeaks(freqIndx,chanIndx,2)=tmpPeak;
                        maxPeaks(freqIndx,chanIndx,3)=peakTime;
                        maxPeaks(freqIndx,chanIndx,4)=peakWidth;                    
                    end


                end
            end
            [maxValueChans, maxChanIndx]    = max(maxPeaks(:,:,1),[],2); % find the highest peak locations among all frequencies

            [~,freqIndex]                   = max(maxValueChans,[],1); % find the frequency with highest peak among all frequencies
            maxChanIndx                     = sort(maxChanIndx).';
            chanOccurences = [1 2 3 4; 0 0 0 0];
            for sortIndx = 1:4 
                countFreq = find(maxChanIndx==sortIndx);

                if isempty(countFreq)
                    countFreq = 0;                
                else
                    countFreq = length(countFreq); 
                end
                chanOccurences(2,sortIndx)=countFreq;
            end

    %         max_Height                      = maxPeaks(freqIndex,maxChanIndx,1);
    %         max_Peak                        = maxPeaks(freqIndex,maxChanIndx,2);
    %         max_Time                        = data(k).times(maxPeaks(freqIndex,maxChanIndx,3)+addTimeIndex);
    %         max_Width                       = 1000/data(k).srate*maxPeaks(freqIndex,maxChanIndx,4);
                if isnan(freqIndex) || isempty(freqIndex)
                    freqIndex = missingIndex;
                end
                data(k).(outputFieldName)       = data(k).convFreqs(freqIndex);
    %         data(k).peakParameters          = [max_Height max_Peak max_Time max_Width];
    %         data(k).peakChan                = maxChanIndx;
    %         data(k).peakTopoDistribution    = chanOccurences;
        elseif method == 3
            %% peak to peak
            peakMatrix = nan(2,4);
            for chanIndx = 1:length(channels)
                values=peak2peak(data(k).(dataname)(freqInterval,timeInterval,channels(chanIndx)),2);
                [maxval freqIndx] = max(values);

                peakMatrix(1,chanIndx)=maxval;
                peakMatrix(2,chanIndx)=freqIndx;

            end
                [maxval maxFreqIndx]= max(peakMatrix(1,:));
                maxFreqIndx=max(peakMatrix(2,maxFreqIndx));
    %             data(k).peakParameters          = maxval;
                data(k).(outputFieldName)       = data(k).convFreqs(maxFreqIndx+addFreqIndex);
        elseif method == 4
            %% mean
            meandata = mean(data(k).(dataname)(freqInterval,timeInterval,channels),2);
            values  = max(meandata,[],2);
            values = permute(values,[1 3 2]);    

            maxValueChans = max(values,[],2);
            [maxval,freqIndex] = max(maxValueChans,[],1);    
            data(k).([outputFieldName '_val']) = maxval;
            data(k).(outputFieldName) = data(k).convFreqs(freqIndex+addFreqIndex);              
        end
    end

%     if k == 1
%         maxChanIndx
%         maxValueChans
%         freqIndex
%         countChan
% %         findpeaks(data(k).(dataname)(freqInterval,timeInterval,channels),2);
%         reply=input('Save figure? y/n','s');
%     end    
    
end
    