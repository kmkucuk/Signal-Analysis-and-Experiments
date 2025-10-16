


monitor_distance = 100; % participants are 140 cm away from monitor
horizontal_moni_length = 60; % horizontal length of monitor is 44.3 cm
pixPerCm = 1080 / horizontal_moni_length;
degreePerCm =2*atand((1/2)/monitor_distance);  % how much degrees in 1 cm
unitDegreePerCm = 1/degreePerCm;

stimSizeInDegree = 2; % 8 cm corresponds to 4° visual angle at 140 cm viewing distance
stimSizeInCm = stimSizeInDegree*unitDegreePerCm; % stim will be 4 degree in size
stimSizeInPix = round(stimSizeInCm*pixPerCm);

fprintf('Stimulus size in cm: %s \n',num2str(stimSizeInCm));
fprintf('Stimulus size in pixels: %s pixels \n',num2str(stimSizeInPix));




