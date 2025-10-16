function [tf,frex]=waveletconv_ISPC(data,srate,freq_range,freqsteps,cycles) % convolution and baseline time windows
%%% use data structure: times x chans
%%%
%%% data that is fed here should already be only one channel
%%%
%%% a parent function should exist such that the data is organized into
%%% channels and participants etc. 
%%%
%%% This is just to conduct convolution all else should take place
%%% somewhere else. 

% frequency parameters
if length(freq_range) <= 2 
    freqcount=((freq_range(2)-freq_range(1))/freqsteps)+1;
    frex = linspace(freq_range(1),freq_range(2),freqcount);
else
    frex = freq_range;
    freqcount = length(freq_range);
end


%cycle parameters
% below are the cycles for specific frequency intervals
if length(cycles) <=2
    s = logspace(log10(cycles(1)),log10(cycles(end)),freqcount) ./ (2*pi*frex);
else
    s = cycles ./ (2*pi*frex);
end
%% cohen check
% fwhm = linspace(.3,.1,50);

%%

%wavelet parameters
wavtime = -1: 1/srate :1;

half_wave = (length(wavtime)-1)/2;

%%% time points within a data
nData       = size(data,1);%nData= convPnts*trials // if the data is with trials
chanCount   = size(data,2);
nWave       = length(wavtime);
nConv       = nWave+nData-1;

% FFT parameters
dataX = nan(nConv,chanCount);

for chani = 1:chanCount
    dataX(:,chani) = fft(data(:,chani),nConv);
end

dataX = permute(dataX, [2 1]);
tf=nan(length(frex),nData,chanCount);

for chani = 1:chanCount
    
    for fi=1:length(frex)

        wavelet  = exp(2*1i*pi*frex(fi).*wavtime) .* exp(-wavtime.^2./(2*(s(fi)^2)));
%% cohen check
%         wavelet  = exp(2*1i*pi*frex(fi).*wavtime) .* exp( -4*log(2)*wavtime.^2 / fwhm(fi)^2 );   
%%        
        waveletX = fft(wavelet,nConv);
        
        waveletX = waveletX ./ max(waveletX);              
        
        as = ifft(waveletX .* dataX(chani,:),nConv);
    
        as = as(half_wave+1:end-half_wave);
        
        tf(fi,:,chani)=as;
        
    end
    
    


end
    
end

