function plotDKLspace
% Plots the DKL coordinates (after Derrington, Krauskopf and Lennie,
% 1984) of the phosphors and secondary colours. Generate a 3-D solid
% representing the colour gamut of a 21-inch Sony F520 Trinitron monitor.
%
% 09-Dec -2011   kr Wrote it.

% Set DKL coordinates of the phosphors. 
dkl_deg_red     = [0.5484 58.8425 -56.9676];
dkl_deg_green   = [1.0982 99.7294 19.8041];
dkl_deg_blue    = [1.5547 266.3804 -39.5537];  
dkl_deg_white   = [1.7321 0 90.0000];
dkl_deg_black   = [1.7321 0 -90.0000];
dkl_deg_cyan    = [ 0.5484 238.8425 56.9676];
dkl_deg_magenta = [1.0982 279.7294 -19.8041];
dkl_deg_yellow  = [1.5547 86.3804 39.5537];
  
   
DEGS_TO_RADS    = 2*pi/360;
max_elevation   = DEGS_TO_RADS*90;
el_white        = (max_elevation);

% Plot phosphors in cartesian space.
figure(1)
set(gcf,'color','w');
[theta, rho] = meshgrid (0:(2*pi)/36:2*pi+.2, 0:0.1:1);
x            = cos(theta).*rho;
y            = sin(theta).*rho;
surf(x,y,zeros(size(x)),'FaceColor','none');
hold on

% Plot axes
line_width  = 4;
red_line    = [255/255 102/255 153/255];
green_line  = [0 204/255 153/255];
blue_line   = [51/255 153/255 255/255];
yellow_line = [204/255 255/255 0];

plot3([0 1],  [0 0],[0 0],'Color',red_line,  'LineWidth',line_width)
plot3([-1 0], [0 0],[0 0],'Color',green_line,'LineWidth',line_width)

plot3([0 0], [0 1], [0 0],'Color',yellow_line,  'LineWidth',line_width)
plot3([0 0], [-1 0],[0 0],'Color',blue_line,'LineWidth',line_width)

plot3([0 0], [0 0],[0 1], 'Color',[0.8 0.8 0.8],'LineWidth',line_width)
plot3([0 0], [0 0],[-1 0],'Color',[0.4 0.4 0.4],'LineWidth',line_width)

% Define DKL coordinates in radians.
symbol_size = 6;
red_azimuth = dkl_deg_red(2) * DEGS_TO_RADS;
red_elev    = dkl_deg_red(3)* DEGS_TO_RADS;
green_azimuth = dkl_deg_green(2) * DEGS_TO_RADS;
green_elev    = dkl_deg_green(3)* DEGS_TO_RADS;
blue_azimuth = dkl_deg_blue(2) * DEGS_TO_RADS;
blue_elev    = dkl_deg_blue(3)* DEGS_TO_RADS;

% Define DKL coordinates of secondary colours in radians.
cyan_azimuth = dkl_deg_cyan(2) * DEGS_TO_RADS;
cyan_elev    = dkl_deg_cyan(3)* DEGS_TO_RADS;
magenta_azimuth = dkl_deg_magenta(2) * DEGS_TO_RADS;
magenta_elev    = dkl_deg_magenta(3)* DEGS_TO_RADS;
yellow_azimuth = dkl_deg_yellow(2) * DEGS_TO_RADS;
yellow_elev    = dkl_deg_yellow(3)* DEGS_TO_RADS;
white_azimuth = dkl_deg_white(2) * DEGS_TO_RADS;
white_elev    = dkl_deg_white(3)* DEGS_TO_RADS;
black_azimuth = dkl_deg_black(2) * DEGS_TO_RADS;
black_elev    = dkl_deg_black(3)* DEGS_TO_RADS;

[x_red y_red z_red]       = sph2cart(red_azimuth,red_elev, dkl_deg_red(1));
z_red= (red_elev)/max_elevation;
[x_green y_green z_green] = sph2cart(green_azimuth,green_elev, dkl_deg_green(1));
z_green = z_green/max_elevation;
[x_blue y_blue z_blue]    = sph2cart(blue_azimuth,blue_elev, dkl_deg_blue(1));
z_blue= blue_elev/max_elevation;

