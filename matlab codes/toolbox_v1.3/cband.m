% ===================================================
% *** FUNCTION cband
% ***
% *** Stearns-Stearns spectral bandpass correction 
% *** operates on matrix P of dimensions n by m 
% *** n spectra each at m wavelengths
% ===================================================
function [p] = cband(p)

a = 0.083;
dim = size(p);
n = dim(1);

% the first and last wavelengths
p(1,:) = (1 + a)*p(1,:) - a*p(2,:);
p(n,:) = (1 + a)*p(n,:) - a*p(n-1,:);
% al the other wavelengths
for i=2:n-1
	p(i,:) = -a*p(i-1,:) + (1 + 2*a)*p(i,:) - a*p(i+1,:);
end

end
% ====================================================
% *** END FUNCTION cband
% ====================================================



