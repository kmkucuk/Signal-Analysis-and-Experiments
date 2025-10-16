%% MERT
% plot the two
subplot(221)
contourf(EEG.times,frex,voltage_synch{2},40,'linecolor','none')
set(gca,'xlim',[-300 1200],'clim',[0 .4])
colormap hot; colorbar
title('ISPC, Voltage, Mert')

subplot(222)
contourf(EEG.times,frex,voltage_synch{3},40,'linecolor','none')
set(gca,'xlim',[-300 1200],'clim',[0 .4])
colormap hot; colorbar
title('PLI, Voltage, Mert')




% pick two channels
chan1 = 'FCz';
chan2 = 'POz';


% frequency parameters
min_freq =  2;
max_freq = 40;
num_frex = 50;

% set range for variable number of wavelet cycles
fwhm = linspace(.3,.1,num_frex);

% other wavelet parameters
frex  = logspace(log10(min_freq),log10(max_freq),num_frex);
time  = -2:1/EEG.srate:2;
half_wave = (length(time)-1)/2;

% FFT parameters
nWave = length(time);
nData = EEG.pnts*EEG.trials;
nConv = nWave+nData-1;


% FFT of data (doesn't change on frequency iteration)
data1X = fft( reshape(EEG.data(1,:,:),1,nData) ,nConv);
data2X = fft( reshape(EEG.data(20,:,:),1,nData) ,nConv);

% initialize output time-frequency data
ispc = zeros(num_frex,EEG.pnts);
pli  = zeros(num_frex,EEG.pnts);

% loop over frequencies
for fi=1:num_frex
    
    % create wavelet and get its FFT
    wavelet  = exp(2*1i*pi*frex(fi).*time) .* exp( -4*log(2)*time.^2 / fwhm(fi)^2 );
    waveletX = fft(wavelet,nConv);
    waveletX = waveletX./max(waveletX); % is this line necessary?
    
    
    % convolution for chan1
    as1 = ifft(waveletX.*data1X,nConv);
    as1 = as1(half_wave+1:end-half_wave);
    as1 = reshape(as1,EEG.pnts,EEG.trials);
    
    
    % convolution for chan2
    as2 = ifft(waveletX.*data2X,nConv);
    as2 = as2(half_wave+1:end-half_wave);
    as2 = reshape(as2,EEG.pnts,EEG.trials);
    
    
    % collect "eulerized" phase angle differences
    cdd = exp(1i*( angle(as1)-angle(as2) ));
    
    % compute ISPC and PLI (and average over trials!)
    ispc(fi,:) = abs(mean(cdd,2));
    pli(fi,:)  = abs(mean(sign(imag(cdd)),2));
end


% plot the two
subplot(223)
contourf(EEG.times,frex,ispc,40,'linecolor','none')
set(gca,'xlim',[-300 1200],'clim',[0 .4])
colormap hot; colorbar
xlabel('Time (ms)'), ylabel('Frequency (Hz)')
title('ISPC, voltage')

subplot(224)
contourf(EEG.times,frex,pli,40,'linecolor','none')
set(gca,'xlim',[-300 1200],'clim',[0 .4])
colormap hot; colorbar
title('PLI, voltage')







%% LAPLACIAN
figure(4)
%% MERT
% plot the two
subplot(221)
contourf(EEG.times,frex,lap_synch{2},40,'linecolor','none')
set(gca,'xlim',[-300 1200],'clim',[0 .4])
colormap hot; colorbar
title('ISPC, Laplacian, Mert')

subplot(222)
contourf(EEG.times,frex,lap_synch{3},40,'linecolor','none')
set(gca,'xlim',[-300 1200],'clim',[0 .4])
colormap hot; colorbar
title('PLI, Laplacian, Mert')


% COHEN

time  = -2:1/EEG.srate:2;
EEG.lap = laplacian_perrinX(EEG.data,[EEG.chanlocs.X],[EEG.chanlocs.Y],[EEG.chanlocs.Z]);

% FFT of data (doesn't change on frequency iteration)

data1X = fft( reshape(EEG.lap(1,:,:),1,nData) ,nConv);
data2X = fft( reshape(EEG.lap(20,:,:),1,nData) ,nConv);

% initialize output time-frequency data
ispc = zeros(num_frex,EEG.pnts);
pli  = zeros(num_frex,EEG.pnts);

% loop over frequencies
for fi=1:num_frex
    
    % create wavelet and get its FFT
    wavelet  = exp(2*1i*pi*frex(fi).*time) .* exp( -4*log(2)*time.^2 / fwhm(fi)^2 );
    waveletX = fft(wavelet,nConv);
    
    
    % convolution for chan1
    as1 = ifft(waveletX.*data1X,nConv);
    as1 = as1(half_wave+1:end-half_wave);
    as1 = reshape(as1,EEG.pnts,EEG.trials);
    
    
    % convolution for chan2
    as2 = ifft(waveletX.*data2X,nConv);
    as2 = as2(half_wave+1:end-half_wave);
    as2 = reshape(as2,EEG.pnts,EEG.trials);
    
    
    % collect "eulerized" phase angle differences
    cdd = exp(1i*( angle(as1)-angle(as2) ));
    
    % compute ISPC and PLI (and average over trials!)
    ispc(fi,:) = abs(mean(cdd,2));
    pli(fi,:)  = abs(mean(sign(imag(cdd)),2));
end


% plot the two
subplot(223)
contourf(EEG.times,frex,ispc,40,'linecolor','none')
set(gca,'xlim',[-300 1200],'clim',[0 .4])
colormap hot; colorbar
title('ISPC, Laplacian')

subplot(224)
contourf(EEG.times,frex,pli,40,'linecolor','none')
set(gca,'xlim',[-300 1200],'clim',[0 .4])
colormap hot; colorbar
title('PLI, Laplacian')
