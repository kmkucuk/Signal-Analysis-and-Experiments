figure(1)
subplot(2,1,1)
plot(convStats(1).times,convStats(1).erspAvgROI(13,:,1),'linewidth',2.5)
hold on
plot(convStats(1).times,convStats(1).erspAvgROI(13,:,2),'linewidth',2.5)
plot(convStats(1).times,convStats(1).erspAvgROI(13,:,3),'linewidth',2.5)
plot(convStats(1).times,convStats(1).erspAvgROI(13,:,4),'linewidth',2.5)
formataxes([-3 3],[-1.5 .5],'normal',5,5,2);
legend({'Frontal','Central','Parietal','Occipital'},'Location','northeastoutside')
subplot(2,1,2)
plot(convStats(1).times,convStats(5).erspAvgROI(13,:,1),'linewidth',2.5)
hold on
plot(convStats(1).times,convStats(5).erspAvgROI(13,:,2),'linewidth',2.5)
plot(convStats(1).times,convStats(5).erspAvgROI(13,:,3),'linewidth',2.5)
plot(convStats(1).times,convStats(5).erspAvgROI(13,:,4),'linewidth',2.5)
formataxes([-3 3],[-1.5 .5],'normal',5,5,2);
legend({'Frontal','Central','Parietal','Occipital'},'Location','northeastoutside')

figure(2)
subplot(2,1,1)
plot(convStats(1).times,convStats(3).erspAvgROI(13,:,1),'linewidth',2.5)
hold on
plot(convStats(1).times,convStats(3).erspAvgROI(13,:,2),'linewidth',2.5)
plot(convStats(1).times,convStats(3).erspAvgROI(13,:,3),'linewidth',2.5)
plot(convStats(1).times,convStats(3).erspAvgROI(13,:,4),'linewidth',2.5)
formataxes([-3 3],[-1.5 .5],'normal',5,5,2);
legend({'Frontal','Central','Parietal','Occipital'},'Location','northeastoutside')
subplot(2,1,2)
plot(convStats(1).times,convStats(7).erspAvgROI(13,:,1),'linewidth',2.5)
hold on
plot(convStats(1).times,convStats(7).erspAvgROI(13,:,2),'linewidth',2.5)
plot(convStats(1).times,convStats(7).erspAvgROI(13,:,3),'linewidth',2.5)
plot(convStats(1).times,convStats(7).erspAvgROI(13,:,4),'linewidth',2.5)
formataxes([-3 3],[-1.5 .5],'normal',5,5,2);
legend({'Frontal','Central','Parietal','Occipital'},'Location','northeastoutside')