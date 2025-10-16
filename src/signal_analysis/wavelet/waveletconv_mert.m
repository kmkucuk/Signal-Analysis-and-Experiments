function [tf,frex,cycles]=waveletconv_mert(data,srate,freq_range,freqsteps,cycles) % convolution and baseline time windows
%%% use data structure: times x Trials
%%%
%%% data that is fed here should already be only one channel
%%%
%%% a parent function should exist such that the data is organized into
%%% channels and participants etc. 
%%%
%%% This is just to conduct convolution all else should take place
%%% somewhere else. 


% downsampling
% 
% savedTimes=-1.5:.010:1.5;
% 
% savedTimesIndx=dsearchn(times',savedTimes');
% 
% savedTimesIndx=savedTimesIndx';

% frequency parameters


%% frequencies
if length(freq_range)<=2
    freqcount=((freq_range(2)-freq_range(1))/freqsteps)+1;
    frex = linspace(freq_range(1),freq_range(2),freqcount);
else
    freqcount = length(freq_range);
    frex = freq_range;
end


%% cycles
%%% below are the cycles for specific frequency intervals
if length(cycles)<=2
    cycles = logspace(log10(cycles(1)),log10(cycles(end)),freqcount);
    s =  cycles./ (2*pi*frex);
else
    s = cycles./ (2*pi*frex);
end
%% wavelet parameters
wavtime = -1:1/srate:1;

half_wave = (length(wavtime)-1)/2;
% time points within a data
convPnts=length(data);

%% FFT parameters

nWave = length(wavtime);
nData = convPnts; %nData= convPnts*trials // if the data is with trials


nConv=nWave+nData-1;

dataX = fft(data ,nConv);
tf=nan(length(frex),convPnts);
%% Convolution
    for fi=1:length(frex)

        wavelet  = exp(2*1i*pi*frex(fi).*wavtime) .* exp(-wavtime.^2./(2*(s(fi)^2)));

        waveletX = fft(wavelet,nConv);

        waveletX = waveletX ./ max(waveletX);

        as = ifft(waveletX .* dataX);

        as = as(half_wave+1:end-half_wave);
        
        tf(fi,:)=as;
    end
    
end

