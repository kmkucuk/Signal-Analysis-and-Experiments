function frex=findNyquistFreq(data,srate)

n=length(data);

frex=linspace(0,srate/2,floor(n/2)+1);

frex(:,1)=[];

end