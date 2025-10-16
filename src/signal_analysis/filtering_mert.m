function [EEG2,avg_data, prcssd_data, fou,filtering,frequencies] = filtering_mert(EEG, chans,dataname, f_type, f_range, sf,filtering,newdataname,alphatype)

% This script executes inverse FFT around the EEG epochs / mean values ??high-, low- or bandpass
% filter or use notchfilter
%
% OUTPUT
% filt3D_data = 3dim matrix (time point * channel * sweep no.), i.e. same matrix as before, but filtered
% mean_data: mean value of data-gef_alle (time * channel)
% filter limit: from f - which frequencies were actually closed (lp, hp, bp) or closed (no):,
% important if the values ??have to be approximated
%
% OUTPUT TO VIEW
% test: max test should be very small, otherwise something with fft was wrong!
% fou: from last run: all FFT transformed
% filtered: from the last run: FFT-transformed that go into iFFT
% f: from fou, which frequency corresponds to values ??in fou
%
% INPUT
% data = 3dim matrix (time point * channel * sweep no.) or 2dim (average: time point + channel)
% chans = vector of the channels to be filtered
% f_type: 'lp' = lowpass, 'hp' = highpass, 'bp' = bandpass, 'no' = notch
% f_range = filter limit (filtergrenze), a number for no, lp and hp (e.g. [30]); for bandpass both filter limits, e.g. ([7 12])
% sf = sampling freq (500)
%
% EXAMPLES
% [filt3D_data, mean_data, test, fou,filtered,f] = filtering_mert (dmy011, [3: 10,18], 'no', 50, 500);
% [filt3D_data, mean_data] = filtering_mert (dmy011, 15, 'bp', [8 13], 500);
%
% GENERAL NOTE: it is generally better if the cut-off value actually exists,
% otherwise:
% cutoff_lp ->% includes the value (e.g. fg = 50Hz), if it exists in f, otherwise takes everything below, otherwise everything below
% cutoff_hp ->% does NOT include the value (e.g. fg = 50Hz) if it exists in f, but takes everything else above
% cutoff_no ->% if value exists in f (e.g. fg = 50Hz), f = fg + the value below and above it in f is taken out;
% if value does not exist in f, then the next smaller value is taken from f, as well as the value below and above it,
% i.e. fg is removed in any case, but notchfilter is not completely sharp
% cutoff_bp ->% if there are upper and lower limit values ??in f, both are included;
% if the lower limit does not exist in f, the next smallest value is included, i.e. bandpass down slightly wider than specified
% if the upper limit does not exist in f, the next lower value ends, i.e. bandpass slightly upwards slightly narrower than specified
%
%
% filtering = 1 to filter into time domain (ERP), 0 to filter into FFT domain
% (power spectrum)
%
%
% GENERAL REMARK
% zero has a special position at fft: it doesn't exist at the end, there the vector must be shortened by one.
% and this shows why the vector is a number longer than maybe expected (e.g. 31 for lp = 30 if 500 data points and sf = 500Hz)

% if exist('timewindow','var')
%     timewindow=findIndices(EEG(1).times,timewindow);
%     timewindow=timewindow(1):timewindow(2);
%     
%     
% else
%     
%     timewindow=1:length(EEG(1).times);
%     
% end
%  timewindow=1:length(EEG(1).times);
data_gef = [];
prcssd_data = [];

% dt = 0.002; % dt is the time between data points, always in sec !!! (i.e. ms / 1000)
dt = 1/sf; % this is more precise, because dt is "incorrectly rounded" for sf = 512 also 0.002, but vector for f as always correct here
nyquist=sf/2;

% if data vector with single sweeps, with 2 dimensions this is "1"
EEG2=EEG;
for pC = 1:length(EEG)
    
    
    data=EEG(pC).(dataname);    
    
    if isempty(data)
        continue
    end
    
    chans = 1:size(data,1); 
    sw = size(data,3);
    
    if sw > 1
        data = permute(data,[2,1,3]);
    else
        data = permute(data,[2,1]);
    end    
%     
%     fprintf('Processing participant: %s \ngroup: %s \ncondition: %s\niteration: %d\n..',...
%         EEG(pC).subject, EEG(pC).group,EEG(pC).condition,pC);
    
        for w = 1:sw
            
            if sw > 1
                Trialdata = data(:,:,w);    
            else
                Trialdata = data;
            end

            for i=1:length(chans)
                
                % how many data points are received
                n = size(Trialdata,1);
                
                % fourier-transformation
                fou = fft(Trialdata(:,chans(i)))/n;
                


        %         % powerspektrum a la dennis 
        %         Pow = fou .* conj(fou) / n;


                % assignment of the individual Fourier-transformed to Hz: 1 / dt == sampling frequency!
%                 frequencies = ((1/dt)*(0:n-1)/n)';

                frequencies = linspace(0,nyquist,floor(length(fou)/2)+1);
