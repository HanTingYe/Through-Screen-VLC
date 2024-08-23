% ===================================================
% *** FUNCTION xyz2srgb
% ***
% *** function [RGB] = xyz2srgb(XYZ)
% *** computes 8-bit sRGB from XYZ 
% *** XYZ is n by 3 and in the range 0-1
% *** see also srgb2xyz
function [RGB] = xyz2srgb(XYZ)
if (size(XYZ,2)~=3)
   disp('XYZ must be n by 3'); return;   
end

M = [3.2406 -1.5372 -0.4986; -0.9689 1.8758 0.0415; 0.0557 -0.2040 1.0570];

RGB = (M*XYZ')';


RGB(RGB<0) = 0;
RGB(RGB>1) = 1;

DACS = zeros(size(XYZ));
index = (RGB<=0.0031308);
DACS = DACS + (index).*(12.92*RGB);
DACS = DACS + (1-index).*(1.055*RGB.^(1/2.4)-0.055);

RGB=ceil(DACS*255);
RGB(RGB<0) = 0;
RGB(RGB>255) = 255;
end