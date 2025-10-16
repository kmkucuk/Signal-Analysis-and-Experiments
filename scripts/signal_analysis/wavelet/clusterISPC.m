function ALLData=clusterISPC(ALLEEG,waveparams,chanlocs)

for k = [14:26, 41:52]       
       
    data=ALLEEG(k).data;
    
    data=permute(data,[1 3 2]);
    
    fprintf('\nNow processing subject: %s', [ALLEEG(k).subject ALLEEG(k).condition]);
    
    [volt_synch, lap_synch, frex, pairIndex]= initiateISPC(data,waveparams,[1 2 3 4 5 6 7 8],chanlocs);
    
    ALLData(k).subject=ALLEEG(k).subject;
    
    ALLData(k).group=ALLEEG(k).group;
    
    ALLData(k).condition=ALLEEG(k).condition;    
    
      
    
%     ALLData(k).itpc=volt_synch{1};
    
%     ALLData(k).itpc_lap=lap_synch{1};
    
    ALLData(k).avg_phase_diff=volt_synch{2};
%     
    ALLData(k).avg_phase_diff_pli=volt_synch{3};
    
    ALLData(k).std_phase_diff_pli=volt_synch{4};
% 
%     ALLData(k).avg_phase_diff_lap=lap_synch{2};
%     
%     ALLData(k).avg_phase_diff_pli_lap=lap_synch{3};    
    % comment below if there are no reaction times 
%     ALLData(k).reactionTimes=ALLEEG(k).reactionTimes; 
    
    ALLData(k).electrodePairs=pairIndex;
    
    ALLData(k).chaninfo=ALLEEG(k).chaninfo;
    
    ALLData(k).times=ALLEEG(k).times;
    
    ALLData(k).convFreqs=frex;
    
    ALLData(k).srate=ALLEEG(k).srate;
    
    ALLData(k).convCycles=waveparams.cycles;
    
end

