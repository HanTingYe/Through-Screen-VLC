% ============================================================================
% *** FUNCTION dkl2lms
% ***
% *** function [lms_t] = dkl2lms(lms_b,dkl_rad)
% *** computes lms excitations from dkl coordinates (in rad).
% *** the lms_b are the cone-excitations of the background.
% *** dkl_rad is a vector that contains the derived DKL coordinates
% *** in the order: [luminance; chromatic (L-M); chromatic S-(L+M)] in radians
% *** the lms_t are the cone-excitations of the target.
% ============================================================================

function [lms_t] = dkl2lms(lms_b,dkl_rad)

% compute 3 by 3 matrix in Equation 7.18
% note that this matrix is background-dependent 
B = [1 1 0; 1 -lms_b(1)/lms_b(2) 0; -1 -1 (lms_b(1)+lms_b(2))/lms_b(3)];
% compute the inverse of B as in Equation 7.19
B_inv = inv(B);

% set the three isolating stimuli equal to
% the columns of B_inv. 
lum  = B_inv(:,1); % luminance
chro_LM = B_inv(:,2); % chromatic L+M
chro_S  = B_inv(:,3); % chromatic S

% use the MATLAB function norm 
% to find the pooled cone contrast 
% for each mechanism as in Equation 7.13
lum_pooled  = norm(lum./lms_b);  % k(LUM)
chro_LM_pooled = norm(chro_LM./lms_b); % k(L-M)
chro_S_pooled  = norm(chro_S./lms_b);  % k(S-LUM)

% normalise each isolating stimulus 
% by its pooled contrast such that each mechanism 
% will produce unit response
lum_unit = lum  / lum_pooled;
chroLM_unit = chro_LM / chro_LM_pooled;
chroS_unit  = chro_S  / chro_S_pooled;

% normalise B to obtain the normalising constants
lum_norm = B*lum_unit;
chroLM_norm = B*chroLM_unit;
chroS_norm = B*chroS_unit;

% use the normalising constants to rescale B and obtain unit response.
% first create a diagonal matrix containing the normalising constants.
D_const=[1/lum_norm(1) 0 0; 0 1/chroLM_norm(2) 0;  0 0 1/chroS_norm(3)];
% then rescale B to obtain the matrix transform T.
T = D_const*B;
T_inv=inv(T);
% compute differencial cone excitations
lms_diff = T_inv * dkl_rad;
lms_t = (lms_b-lms_diff);
% ===================================================
% *** END FUNCTION dkl2lms
% ===================================================
