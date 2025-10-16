
                            if ~initialPressed % if no buttons are pressed before the loop

                                if checkRelease && ~ Pressed % check if a release happened after first press registery                          
                                    % released > released 
                                    registeredKeys = 0;
                                    checkRelease = 0; % reset the released condition for new press registeries

                                elseif ~checkRelease && Pressed % new press (no pre-loop press version)
                                    % no press > press
                                    registeredKeys = 0;   

                                elseif ~checkRelease && ~Pressed % no released or pressed buttons (idle responses: do nothing)

                                end                            

                            elseif initialPressed % if there is a press before the loop
                                if ~checkRelease && Pressed % and same press in the above condition continues without a release in between
                                    registeredKeys = 1;  
                                elseif ~checkRelease && ~Pressed % press before the loop did not continue within the loop and no release registery exists
                                                                 % release could have happened in the very few tenth of milliseconds in between (very very low
                                                                 % probability) 

                                elseif checkRelease && Pressed % a new press was made before the loop (pre-loop version)
                                    checkRelease = 0; % reset the released condition for new press registeries
                                    registeredKeys = 0; 

                                elseif checkRelease && ~Pressed % a press happened after the release and did not continue within the loop 

                                end
                            end        