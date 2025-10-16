iteration = 0;
breaker = 0;

iteration = 0;
timeWin = 500;
segmentedData = nan(500,;
while 1
    if breaker
        break
    end
    iteration = iteration +1;
    if iteration == 1
        segmentedData(plot(data2(1:timeWin,[1 2 3]))
    else
        clf;
        hold on
        plot(data2((iteration*timeWin)+1:((iteration*timeWin)+timeWin),1));
        plot(data2((iteration*timeWin)+1:((iteration*timeWin)+timeWin),[2])-10);
        plot(data2((iteration*timeWin)+1:((iteration*timeWin)+timeWin),[3])-20);
        
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