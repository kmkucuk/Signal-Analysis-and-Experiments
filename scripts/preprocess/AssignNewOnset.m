function [arbitraryIndx]=AssignNewOnset(data,timevector,type)

zeroIndx=find(timevector==0);

newtimepointIndx=zeroIndx-750;

data=-data;

% if type(1) == 'b'
    
    [~,Aindices,~,~]=findpeaks(data(newtimepointIndx:newtimepointIndx+126));
    
% elseif type(1) == 's'
    
%     [~,S_indices,~,~]=findpeaks(data(newtimepointIndx:zeroIndx));
    
% end
% if -1500 ms index is at the beginning of a dot display, take -1500 ms idx
% as the new time point idx. Else, add fixation duration points:
% 28 points = 58 ms (duration of fixation)

    if Aindices == 98
        
        arbitraryIndx=newtimepointIndx;
        
    elseif isempty(Aindices)
        disp('ALOO')
        [~,arbitraryIndx]=min(abs(data(newtimepointIndx:newtimepointIndx+40)-0));
        arbitraryIndx=arbitraryIndx+newtimepointIndx;
    else
        
        arbitraryIndx=newtimepointIndx+Aindices+28;

    end
    
    
end
