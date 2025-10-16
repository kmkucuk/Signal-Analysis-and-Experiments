function tfdata=waveletBaseline(tfdata,baseIdx)
frex=size(tfdata,1);

    for fi=1:frex

        BaselineMean=mean(tfdata(fi,baseIdx(1):baseIdx(2)),2);

        tfdata(fi,:)= 10*log10( tfdata(fi,:) / BaselineMean);

    end
end