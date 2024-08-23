% ===================================================
% *** FUNCTION cband
% ***
% *** Stearns-Stearns spectral bandpass correction 
% *** operates on matrix P of dimensions n by m 
% *** n spectra each at m wavelengths
% ===================================================
function printer_demo
wave = linspace(400,700,31);
load halftone.mat  
% conc is 120x2
% P is 120x31
% W is 1x31

n = 20;

% get the colour ramp for magenta ink
mag = [W; P([11 22 33 44 55 66 77 88 99 110],:)];
figure; plot(wave,mag)
% get the colour ramp for yellow ink
yel = [W; P(1:10,:)];
figure; plot(wave,yel)

% get tone reproduction curves
dig = linspace(0,1,11);
[mag_trc] = gettrc(dig,mag,W,mag(11,:),n);
[yel_trc] = gettrc(dig,yel,W,yel(11,:),n);

for i=1:120

conc = concs(i,:);
meas = P(i,:);

mag_dig = polyval(mag_trc, conc(1));
yel_dig = polyval(yel_trc, conc(2));
      
% get the areas using Dimechel
Am = mag_dig*(1-yel_dig);
Ay = yel_dig*(1-mag_dig);
Aw = (1-mag_dig)*(1-yel_dig);
Ao = mag_dig*yel_dig;
       
% get the colour of the overlap region
overlap = P(120,:);
         
for w = 1:31
    pred(i,w)=(Am*(mag(11,w))^(1/n) + ...
     Ay*(yel(11,w))^(1/n) + ...
     Ao*(overlap(w))^(1/n) + Aw*(W(w))^(1/n))^n;
end

% figure
% plot(wave,meas,'ro')
% hold on
% plot(wave,pred,'b-')
end

xyz = r2xyz([W; P],400,700,'d65_64');
rgbm = xyz2srgb(xyz/100);
lab=xyz2lab(xyz,'d65_64');

xyz = r2xyz([W; pred],400,700,'d65_64');
rgbp = xyz2srgb(xyz/100);
labp=xyz2lab(xyz,'d65_64');

de = cie00de(lab,labp);
disp(mean(de))


figure
subplot(2,2,1)
plot(wave,P(32,:),'ro')
hold on
plot(wave,pred(32,:),'k-')
xlabel('wavelength')
ylabel('reflectance')
axis([400 700 0 1])
subplot(2,2,2)
plot(wave,P(50,:),'ro')
hold on
plot(wave,pred(50,:),'k-')
xlabel('wavelength')
ylabel('reflectance')
axis([400 700 0 1])
subplot(2,2,3)
plot(wave,P(65,:),'ro')
hold on
plot(wave,pred(65,:),'k-')
xlabel('wavelength')
ylabel('reflectance')
axis([400 700 0 1])
subplot(2,2,4)
plot(wave,P(112,:),'ro')
hold on
plot(wave,pred(112,:),'k-')
xlabel('wavelength')
ylabel('reflectance')
axis([400 700 0 1])

end
% ====================================================
% *** END FUNCTION cband
% ====================================================

function [p] = gettrc(dig,R,W,Solid,n);

% function [p] = gettrc(dig,R,W,Solid,n,graphs)
% gettrc function to compute the trc for an ink
% function [p] = gettrc(dig,R,W,Solid,n,graphs);
% dig is an 1 by n matrix of target area coverages
% R is an n by m matrix of measured reflectance values
% W is a 1 by m matrix of reflectance for the white substrate
% Solid is a 1 by m matrix of reflectance for the solid ink
% n is a free parameter > 0
% p is a matrix containing the coefficients of a polynomial to 
% relate target coverage to actual coverage


num = length(dig);

R = R.^(1/n);
W = W.^(1/n);
Solid = Solid.^(1/n);

for i=1:num
   c(i) = sum((Solid - R(i,:)).*(Solid - W))/sum((Solid - W).*(Solid - W));
end

c = 1-c;

[p,s]=polyfit(dig,c,3);
figure
plot(dig,c,'k*')
x = linspace(0,1,101);
y = polyval(p,x);
hold on
plot(x,y,'k-')
xlabel('target coverage')
ylabel('actual coverage')

end



