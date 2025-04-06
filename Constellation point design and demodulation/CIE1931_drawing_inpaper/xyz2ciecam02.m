function out = xyz2ciecam02(XYZ,XYZ_w,L_A,Y_b,surround)
%xyz2ciecam02 Convert XYZ values to CIECAM02.
%
%   out = xyz2ciecam02(XYZ,XYZ_w,L_A,Y_b,surround) converts the Mx3
%   matrix of CIE XYZ values to a table of CIECAM02 values. XYZ is
%   assumed to contain CIE 1931 Standard Colorimetric Observer (2
%   degree) values in the range [0.0,1.0].
%
%   XYZ_w is a three-element vector containing the CIE XYZ values
%   for the adopted white point.
%
%   L_A is the adapting luminance (in cd/m^2).
%
%   Y_b is the relative background luminance (in the range
%   [0.0,1.0].
%
%   surround is either 'average' (the typical relative luminance for
%   viewing reflection prints), 'dim' (the typical relative
%   luminance for CRT displays or televisions), or 'dark' (the
%   typical relative luminance for projected transparencies).
%
%   REFERENCE
%
%   Mark D. Fairchild, Color Appearance Models, 3rd edition, John
%   Wiley & Sons, 2013, pp. 287-302.
%
%   EXAMPLE
%
%   Convert an XYZ color to CIECAM02. (From Fairchild, Table 16.4,
%   Case 1, p. 299)
%
%       XYZ = [0.1901 0.2000 0.2178];
%       XYZ_w = [0.9505 1.0000 1.0888];
%       L_A = 318.31;
%       Y_b = 0.20;
%       surround = 'average';
%       out = xyz2ciecam02(XYZ,XYZ_w,L_A,Y_b,surround)
%
%   See also xyz2ciecam02.

%   Copyright MathWorks 2016-2018

% Image Processing Toolbox uses tristimulus values in the range
% [0,1]. The CIECAM02 conversion assumes tristimulus values in the
% range [0,100].
XYZ = 100 * XYZ;
XYZ_w = 100 * XYZ_w;

Y_b = 100 * Y_b;

% Fairchild, Color Appearance Models, 3rd ed., Wiley, 2013.

% Equation (16.1), Fairchild, p. 290.
M_cat02 = [ ...
    0.7328  0.4296 -0.1624
   -0.7036  1.6975  0.0061
    0.0030  0.0136  0.9834];

% Equation (16.2), Fairchild, p. 290.
RGB = XYZ * M_cat02';

% "The transformation must also be completed for the tristimulus
% values of the adapting stimulus." Fairchild, p. 290.
RGB_w = XYZ_w * M_cat02';

% Table 16.1, Fairchild, p. 289.
switch surround
   case 'average'
      c = 0.69;
      N_c = 1.0;
      F = 1.0;
      
   case 'dim'
      c = 0.59;
      N_c = 0.9;
      F = 0.9;
      
   case 'dark'
      c = 0.525;
      N_c = 0.8;
      F = 0.8;
end

% Equation (16.3), Fairchild, p. 290.
D = F*(1 - (1/3.6)*exp(-(L_A + 42)/92));

% Equations (16.4) - (16.6), Fairchild, p. 290-291.
% Equations (7.4) - (7.6), CIE 159:2004,
% R_w = RGB_w(1);
% G_w = RGB_w(2);
% B_w = RGB_w(3);
% 
% R = RGB(:,1);
% G = RGB(:,2);
% B = RGB(:,3);

Y_w = XYZ_w(2);
% RGB_c = ((Y_w * D ./ RGB_w) + (1 - D)) .* RGB;
RGB_c = bsxfun(@times,((Y_w * D ./ RGB_w) + (1 - D)),RGB);

% R_c = ((100*D/R_w) + (1-D))*R;
% G_c = ((100*D/G_w) + (1-D))*G;
% B_c = ((100*D/B_w) + (1-D))*B;
% RGB_c = [R_c G_c B_c];

RGB_w_c = ((Y_w * D ./ RGB_w) + (1 - D)) .* RGB_w;

% R_w_c = ((100*D/R_w) + (1-D))*R_w;
% G_w_c = ((100*D/G_w) + (1-D))*G_w;
% B_w_c = ((100*D/B_w) + (1-D))*B_w;
% RGB_w_c = [R_w_c G_w_c B_w_c];

% Equation (16.7), Fairchild, p. 292.
k = 1/(5*L_A + 1);

% Equation (16.8), Fairchild, p. 292.
F_L = (0.2 * k^4 * 5 * L_A) + 0.1*(1-k^4)^2 * (5*L_A)^(1/3);

% Equation (16.9), Fairchild, p. 292.
n = Y_b / Y_w;

% Equation (16.10), Fairchild, p. 292.
N_bb = 0.725*(1/n)^0.2;
N_cb = N_bb;

% Equation (16.11), Fairchild, p. 292.
z = 1.48 + sqrt(n);

% Equation (16.13), Fairchild, p. 293.
M_HPE = [ ...
    0.38971  0.68898  -0.07868
    -0.22981 1.18340   0.04641
    0.00000  0.00000   1.00000 ];

% Equation (16.12), Fairchild, p. 292.
RGB_p = (M_HPE * (M_cat02 \ RGB_c'))';
RGB_w_p = (M_HPE * (M_cat02 \ RGB_w_c'))';

% Equations (16.15) - (16.17), Fairchild, p. 292.
% "If any of the values of R', G', or B' are negative, then their absolute
% values must be used, and then the quotient term in Equations 7.15 through
% 7.17 must be multiplied by a negative 1 before adding the value 0.1" CIE
% 159:2004, p. 8.

f = @(RGB) sign(RGB) .* (400 * (F_L * abs(RGB) / 100).^0.42) ./ (27.13 + (F_L * abs(RGB) / 100).^0.42) + 0.1;
RGB_ap = f(RGB_p);
RGB_w_ap = f(RGB_w_p);

% RGB_ap = (400 * (F_L * RGB_p / 100).^0.42) ./ (27.13 + (F_L * RGB_p / 100).^0.42) + 0.1;
% RGB_w_ap = (400 * (F_L * RGB_w_p / 100).^0.42) ./ (27.13 + (F_L * RGB_w_p / 100).^0.42) + 0.1;

% Initial opponent-type responses. Equations (16.18) and (16.19), Fairchild,
% p. 294.
R_ap = RGB_ap(:,1);
G_ap = RGB_ap(:,2);
B_ap = RGB_ap(:,3);
a = R_ap - 12*G_ap/11 + B_ap/11;
b = (R_ap + G_ap - 2*B_ap)/9;

% Hue angle, h, "expressed in degrees ranging from 0 to 360 measured from
% the positive a axis." Equation (16.20), Fairchild, p. 294.
h = atan2(b,a);
h(h<0) = h(h<0) + 2*pi;
h = h * (180/pi);

% Eccentricity factor, equation (16.21), Fairchild, p. 294.
e_t = (1/4) * (cos(h*pi/180 + 2) + 3.8);

% Convert from hue angle to hue quadrature. Equation (16.22) and Table 16.2,
% Fairchild, p. 294.
h_p = h;
add360 = h_p < 20.14;
h_p(add360) = h_p(add360) + 360;

i = (h_p >= 20.14) + ...
    (h_p >= 90) + ...
    (h_p >= 164.25) + ...
    (h_p >= 237.53);

h_i = [20.14 90.00 164.25 237.53 380.14]';
e_i = [0.8 0.7 1.0 1.2 0.8]';
H_i = [0 100 200 300 400]';

H = H_i(i) + (100*(h_p - h_i(i))./e_i(i)) ./ ...
    ((h_p - h_i(i))./e_i(i) + (h_i(i+1) - h_p)./e_i(i+1));


% Lightness, equations (16.23) and (16.24), Fairchild,
% p. 295.
A = (2*R_ap + G_ap + (1/20)*B_ap - 0.305) * N_bb;
A_w = (2*RGB_w_ap(1) + RGB_w_ap(2) + (1/20)*RGB_w_ap(3) - 0.305) * N_bb;

J = 100 * (A / A_w).^(c*z);

% Brightness, equation (16.25), Fairchild, p. 295.
Q = (4/c) * sqrt(J/100) * (A_w + 4) * F_L^0.25;

% Chroma, equations (16.26) and (16.27), Fairchild, pp. 295-296.
t = (50000/13) * N_c * N_cb * e_t .* sqrt(a.^2 + b.^2);
t = t ./ (R_ap + G_ap + (21/20)*B_ap);
C = t.^0.9 .* sqrt(J/100) .* (1.64 - 0.29^n).^0.73;

% Colorfulness, equation (16.28), Fairchild, p. 296.
M = C .* F_L^0.25;

% Saturation, equation (16.29), Fairchild, p. 296.
s = 100 * sqrt(M ./ Q);

out = table(J,Q,C,M,s,h,H);