function totalDuration = determineExperimentLength(stimduration,ISIduration,stimCount,stimRepeat)

totalStimDuration = stimCount*stimRepeat * stimduration;

totalISIDuration = (stimCount-1) * ISIduration*stimRepeat;

totalDuration = (totalStimDuration + totalISIDuration)/60;

% disp(totalDuration)

end