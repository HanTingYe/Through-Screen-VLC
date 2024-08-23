% ===================================================
% *** FUNCTION camera_demo
% ***
% *** function camera_demo1()
% *** demonstrates camera characterization
% *** performs linear, second-order and third-order
% *** modelling to predict XYZ from RGB
% *** requires rgb_cc.mat and xyz_cc.mat are in the path
% *** see also camera_demo
function camera_demo1

load rgb_cc.mat
load xyz_cc.mat
% rgb 240x3
% xyz 240x3

% only use a sub-set of the 240 samples for the analysis
trgb = rgb([14:23 26:35 38:47 50:59 62:71 74:83 86:95 98:107 110:119 122:131 134:143 146:155 158:167 170:179 182:191 194:203 206:215],:)/255;
txyz = xyz([14:23 26:35 38:47 50:59 62:71 74:83 86:95 98:107 110:119 122:131 134:143 146:155 158:167 170:179 182:191 194:203 206:215],:);


% find the linear transform between trgb and txyz
M1=txyz'/trgb';
% use this transform
pxyz1 = (M1*trgb')';
% calculate performance
pxyz1(pxyz1<0)=0;
lab = xyz2lab(txyz,'d65_64');
lab1 = xyz2lab(pxyz1,'d65_64');
de1 = cie00de(lab, lab1);
disp('mean and max colour differences for linear transform');
disp([mean(de1) max(de1)])

% now perform a second-order transform
trgb2 = [trgb trgb(:,1).^2 trgb(:,2).^2 trgb(:,3).^2 trgb(:,1).*trgb(:,2) trgb(:,1).*trgb(:,3) trgb(:,2).*trgb(:,3) ones(170,1)];
M2=txyz'/trgb2';
pxyz2 = (M2*trgb2')';
pxyz2(pxyz2<0)=0;
lab = xyz2lab(txyz,'d65_64');
lab2 = xyz2lab(pxyz2,'d65_64');
de2 = cie00de(lab, lab2);
disp('mean and max colour differences for 2nd-order transform');
disp([mean(de2) max(de2)])


% now perform a third-order transform
trgb3 = [trgb trgb(:,1).^2 trgb(:,2).^2 trgb(:,3).^2 trgb(:,1).*trgb(:,2) trgb(:,1).*trgb(:,3) trgb(:,2).*trgb(:,3) ...
    trgb(:,1).^3 trgb(:,2).^3 trgb(:,3).^3 ...
    trgb(:,1).*trgb(:,1).*trgb(:,2) trgb(:,1).*trgb(:,1).*trgb(:,3) ...
    trgb(:,2).*trgb(:,2).*trgb(:,1) trgb(:,2).*trgb(:,2).*trgb(:,3) ...
    trgb(:,3).*trgb(:,3).*trgb(:,1) trgb(:,3).*trgb(:,3).*trgb(:,2) ...    
    ones(170,1)];
M3=txyz'/trgb3';
pxyz3 = (M3*trgb3')';
pxyz3(pxyz3<0)=0;
lab = xyz2lab(txyz,'d65_64');
lab3 = xyz2lab(pxyz3,'d65_64');
de3 = cie00de(lab, lab3);
disp('mean and max colour differences for 3rd-order transform');
disp([mean(de3) max(de3)])

end

