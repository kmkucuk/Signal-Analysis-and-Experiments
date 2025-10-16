function waveData=FreqDomainWavelet(frex,cycle,srate,graph)
% frex = 8; % center freq

time = -2:1/srate:2;
wavtime = -2:1/srate:2;
nData=length(time);
nWave=length(wavtime);
nConv=nData+nWave-1; % wave length + data length -1 

% cycle = 7; 

s = cycle ./ (2*pi*frex); %adjusted cycles

%Gaussiand
gaussian=exp( (-wavtime.^2) ./ (2*s^2) );

%Complex Morlet wavelet
cmw = exp(1i*2*pi*frex.*wavtime) .* gaussian;

%FFT of wavelet
fcmw=fft(cmw)/length(cmw);

hz = linspace(0,srate/2,floor(length(cmw)/2)+1); % freqs (x axis)

% fcmw=fcmw(nData/2+1:end-nData/2);
% folding time
cf = cycle/(2*pi);
predtimes = sqrt(2)*cf./frex;
disp(['Folding time: ' num2str(predtimes)])
% length(fcmw)
% length(hz)
waveData.wavelet = cmw;
waveData.srate = srate;
waveData.freqs = hz;
waveData.times = wavtime;
waveData.cycle = cycle;
waveData.foldTime = predtimes;
if graph ==1
    figure(1)
    subplot(3,1,1)
    plot(hz,2*abs(fcmw(1:length(hz))) ,'k','linew',2);
    
    if cycle == 7 && frex == 11        
        hold on 
        plot([11 11],get(gca,'ylim') ,'k:','linew',3);
        plot([7.87 7.87],get(gca,'ylim') ,'r:','linew',2);
        plot([14.12 14.12],get(gca,'ylim') ,'r:','linew',2);
        set(gca,'xtick',[0 6, 7.87, 10,11, 12, 14.12 16]);
    end
    hold off 
    set(gca,'xlim',[5 17]);
    ylabel('Power')
    xlabel('Frequencies (Hz)')
    title([num2str(frex) 'Hz wavelet in frequency domain ' num2str(cycle) ' cycles' ])

    subplot(3,1,2)

    plot(wavtime,gaussian ,'k','linew',2);
    xlabel('Time')
    title([ 'Gaussian with ' num2str(cycle) ' cycles' ])

    subplot(3,1,3)

    plot(wavtime,cmw ,'k','linew',2);
%     text([.6 .6],[.7 .7],['Folding time: ' num2str(round(predtimes,3))],'Color','k','FontSize',12,'HorizontalAlignment','center')
    title([ 'Complex Morlet Wavelet ',num2str(frex), ' Hz ' num2str(cycle) ' cycle' ])
    xlabel('Time')
    ylabel('Unit Energy')
end