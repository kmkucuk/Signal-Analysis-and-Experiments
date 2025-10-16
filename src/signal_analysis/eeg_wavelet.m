function [spect,taxis,faxis,power,coi,scale] = eeg_wavelet(data,freq,nFreqs,k0,dt,spacing,range,ampl_po)
%   eeg_wavelet.m - wrapper function for Colorado's wavelet.m
% ============================================================================
%   Usage: [spect,taxis,faxis,power,coi] =
%                  eeg_wavelet(data,freq,nFreqs,nCycles,dt,spacing,range);
% INPUT
%       data        : 1D eeg data
%       freq	    : center frequencies to be analyzed or 
%                     frequency range if range == 1 and length(freq) == 2. 
%		      Default: [10 50] 
%       nFreqs	    : number of frequencies in range. Default: 30
%       k0          : dimensionless frequency of morlet wavelet, i.e. 
%               number of cycles in 
%       dt          : size of time bins (inverse of sampling rate). Default: 1/500
%       spacing	    : spacing of frequencies in frequency range 
%                   'logarithmic' or 'linear'. Default: 'linear'
%       range       : see freq
%       ampl_po     : 'ampl' (output in mircovolt) or 'po' (power: output in microvolt ^2)
%                   
%
% OUTPUT
%       spect       : complex wavelet spectrum containing power and phase
%       taxis       : time axis starting at 0, i.e. shifting is possibly
%                     needed for correct time axis
%       faxis       : frequency axis
%       power	    : power spectrum
%       coi         : cone of influence (everything below is dubious)
%
% Version 01/11/11, Joscha Schmiedt
%

% check for inputs and set default values if missing
if ~exist('data', 'var') 
  error('Input missing: no data')
end
if ~exist('dt','var');
  dt = 1/500;
end
if ~exist('spacing', 'var')
  spacing = 'linear';
end
if ~exist('k0','var') % entspricht ncycles
  k0 = 6;
end
if ~exist('nFreqs','var')
  nFreqs = 30;
end
if ~exist('freq','var')
	freq = [10 50];
end
if ~exist('range','var')
  range = 1;
end
if ~exist('ampl_po','var')
  ampl_po = 'ampl';
end

% if freq is gives a range constrcut frequency vector logarithmically or linear
if length(freq) == 2 & range == 1 
	switch spacing
	case 'logarithmic'
		freq = logspace(log10(freq(1)),log10(freq(2)),nFreqs);
	case 'linear'
		freq = linspace(freq(1),freq(2),nFreqs);
	end
end


% pseudo variables to run colorado-skript with one centerfrequency at a
% time: i.e. with those that this script specifies in freqs (see loop below)
sspacing = 1; % DJ in compo-skript: spacing between scales (i.e. just the given frequency)
nScales = 0; % J1 in compo-skript: number of scales (1 is added in the script, i.e. script runs with 1 scale)

% conversion from center frequency given in freqs to scale
scale = 1./freq/getfourierfactor(k0);

% preallocate wavelet spectrum 
spect = zeros(length(scale),length(data));
p = zeros(1,length(scale));
sc = zeros(1,length(scale));


% do wavelet transform for all scales: run colorado-script
for i = 1:length(scale)
    [spect(i,:),p(i),sc(i),coi(:,i)] = wavelet(double(data),dt,1,sspacing,scale(i),nScales,'morlet',k0);
end

% conversion from fourier periods in Hz
faxis = 1./p;

% create time axis
L = length(data);
taxis = (0:L-1).*dt;

spect = sqrt(dt)*spect;  % Normierung % absolutwert von spect entspricht der wurzel von power.

% power
switch ampl_po
	case 'po'
power = (2*abs(spect)).^2;
    case 'ampl'
power =sqrt((2*abs(spect)).^2); %% ausgabe in mikrovolt - wurzel gezogen
end

% convert cone of influence to frequencies
coi = 1./coi;
