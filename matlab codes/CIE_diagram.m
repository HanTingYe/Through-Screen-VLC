cie_x=0.169;
cie_y=0.007;
figure(1);
plotChromaticity();
hold on;
h1 = plot(cie_x, cie_y);
legend(h1,{'legend_text1'})



figure(2)

%xyz_primaries = rgb2xyz([1 0 0; 0 1 0; 0 0 1],);
xyz_primaries = rgb2xyz([1 0 0; 0 1 0; 0 0 1],'ColorSpace','adobe-rgb-1998');
xyzMag = sum(xyz_primaries,2);
x_primary = xyz_primaries(:,1)./xyzMag;
y_primary = xyz_primaries(:,2)./xyzMag;

wp = whitepoint('D65');
wpMag = sum(wp,2);
x_whitepoint = wp(:,1)./wpMag;
y_whitepoint = wp(:,2)./wpMag;

plotChromaticity

hold on
scatter(x_whitepoint,y_whitepoint,36,'black')
scatter(x_primary,y_primary,36,'black')
plot([x_primary; x_primary],[y_primary; y_primary],'k')
hold off

figure(3)
plotChromaticity("ColorSpace","uv","View",3,"BrightnessThreshold",0)


figure(4)

x_CBC2=[0.734; 0.011; 0.169];
y_CBC2=[0.265; 0.733; 0.007];

plotChromaticity

hold on
scatter(x_whitepoint,y_whitepoint,36,'black')
scatter(x_CBC2,y_CBC2,36,'black')
plot([x_CBC2; x_CBC2],[y_CBC2; y_CBC2],'k')
hold off