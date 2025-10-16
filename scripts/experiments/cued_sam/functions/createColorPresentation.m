function [colorVector, presentationColors] = createColorPresentation(allColors,presentationCount,white_colored,firstColor)
    % white_colored = which colors are used in this trial
    % firstColor    = which color will be the first to be presented
    % (counterbalance variable) 
    % presentationCount = how many presentation will be made 
    % allColors = arrays of white, red, and blue colors in RGB 
    
    whiteDot = allColors{1};
    redDot   = allColors{2};
    blueDot  = allColors{3};
    % Adjust color of first dots according to counterbalance group descriptions for the trial
    oneColorReplicate = ceil(presentationCount/4); % because there are four assigned colors for white dots
    twoColorReplicate  = ceil(presentationCount/8); % because there are 8 assigned colors for colored dots
    
    % create color vectors
    whiteVector                 = repmat(whiteDot,[1,oneColorReplicate]);
    blueVector                  = repmat(blueDot,[1,oneColorReplicate]);
    redVector                   = repmat(redDot, [1,oneColorReplicate]);
    redBlueVector               = repmat([redDot blueDot],[1,twoColorReplicate]); % redDot and blueDot variables contain white fixations as well.

    colorVector                 = {whiteVector,redBlueVector,redVector,blueVector};
    
    
    % color names for stimulus property registeries
    dotColors_white={'white','','white',''};
    dotColors_red={'red','','red',''};
    dotColors_blue={'blue','','blue',''};
    
    if white_colored == 2 % 2 = colored
        if firstColor==0 % 0= red-blue, 1=blue-red sequence
            presentationColors=cat(2,dotColors_red,dotColors_blue); % first red
        elseif firstColor==1
            presentationColors=cat(2,dotColors_blue,dotColors_red); % first blue 
        end 
    elseif white_colored == 3
         presentationColors=cat(2,dotColors_red,dotColors_red); % first red
    elseif white_colored == 4
        presentationColors=cat(2,dotColors_blue,dotColors_blue); % first red
    else % 1= white
        presentationColors=cat(2,dotColors_white,dotColors_white); % all-white dots: standard
    end