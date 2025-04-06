clc
clear

%%

wp = whitepoint('D65');
wpMag = sum(wp,2);
x_whitepoint = wp(:,1)./wpMag;
y_whitepoint = wp(:,2)./wpMag;


%%
figure(1)

x_center=[0.734; 0.402; 0.169];
y_center=[0.265; 0.597; 0.007];

plotChromaticity

hold on
scatter(x_whitepoint,y_whitepoint,36,'black')
scatter(x_center,y_center,36,'black')
plot([x_center; x_center],[y_center; y_center],'k')
hold off

%% 4CSK
figure(2)

x_4CSK=[0.402; 0.435; 0.169; 0.734];
y_4CSK=[0.597; 0.290; 0.007; 0.265];

plotChromaticity

hold on
scatter(x_4CSK,y_4CSK,36,'black')
plot([x_center; x_center],[y_center; y_center],'k')
hold off

%% 8CSK
figure(3)

x_8CSK=[0.324; 0.297; 0.579; 0.452; 0.402; 0.169; 0.513; 0.734];
y_8CSK=[0.400; 0.200; 0.329; 0.136; 0.597; 0.007; 0.486; 0.265];

plotChromaticity

hold on
scatter(x_8CSK,y_8CSK,36,'black')
plot([x_center; x_center],[y_center; y_center],'k')
hold off

%% 16CSK
figure(4)

x_16CSK=[0.402; 0.413; 0.335; 0.324; 0.623; 0.513; 0.435; 0.524; 0.734; 0.169; 0.247; 0.258; 0.546; 0.634; 0.446; 0.357];
y_16CSK=[0.597; 0.495; 0.298; 0.400; 0.376; 0.486; 0.290; 0.384; 0.265; 0.007; 0.204; 0.101; 0.179; 0.273; 0.179; 0.093];

plotChromaticity

hold on
scatter(x_16CSK,y_16CSK,36,'black')
plot([x_center; x_center],[y_center; y_center],'k')
hold off