% ===================================================================
% *** FUNCTION rgbMB2lms
% ***
% *** function [lms] = rgbMB2lms(rgbMB,luminance,s)
% *** computes lms from rgbMB.
% *** lms is a 1 by n matrix containing 
% *** the l-,m-, and s-cone excitations
% *** rgbMB is a 1 by n matrix which represents 
% *** the chromaticity coordinates in the  
% *** MacLeod and Boynton (1979) chromaticity diagram.
% *** luminance is the sum of the scaled l_bar and m_bar excitations.
% *** s is a 1 by n matrix containing the lms scaling factors.
% ====================================================================
function [lms] = rgbMB2lms(rgbMB,luminance,s)
% check number of input arguments.
% if s is not provided, use default scaling factors valid 
% for the Stockman and Sharpe (2000) 2-deg fundamentals.
% else use s.
if nargin==2
    lms_scaling=[0.689903 0.348322 0.0371597];
else
    lms_scaling = s;  
end
% compute scaled LMS from rgbMB and luminance.
lms_scaled = rgbMB .* luminance
% to obtain LMS excitations the previous LMS values need to be unscaled.
% define LMS scaling according to which fundamentals are used.
lms = lms_scaled./(lms_scaling);
% ======================================================================
% *** END FUNCTION lms2rgbMB
% ======================================================================