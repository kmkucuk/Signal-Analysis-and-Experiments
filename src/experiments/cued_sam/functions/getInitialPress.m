pressTime             = GetSecs();
whichResponse         = find(currentResponseByte == response_bytes);
keyIndex              = response_bytes(whichResponse);
keyName               = response_byte_names{whichResponse};                               
relativePress         = pressTime-first_vb; % get relative press time, because raw press time value cannot be used in algebra with fixed value (e.g. .2 or 2)
stimInterval          = [relativePress - 2.5 relativePress - 0.15]; % expected onset interval is between .15 to 2.3 seconds before the button press 
if keyIndex==response_bytes(1)  % IF LEFT KEY PRESS NO COUNTER CONDITION /// IF RIGHT KEY PRESS COUNTERBALANCE CONDITION
    stimulusMarkers   = [1 3]; % select 1 and 3 stim markers. 1: first-red, 2: second-red 
elseif keyIndex==response_bytes(2)   % IF RIGT KEY PRESS NO COUNTER CONDITION /// IF LEFT KEY PRESS COUNTERBALANCE CONDITION
    stimulusMarkers   = [5 7]; % select 5 and 7 stim markers. 5: first-blue, 7: second-blue 
end  

checkValidKeys=(keyIndex==response_bytes(1) || keyIndex==response_bytes(2)); % if pressed keys are valid (e.g. j or k)