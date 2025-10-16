
function endParallelSignal(portAddress,ioObj)
io64(ioObj,portAddress,0);% '0' closes the previously sent byte. This is necessary to send subsequent signals from the same byte value. 
                          % Otherwise subsequent same values do not register after one signal. 
end

