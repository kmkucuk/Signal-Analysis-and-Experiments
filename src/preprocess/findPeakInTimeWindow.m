% data = data vector that you want to find the peak in
%
% twindow = is the time in second units e.g. [-1.5 0] 
%
% timeaxis = is the time axis you want to index your time window
%
% datatype = is the fieldname of the structure that you want to process
% (e.g. variable.data ==>>> datatype ='data',

function [IndxMax,peakValue,peakValIndx,height]=findPeakInTimeWindow(data,twindow,timeaxis,datatype)


        windowIndices=findIndices(timeaxis,twindow);
        % find max values in ersp / 3-4D data structures
        if exist('datatype','var') && (datatype(1)=='e' || datatype(1)=='i')
            
            [peakvalues, indices]=max(data(:,windowIndices(1):windowIndices(2)),[],2);
            
            [peakValue,peakValIndx]=max(peakvalues);
            
            timeIdx=indices(peakValIndx);
            disp(peakValIndx)
            indices(peakValIndx)
            IndxMax=timeIdx+windowIndices(1);
            
            height=[];
            
        else 
            % find max values in amplitude / 2D data structures
            [peakvalues,indices,~,height]=findpeaks(data(windowIndices(1):windowIndices(2)),'Threshold',0);

            [peakValue,peakValIndx]=max(peakvalues);
            height=height(peakValIndx);
            timeIdx=indices(peakValIndx);
            
            IndxMax=timeIdx+windowIndices(1);  
        
        end        
        
        

        
end