[x_cyan y_cyan z_cyan]    = sph2cart(cyan_azimuth,cyan_elev, dkl_deg_cyan(1));
z_cyan= cyan_elev/max_elevation;

[x_magenta y_magenta z_magenta]    = sph2cart(magenta_azimuth,magenta_elev, dkl_deg_magenta(1));
z_magenta= magenta_elev/max_elevation;

[x_yellow y_yellow z_yellow]    = sph2cart(yellow_azimuth,yellow_elev, dkl_deg_yellow(1));
z_yellow= yellow_elev/max_elevation;

[x_white y_white z_white]    = sph2cart(white_azimuth,white_elev, dkl_deg_white(1));
z_white= white_elev/max_elevation;

[x_black y_black z_black]    = sph2cart(black_azimuth,black_elev, dkl_deg_black(1));
z_black= black_elev/max_elevation;

plot3(x_red, y_red, z_red); hold on
plot3(x_green, y_green, z_green) ; hold on
plot3(x_blue, y_blue, z_blue) ; hold on
plot3(x_cyan, y_cyan, z_cyan) ; hold on
plot3(x_magenta, y_magenta,z_magenta) ; hold on
plot3(x_yellow, y_yellow, z_yellow) ; hold on
plot3(x_white, y_white, z_white) ; hold on
plot3(x_black, y_black, z_black) ; hold on

% Plot colour gamut of display device.
vertex_matrix=[x_black y_black z_black;
               x_magenta y_magenta z_magenta;
               x_red     y_red     z_red;
               x_yellow  y_yellow  z_yellow;
               x_green   y_green   z_green;
               x_cyan    y_cyan    z_cyan;
               x_blue    y_blue    z_blue;
               x_white   y_white   z_white];
          
faces_matrix=[1 2 3;
    1 3 4;
    1 4 5;
    1 5 6;
    1 6 7;
    1 7 2;
    2 3 8;
    3 4 8;
    4 5 8;
    5 6 8;
    6 7 8;
    7 2 8];

vertex_colour=[0 0 0;
    1 0 1;
    1 0 0;
    1 1 0;
    0 1 0;
    0 1 1;
    0 0 1;
    1 1 1];

patch('Vertices',vertex_matrix,'Faces',faces_matrix,...
      'FaceVertexCData',vertex_colour,'FaceColor','interp','EdgeColor','interp');
 

for i=0:0.05:pi
    az_arc=0; rad_arc=1; el_arc=i;
    [x_arc y_arc z_arc] = sph2cart(az_arc,el_arc, rad_arc);
    plot3(x_arc, y_arc, z_arc,'ko','MarkerFaceColor','k',...
        'MarkerSize',1) ; hold on
    plot3(x_arc, y_arc, -z_arc,'ko','MarkerFaceColor','k',...
        'MarkerSize',1) ; hold on
end

for i=0:0.05:pi
    az_arc=pi/2; rad_arc=1; el_arc=i;
    [x_arc y_arc z_arc] = sph2cart(az_arc,el_arc, rad_arc);
    plot3(x_arc, y_arc, z_arc,'ko','MarkerFaceColor','k',...
        'MarkerSize',1) ; hold on
    plot3(x_arc, y_arc, -z_arc,'ko','MarkerFaceColor','k',...
        'MarkerSize',1) ; hold on
end

text_size=12;
text(1.1,0,'0','Color','k','FontSize',text_size,'FontWeight','bold');
text(1.3,0,'(L - M)','Color',red_line,'FontSize',text_size,'FontWeight','bold');
text(0,1.2,'90','Color','k','FontSize',text_size,'FontWeight','bold');
text(-1.2,0,'180','Color','k','FontSize',text_size,'FontWeight','bold');
text(0,-1.3,'270','Color','k','FontSize',text_size,'FontWeight','bold');
text(0,-2.2,'[S - (L + M)]','Color',blue_line,'FontSize',text_size,'FontWeight','bold');

text(0,0,1.3,'90','Color','k','FontSize',text_size,'FontWeight','bold');
text(0,0.,-1.3,'-90','Color','k','FontSize',text_size,'FontWeight','bold');
text(0,-0.2,1.7,'(L + M)','Color','k','FontSize',text_size,'FontWeight','bold');

view(60,30);
axis off;