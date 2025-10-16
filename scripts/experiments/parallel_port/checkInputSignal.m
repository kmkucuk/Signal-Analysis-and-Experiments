allbytes=[];
while 1 
    for k = 1:8
        byte = io64(ioObj,portAddress(k));
        allbytes = [allbytes byte];
    end
    allbytes
    WaitSecs(1);
    allbytes=[];
end