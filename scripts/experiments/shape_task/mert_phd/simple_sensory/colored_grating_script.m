
sca;

% Setup defaults and unit color range:
PsychDefaultSetup(2);

% Disable synctests for this quick demo:
oldSyncLevel = Screen('Preference', 'SkipSyncTests', 1);

% Select screen with maximum id for output window:
screenid = max(Screen('Screens'));

% Open a fullscreen, onscreen window with gray background. Enable 32bpc
% floating point framebuffer via imaging pipeline on it, if this is possible
% on your hardware while alpha-blending is enabled. Otherwise use a 16bpc
% precision framebuffer together with alpha-blending. 
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');

baseColor = [.5 .5 .5 1];
[win, winRect] = PsychImaging('OpenWindow', screenid, baseColor);
[screenXpixels, screenYpixels] = Screen('WindowSize', win);
% Query frame duration: We use it later on to time 'Flips' properly for an
% animation with constant framerate:
ifi = Screen('GetFlipInterval', win);

% Enable alpha-blending
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Physical Distance/Length parameters

monitor_distance = 140; % participants are 140 cm away from monitor
horizontal_moni_length = 44.3; % horizontal length of monitor is 44.3 cm
pixPerCm = screenXpixels / horizontal_moni_length;
degreePerCm =2*atand((1/2)/monitor_distance);  % how much degrees in 1 cm
unitDegreePerCm = 1/degreePerCm;


stimSizeInDegree = 4; % 8 cm corresponds to 4° visual angle at 140 cm viewing distance
stimSizeInCm = stimSizeInDegree*unitDegreePerCm; % stim will be 4 degree in size
stimSizeInPix = stimSizeInCm*pixPerCm;


% default x + y size
virtualSize = ceil(stimSizeInPix);
% radius of the disc edge
radius = floor(virtualSize / 2);

color1 = [1 1 1 1];
color2 = [0 0 0 1];

% Build a procedural texture, we also keep the shader as we will show how to
% modify it (though not as efficient as using parameters in drawtexture)
texture = CreateProceduralColorGrating(win, virtualSize, virtualSize,...
     color1, color2, radius);

% These settings are the parameters passed in directly to DrawTexture

% angle
angle = 0;

% phase
phase = 90;

% spatial frequency
cyclesPerDegree = 1;
frequency = (cyclesPerDegree.*stimSizeInDegree) ./ stimSizeInPix;

% contrast
contrast = 1;

% sigma < 0 is a sinusoid.
sigma = -1;
mode = 'none';

while 1 
% Draw a message
Screen('DrawText', win, sprintf('a-angle = %d, s-contrast = %.2f', angle, contrast), 10 , 80, 1);
Screen('DrawText', win, sprintf('d-cycle/degree = %.2f, f-phase = %d', cyclesPerDegree,phase), 10 , 110, 1);
Screen('DrawText', win, sprintf('mode = %s', mode), 10 , 180, 1);
Screen('DrawText', win, sprintf('sigma = %.2f', sigma), 10 , 220, 1);
Screen('DrawText', win, 'Standard Sinusoidal Grating', 10, 10, [1 1 1]);

% Draw the shader texture with parameters
Screen('DrawTexture', win, texture, [], [],...
    angle, [], [], baseColor, [], [],...
    [phase, frequency, contrast, sigma]);

vbl = Screen('Flip', win);


KbWait();
[~, ~, keyCode]=KbCheck;
    if keyCode(KbName('Escape'))
        break;
    end
    
    if keyCode(KbName('a'))
       mode = 'angle';
    end
    
    if keyCode(KbName('s'))
       mode = 'contrast';
    end    
    
    if keyCode(KbName('d'))
       mode = 'frequency';
    end    

    if keyCode(KbName('f'))
       mode = 'phase';
    end   
    
    if keyCode(KbName('g'))
       mode = 'sigma';
    end       
    
    if keyCode(KbName('r'))
        angle = 0;
        sigma = -1; 
        contrast = 1;
        cyclesPerDegree = 1;
        frequency = (cyclesPerDegree.*stimSizeInDegree) ./ stimSizeInPix;
        mode='none';
    end
    if keyCode(KbName('DownArrow'))
        
        if strcmp(mode,'angle')
           if angle >= 45
               angle = angle-45;
           end
        end

        if strcmp(mode,'contrast')
           if contrast >= .005
               contrast = contrast-.005;
           end      

        end

        if strcmp(mode,'frequency')
            if cyclesPerDegree >= 1
                cyclesPerDegree = cyclesPerDegree/2;
                frequency = (cyclesPerDegree.*stimSizeInDegree) ./ stimSizeInPix;
            end
            
        end
        if strcmp(mode,'phase')
            if phase >= 15
                phase = phase-15;
            end
            
        end     
        
        if strcmp(mode,'sigma')
           if sigma >= -5
               sigma = sigma-.1;
           end
        end        
    elseif keyCode(KbName('UpArrow'))
        
        if strcmp(mode,'angle')
           if angle < 270
               angle = angle+45;
           end
        end

        if strcmp(mode,'contrast')
           if contrast <=.995
               contrast = contrast+.005;
           end
        end

        if strcmp(mode,'frequency')
            if cyclesPerDegree <= 32
                cyclesPerDegree = cyclesPerDegree*2;
                frequency = (cyclesPerDegree.*stimSizeInDegree) ./ stimSizeInPix;
            end
        end    
        
        if strcmp(mode,'phase')
            if phase <= 345
                phase = phase+15;
            end
            
        end      
        
        if strcmp(mode,'sigma')
           if sigma <= 100
               sigma = sigma+.1;
           end
        end         
        
    end
WaitSecs(.025);
end

sca;



