endostabC_o=[];
for i = [1 2 4 7 8 10 11 12 13 14 15]+15
tcount=size(ALLEEG(i).data,3);
endostabC_o=[endostabC_o tcount];
end
exostabC_o=[];
for i = [1 2 4 7 8 10 11 12 13 14 15]+45
tcount=size(ALLEEG(i).data,3);
exostabC_o=[exostabC_o tcount];
end
endostabC_y=[];
for i = [1 2 3 4 6 7 9 11 13 14 15]+75
tcount=size(ALLEEG(i).data,3);
endostabC_y=[endostabC_y tcount];
end
exostabC_y=[];
for i = [1 2 3 4 6 7 9 11 13 14 15]+105
tcount=size(ALLEEG(i).data,3);
exostabC_y=[exostabC_y tcount];
end


totalcEndo_Old=[];
for i = [1 2 4 7 8 10 11 12 13 14 15]
tcount=size(ALLEEG(i).data,3);
totalcEndo_Old=[totalcEndo_Old tcount];
end
totalcExo_Old=[];
for i = [1 2 4 7 8 10 11 12 13 14 15]+30
tcount=size(ALLEEG(i).data,3);
totalcExo_Old=[totalcExo_Old tcount];
end

totalcEndo_y=[];
for i = [1 2 3 4 6 7 9 11 13 14 15]+60
tcount=size(ALLEEG(i).data,3);
totalcEndo_y=[totalcEndo_y tcount];
end

totalcExo_y=[];
for i = [1 2 3 4 6 7 9 11 13 14 15]+90
tcount=size(ALLEEG(i).data,3);
totalcExo_y=[totalcExo_y tcount];
end
trialstats=[mean(totalcEndo_Old) mean(totalcExo_Old) mean(totalcEndo_y) mean(totalcExo_y); std(totalcEndo_Old) std(totalcExo_Old) std(totalcEndo_y) std(totalcExo_y)];
trialstats

stabtrialstats=[mean(endostabC_o) mean(exostabC_o) mean(endostabC_y) mean(exostabC_y); std(endostabC_o) std(exostabC_o) std(endostabC_y) std(exostabC_y)];
stabtrialstats