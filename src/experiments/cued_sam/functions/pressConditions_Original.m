                        if  initialResponseByte == currentResponseByte
                            if currentResponseByte == noPressByte && ~ previousPress
                                % released > released
                                registeredKeys = 0;
%                                 feedbackAvailable = 0;
                                Pressed = 0;
                            elseif Pressed
                                % press > press
%                                 feedbackAvailable = 0;
                                if enablePressDuration
                                    registeredKeys = 1;
                                else
                                    registeredKeys = 3;
                                end
                            end
                            
                        else
                            Pressed  = noPressByte ~= currentResponseByte;  % check if pressed a response button
                            if Pressed 
                                initialResponseByte = currentResponseByte; % switch to press>press condition, wait for release
                            end
                        end     