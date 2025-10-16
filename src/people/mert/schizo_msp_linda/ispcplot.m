%% ISPC PLOTS
% phase difference - standard
chans = EEG(1).chaninfo;
freqs = [1 48];
%% short range f to f / f to c
subplot(4,2,1)
pair=13;
contourf(timevec,frex,avg_phase_diff(:,:,pair),40,'linecolor','none')
title(['Phase Synch at:' chans{pairIndex(pair,1)}(1:2) '-' chans{pairIndex(pair,2)}(1:2)])
set(gca,'clim',[0 .6],'xlim',[-1000 0],'ylim',freqs)

subplot(4,2,3)
pair=27;
contourf(timevec,frex,avg_phase_diff(:,:,pair),40,'linecolor','none')
title(['Phase Synch at:' chans{pairIndex(pair,1)}(1:2) '-' chans{pairIndex(pair,2)}(1:2)])
set(gca,'clim',[0 .6],'xlim',[-1000 0],'ylim',freqs)

% phase difference - phase lagged 
chans = EEG(1).chaninfo;
subplot(4,2,2)
pair=7;
contourf(timevec,frex,avg_phase_diff_pli(:,:,pair),40,'linecolor','none')
title(['Phase Synch at:' chans{pairIndex(pair,1)}(1:2) '-' chans{pairIndex(pair,2)}(1:2)])
set(gca,'clim',[0 .6],'xlim',[-1000 0],'ylim',freqs)

subplot(4,2,4)
pair=27;
contourf(timevec,frex,avg_phase_diff_pli(:,:,pair),40,'linecolor','none')
title(['Phase Synch at:' chans{pairIndex(pair,1)}(1:2) '-' chans{pairIndex(pair,2)}(1:2)])
set(gca,'clim',[0 .6],'xlim',[-1000 0],'ylim',freqs)

%% long range (f to p)
subplot(4,2,5)
pair=6;
contourf(timevec,frex,avg_phase_diff(:,:,pair),40,'linecolor','none')
title(['Phase Synch at:' chans{pairIndex(pair,1)}(1:2) '-' chans{pairIndex(pair,2)}(1:2)])
set(gca,'clim',[0 .6],'xlim',[-1000 0],'ylim',freqs)

subplot(4,2,7)
pair=7;
contourf(timevec,frex,avg_phase_diff(:,:,pair),40,'linecolor','none')
title(['Phase Synch at:' chans{pairIndex(pair,1)}(1:2) '-' chans{pairIndex(pair,2)}(1:2)])
set(gca,'clim',[0 .6],'xlim',[-1000 0],'ylim',freqs)

% phase difference - phase lagged 
chans = EEG(1).chaninfo;
subplot(4,2,6)
pair=6;
contourf(timevec,frex,avg_phase_diff_pli(:,:,pair),40,'linecolor','none')
title(['Phase Synch at:' chans{pairIndex(pair,1)}(1:2) '-' chans{pairIndex(pair,2)}(1:2)])
set(gca,'clim',[0 .6],'xlim',[-1000 0],'ylim',freqs)

subplot(4,2,8)
pair=17;
contourf(timevec,frex,avg_phase_diff_pli(:,:,pair),40,'linecolor','none')
title(['Phase Synch at:' chans{pairIndex(pair,1)}(1:2) '-' chans{pairIndex(pair,2)}(1:2)])
set(gca,'clim',[0 .6],'xlim',[-1000 0],'ylim',freqs)



colormap('jet')