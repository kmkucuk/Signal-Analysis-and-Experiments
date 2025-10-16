%%% data = any vector with the desired data. This can be time vector,
%%% frequency vector etc. 
%%%
%%% points2extract= [-1.650 -.800 -800 .05] Enter any pair of data values
%%% which the indices will be extracted. WITHIN EACH PAIR enter smaller
%%% values at the beginning. Order of each pairs' size is not
%%% important. Pair with a smaller value can start at the beginning. 
isempty(gradAcceptance)
function dataIndices=extractDataIndex2(data,points2extract)

p2eCount=length(points2extract);

dataIndices=nan(1,p2eCount);
    if p2eCount>1
        for i = 1:2:p2eCount

            if i == 1
                indices=findIndices(data,points2extract(i:i+1));
                dataIndices(1,i:i+1)= indices(1:2);        
            else 
                indices=findIndices(data,points2extract(i:i+1));
                dataIndices(1,i:i+1)=indices(1:2);
            end

        end

    else
        indices=findIndices(data,points2extract);
        dataIndices=indices;
    end

end