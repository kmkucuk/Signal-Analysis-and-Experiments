% left vs. right press 
if enablePressDuration % continue with press release algorithm
    if ~checkEndogenousTask % decide accuracy based on color orders in exogenous task
        % logical statement of correct or error responses: 1= correct press, 0=incorrect press
        checkCorrectError               =(~isempty(regexp(stimProperties{2},'red')) && response_bytes(1)==keyIndex) || (~isempty(regexp(stimProperties{2},'blue')) && response_bytes(2)==keyIndex);                     
    elseif simple_stroboscopic == 1 % same for simple RT task
        checkCorrectError               =(~isempty(regexp(stimProperties{2},'red')) && response_bytes(1)==keyIndex) || (~isempty(regexp(stimProperties{2},'blue')) && response_bytes(2)==keyIndex);                     
    end
else % bypass press release algorithm for white/directional trials
    if ~checkEndogenousTask % decide accuracy based on movement directions in exogenous task
        % logical statement of correct or error responses: 1= correct press, 0=incorrect press
        checkCorrectError               =(~isempty(regexp(stimProperties{1},'horizontal')) && response_bytes(1)==keyIndex) || (~isempty(regexp(stimProperties{1},'vertical')) && response_bytes(2)==keyIndex);                      %#ok<*RGXP1>
    elseif simple_stroboscopic == 1 % decide accuracy based on whether or not there is a dot at the top left corner 
        checkCorrectError               =(~isempty(regexp(stimProperties{2},'left_top')) && response_bytes(1)==keyIndex) || (~isempty(regexp(stimProperties{2},'left_bottom')) && response_bytes(2)==keyIndex);                     
    end 
end


% long vs. short press
if ~checkEndogenousTask % if exogenous task
    % we calculate release duration by the motion
    % change onset in exogenous task. This is
    % registered in combinedReversalMatrix variable
    checkLongerDuration     = combinedReversalMatrix(2,reversalIteration)==long_press; % check if the release duration should be longer
elseif simple_stroboscopic == 1
    checkLongerDuration     = ~isempty(regexp(stimProperties{1},resp_duration_text_simple{1})); % output is 1 if response has to be long, 0 if it has to be short
end