function [erspData, itpcData, nobasedata,frex,cycles]= initiateConvolution(data,waveparams)
%%% data = times X trials x channels
%%% waveparams = structure variable with fields containing wavelet parameters
%%%
%%%
countTrials=size(data,2);
countChannels=size(data,3);
countTimes=size(data,1);

freq_range=waveparams.freq_range;
freqsteps=waveparams.freqsteps;

if freq_range <= 2
    freqcount=((freq_range(2)-freq_range(1))/freqsteps)+1;
else
    freqcount=length(freq_range);
end

itpcData=nan(freqcount,size(data,1),size(data,3));
erspData=nan(freqcount,size(data,1),size(data,3));
size(erspData);

bIndx=findIndices(waveparams.times,waveparams.baselineperiod);
for chani = 1:countChannels
    fprintf('\nProcessing channel: %f', chani);    
    
    tmpdata=concatenateData(data(:,:,chani));
    
    [tmpdata,frex,cycles]=waveletconv_mert(tmpdata,waveparams.srate,waveparams.freq_range,waveparams.freqsteps,waveparams.cycles);

    tmpdata=deconcatenateData(tmpdata,[freqcount,countTimes,countTrials]);

    [tmpitpc, tmpavg]=computePowerAndPhase(tmpdata,3);
    % size(tmpavg)
    basedata=waveletBaseline(tmpavg,bIndx);

    itpcData(:,:,chani)=tmpitpc;

    erspData(:,:,chani)=basedata;

    nobasedata(:,:,chani)=tmpavg;
end


