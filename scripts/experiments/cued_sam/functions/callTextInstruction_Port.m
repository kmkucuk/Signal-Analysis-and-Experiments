function callTextInstruction_Port(window,textVariable,xCenter, yCenter,portVariables)
ioObj       = portVariables{1};
portAddress = portVariables{2};
noPressByte = portVariables{3};

DrawFormattedText2(['<color=0.,0.,0.>' textVariable],'win',window, 'sx',xCenter/10,'sy', yCenter*.2,'xalign','left','yalign','top','xlayout','left','baseColor',[0 0 0],'vSpacing',1.25,'wrapat',120);
Screen('Flip',window);       
breakInstruction=0;
while 1
    if breakInstruction
        break
    end
    currentResponseByte = io64(ioObj,portAddress(2));   % second port address is response input
    Pressed  = noPressByte ~= currentResponseByte;
        if Pressed
            pressTime             = GetSecs();
            while 1 
                releaseCheckByte = io64(ioObj,portAddress(2));   % second port address is response input
                checkIfReleased = releaseCheckByte == noPressByte; % check if there is still a press to the same button 
                completePressDuration = GetSecs()-pressTime>3;
                if completePressDuration  % if 3 seconds has passed
%                     if checkIfReleased  % and still pressing the same button 
                        breakInstruction=1; % break instruction and continue 
                        Screen('Flip',window);
                        break
%                     end
                elseif checkIfReleased % if released earlier than 3 seconds, repeat 
                    Pressed=0;
                    disp('early release')
                    break
                end
            end
        end
end
