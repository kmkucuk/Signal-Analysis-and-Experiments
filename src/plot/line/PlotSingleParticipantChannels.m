function PlotSingleParticipantChannels(EEG,channel,pCount)

secs=EEG(pCount).times;


cd('G:\Matlab Directory\2020_MSPAging_EEG_Mert\Figures_Mert');

for i = pCount:pCount 
    
%     f=figure('visible','off'); clf;
     f=figure; clf;
    for kk = 1:length(channel) 
        
        channame=EEG(1).chaninfo{channel(kk)};   
    
        subplot(ceil(length(channel)/ceil(sqrt(length(channel)))),ceil(sqrt(length(channel))),kk)        

        plot(secs,EEG(i).avgdata(:,channel(kk)),'k','linew',1.1);
                set(gca,'xlim',[-2 1],'ylim', [-10 10], 'ydir','reverse');


        title([EEG(i).subject(1:5), ' ', EEG(i).condition(1:3),' ',...
      'chan: ',channame]);

        hold on

        plot(get(gca,'xlim'),[0 0],'k')

        plot([0 0],get(gca,'ylim'),'k:')

        xlabel('times (ms)'), ylabel('Amplitude') 
        
                  
    end
% saveas(f,[EEG(i).subject,'-',  EEG(i).condition,'.jpg']);
    
end
