% EEG = struct variable with EEG data
%
% channels = channel orders (e.g. 1=F3, 2=F4 etc.)
%
% pairs = how chans to average? (e.g. 2 or 4 etc.)
% example:
% IF
% channels = [1 2 3 4 5 6] and pairs = 2
%   Then 
%       mean(chan1,chan2) & mean(chan3,chan4)... etc.
% IF pairs = 3;
%   Then
%       mean(chan1,chan2,chan3) & mean(chan4,chan5,chan6)... etc.
%
% datatype = data field name: EEG.(datatype)
% outputname = enter a field name that you want to register your data:
%          e.g.: EEG.(outputname)=averaged data


function EEG=averageROIs(EEG,channels,pairs,datatype,outputname)


%%%%%%%% Creating new channel names 
chancount=input('How many channels are created? \n','s');
channames=input('Enter new channel names and use equal number of characters for each channel name \n','s');
channamel=length(channames);
chancount=str2double(chancount);
chanpairl=channamel/chancount;


ik=0;
for k = 1:chanpairl:channamel
    ik=ik+1;
    newchannames(ik)={channames(k:(k+chanpairl-1))}
end

chanField=input('Enter new channel fieldname: \n','s');
%%%%%%%%


pCount=length(EEG);       
for pti = 1:pCount
    
    k=0;
    fprintf('Processing %s %s \n', EEG(pti).group,EEG(pti).condition);
    for i = 1:pairs:length(channels)
       
           
       
       if ~isempty(EEG(pti).(datatype))
       k=k+1;
       
       chantoavg=channels(i:i+pairs-1);
       if pti == pCount
            disp(chantoavg);
       end
       %% cluster with averaged raw data
%        EEG(pti).(outputname)(:,k)=mean(EEG(pti).(datatype)(:,chantoavg),2);
       
       %% cluster with averaged wavelet data
       EEG(pti).(outputname)(:,:,k)=nanmean(EEG(pti).(datatype)(:,:,chantoavg),3);
       %% cluster with trial by trial data
       % cluster channels
%        EEG(pti).(outputname)(:,k,:)=mean(EEG(pti).(datatype)(:,chantoavg,:),2);
       
       EEG(pti).(chanField)=newchannames;
       fprintf('Processing %s \n', EEG(pti).chaninfo{chantoavg});
       end
       
    end
    
end

% assignin('base','EEG',EEG);
    
    
    
    
    
    