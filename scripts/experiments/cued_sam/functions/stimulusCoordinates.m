function [baseRectCenter, allRects]=stimulusCoordinates(stimulusParameters,screenParameters)
xCenter=screenParameters(2,1);
yCenter=screenParameters(2,2);
%% Calibrate stimulus lengths from centimeters to pixels 
baseRect_height         = stimulusParameters(1); % rectangle height
baseRect_width          = stimulusParameters(2); % rectangle width
dot_size                = stimulusParameters(3); % dot margins length

% Create black base rectangle and small dots for fixation and double dot
% displays
baseRect                = [0 0 baseRect_width baseRect_height]; % black rectangle
dotRect                 = [0 0 dot_size dot_size]; % dot stimulus

% Coordinates of dot stimuli 
coor_left               = xCenter-(baseRect_width/2)+(1.5*dot_size); % left
coor_right              = xCenter+(baseRect_width/2)-(1.5*dot_size); % right
coor_bottom             = yCenter+(baseRect_height/2)-(1.5*dot_size); % bottom 
coor_up                 = yCenter-(baseRect_height/2)+(1.5*dot_size); % top
coor_fixation           = [xCenter, yCenter]; % center coordinates, used for fixation dot

% coordinates for horizontal movement: 
% Sequence: Right -- Fixation -- Left -- Fixation
coor_exo_horizontal     = {[coor_right, coor_bottom;coor_right,coor_up;coor_fixation],...
                        coor_fixation,...
                        [coor_left, coor_bottom;coor_left,coor_up;coor_fixation],...
                        coor_fixation};

% coordinates for vertical movement: 
% Sequence: Bottom -- Fixation -- Top -- Fixation
coor_exo_vertical       ={[coor_left, coor_bottom;coor_right,coor_bottom;coor_fixation],...
                        coor_fixation,...
                        [coor_left, coor_up;coor_right,coor_up;coor_fixation],...
                        coor_fixation};

% coordinates for ambiguous movement: 
% Sequence: Ambiguous 1 -- Fixation --  Ambiguous 2 -- Fixation
% 
%  Ambiguous 1: bottom-left and top-right dots
%  Ambiguous 2: top-left and bottom-right dots
coor_endo               ={[coor_left, coor_bottom;coor_right,coor_up;coor_fixation],...
                        coor_fixation,...
                        [coor_left, coor_up;coor_right,coor_bottom;coor_fixation],...
                        coor_fixation};

endoRects={};
verticalRects={};
horizontRects={};

% Create double dot and fixation stimuli using the coordinates above
for k = 1:4 
    for i=1:size(coor_endo{k},1)
        endoRects{k}(:,i)          = CenterRectOnPointd(dotRect, coor_endo{k}(i,1), coor_endo{k}(i,2));
        verticalRects{k}(:,i)      = CenterRectOnPointd(dotRect, coor_exo_vertical{k}(i,1), coor_exo_vertical{k}(i,2));
        horizontRects{k}(:,i)      = CenterRectOnPointd(dotRect, coor_exo_horizontal{k}(i,1), coor_exo_horizontal{k}(i,2));
    end
end
% base rectangle (black rectangle centered on the screen)
baseRectCenter = CenterRectOnPointd(baseRect, xCenter, yCenter);

% All stimulus configurations for:
% row1: stroboscopic alternative motion - multistable movement
% row2: vertical exogenous motion
% row3: horizontal exogenous motion
allRects=cat(1,endoRects,verticalRects,horizontRects);
end


