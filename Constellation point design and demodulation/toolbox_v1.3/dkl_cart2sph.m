% ==============================================================================
% *** FUNCTION dkl_cart2sph
% ***
% *** function [dkl_deg] = dkl_cart2sph(dkl_rad)
% *** transforms dkl coordinates from Cartesian to spherical
% *** and then from radians to degrees. 
% *** dkl_rad is a vector containing the DKL coordinates in radians
% *** in the order: [luminance; chromatic (L-M); chromatic S-(L+M)] in radians
% *** dkl_deg is a vector containing the DKL coordinates in degrees
% *** in the order: [radius azimuth elevation]
% ==============================================================================

function [dkl_deg] = dkl_cart2sph(dkl_rad)
 
% compute radius, which represents the excitation of each mechanism. 
 isolum_len     = (sqrt(dkl_rad(2)^2+ dkl_rad(3)^2));

 % compute elevation, which represents the relative luminance of the target. 
 if  isolum_len==0
     elevation_rads = atan(dkl_rad(1)/0.000000001);
 else
     elevation_rads = atan(dkl_rad(1)/isolum_len);
 end

 % compute azimuth, which represents the relative chromaticity of the
 % target.
if dkl_rad(2)> -0.000001 & dkl_rad(2)< 0.000001 & dkl_rad(3)> -0.000001 &  dkl_rad(3)< 0.000001
    % if target is along the luminance axis, 
    % then chro_LM and chro_S are = 0.
    azimuth_rads = 0;
    % Therefore radius is the sqrt of the length of lum^2.
    radius  = sqrt(dkl_rad(1)^2);  
else
    % if target is not along the luminance axis,
    % then the length of radius is
    % a vector given by chro_LM and chro_S only.
    azimuth_rads = atan(-dkl_rad(3)/dkl_rad(2));
    radius  = isolum_len;
end

% convert radians into degrees using the 
% MATLAB function radtodeg.
if dkl_rad(2)>0 & dkl_rad(3)>0
    % if target is in the 'green' quadrant:
    azimuth_deg    = radtodeg(azimuth_rads)+180;
elseif dkl_rad(2)>0 & dkl_rad(3)<0
    % if target is in the 'blue' quadrant:
    azimuth_deg    = radtodeg(azimuth_rads)+180;
elseif dkl_rad(2)<0 & dkl_rad(3)<0
    % if target is in the 'magenta' quadrant:
    azimuth_deg    = 360 + radtodeg(azimuth_rads);  
else
    azimuth_deg    = radtodeg(azimuth_rads);
end

elevation_deg  = -radtodeg(elevation_rads);
dkl_deg = [radius azimuth_deg elevation_deg]';
% ===================================================
% *** END FUNCTION dkl_cart2sph
% ===================================================
