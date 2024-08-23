figure(26)

x_primary = [0.6774; 0.1888; 0.1313];%RGB
y_primary = [0.2903; 0.6980; 0.0688];%RGB



plotChromaticity

hold on
scatter(x_primary,y_primary,36,'black')
plot([x_primary; x_primary],[y_primary; y_primary],'k')
scatter(0.6774,0.2903,60,'s','b');%r:0.6544,0.3205; y: 0.46,0.48; w: 0.3350,0.3722
hold off