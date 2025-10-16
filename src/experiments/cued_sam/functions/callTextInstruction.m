function callTextInstruction(window,textVariable,xCenter, yCenter)
       DrawFormattedText2(['<color=0.,0.,0.>' textVariable],'win',window, 'sx',xCenter/10,'sy', yCenter*.2,'xalign','left','yalign','top','xlayout','left','baseColor',[0 0 0],'vSpacing',1.25,'wrapat',120);
       Screen('Flip',window);       
            while 1
                KbPressWait();
                 [~, ~, keyCode]=KbCheck;
                        if keyCode(KbName('Return'))
                            Screen('Flip',window);
                            break;
                        end
            end