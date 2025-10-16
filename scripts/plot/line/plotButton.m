function plotButton(secs,data,stimdata,window,reactionTime,channame)

        plot(secs,data,'k','linew',2);
        hold on
%         plot(secs,stimdata(:,:),'r','linew',2);
        plot(secs,stimdata(:,:),'b','linew',2);
        set(gca,'xlim',window,'ylim', [-35 35], 'ydir','reverse');
        
        hold on
        
        plot(get(gca,'xlim'),[0 0],'k')

        plot([reactionTime reactionTime],get(gca,'ylim'),'k:')
        
        xlabel('times')
        
        ylabel(channame);
end