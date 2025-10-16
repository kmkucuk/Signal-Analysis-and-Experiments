function [Pressed, PressedButton,firstRelease]=keyboardDemo(seconds,deviceIndex)

KbQueueCreate(deviceIndex);    KbQueueStart(deviceIndex);


% WaitSecs(seconds);
startTime=GetSecs();
while GetSecs()-startTime<=seconds
  

    [Pressed, PressedButton,firstRelease]=KbQueueCheck(deviceIndex); 
    if Pressed
        PressedButton(PressedButton==0)=NaN;        
        [~, pressIndex]=min(PressedButton);        
        
%         KbName([pressIndex releaseIndex])
        while Pressed && GetSecs()-PressedButton(pressIndex)<.75
            [~,~,firstRelease]=KbQueueCheck(deviceIndex); 
            if firstRelease(firstRelease>0)>0
                firstRelease(firstRelease==0)=NaN;
                [~, releaseIndex]=min(firstRelease);
                PressedButton(pressIndex)-firstRelease(releaseIndex)
                Pressed=0;
                KbQueueFlush(deviceIndex);
            end
        end
    end
end



% PressedButton(PressedButtonIndices)
KbQueueFlush(deviceIndex);

% 
% WaitSecs(seconds);
% [Pressed, PressedButton,firstRelease]=KbQueueCheck(deviceIndex);  
% PressedButton(PressedButton==0)=NaN;
% firstRelease(firstRelease==0)=NaN;
% [endtime, pressIndex]=min(PressedButton);
% [endtime, releaseIndex]=min(firstRelease);
% 
% PressedButton(pressIndex)-firstRelease(releaseIndex)
% KbName([pressIndex releaseIndex])
% 
% 
% % PressedButtonIndices
% 
% % PressedButton(PressedButtonIndices)
% 
% KbQueueRelease(deviceIndex); 

