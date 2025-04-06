clc
clear

%%

wp = whitepoint('D65');
wpMag = sum(wp,2);
x_whitepoint = wp(:,1)./wpMag;
y_whitepoint = wp(:,2)./wpMag;


%%
figure(1)

x_center=[0.734; 0.011; 0.169];
y_center=[0.265; 0.733; 0.007];

plotChromaticity

hold on
scatter(x_whitepoint,y_whitepoint,36,'black')
scatter(x_center,y_center,36,'black')
plot([x_center; x_center],[y_center; y_center],'k')
hold off

%% 4CSK
figure(2)

x_4CSK=[0.011; 0.305; 0.169; 0.734];
y_4CSK=[0.733; 0.335; 0.007; 0.265];

plotChromaticity

hold on
scatter(x_4CSK,y_4CSK,36,'black')
plot([x_center; x_center],[y_center; y_center],'k')
hold off

%% 8CSK
figure(3)

x_8CSK=[0.064; 0.188; 0.470; 0.452; 0.011; 0.169; 0.252; 0.734];
y_8CSK=[0.491; 0.237; 0.366; 0.136; 0.733; 0.007; 0.577; 0.265];

plotChromaticity

hold on
scatter(x_8CSK,y_8CSK,36,'black')
plot([x_center; x_center],[y_center; y_center],'k')
hold off

%% 16CSK
figure(4)

x_16CSK=[0.011; 0.109; 0.162; 0.064; 0.493; 0.252; 0.305; 0.350; 0.734; 0.169; 0.116; 0.214; 0.546; 0.591; 0.546; 0.357];
y_16CSK=[0.733; 0.600; 0.358; 0.491; 0.421; 0.577; 0.335; 0.444; 0.265; 0.007; 0.249; 0.116; 0.179; 0.288; 0.179; 0.093];

plotChromaticity

hold on
scatter(x_16CSK,y_16CSK,36,'black')
plot([x_center; x_center],[y_center; y_center],'k')
hold off