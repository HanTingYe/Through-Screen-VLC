% =================================================================
% *** FUNCTION rgb2lms
% ***
% *** function [lms] = rgb2lms(phosphors,fundamentals,rgb)
% *** computes lms from rgb.
% *** phosphors is an n by 3 matrix containing 
% *** the three spectral power distributions of the display device
% *** fundamentals is an n x 3 matrix containing
% *** the rgb are the rgb values of the display device.
% *** the lms are the cone spectral sensitivities.
% =================================================================
function [lms] = rgb2lms(phosphors,fundamentals,rgb)

% Compute lms from rgb.
rgbTOlms = fundamentals'*phosphors; 
lms      = rgbTOlms * rgb;
% ===================================================
% *** END FUNCTION rgb2lms
% ===================================================