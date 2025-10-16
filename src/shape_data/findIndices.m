%%% vector = the vector where the Indices will be extracted
%%%
%%% points2extract = [min max] minimum and maximum data points. 
%%%
%%% e.g. [-1 0] (in seconds) or [4 6] (in frequency).
%%%
%%% Always enter smaller value at the beginning. 
%%%
%%% Kurtulu? Mert Küçük

function Indices=findIndices(vector,points2extract)
    p2ecount=length(points2extract);
    Indices=[];
if p2ecount>1
    for i = 1:2:p2ecount
        [~, minIndx]=min(abs(vector-(points2extract(i))));
        [~, maxIndx]=min(abs(vector-(points2extract(i+1))));
        Indices=[Indices,minIndx,maxIndx];
    end
else
    [~, minIndx]=min(abs(vector-points2extract));
    maxIndx=[];
    Indices=[minIndx maxIndx];
end
    
end
    