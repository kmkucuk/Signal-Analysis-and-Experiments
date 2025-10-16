%%% Parameters:
%%% EEG = dataset structure
%%% freq_range = frequency range to be plotted
%%% freqcount = how many frequencies within the range
%%% channels = which channels as in integer vector e.g. [1:10] = first 10
%%% cycles = cycle range 
%%%
%%%baselinePeriod= specify the baseline in seconds
%%%convWindow = specify convolution window in seconds

function [EEG]=convolveWithinConditionBaseline(EEG,freq_range,freqcount,channels,cycles,convWindow,baselinePeriod) 
%% TF of many trials: the painful, slow, and redundant way

% convolution and baseline time windows

times=EEG(1).times;  %%% time points within a data

[~, minConvWinIx]=min(abs(times-(convWindow(1))));
[~, maxConvWinIx]=min(abs(times-(convWindow(2))));

[~, minBLIndx]=min(abs(times-(baselinePeriod(1))));
[~, maxBLIndx]=min(abs(times-(baselinePeriod(2))));
%%% if the length of the baseline/conv period is not even, then decrease maxIndx
%%% by one
if ~mod(maxConvWinIx-minConvWinIx,2)
   maxConvWinIx=maxConvWinIx-1; 
end

convWindow=times(minConvWinIx:maxConvWinIx);
convPnts=length(convWindow);

if ~mod(maxBLIndx-minBLIndx,2)
   maxBLIndx=maxBLIndx-1; 
end

% frequency parameters

frex = logspace(log10(freq_range(1)),log10(freq_range(2)),freqcount);

%cycle parameters

s = logspace(log10(cycles(1)),log10(cycles(end)),freqcount) ./ (2*pi*frex);

wavtime = -2:.002:2;

half_wave = (length(wavtime)-1)/2;

% FFT parameters

nWave = length(wavtime);

cCount=length(channels); 

pCount=length(EEG);         %%% subjects count * condition count (every participant is registered again per condition)


% initialize output time-frequency data according to convolution period and
% frequency vector 

tf = zeros(length(frex),convPnts);
itpc= zeros(length(frex),convPnts);

MemoryconvData=nan(length(frex),convPnts,length(channels));

convData=MemoryconvData;
itpcData=MemoryconvData;
for pti = 1:pCount
    
    fprintf('\nProcessing participant: %s', EEG(pti).subject);
    
    tCount=size(EEG(pti).data,3);  
    
    nData = length(times) * tCount; %%% calculates the length of concatenated data

    nConv = nWave + nData - 1;    


        for ci = 1:cCount

        % now compute the FFT of all trials concatenated
        fprintf('\nProcessing channel: %s', EEG(pti).chaninfo{ci});
        
        alldata = reshape(EEG(pti).data(:,ci,:) ,1,[]);

        dataX = fft(alldata ,nConv);

        % loop over frequencies

            for fi=1:length(frex)  
                    
                % create wavelet and get its FFT
                % the wavelet doesn't change on each trial...
                wavelet  = exp(2*1i*pi*frex(fi).*wavtime) .* exp(-wavtime.^2./(2*s(fi)^2));

                waveletX = fft(wavelet,nConv);

                waveletX = waveletX ./ max(waveletX);       %%% amp normalization to max=1

                % now run convolution in one step
                as = ifft(waveletX .* dataX);

                as = as(half_wave+1:end-half_wave);

                % and reshape back to time X trials
                as = reshape( as, length(times), tCount );
                
                %compute inter-trial phase clustering
                tmpitpc=abs(mean(exp(1i*angle(as)),2));
                
                % compute power and average over trials
                tmpavg = mean( abs(as).^2 ,2);
                
                % compute baseline correction via DB change                
                tf(fi,:) = 10 * log10(tmpavg(minConvWinIx:maxConvWinIx) / mean(tmpavg(minBLIndx:maxBLIndx)));
                itpc(fi,:)=tmpitpc(minConvWinIx:maxConvWinIx);
                
            end
            
            itpcData(:,:,ci)=itpc;
            convData(:,:,ci)=tf;           
                        
        end

        EEG(pti).data=convData;
        EEG(pti).itpcdata=itpc;
        EEG(pti).convFreqs=frex;
        EEG(pti).convCycles=s;
        EEG(pti).convWindow=convWindow;
        EEG(pti).baselinePeriod=baselinePeriod;
        convData=MemoryconvData;    
        
end

fprintf('\nDone...\n');


%% end