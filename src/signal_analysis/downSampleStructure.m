function data=downSampleStructure(data,fieldToDown,downSampleSlidingWindow)
% data = structure variable that contain the data

% fieldToDown = cell variable with field names to downsample (e.g.
% {'data','times'} 

% downSampleSlidingWindow = how much milliseconds that will be downsampled
% (e.g. 10 =>  signal(1:10:end)
srate = data(1).srate;

srateNorm = 1000/srate; 

downSampleSlidingWindow = downSampleSlidingWindow / srateNorm;

pcount = length(data);
for pIndx = 1:pcount
    fprintf('\nProcessing participant: %s', data(pIndx).subject(1:5));
   for fieldIndx = 1:length(fieldToDown)
       
       [d1,d2,d3] = size(data(pIndx).(fieldToDown{fieldIndx}));
       timeDimension = max([d1 d2 d3]);
       
       if timeDimension == d1
           data(pIndx).(fieldToDown{fieldIndx}) = data(pIndx).(fieldToDown{fieldIndx})(1:downSampleSlidingWindow:end,:,:);
       elseif timeDimension == d2
           data(pIndx).(fieldToDown{fieldIndx}) = data(pIndx).(fieldToDown{fieldIndx})(:,1:downSampleSlidingWindow:end,:);
       elseif timeDimension == d3
           data(pIndx).(fieldToDown{fieldIndx}) = data(pIndx).(fieldToDown{fieldIndx})(:,:,1:downSampleSlidingWindow:end);
       end
       
   end
end
