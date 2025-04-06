% ===================================================
% *** FUNCTION crtdemo
% ***
% *** function = crtdemo
% *** demonstrates use of GOG model to  
% *** characterize a CRT monitor
function crtdemo
% RGB Yxy measured data
rawdata = [255 0 0 17.30 0.610 0.349; ...
0 225 0 61.00 0.296 0.598; ...
0 0 255 8.99 0.145 0.070; ...
0 0 0 0.34 0.360 0.331;
25 25 25 3.36 0.298 0.328 ;
50 50 50 8.91 0.290 0.325;
80 80 80 16.60 0.285 0.320;
120 120 120 29.30 0.284 0.317;
160 160 160 45.80 0.283 0.316;
200 200 200 63.80 0.282 0.313;
220 220 220 73.70 0.282 0.312;
255 255 255 85.40 0.284 0.315;
110 40 170 14.70 0.231 0.159;
250 187 160 63.40 0.327 0.344;
10 180 230 46.20 0.202 0.261;
5 20 240 10.20 0.150 0.084;
240 20 5 17.90 0.585 0.362;
5 240 20 57.40 0.292 0.579;
34 40 32 6.40 0.295 0.363;
220 210 195 69.00 0.294 0.325];

for i=1:20
    Y = rawdata(i,4);
    x = rawdata(i,5);
    y = rawdata(i,6);
    z = 1 - x - y;
    X = x*Y/y;
    Z = z*Y/y;
    XYZ(i,:) = [X Y Z];    
end

% use the white of the display for CIELAB
white = XYZ(12,:);
LAB = xyz2lab(XYZ,'user',white);

M = [XYZ(1,1) XYZ(2,1) XYZ(3,1); XYZ(1,2) XYZ(2,2) XYZ(3,2); XYZ(1,3) XYZ(2,3) XYZ(3,3)];
disp(M)

% get the neutral samples
nXYZ = XYZ(4:12,:);
% get their linear RGB values
nRGB = (inv(M)*nXYZ')';
% and the corresponding non-linear RGBs
dacs=rawdata(4:12,1:3)/255;

% compute the GOG values for each channel
x1=linspace(0,1,101);
% red channel
x = [1, 1];
options = optimset;
x = fminsearch('gogtest',x,options,dacs(:,1), nRGB(:,1)); 
gogvals(1,:) = x;
figure
plot(dacs(:,1),nRGB(:,1),'r*')
y1 = compgog(gogvals(1,:),x1);
hold on
plot(x1,y1,'r-')
% green channel
x = [1, 1];
options = optimset;
x = fminsearch('gogtest',x,options,dacs(:,2), nRGB(:,2)); 
gogvals(2,:) = x;
hold
plot(dacs(:,2),nRGB(:,2),'g*')
y2 = compgog(gogvals(2,:),x1);
hold on
plot(x1,y2,'g-')
% blue channel
x = [1, 1];
options = optimset;
x = fminsearch('gogtest',x,options,dacs(:,3), nRGB(:,3)); 
gogvals(3,:) = x;
hold on
plot(dacs(:,3),nRGB(:,3),'b*')
y3 = compgog(gogvals(3,:),x1);
hold on
plot(x1,y3,'b-')
disp(gogvals)


% now takes the dacs of the test samples
% and linearize them using the gogvals
red = rawdata(13:20,1)/255;
RGB(:,1) = compgog(gogvals(1,:), red);
green = rawdata(13:20,2)/255;
RGB(:,2) = compgog(gogvals(2,:), green);
blue = rawdata(13:20,3)/255;
RGB(:,3) = compgog(gogvals(3,:), blue);

linXYZ = (M*RGB')';
linLAB = xyz2lab(linXYZ,'user',white);
DE = cmcde(LAB(13:20,:),linLAB,2,1);

disp([mean(DE) max(DE)])
end

% function [err] = gogtest(gogs,dacs,rgbs)
% computes the error between measured and predicted 
% linearized dac values for a given set of GOG values
% gogs is a 2 by 1 matrix that contains the gamma and gain
% dacs is an n by 1 matrix that contains the actual RGB values
% obtained by dividing the RGB values by 255
% rgbs is an n by 1 matrix that is obtained from a linear 
% transform of measured XYZ values
function [err] = gogtest(gogs,dacs,rgbs)

gamma = gogs(1);
gain = gogs(2);

% force to be row matrices
dacs = dacs(:)';
rgbs = rgbs(:)'; 

if (length(dacs) ~= length(rgbs))
   disp('dacs and rgbs vectors must be the same length'); 
   err = 0;
   return
end

% compute gog model predictions
for i=1:length(dacs)
   if (gain*dacs(i) + (1-gain)) <= 0
      pred(i)=0;      
   else
      pred(i)=(gain*dacs(i) + (1-gain))^gamma;    
   end
end

% force to be a row matrix
pred = pred(:)';
% compute rms error
err = sqrt((sum((rgbs-pred).*(rgbs-pred)))/length(dacs));
end

% function [rgb] = compgog(gogs,dacs)
% computes the linearized RGB values  
% from the normalized RGB values 
% for a given set of gog values
% gog is a 2 by 1 matrix that contains the gamma and gain
% dacs is an n by 1 matrix that contains the RGB values
% rgb is an n by 1 matrix of linearized RGB values 
function [rgb] = compgog(gogs,dacs)

gamma = gogs(1);
gain = gogs(2);
for i=1:length(dacs)
   if (gain*dacs(i) + (1-gain)) <= 0
      rgb(i)=0;      
   else
      rgb(i)=(gain*dacs(i) + (1-gain))^gamma;    
   end
end
% force output to be a column vector
rgb=rgb(:);
end

