function [phase_data, phase_diff, phase_diff_pli, pairIndex]=compute_ISPC(data,synchChannels)
% data format = data(frex,times,channels)

phase_data = nan(size(data));
% size(phase_data)
times      = size(data,2);
freqCounts = size(data,1);

for chani = 1:length(synchChannels)
    
    for freqi = 1:freqCounts
        phase_data(freqi,:,chani) = angle(data(freqi,:,chani));        
    end

end
%% Actual pair indexes for checking the channels on the actual dataset
chanVecIndex = synchChannels;
pairIndex    = nchoosek(chanVecIndex,2);
%% Pair indexes for computing. Because actual indices can be [34 120], this makes convolution problematic and scripts fill in those missing channels.
% therefore, we use dummy channels indices within these functions instead of actual channels indices. 
pairIndexForComputing = 1:length(synchChannels);
pairIndexForComputing = nchoosek(pairIndexForComputing,2);

pairCount    = size(pairIndex,1);

phase_diff = nan(freqCounts,times,pairCount);
phase_diff_pli = nan(freqCounts,times,pairCount);

for diffIndx = 1:pairCount
    
%        phase_diff(:,:,diffIndx)     = exp(1i* (phase_data(:,:,pairIndexForComputing(diffIndx,1)) - phase_data(:,:,pairIndexForComputing(diffIndx,2)))); % diff once (1) and on third dimension

       phase_diff_pli(:,:,diffIndx) = sign(imag(exp(1i * (phase_data(:,:,pairIndexForComputing(diffIndx,1)) - phase_data(:,:,pairIndexForComputing(diffIndx,2))))));
    
end
    