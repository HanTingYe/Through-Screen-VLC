% ===================================================
% *** FUNCTION xyz2luv
% ***
% *** function [luv,up,vp] = xyz2lab(xyz, obs, xyzw)
% *** computes LUV and uv prime from XYZ 
% *** xyz is an n by 3 matrix 
% *** e.g. set obs to 'd65_64 for D65 and 1964
% *** set obs to 'user' to use optional argument   
% *** xyzw as the white point
% ===================================================
function [luv,up,vp] = xyz2luv(xyz,obs)

if (size(xyz,2)~=3)
   disp('xyz must be n by 3'); return;   
end
luv = zeros(size(xyz,1),size(xyz,2));

if strcmp('a_64',obs)
    white=[111.144 100.00 35.200];
elseif strcmp('a_31', obs)
    white=[109.850 100.00 35.585];
elseif strcmp('c_64', obs)
    white=[97.285 100.00 116.145];
elseif strcmp('c_31', obs)
    white=[98.074 100.00 118.232];
elseif strcmp('d50_64', obs)
    white=[96.720 100.00 81.427];
elseif strcmp('d50_31', obs)
    white=[96.422 100.00 82.521];
elseif strcmp('d55_64', obs)
    white=[95.799 100.00 90.926];
elseif strcmp('d55_31', obs)
    white=[95.682 100.00 92.149];
elseif strcmp('d65_64', obs)
    white=[94.811 100.00 107.304];
elseif strcmp('d65_31', obs)
    white=[95.047 100.00 108.883];
elseif strcmp('d75_64', obs)
    white=[94.416 100.00 120.641];
elseif strcmp('d75_31', obs)
    white=[94.072 100.00 122.638];
elseif strcmp('f2_64', obs)
    white=[103.279 100.00 69.027];
elseif strcmp('f2_31', obs)
    white=[99.186 100.00 67.393];
elseif strcmp('f7_64', obs)
    white=[95.792 100.00 107.686];
elseif strcmp('f7_31', obs)
    white=[95.041 100.00 108.747];
elseif strcmp('f11_64', obs)
    white=[103.863 100.00 65.607]; 
elseif strcmp('f11_31', obs)
    white=[100.962 100.00 64.350];
elseif strcmp('user', obs)
    white=xyzw;
else
   disp('unknown option obs'); 
   disp('use d65_64 for D65 and 1964 observer'); return;
end


% compute u' v' for sample
up = 4*xyz(:,1)./(xyz(:,1) + 15*xyz(:,2) + 3*xyz(:,3));
vp = 9*xyz(:,2)./(xyz(:,1) + 15*xyz(:,2) + 3*xyz(:,3));
% compute u' v' for white
upw = 4*white(1)/(white(1) + 15*white(2) + 3*white(3));
vpw = 9*white(2)/(white(1) + 15*white(2) + 3*white(3));

index = (xyz(:,2)/white(2) > 0.008856);
luv(:,1) = luv(:,1) + index.*(116*(xyz(:,2)/white(2)).^(1/3) - 16);  
luv(:,1) = luv(:,1) + (1-index).*(903.3*(xyz(:,2)/white(2)));  

luv(:,2) = 13*luv(:,1).*(up - upw);
luv(:,3) = 13*luv(:,1).*(vp - vpw);

end


















