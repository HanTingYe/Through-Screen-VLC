% ==============================================================================
% *** FUNCTION dkl_sph2cart
% ***
% *** function [dkl_rad] = dkl_sph2cart(dkl_deg)
% *** transforms dkl coordinates from radians to degrees 
% *** and then from spherical to Cartesian.
% *** dkl_deg is a vector containing the DKL coordinates in degrees
% *** in the order: [radius azimuth elevation]
% *** dkl_rad is a vector containing the DKL coordinates in radians
% *** in the order: [luminance; chromatic (L-M); chromatic S-(L+M)] in radians

% ==============================================================================

function [dkl_rad] = dkl_sph2cart(dkl_deg)

% define radius, azimuth and elevation. 
radius        = dkl_deg(1);
azimuth_deg   = dkl_deg(2);
elevation_deg = -dkl_deg(3);
% convert degrees into radians using the 
% MATLAB function degtorad.
azimuth_rad   = degtorad(azimuth_deg);
elevation_rad = degtorad(elevation_deg);

% convert spherical coordinates into Cartesian.
if elevation_deg == 90 
    lum      = radius;
    rgisolum = 0;
    sisolum  = 0;
elseif elevation_deg == -90
    % target is along the luminance axis.
    lum      = radius;
    rgisolum = 0;
    sisolum  = 0;
else
    radius = radius;
    lum        = radius*tan(elevation_rad);   
    chro_LM   = radius*-cos(azimuth_rad);
    chro_S    = radius*sin(azimuth_rad);
end

dkl_rad = [lum chro_LM chro_S]';
% ===================================================
% *** END FUNCTION dkl_cart2sph
% ===================================================