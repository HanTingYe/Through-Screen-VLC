% ===================================================
% *** FUNCTION r2xyz
% ***
% *** function [xyz] = r2xyz(p, startw, endw, obs)
% *** computes XYZ from reflectance p 
% *** p is an n by w matrix of n spectra 
% *** e.g. set obs to 'd65_64 for D65 and 1964
% *** the startw and endw variables denote first and 
% *** last wavelengths (e.g. 400 and 700) for p which
% *** must be 10-nm data in the range 360-780
% ===================================================

function [xyz] = r2xyz(p, startw, endw, obs)

if ((endw>780) | (startw<360) | (rem(endw,10)~=0) | (rem(startw,10)~=0))
   disp('startw and endw must be divisible by 10')
   disp('wavelength range must be 360-780 or less'); 
   return;   
end

load weights.mat 
% weights.mat contains the tables of weights
if strcmp('a_64',obs)
   cie = a_64;
elseif strcmp('a_31', obs)
   cie = a_31; 
elseif strcmp('c_64', obs)
   cie = c_64; 
elseif strcmp('c_31', obs)
   cie = c_31; 
elseif strcmp('d50_64', obs)
   cie = d50_64; 
elseif strcmp('d50_31', obs)
   cie = d50_31; 
elseif strcmp('d55_64', obs)
   cie = d55_64; 
elseif strcmp('d55_31', obs)
   cie = d55_31; 
elseif strcmp('d65_64', obs)
   cie = d65_64; 
elseif strcmp('d65_31', obs)
   cie = d65_31; 
elseif strcmp('d75_64', obs)
   cie = d75_64; 
elseif strcmp('d75_31', obs)
   cie = d75_31; 
elseif strcmp('f2_64', obs)
   cie = f2_64; 
elseif strcmp('f2_31', obs)
   cie = f2_31; 
elseif strcmp('f7_64', obs)
   cie = f7_64; 
elseif strcmp('f7_31', obs)
   cie = f7_31; 
elseif strcmp('f11_64', obs)
   cie = f11_64; 
elseif strcmp('f11_31', obs)
   cie = f11_31; 
else
   disp('unknown option obs'); 
   disp('use d65_64 for D65 and 1964 observer'); 
   return;
end

% check dimensions of P
dim = size(p);
N = ((endw-startw)/10 + 1);
if (dim(2) ~= N)
   disp('dimensions of p inconsistent'); 
   return;   
end

% deal with possible truncation of reflectance
i = (startw - 360)/10 + 1;
if (i>1)
   cie(i,:) = cie(i,:) + sum(cie(1:i-1,:));
end
j = i + N - 1;
if (j<43)
   cie(j,:) = cie(j,:) + sum(cie(j+1:43,:));
end
cie = cie(i:j,:);

% the main calculation
xyz = (p*cie)*100/sum(cie(:,2));

end
% ====================================================
% *** END FUNCTION r2xyz
% ====================================================















