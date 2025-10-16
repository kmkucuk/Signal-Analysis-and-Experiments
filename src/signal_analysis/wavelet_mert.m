function wavelet_mert(freq,k0,sf)

%   eeg_waveletbandwidth.m - numerical estimation of wavelet bandwidth
%============================================================================
% INPUT
%       freq        : vector of center frequencies, at which the bandwidth is
% 			estimated
%       k0          : number of cycles in one standard deviation of the Morlet wavelet 
%       sf          : sampling frequency
% OUTPUT
% 	table	    : 1- freq
%                 2- lower end (see 4)
%                 3- upper end (see 4)
% %                 4-vector of estimated full widths at half maximum
% 
%  freq = 7:30; % vector of center frequencies, at which the bandwidth is estimated
%  k0 = 7;% number of cycles in one standard deviation of the Morlet wavelet 
%  sf = 500;% sampling frequency
 frange = [0.1 70]; % band-pass filters used during recording

%%=============================================================================== 


dt = 1/sf;
spacing = 'linear';
for i = 1:length(freq)
	if freq(i) <= 15 && freq(i) > 2
		nFreqs = 400;
		frange = [0.1 25];
		t_end = 5;
	elseif freq(i) <= 2
		nFreqs = 1000;
		t_end = 5;
		frange = [0.1 5];
	elseif freq(i) > 15 && freq(i) < 25
		nFreqs = 300; 		
		t_end = 1;
		frange = [0.1 40];
	elseif freq(i) >= 25
		nFreqs = 200;
		t_end = 1;
		frange = [0.1 70];
	end
	t = 0:dt:t_end;
	x = sin(2*pi*freq(i)*t);
	[spect,taxis,faxis,power] = eeg_wavelet(x,frange,nFreqs,k0,dt,spacing);
	powerspectrum = power(:,fix(length(taxis)/2));
	[a] = find(powerspectrum >= max(powerspectrum)/2);
	bw(i) = faxis(a(end))-faxis(a(1));
        
    
    % siehe doku 18.10.11 und http://de.wikipedia.org/wiki/Halbwertsbreite - umrechnung von bw = 2.3548*sig
    % achtung: sig meint nur einseitig, bw ist beidseitig von der kurve
    % sig(i) = bw(i)/2.3548;
    sig(i) = bw(i)/(2*sqrt(2*log(2)));
    
    %range nach halbwertsbreite (50%)
    range_o(i) = freq(i) + bw(i)/2;
    range_u (i) = freq(i) - bw(i)/2;
    
    %range +/- 1 std (68% der kurve) - etwas weniger als bw-range
    range_os(i) = freq(i) + sig(i);
    range_us(i) = freq(i) - sig(i);
    
    % range (+/- 2 std (95.4% der kurve)
    range_os2(i) = freq(i) + sig(i)*2;
    range_us2(i) = freq(i) - sig(i)*2;
    
    
% 	plot(faxis,powerspectrum, '*-')
% 	xlim( [0 50 ])
%	waitforbuttonpress
end

info_table = 'Frequency /  lower band edge / upper band edge / bandwidth';
    
table_full_width_at_half_maximum = [freq;range_u;range_o;bw];

 
%info_table = 'centrefreq /  Halb-U / Halb-O / STD-U / STD-O / STD2-U / STD2-O';

% table = [freq;range_u;range_o;range_us;range_os;range_us2;range_os2]
 

  % nur std-2mal
 %info_table = 'centrefreq /  STD2-U / STD2-O';

 table_2sig_94perc = [freq;range_us2;range_os2]
 table_1_sig_68perc = [freq;range_us2;range_os2];
%  clear a bw dt faxis frange freq i k0 nFreqs power powerspectrum range_o range_os range_os2 range_u range_us2 range_us df sig spacing spect t t_end taxis x sf
 