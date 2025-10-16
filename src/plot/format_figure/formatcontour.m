function formatcontour(frex,xlims,noyticks)

yticks=ceil(linspace(frex(1),frex(end),noyticks));
yticks=[1 2 4 8 11 14 28 36 48];
set(gca,'yscale','log','xlim', xlims,...
                    'YTick',yticks,'TickDir','out','XColor', [0 0 0], 'YColor', [0 0 0], 'linewidth', 3.5);
xlabel('Time (secs)'), ylabel('Frequencies (Hz)')

set(gca,'FontName','Times New Roman','FontSize',25);

cb=colorbar;
colormap('jet')
cbtitle=get(cb,'Title');
set(cbtitle,'String',"Coherence")
set(cbtitle,'fontweight','bold','fontsize',25);
end