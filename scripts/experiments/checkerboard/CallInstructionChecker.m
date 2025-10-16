function CallInstructionChecker(window,imagefile)
        Screen('DrawTexture',window,imagefile);
        Screen('Flip',window);       
        startIns=tic;
        while 1
            if toc(startIns)>90
                Screen('Flip',window);
                break;                
            end
        end
end