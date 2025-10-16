medianlist=[];
for i=1:64
    medianlist=[medianlist,median(DominanceValues{i})];

end
    medianlist=medianlist.';
    medianlist=sort(medianlist);