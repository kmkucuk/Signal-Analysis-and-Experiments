function newData=deconcatenateData_ISPC(data,reshapevector)
%%% INITIALLY your data should be FREX x TIMES X CHANPAIRS. CHANPAIRS mean channel pairs for ISPC not channels themselves.
%%%
%%% reshapevector = [freqcount,countTimes,countTrials]
%%%
%%% THIS function will convert it back to CHANS x FREQS x TIMES x TRIALS
%%% enter your new dimensions into reshapevector:
%%% reshapevector = [2 3] this will convert your data into a 2x3 matrix
%%%

chanCount = size(data,3);

newData = nan(reshapevector(1),reshapevector(2),reshapevector(3),chanCount);

for chani = 1:chanCount
    newData(:,:,:,chani)=reshape(data(:,:,chani),reshapevector(1),reshapevector(2),reshapevector(3));
end