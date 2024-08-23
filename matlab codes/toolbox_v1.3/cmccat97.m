% ===================================================
% *** FUNCTION cmccat97
% ***
% *** function [xyzc] = cmccat97(xyz,xyzt,xyzr,la,f)
% *** implements the cmccat97s CAT 
% *** xyz must be an n by 3 matrix of XYZ
% *** xyzt and xyzr contain white points
% *** f has default value of 1
% *** la is the luminance of the adapting field and
% *** has a default value of 100
% *** see also 
function [xyzc] = cmccat97(xyz,xyzt,xyzr,la,f)

if (size(xyz,2)~=3)
   disp('first input must be n by 3'); return;   
end
if (length(xyzt)~=3 | length(xyzr)~=3)
   disp('check white point inputs'); return;   
end

if (nargin<5)
   disp('using default values of la and f')
   la = 100; f=1;
end

xyzc = xyz; % to allocate memory
rgb = xyz;

% define the matrix for the transform to 'cone' space
M(1,:) = [0.8951 0.2664 -0.1614];
M(2,:) = [-0.7502 1.7135 0.0367];
M(3,:) = [0.0389 -0.0685 1.0296];

% normalise xyz and transform to rgb
rgb = (M*(xyz./[xyz(:,2) xyz(:,2) xyz(:,2)])')';
rgbt = M*(xyzt/xyzt(2))';
rgbr = M*(xyzr/xyzr(2))';

%  compute d, the degree of adaptation
d = f - f/(1 + 2*(la^0.25) + la*la/300);
% clip d if it is outside the range [0,1]
if (d<0)
   d=0;
elseif (d>1)
   d=1;
end
p = (rgbt(3)/rgbr(3))^0.0834;

% compute corresponding rgb values
rgbc(:,1) = rgb(:,1)*(d*rgbr(1)/rgbt(1) + 1 - d);
rgbc(:,2) = rgb(:,2)*(d*rgbr(2)/rgbt(2) + 1 - d);
rgbc(:,3) = abs(rgb(:,3)).^p*(d*(rgbr(3)/(rgbt(3)^p)) + 1 - d);
index = (rgb(:,3)<0);
rgbc(:,3) = index.*(-rgbc(:,3)) + (1-index).*rgbc(:,3);

% define the matrix for the inverse transform
IM(1,:) = [0.98699 -0.14705 0.15996];
IM(2,:) = [0.43231 0.51836 0.04929];
IM(3,:) = [-0.00853 0.04004 0.96849];

% implement step 4: convert from rgb to xyz
xyzc = [xyz(:,2) xyz(:,2) xyz(:,2)].*(IM*rgbc')'; 