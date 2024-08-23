function XYZ = ciecam022xyz(ciecam02,XYZ_w,L_A,Y_b,surround)
%ciecam022xyz Convert CIECAM02 values to XYZ.
%
%   out = ciecam022xyz(in,XYZ_w,L_A,Y_b,surround) converts the table of
%   CIECAM02 values to XYZ (CIE 1931 2-Degree Standard Colorimetric
%   Observer) values. in should be a table with variables J, Q, C, M, s, h,
%   and H.
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
%       J = 41.73;
%       Q = 195.37;
%       C = 0.10;
%       M = 0.11;
%       s = 2.36;
%       h = 219.0;
%       H = 278.1;
%       in = table(J,Q,C,M,s,h,H);
%       XYZ_w = [0.9505 1.0000 1.0888];
%       L_A = 318.31;
%       Y_b = 0.20;
%       surround = 'average';
%       out = ciecam022xyz(in,XYZ_w,L_A,Y_b,surround)
%
%   See also xyz2ciecam02.

%   Copyright MathWorks 2016-2018

XYZ_w = XYZ_w * 100;
Y_w = XYZ_w(2);
Y_b = Y_b * 100;


% Calculate A_w using equations 7.1 through 7.28. CIE 159:2004, p. 9.
n = Y_b / Y_w;
z = 1.48 + sqrt(n);

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

D = F*(1 - (1/3.6)*exp(-(L_A + 42)/92));

N_bb = 0.725*(1/n)^0.2;
N_cb = N_bb;

k = 1/(5*L_A + 1);

F_L = (0.2 * k^4 * 5 * L_A) + 0.1*(1-k^4)^2 * (5*L_A)^(1/3);

M_cat02 = [ ...
   0.7328  0.4296 -0.1624
   -0.7036  1.6975  0.0061
   0.0030  0.0136  0.9834];

M_HPE = [ ...
    0.38971  0.68898  -0.07868
    -0.22981 1.18340   0.04641
    0.00000  0.00000   1.00000 ];

RGB_w = XYZ_w * M_cat02';

RGB_w_c = ((Y_w * D ./ RGB_w) + (1 - D)) .* RGB_w;

RGB_w_p = (M_HPE * (M_cat02 \ RGB_w_c'))';

f = @(RGB) sign(RGB) .* (400 * (F_L * abs(RGB) / 100).^0.42) ./ (27.13 + (F_L * abs(RGB) / 100).^0.42) + 0.1;
RGB_w_ap = f(RGB_w_p);

A_w = (2*RGB_w_ap(1) + RGB_w_ap(2) + (1/20)*RGB_w_ap(3) - 0.305) * N_bb;

% Compute t from C and J.
% Equation 8.6, CIE 159:2004, p. 10.
%

C = ciecam02.C;
J = ciecam02.J;
t = (C ./ (sqrt(J/100) * (1.64 - 0.29.^n).^0.73)) .^ (1/0.9);

% Equation 8.5, CIE 159:2004, p. 10, and Table 3, p. 8.
if ismember('H',ciecam02.Properties.VariableNames) && ...
        ~ismember('h',ciecam02.Properties.VariableNames)
    H = ciecam02.H;
    i = min(floor(H/100)+1,4);
    
    h_i = [20.14 90.00 164.25 237.53 380.14]';
    e_i = [0.8 0.7 1.0 1.2 0.8]';
    H_i = [0 100 200 300 400]';
    
    num = (H - H_i(i)) .* (e_i(i+1).*h_i(i) - e_i(i).*h_i(i+1)) - 100*h_i(i).*e_i(i+1);
    den = (H - H_i(i)) .* (e_i(i+1) - e_i(i)) - 100*e_i(i+1);
    h_p = num ./ den;
    
    h = h_p;
    h(h>360) = h(h>360) - 360;
else
    h = ciecam02.h;
end

% Equation 8.7, CIE 159:2004, p. 10.
e_t = 0.25 * (cos(h*pi/180 + 2) + 3.8);

% Equation 8.8, CIE 159:2004, p. 10.
A = A_w * (J/100).^(1/(c*z));

% Equation 8.9, CIE 159:2004, p. 10.
p_1 = (50000/13) * N_c * N_cb * e_t ./ t;

% Equation 8.10, CIE 159:2004, p. 10.
p_2 = (A/N_bb) + 0.305;

% Equation 8.11, CIE 159:2004, p. 10.
p_3 = 21/20;

% Equation 8.12, CIE 159:2004, p. 10.
h_r = h*(pi/180);

% Equations 8.13 - 8.18, CIE 159:2004, pp. 10-11.
a = zeros(size(h));
b = zeros(size(h));
sin_greater = abs(sin(h_r)) >= abs(cos(h_r));

% Compute a and b values for sin_greater
p_4 = p_1 ./ sin(h_r);
b_1_num = p_2 .* (2 + p_3) * 460 / 1403;
b_1_den = p_4 + (2 + p_3) * (220/1403) * ...
    (cos(h_r)./sin(h_r)) - (27/1403) + p_3*(6300/1403);
b_1 = b_1_num ./ b_1_den;
a_1 = b_1 .* (cos(h_r)./sin(h_r));

% Compute a and b values for ~sin_greater
p_5 = p_1 ./ cos(h_r);
a_2_num = p_2 .* (2 + p_3) * (460/1403);
a_2_den = p_5 + (2 + p_3)*(220/1403) - ((27/1403) - p_3*(6300/1403)) .* (sin(h_r)./cos(h_r));
a_2 = a_2_num ./ a_2_den;
b_2 = a_2 .* (sin(h_r)./cos(h_r));

a(sin_greater) = a_1(sin_greater);
b(sin_greater) = b_1(sin_greater);
a(~sin_greater) = a_2(~sin_greater);
b(~sin_greater) = b_2(~sin_greater);

% "Note that if t is equal to zero, then set a and b equal to zero,
% calculate A using equation 8.8, compute p_2 using equation 8.10 and go
% directly to equation 8.19." CIE 159:2004, p. 10.
t_equal_0 = (t == 0);
a(t_equal_0) = 0;
b(t_equal_0) = 0;

% Equations 8.19 - 8.21, CIE 159:2004, p. 11.

M = [ ...
    460    451    288
    460   -891   -261
    460   -220   -6300
    ] / 1403;

RGB_a_p = [p_2 a b] * M';

% Equations 8.22 - 8.24, CIE 159:2004, p. 11.
RGB_p = (100/F_L) * ( (27.13 * abs(RGB_a_p - 0.1)) ./ (400 - abs(RGB_a_p - 0.1)) ).^(1/0.42);

% "If any of the values of (Ra' - 0.1), (Ga' - 0.1) or (Ba' - 0.1) are
% negative, then the corresponding value R', G' or B' must be made
% negative."
RGB_p = RGB_p .* sign(RGB_a_p - 0.1);

% Equation 8.25, CIE 159:2004, p. 11.
RGB_c = (M_cat02 * (M_HPE \ RGB_p'))';

% Equation 8.27 - 8.29, CIE 159:2004, p. 11.
RGB = RGB_c ./ ((Y_w * D ./ RGB_w) + 1 - D);

% Equation 8.30, CIE 159:2004, p. 11.
XYZ = (M_cat02 \ RGB')';

XYZ = XYZ / 100;