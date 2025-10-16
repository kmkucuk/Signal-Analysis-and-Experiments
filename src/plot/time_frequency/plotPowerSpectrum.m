function plotPowerSpectrum(data,srate,freqrange)
    
    if ~exist('freqrange','var')
        
        freqrange=[1 30];
        
    end
    
    n=length(data);
    
    frex=linspace(0,srate/2,floor(n/2)+1);  
    frex(:,1)=[];
    
    freqrange=findIndices(frex,freqrange);
    
    fou = fft(data,size(data,2));
    
    PowerSpect = data .* conj(data);
    
    % plot Fourrier Transform
    xTicks=freqrange(1):freqrange(2);
    subplot(2,1,1)
    plot(frex(xTicks), abs(fou(xTicks))*2);
%     plot(frex(xTicks), abs(data(xTicks))*2,'*-');
    
    % plot Power Spectrum
    
    subplot(2,1,2)    
%     
    plot(frex(xTicks), abs(PowerSpect(xTicks))*2);
    
    xlabel('Frequency (Hz)')
    
    ylabel('Power (\muV)')
    
end


