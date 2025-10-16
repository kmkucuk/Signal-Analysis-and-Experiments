[kbPress,kbKey] = KbQueueCheck(); 
if kbPress == 1
    kbKey(kbKey==0) = NaN; % format press-matrix 
    [~, kbIndex]                    = min(kbKey); % get the earliest press
    if kbIndex == pause_key % wait for another key press for experiment to continue if 'p' is pressed
        % send ' experiment paused' marker
        sendParallelSignal(portAddress,3,ioObj)
        WaitSecs(.01);
        endParallelSignal(portAddress,ioObj)
        % wait for keyboard press to continue
        KbStrokeWait();        
        % send ' experiment continued' marker
        sendParallelSignal(portAddress,4,ioObj)
        WaitSecs(.01);
        endParallelSignal(portAddress,ioObj)        
    elseif kbIndex == escape_key % terminate experiment if 'ESCAPE' is pressed
        exitmarker = 0;
        
    end
    kbPress = 0;
    KbQueueFlush;
end