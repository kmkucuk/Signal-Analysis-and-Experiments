chans = EEG(1).chaninfo;
freqs = [4 8];
%% short range f to f / f to c
subplot(2,1,1)
pair=1;
contourf(timevec,frex,voltage_synch{2}(:,:,pair),40,'linecolor','none')
title(['Phase Synch at:' chans{pairIndex(pair,1)}(1:2) '-' chans{pairIndex(pair,2)}(1:2)])
set(gca,'clim',[0 .6],'xlim',[-500 1000],'ylim',freqs)

subplot(2,1,2)
pair=1;
contourf(timevec,frex,lap_synch{2}(:,:,pair),40,'linecolor','none')
title(['Phase Synch at:' chans{pairIndex(pair,1)}(1:2) '-' chans{pairIndex(pair,2)}(1:2)])
set(gca,'clim',[0 .6],'xlim',[-500 1000],'ylim',freqs)

colormap('jet')