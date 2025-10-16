
% 1- Enter your port adress to first input 'portadress' ('C400' for Izmir University of Economics EEG laboratory). 

% 2- Enter byte value to second input 'byteValue'. 

% 3- Enter the input/output object that you created with "io64", an example would be:
%   ioObj=io64;
% This step has to be done within the source code because individual
% functions do not register variables unless you use scripts like 'assigin'
% which registers the variables you specify. (type: 'help assignin' for more info)

%Following is the list of stimulus markers in the Brainvision Recorder that
%corresponds to individual bytes within Matlab code. However, whatever byte
%value you enter into this function it will show S'#bytevalue' within the
%brainvision recorder (e.g. S'1' if you enter '1' as the byte value. 
%For instance 
% • sendParallelSignal(portAdress,2,ioObj) --> S2
% • sendParallelSignal(portAdress,14,ioObj)--> S14 etc.

% MATLAB BYTE VALUE        BRAINVISION RECORDER DIGITAL PORT VALUE
%       1                                   0
%       2                                   1
%       3                                   1 & 0  
%       4                                   2
%       5                                   2 & 0
%       6                                   2 & 1
%       7                                   2 & 1 & 0
%       8                                   3
%       9                                   3 & 0 
%       10                                  3 & 1
%       11                                  3 & 1 & 0 
%       12                                  3 & 2 
%       13                                  3 & 2 & 0 
%       14                                  3 & 2 & 1 
%       15                                  3 & 2 & 1 & 0
%       16                                  4  
%       17                                  4 & 0 
%       18                                  4 & 1 
%       19                                  4 & 1 & 0 
%       20                                  4 & 2 
%       21                                  4 & 2 & 0 
%.....................................................................
% This sequence goes on until the byte value is 128 which corresponds to 
% 7th bit in brainvision recorder.



function sendParallelSignal(portAddress,Bytevalue,ioObj)

io64(ioObj,portAddress,Bytevalue); % Sends signal/data to the system (EEG, Brainvision recorder in our case)

end