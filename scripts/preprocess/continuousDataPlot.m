
timeRange = [-1000 1000];
iteration = 0;
breaker = 0;
data2 = data - mean(data(:,[2 12 17]),2);
data2 = data(:,[2 12 17]) - mean(data(:,[2 12 17]),1);
timeWin = 250;
while 1
    if breaker
        break
    end
    iteration = iteration +1;
    if iteration == 1
        plot(data2(1:timeWin,[1 2 3]))
    else
        clf;
        hold on
        plot(data2((iteration*timeWin)+1:((iteration*timeWin)+250),1));
        plot(data2((iteration*timeWin)+1:((iteration*timeWin)+250),[2])-10);
        plot(data2((iteration*timeWin)+1:((iteration*timeWin)+250),[3])-20);
        
    end
     while 1
        reply=input('did you save? y/n', 's');  
        if ~isempty(reply) && reply(1)=='y' 
            break
        end
        if ~isempty(reply) && reply(1)=='q' 
            breaker = 1;
        end            
     end
end