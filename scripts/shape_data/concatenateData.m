function newdata=concatenateData(data)
%%% concdata=[] if you start new concatenation;
%%%
%%% concdata=your_variable if you want to make additional concatenation to
%%% already existing variables
%%%

newdata=reshape(data,1,size(data,1)*size(data,2));


end