function data=changeDimensionStructure(data,newDimensions)
% data = structure variable that contain the data

% newDimensions = a numeric array containing the new arrangement of matrix
% dimensions.
%           example: 
%           original dimensions with 2500x10x30 (timeXchannelxTrial)
%           newDimensions = [1 3 2] will transform the matrix dimensions
%           to: • 2500x30x10

pcount = length(data);
for pIndx = 1:pcount
    data(pIndx).(data)=permute(data(pIndx).(data),newDimensions);
end
