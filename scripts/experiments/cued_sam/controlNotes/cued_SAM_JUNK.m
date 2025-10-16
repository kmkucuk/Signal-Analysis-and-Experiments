%                                     if responseIteration>2
%                                         previousPressTime = no_onset_ResponseTable{responseIteration-backwardSearch,8}; % get the time of previous press 
%                                         while isempty(previousPressTime) % loop continues until it finds an eligible previous press 
%                                                                                        
%                                             stopSearch=responseIteration-backwardSearch==1;
%                                             if stopSearch % if there are no eligible previous presses
%                                                 checkValidPressInterval = 0;
%                                                 break
%                                             end   
%                                              backwardSearch=backwardSearch+1; 
%                                              % get the time of previous press 
%                                             previousPressTime = no_onset_ResponseTable{responseIteration-backwardSearch,8};                                            
%                                            
%                                         end
%                                         checkValidPressInterval = relativePress-previousPressTime>2;
%                                     else
%                                         previousPressTime = 0;
%                                         checkValidPressInterval = relativePress-previousPressTime>2;
%                                     end