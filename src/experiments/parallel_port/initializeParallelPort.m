
% Installs parallel port driver for Windows. 
% Remember to use 'clear all' after you are done with it.
% Otherwise port driver will remain installed.

function initializeParallelPort

ioObj=io64;
IEU_EEG_portaddress=[];
status=io64(ioObj);
for k = 0:7
    adressName = ['C40' num2str(k)];
    IEU_EEG_portaddress(k+1)=hex2dec(adressName); % We have socketed an external PCI Parallel Port to the paradigm computer within the EEG laboratory. 
                                                 % 'C400' is the adress of this port. You can check your own port's adress from:
                                                 % Device Manager->Ports->LPT2(if external)->Properties->Resources: First of I/O Range values. 
    if status ~= 0  
        error('Input/Output installation failed');
    else
        assignin('base','ioObj',ioObj);                 % Registers I/O related variables to the workspace. 
        assignin('base','portStatus',status);
        assignin('base','portAddress',IEU_EEG_portaddress);
    end

    
end