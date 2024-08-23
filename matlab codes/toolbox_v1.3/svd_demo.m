% ===================================================
% *** FUNCTION svd_demo
% ***
% *** function svd_demo
% *** performs svd on set of reflectance spectra
% *** using original and centred data
% *** plots the first three basis functions
% *** rrequires keele.mat is in the path
% ===================================================
function svd_demo
numbas = 3; % the number of basis functions required
load keele.mat
% the keele data are in the 0-100 format
spectra=spectra/100;
w=linspace(400,700,31);

% perform svd
[u1,s1,v1]=svd(spectra);
% only keep the first numbas
v1 = v1(:,1:numbas);
plot(w,v1);
title('1st three basis function without centering')
xlabel('wavelength')

% perform svd on centred data
m = mean(spectra);
diff = spectra-ones(size(spectra,1),1)*m;
[u2,s2,v2] =svd(diff);
% only keep the first numbas
v2 = v2(:,1:numbas);
figure
plot(w,v2);
title('1st three basis function with centering')
xlabel('wavelength')


% find the weights
x1 = v1'*spectra'; % x = v'*spectra;
x2 = v2'*diff';

% reconstruct the spectra from the weights
recon = x1'*v1';
recon1 = x2'*v2'+ones(size(spectra,1),1)*m;


i = round(rand*404);
figure
plot(w,recon(i,:),'b-',w,recon1(i,:),'r-',w,spectra(i,:),'ko')
axis([400 700 0 1])
xlabel('wavelength');
ylabel('reflectance factor');

% compute colour differences
xyz = r2xyz(spectra,400,700,'d65_64');
xyz1 = r2xyz(recon,400,700,'d65_64');
xyz2 = r2xyz(recon1,400,700,'d65_64');
lab = xyz2lab(xyz,'d65_64');
lab1 = xyz2lab(xyz1,'d65_64');
lab2 = xyz2lab(xyz2,'d65_64');
de1 = cielabde(lab,lab1);
de2 = cielabde(lab,lab2);

disp([median(de1) median(de2)]);
end


    
    
    