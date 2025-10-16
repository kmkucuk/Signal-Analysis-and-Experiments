gatherPeakTime = [];
for k = [31:45, 91:105]-30
gatherPeakTime = [gatherPeakTime wholeData(k).peakParameters(3)];
end
hist(gatherPeakTime(1:15))
figure(2)
hist(gatherPeakTime(16:end))
 
 
gatherPeakWidth=[];
for k = [1:15, 61:75]
gatherPeakWidth = [gatherPeakWidth wholeData(k).peakParameters(4)];
end

hist(gatherPeakWidth(1:15))
figure(2)
hist(gatherPeakWidth(16:end))



gatherTopo = {};
for k = [1:15, 61:75]
gatherTopo = {gatherTopo; PeakData_low(k).subject};
end