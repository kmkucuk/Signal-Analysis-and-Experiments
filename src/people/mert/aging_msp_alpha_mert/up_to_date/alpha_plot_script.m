
cd('F:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\Data_Analysis\Mert_AlphaArticle\Alpha_Birgit')
load('alpha_plot_data.mat')
gnames = cat(2,repmat({'Older'},1,12),repmat({'Younger'},1,12));
%% LINE PLOTS %%
%% ENDOGENOUS
figure(1)
t1=subplot(2,2,1);
tpos1 = t1.OuterPosition;
set(t1, 'OuterPosition', tpos1.*[1 1 1.15 1]);
%line plot
endoStruct=groupLinePlot(spss_endo_reversal,[1 2],[1 2 3 4 5 6 7 8],2,'within','CIs',2,[-2 2],15,gnames,{'Alpha Modulation (dB)'});
% significant annotations
sigAnnotations(endoStruct,{[1 2],[3,4],[5,6],[5,6],[7,8]},[1,1,1,2,2],{'***','**','*','**','****'},'CIs',[-2 2])
text([.4 .4],[2 2],'A','Color','k','FontSize',17,'FontWeight','bold','HorizontalAlignment','center')
title('Endo. Reversals')
%% EXOGENOUS
% figure(2)
t2=subplot(2,2,3);
tpos2 = t2.OuterPosition;
set(t2, 'OuterPosition', tpos2.*[1 1 1.15 1]);
% line plot
exoStruct=groupLinePlot(spss_exo_reversal,[1 2],[1 2 3 4 5 6 7 8],2,'within','CIs',2,[-2 2],15,gnames,{'Alpha Modulation (dB)'});
% significant annotations
sigAnnotations(exoStruct,{[5,6],[7,8],[7,8]},[2,2,1],{'*','*','*'},'CIs',[-2 2])
text([.4 .4],[2 2],'C','Color','k','FontSize',17,'FontWeight','bold','HorizontalAlignment','center')
title('Exo. Reversals')
%% STABLE
% figure(3)
% endo
% figure(4)
h1=subplot(2,2,2);
stabendostruct = groupLinePlot(spss_endo_nonReversal,[1 2],[1 2 3 4],4,'between','error',2,[0 4.5],15,gnames,{'Alpha Power \muV^2'});
pos1 = h1.OuterPosition;
set(h1, 'OuterPosition', pos1.*[1.4 1 .7 1]);
text([.4 .4],[4.5 4.5],'B','Color','k','FontSize',17,'FontWeight','bold','HorizontalAlignment','center')
title('Endo. Baseline')

% exo
h2=subplot(2,2,4);
stabexostruct = groupLinePlot(spss_exo_nonReversal,[1 2],[1 2 3 4],4,'between','error',2,[0 4.5],15,gnames,{'Alpha Power \muV^2'});
pos2 = h2.OuterPosition;
set(h2, 'OuterPosition', pos2.*[1.4 1 .7 1]);
text([.4 .4],[4.5 4.5],'D','Color','k','FontSize',17,'FontWeight','bold','HorizontalAlignment','center')
title('Exo. Baseline')

% %% TOPO PLOTS %%
% figure(2)
% mert_topoplot(convStats,[1 5],[-.95 -.65 -.35 -.05],11,'erspdata',[-1.5 1.5])
% figure(3)
% mert_topoplot(convStats,[3 7],[-.95 -.65 -.35 -.05]+.1,11,'erspdata',[-1.5 1.5])



