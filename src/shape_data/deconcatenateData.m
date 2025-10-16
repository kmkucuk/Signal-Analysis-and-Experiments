function data=deconcatenateData(data,reshapevector)
%%% enter your new dimensions into reshapevector:
%%% reshapevector = [2 3] this will convert your data into a 2x3 matrix
%%%

countDims=length(reshapevector);

if countDims==2
    data=reshape(data,reshapevector(1),reshapevector(2));
elseif countDims==3
    data=reshape(data,reshapevector(1),reshapevector(2),reshapevector(3));
elseif countDims==4
    data=reshape(data,reshapevector(1),reshapevector(2),reshapevector(3),reshapevector(4));
end