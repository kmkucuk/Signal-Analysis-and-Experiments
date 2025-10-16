function Prepare_X_axis(x,y)        %%% X is the column of the participant, Y is the matrix that we are going to operate in (e.g. WithinDurations)

ChosenTab=y(:,x);

cumulativeduration=cumsum(ChosenTab);

newmatrix=[cumulativeduration, ChosenTab];

assignin('base','participant',newmatrix);
hold on;
plot(newmatrix(:,1),newmatrix(:,2));
end