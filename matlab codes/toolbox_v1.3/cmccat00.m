% ===================================================
% *** FUNCTION cmccat00
% ***
% *** function [xyzc] = cmccat97(xyz,xyzt,xyzr,lt, lr,f)
% *** implements the cmccat2000 CAT 
% *** xyz must be an n by 3 matrix of XYZ
% *** xyzt and xyzr contain white points
% *** f has default value of 1
% *** lt and lr are the luminances of the adapting 
% *** test and reference fields and default to 100
% *** see also cmccat97
function [xyzc] = cmccat00(xyz,xyzt,xyzr,lt,lr, f)

if (size(xyz,2)~=3)
   disp('first input must be n by 3'); return;   
end
if (length(xyzt)~=3 | length(xyzr)~=3)
   disp('check white point inputs'); return;   
end

if (nargin<6)
   disp('using default values of la, lt and f')
   la = 100; lt= 100; f=1;
end

xyzc = xyz; % to allocate memory
rgb = xyz;

% define the matrix for the transform to 'cone' space
M(1,:) = [0.7982 0.3389 -0.1371];
M(2,:) = [-0.5918 1.5512 0.0406];
M(3,:) = [0.0008 0.0239 0.9753];

% transform to rgb
rgb = (M*xyz')';
rgbt = M*xyzt';
rgbr = M*xyzr';


%  compute d, the degree of adaptation
d = f*(0.08*log10((lt+lr)/2)+0.76-0.45*(lt-lr)/(lt+lr))
% clip d if it is outside the range [0,1]
if (d<0)
   d=0;
elseif (d>1)
   d=1;
end

% compute corresponding rgb values
a = d*xyzt(2)/xyzr(2)
rgbc(:,1) = rgb(:,1)*(a*rgbr(1)/rgbt(1) + 1 - d);
rgbc(:,2) = rgb(:,2)*(a*rgbr(2)/rgbt(2) + 1 - d);
rgbc(:,3) = rgb(:,3)*(a*rgbr(3)/rgbt(3) + 1 - d);
disp(rgbc)

% define the matrix for the inverse transform
IM(1,:) = [1.076450 -0.237662 0.161212];
IM(2,:) = [0.410964 0.554342 0.034694];
IM(3,:) = [-0.010954 -0.013389 1.024343];

% implement step 4: convert from rgb to xyz
xyzc = (IM*rgbc')'; 