function [voltage_synch, lap_synch, frex, pairIndex]= initiateISPC(data,waveparams,synchChannels,eeglocs)
%%% data = times X trials x channels
%%% waveparams = structure variable with fields containing wavelet parameters
%%% synchChannels = Index of channels you want to compute inter-site phase
%%% clustering. e.g. [1 2 3 4 9 10]= F3 F4 C3 C4 O1 O2
%%% ISPC of all pairs will be calculated. 
%%% eeglocs = eeg locations file. 
countTrials=size(data,2);
countTimes=size(data,1);

if length(waveparams.freq_range) <= 2
    freq_range=waveparams.freq_range;
    freqsteps=waveparams.freqsteps;
    freqcount=((freq_range(2)-freq_range(1))/freqsteps)+1;
else
    freqcount = length(waveparams.freq_range);
end

tmpdata = nan(countTimes*countTrials,length(synchChannels));
% tmpdata_lap = nan(countTimes*countTrials,length(synchChannels));
chanit=0;
%% CONCATANATE SIGNAL ACROSS TRIALS FOR EACH CHANNEL
% ALSO COMPUTES LAPLACIAN
    %% laplacian transform
%     lapData = laplacian_perrinX(permute(data,[3 1 2])  ,[eeglocs.X],[eeglocs.Y],[eeglocs.Z]);
%     lapData = permute(lapData,[2 3 1]);
%     
for chani = synchChannels
    chanit=chanit+1;
    fprintf('\nProcessing channel: %f', chani);    

% %    size(lapData(:,:,chani))
%     %% reshape data into: times (trials*times) X channels
%     tmpdata_lap(:,chanit)   = reshape(lapData(:,:,chani),1,countTimes*countTrials);
    tmpdata(:,chanit)       = reshape(data(:,:,chani),1,countTimes*countTrials);
end

%% laplacian wavelet and phase
% fprintf('\nLaplacian wavelet convolution started');   
% [tmpdata_lap,~] = waveletconv_ISPC(tmpdata_lap,waveparams.srate,waveparams.freq_range,waveparams.freqsteps,waveparams.cycles);
% fprintf('\nFinished...');
% 
% % size(tmpdata_lap)
% 
% [phase_data_lap, phase_diff_lap, phase_diff_pli_lap] = compute_ISPC(tmpdata_lap,synchChannels);
% 
% phase_data_lap      = deconcatenateData_ISPC(phase_data_lap,[freqcount,countTimes,countTrials]);
% 
% phase_diff_lap      = deconcatenateData_ISPC(phase_diff_lap,[freqcount,countTimes,countTrials]);
% 
% phase_diff_pli_lap  = deconcatenateData_ISPC(phase_diff_pli_lap,[freqcount,countTimes,countTrials]);
% 
% avg_phase_lap           = permute(abs(mean(exp(1i*phase_data_lap),3)),[1 2 4 3]);
% 
% avg_phase_diff_lap      = permute(abs(mean(phase_diff_lap,3)),[1 2 4 3]);
% 
% avg_phase_diff_pli_lap  = permute(abs(mean(phase_diff_pli_lap,3)),[1 2 4 3]);
% 
% lap_synch = {avg_phase_lap, avg_phase_diff_lap, avg_phase_diff_pli_lap};
lap_synch = {[0], 0, 0};
%% voltage wavelet and phase
fprintf('\nVoltage wavelet convolution started');  
[tmpdata,frex]                                              = waveletconv_ISPC(tmpdata,waveparams.srate,waveparams.freq_range,waveparams.freqsteps,waveparams.cycles);
fprintf('\nFinished...');

 

[phase_data, phase_diff, phase_diff_pli, pairIndex]         = compute_ISPC(tmpdata,synchChannels);


phase_data      = deconcatenateData_ISPC(phase_data,[freqcount,countTimes,countTrials]);

phase_diff      = deconcatenateData_ISPC(phase_diff,[freqcount,countTimes,countTrials]);

phase_diff_pli  = deconcatenateData_ISPC(phase_diff_pli,[freqcount,countTimes,countTrials]);
assignin('base','phase_diff_pli','pdata');
avg_phase           = permute(abs(mean(exp(1i*(phase_data)),3)),[1 2 4 3]);

avg_phase_diff      = permute(abs(mean(phase_diff,3)),[1 2 4 3]);


avg_phase_diff_pli  = permute(abs(mean(phase_diff_pli,3)),[1 2 4 3]);


% baseline 

baseIndx = findIndices(waveparams.times,waveparams.baselineperiod);
baseIndx = baseIndx(1):baseIndx(2);

pli_std = abs(mean(phase_diff_pli(:,baseIndx,:,:),2));
% pli_std = permute(std(pli_std,[],3),[1 2 4 3]);


% std_phase_diff_pli  = permute(std(phase_diff_pli,[],3),[1 2 4 3]);


voltage_synch = {avg_phase, avg_phase_diff, avg_phase_diff_pli,pli_std};

fprintf('\nDone...');
end


