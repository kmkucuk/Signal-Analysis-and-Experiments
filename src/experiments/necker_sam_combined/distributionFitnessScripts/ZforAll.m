function ZforAll(x)   %%%Enter your variable name in Y, matrix in X

%%% ZforAll():      normalizes a given data set with its median, one can
%%%                 chose to adjust median into mean or some other
%%%                 arbitrary value.

 cd(fileparts(which(mfilename)));

[~,Ncolumns]=size(x);

for i= 1:Ncolumns
    
    PartDurs=x(:,i);

    PartDurs=PartDurs(PartDurs>0);          %%% raw durations of a participant. >0 deletes NaN values.
    PartDurs=sort(PartDurs);
    NormDurs=PartDurs/median(PartDurs);       %%% z durations of a participant
    
    %%% Register values into cell or int arrays
    
    if i==1
        NormPartDurs={NormDurs};   
        PartDurations={PartDurs};
    else
        PartDurations{:,i}=PartDurs;
        NormPartDurs{:,i}=NormDurs;
    end
    
end

RawPoolData={cat(1,PartDurations{:})};
RawPoolData=sort(RawPoolData{1,1});
NormalizedPoolData={cat(1,NormPartDurs{:})};
NormalizedPoolData=sort(NormalizedPoolData{1,1});

assignin('base','NormalizedDurs',NormPartDurs);
assignin('base','DominanceValues',PartDurations);
assignin('base','PoolData',NormalizedPoolData);
assignin('base','RawPoolData',RawPoolData);



end
