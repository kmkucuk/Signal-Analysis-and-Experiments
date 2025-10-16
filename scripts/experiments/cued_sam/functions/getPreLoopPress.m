if (reversalIteration>=1 || (checkEndogenousTask && simple_stroboscopic == 2) || simpleRT_keyReg)

    currentResponseByte             = io64(ioObj,portAddress(2));
    initialPressed                  = currentResponseByte ~= noPressByte; % is there any presses before the registery loop initiated
    previousPressed                 = Pressed == 1; % is there an ongoing press from the previous loop 

    %% below two continues to process registeries within the loop
    continueToReleaseCheck          = initialPressed && previousPressed && ~checkRelease;  % ongoing press from the previous loop = long press
    continueRegularPressRegistry    = ~initialPressed && ~previousPressed && checkRelease; % previous press was registered, and no press was made before the actual registery loop.
    %% below two gets the response properties before the loop and then proceeds to the registery loop
    executeNewPressRegistry      = initialPressed && ~previousPressed && checkRelease; % a press was made before the loop was initiated, get press parameters 
    executeReleaseRegistry       = ~initialPressed && previousPressed && ~checkRelease; % release happened in between the loop and stimulus display, get release parameters


    if executeNewPressRegistry
        %% GET RESPONSE 
        getInitialPress;  % get response properties (timing etc.) of the press if it was made before the registery loop. 

        %% RESPONSE ACCURACY PARAMETERS OF THIS TRIAL (exo & simple RT only)
        % Whether or not press has to be (1) LEFT OR RIGHT 
        %                                (2) LONG OR SHORT 
        getResponseAccuracyParameters; % get response accuracy parameters
    end

    if executeReleaseRegistry
        getResponseRelease;
    end


    bypassPreLoopCheck = ~(executeNewPressRegistry || executeReleaseRegistry); % gives (1) if either of two is 1. Skips the response check prior to registery loop. 
                                                                               % Because these two indicate that the registery occured within this script.
                                                                               
end