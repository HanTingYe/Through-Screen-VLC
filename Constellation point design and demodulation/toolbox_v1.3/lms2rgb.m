% ================================================================
% *** FUNCTION lms2rgb
% ***
% *** function [rgb] = lms2rgb(phosphors,fundamentals,lms)
% *** computes rgb from lms.
% *** phosphors is an n by 3 matrix containing 
% *** the three spectral power distributions of the display device
% *** fundamentals is an n x 3 matrix containing
% *** the lms are the cone spectral sensitivities.
% *** the rgb are the rgb values of the display device.
% ================================================================
function [rgb] = lms2rgb(phosphors,fundamentals,lms)

% Compute lms from rgb.
rgbTOlms = fundamentals'*phosphors; 
lmsTOrgb = inv(rgbTOlms);
rgb      = lmsTOrgb * lms;
% ===================================================
% *** END FUNCTION lms2rgb
% ===================================================