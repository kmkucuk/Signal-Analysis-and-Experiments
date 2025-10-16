function fourier_factor = getfourierfactor(k0)
% k0 = number of cycles of wavelet (morlet)
% WAS IST EIN FOURIER - FAKTOR?

switch nargin
    case 0
	k0 = 6;
end
% factor is determined depending on the cycles of the wavelet and can be
% used to determine the scales for given frequencies
fourier_factor = (4*pi)/(k0 + sqrt(2 + k0^2)); % Scale-->Fourier [Sec.3h]

