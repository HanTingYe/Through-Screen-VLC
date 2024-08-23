% ===================================================
% *** FUNCTION sprague
% ***
% *** Interpolates an n by w matrix of spectra 
% *** where n is the number of spectra 
% *** f is an interpolation factor
% *** e.g. if f=2 the sampling rate is doubled
% ===================================================
function [p] = sprague(spectra,f)
if (f<2 | ((f-floor(f))>0))
    disp('invalid f value - premature termination');
    p = 0;
    return;
end
% set the parameters
c = [884 -1960 3033 -2648 1080 -180; ...
    508 -540 488 -367 144 -24; ...
    -24 144 -367 488 -540 508; ...
    -180 1080 -2648 3033 -1960 884];

[numSpectra lengthSpectra] = size(spectra);

for i=1:numSpectra
    % select a spectrum
    r = spectra(i,:);
    % add the extra start and end points
    k = c(1,:);
    p1 = (k*(r(1:6))')/209;
    k = c(2,:);
    p2 = (k*(r(1:6))')/209;
    k = c(3,:);
    p3 = (k*(r(end-5:end))')/209;
    k = c(4,:);
    p4 = (k*(r(end-5:end))')/209;
    r = [p1 p2 r p3 p4];
    N = lengthSpectra+4;
    
    p = zeros(numSpectra,f*(N-5)+1); 
    xx = linspace(1/f,1-1/f,f-1);

    for j=3:N-3
        a0 = r(j);
        a1 = (2*r(j-2)-16*r(j-1)+16*r(j+1)-2*r(j+2))/24;
        a2 = (-r(j-2)+16*r(j-1)-30*r(j)+16*r(j+1)-r(j+2))/24;
        a3 = (-9*r(j-2)+39*r(j-1)-70*r(j)+66*r(j+1)-33*r(j+2)+7*r(j+3))/24;
        a4 = (13*r(j-2)-64*r(j-1)+126*r(j)-124*r(j+1)+61*r(j+2)-12*r(j+3))/24;
        a5 = (-5*r(j-2)+25*r(j-1)-50*r(j)+50*r(j+1)-25*r(j+2)+5*r(j+3))/24;
        y = a0+a1*xx+a2*xx.^2+a3*xx.^3+a4*xx.^4+a5*xx.^5;
        index = j-2;
        p(i,(index-1)*f+1) = r(j);
        p(i,(index-1)*f+1+1:(index-1)*f+1+f-1)=y;
    end
    p(i,f*(N-5)+1)=r(N-2);
end

end
% ====================================================
% *** END FUNCTION sprague
% ====================================================

