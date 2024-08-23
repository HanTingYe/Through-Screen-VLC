function [j,c,hq,m,h,s,q]=ciecam02(xyz,xyzw,la,yb,para)

% function [j,c,hq,m,h,s,q,cd]=ciecam97s(xyz,xyzw,la,yb,para)
% implements the CIECAM97s colour appearance model
% operates on 1 by 3 matrix xyz containing tristimulus 
% values of the stimulus under the test illuminant
% xyzt and xyzr are 1 by 3 matrices containing the 
% white points for the test and reference conditions 
% la and yb are the luminance and Y tristimulus values of 
% the achromatic background against which the sample is viewed
% para is a 1 by 4 matrix containing c, Nc, Fll and F

f = para(1); c = para(2); nc = para(3);
MH = [0.38971 0.68898 -0.07868; -0.22981 1.18340 0.04641; 0.0 0.0 1.0];
M02 = [0.7328 0.4296 -0.1624; -0.7036 1.6975 0.0061; 0.0030 0.0136 0.9834];
Minv = [1.096124 -0.278869 0.182745; 0.454369 0.473533 0.072098; -0.009628 -0.005698 1.015326];


k = 1/(5*la+1);
fl = (k^4)*la + 0.1*((1-k^4)^2)*((5*la)^(1/3));
n = yb/xyzw(2)
ncb = 0.725*(1/n)^0.2;
nbb = ncb;
z = 1.48+sqrt(n);

% step 1
rgb = M02*xyz'
rgbw = M02*xyzw'


% step 2
D = f*(1-(1/36)*exp((-la-42)/(92)))
D=0.98

% step 3
Dr = (xyzw(2)/rgbw(1))*D+1-D
Dg = (xyzw(2)/rgbw(2))*D+1-D
Db = (xyzw(2)/rgbw(3))*D+1-D

rgbc = rgb;
rgbc(:,1)=Dr*rgb(:,1);
rgbc(:,1)=Dr*rgb(:,1);
rgbc(:,1)=Dr*rgb(:,1);
disp(rgbc)
pause

rgbc(1) = (d*(rgbwr(2)/rgbw(2)) + 1 - d)*rgb(:,1);
rgbc(2) = (d*(rgbwr(2)/rgbw(2)) + 1 - d)*rgb(:,2);
rgbc(3) = (d*(rgbwr(2)/rgbw(2)) + 1 - d)*rgb(:,3);

rgbwc(1) = (d*(rgbwr(2)/rgbw(2)) + 1 - d)*rgbw(1);
rgbwc(2) = (d*(rgbwr(2)/rgbw(2)) + 1 - d)*rgbw(2);
rgbwc(2) = (d*(rgbwr(2)/rgbw(2)) + 1 - d)*rgbw(3);


rgbp = MH*Minv*rgbc;
rgbpw = MH*Minv*rgbwc;

rgbpa(:,1) = (400*(fl*rgbp(:,1)/100).^0.42)./(27.13+(fl*rgbp(:,1)/100).^0.42)+0.1;
rgbpa(:,2) = (400*(fl*rgbp(:,2)/100).^0.42)./(27.13+(fl*rgbp(:,2)/100).^0.42)+0.1;
rgbpa(:,3) = (400*(fl*rgbp(:,3)/100).^0.42)./(27.13+(fl*rgbp(:,3)/100).^0.42)+0.1;

rgbpwa(:,1) = (400*(fl*rgbpw(:,1)/100)^0.42)/(27.13+(fl*rgbpw(:,1)/100)^0.42)+0.1;
rgbpwa(:,2) = (400*(fl*rgbpw(:,2)/100)^0.42)/(27.13+(fl*rgbpw(:,2)/100)^0.42)+0.1;
rgbpwa(:,3) = (400*(fl*rgbpw(:,3)/100)^0.42)/(27.13+(fl*rgbpw(:,3)/100)^0.42)+0.1;

a = rgbpa(:,1) - 12*rgbpa(:,2)/11 + rgbpa(:,3)/11;
b = (rgbpa(:,1) + rgbpa(:,2) - 2*rgbpa(:,3))/9;

% step 7
h = 180*car2pol(a, b)/pi;

% step 8
ehH = [ 20.14   90.00   164.25   237.53  380.14
        0.8     0.7     1.0      1.2     0.8
        0.0    100.0    200.0    300.0   400.0 ];
hh=h;
hh = (1-(hh<20.14)).*hh + (hh<20.14).*(360+20.14);
hh=(hh>=20.14)+(hh>=90)+(hh>=164.25)+(hh>=237.53)+(h>=380.14);

e=ehH(2,i)+(ehH(2,i+1)-ehH(2,i))*(hh-ehH(1,i))/(ehH(1,i+1)-ehH(1,i));
hq=ehH(3,i)+100.0*( (hh-ehH(1,i))/ehH(2,i) )/ ( (hh-ehH(1,i))/ehH(2,i) + (ehH(1,i+1)-hh)/ehH(2,i+1) );
k=floor(hq/100);
Hp=floor(100.0*(hq/100-k)+0.5);

% step 9
A = (2*rgbpa(1) + rgbpa(2) + rgbpa(3)/20 - 2.05)*nbb;
Aw = (2*rgbpwa(1) + rgbpwa(2) + rgbpwa(3)/20 - 2.05)*nbb;

% step 10
z = 1 + sqrt(fll*n);
j = 100*(A/Aw)^(c*z);

% step 11
q = (1.24/c)*((j/100)^0.67)*((Aw + 3)^0.9);

% step 12
s = (5000*sqrt(a^2+b^2)*e*10*nc*nbb/13)/(rgbpa(1) + rgbpa(2) + 21*rgbpa(3)/20);

% step 13
c = 2.44*s^0.69*(j/100.)^(0.67*n)*(1.64-0.29^n);

% step 14
m = c*fl^0.15;












