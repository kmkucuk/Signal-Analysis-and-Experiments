function trueFalse=checkReleasePending(pressTime,releaseDuration)

trueFalse=(GetSecs()-pressTime)<=releaseDuration;
end
