function [tmpitpc,tmpavg]=computePowerAndPhase(data,averagedimension)

tmpitpc=abs(mean(exp(1i*angle(data)),averagedimension));

tmpavg = mean(abs(data) ,averagedimension);
end