%                 frequencies(:,1)=[];

                %security renaming
                filtered = fou;
                if pC == 1
                    assignin('base','filtered',filtered);
                end
                
                if exist('alphatype','var')
                    f_range=EEG(pC).(alphatype);
                end
                
                if filtering
                    % selection of filtering type and filtering
                    switch(f_type)
                        % lowpass-filter
                        case {'lp'}
                            cutoff_lp = find(frequencies > f_range, 1 ); %s.o.
                            % oder filtered(cutoff_lp: (end) - (cutoff_lp - 2)) = 0;
                            filtered(cutoff_lp:(end+1)-(cutoff_lp-1)) = 0;
                            %test = find(real(filtered (1:(length(f)/2)+1))); filtergrenze = [f(test(1)), f(test(end))]

                            % high-filter, since cutoff_hp is actually the first valid number, this must be undone
                        case {'hp'}
                            cutoff_hp = find(frequencies > f_range, 1 ); %s.o.
                            filtered(1: (cutoff_hp - 1)) = 0;
                            filtered ((end-(cutoff_hp-3)) : end) = 0; % -1 because the vector has a shorter back (the special zero point is eliminated), -1s.o. because _hp first valid number,
                            % -1 because calculations are made from behind: e.g. 50 out of 100 data items are 51: end, i.e. only 49 are subtracted from behind


                            % bandpass filter: switch logic from cutoff_lp and cutoff_hp!
                            % because lp now says which start and end and hp which middle piece is set to 0
                            % it is now called -2 and -4, because 30:50 hz includes the range of "31Hz".
                        case {'bp'}
                           
                            passIndices=findIndices(frequencies,f_range);
                            filtered (1: (passIndices(1)-1)) = 0;
                            filtered((end-(passIndices(1)-3)):end)=0;                            
                            filtered ((passIndices(2)+1):(end+1)-(passIndices(2))) = 0;    
                            
%                              test = find(real(filtered)); 
%                              filtergrenze = [frequencies(test(1)), frequencies(test(end/2))]
                             
                        case {'no'} %notchfilter
                            cutoff_no = find(frequencies > f_range, 1 ); %
                            % cutoff_no - 1 and cutoff_no-3 are the actual 50Hz
                            % it is extended by one data point each
                            % advantage if the 50Hz in f does not exactly exist, then
                            % 50Hz still included
                            filtered(cutoff_no-2:cutoff_no) = 0;
                            filtered(end-(cutoff_no-2):end-(cutoff_no-4)) = 0;


                    end
                    % calculate back - only required data
                    y = ifft(filtered)*n;
%                     y=real(y);
                    % assemble the matrix for all channels
                    
                    data_gef = cat(2,data_gef, y);
                else
                    
                    % scale the fft to original signal
                    fou=fou/n;
                    
                    % calculate power
                    fou=abs(fou)*2;
                    
                    % cut mirrored power spectrum
                    truedatalength = ceil(n/2);
                    fou=fou(1:truedatalength);
                    % assemble the matrix for all channels                    
                    
                    data_gef = cat(2,data_gef, fou);
                    
                end



                
                

            end
            disp(dataname)
            disp(w)
            size(data_gef)
            size(prcssd_data)            
            prcssd_data = cat(3,prcssd_data, data_gef);
            data_gef = [];

        end
        
        
        if size(prcssd_data,3) > 1
            prcssd_data = permute(prcssd_data,[2,1,3]);
            avg_data = mean(prcssd_data,3); %%% averages data across trials
        else
            prcssd_data = permute(prcssd_data,[2,1]);
            avg_data = prcssd_data;
        end
        
        
        EEG2(pC).(newdataname)=prcssd_data;       %%% Will register filtered data into original ALLEEG structure.
        
%         EEG2(pC).([newdataname,'avg'])=avg_data;       %%% Will register trial-averaged data into original ALLEEG structure.

        
        if f_type(1)=='n' && filtering    
            
            EEG2(pC).notch={f_type,f_range};            
            
        elseif filtering==1
            EEG2(pC).filterProperties={f_type,frequencies(passIndices)};
            
        else
            avg_chan_data=mean(avg_data,2);
            EEG2(pC).chanAvgData=avg_chan_data;
            EEG2(pC).fourrFreqs=frequencies;
        end
        prcssd_data=[];
        plot(filtered)
end









% calculate the mean value for phase-related data


%zur kontrolle
% figure(1)
% subplot(2,1,1),stem(f,[real(fou), real(filtered)])
% me = mean(daten,3);
% subplot(2,1,2),plot([me(:,k(i)), real(data_gef_mean(:,i))])
% set(gca, 'ydir', 'reverse')

% % ausgabe filtergrenzen
% switch(wastun)
% 
%     case {'lp','hp','bp'}
%         test = find(real(filtered (1:(length(f)/2)+1))); filtergrenze = [f(test(1)), f(test(end))];
%     case {'no'}
%         test = find(real(filtered (1:(length(f)/2)+1))== 0); filtergrenze = [f(test(1)), f(test(end))];
% end

