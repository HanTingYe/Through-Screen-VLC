% ============================================================
% *** FUNCTION lms2rgbMB
% ***
% *** function [rgbMB] = lms2rgbMB(lms,s)
% *** computes rgbMB from lms.
% *** lms is an n by 1 matrix containing 
% *** the l-,m-, and s-cone excitations
% *** s is a 1 by n matrix containing the lms scaling factors.
% *** rgbMB are the chromaticity coordinates in the 
% *** MacLeod and Boynton (1979) chromaticity diagram.
% ============================================================
function [rgbMB] = lms2rgbMB(lms,s)
% check number of input arguments.
% if s is not provided, use default scaling factors valid 
% for the Stockman and Sharpe (2000) 2-deg fundamentals.
% else use s.
if nargin==1
    lms_scaling=[0.689903 0.348322 0.0371597];
else
    lms_scaling = s;  
end
% rescale cone excitations.
lms   =  diag(lms_scaling')*lms;
% compute luminance
luminance =  lms(1)+ lms(2) 
% compute rgbMB chromaticities.
rMB = lms(1)/luminance;
gMB = lms(2)/luminance;
bMB = lms(3)/luminance;
rgbMB = [rMB gMB bMB];
% ===================================================
% *** END FUNCTION lms2rgbMB
% ===================================================