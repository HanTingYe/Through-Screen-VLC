clc
close all
clear

% % 准备一张自己的背景图片
% img = imread('CIE1931_V2.png');
% % 设置图片在绘制时的尺寸
% min_x = 0;
% max_x = 52.5;
% min_y = 0;
% max_y = 20;
%  
% %绘制自己的图形的数据
%  
% alteredX=[38.7 43.6 20.1 7.8 7.9];
% alteredY=[5.5 16.8 19.1 7.5 17.6];
%  
% %插入背景图 
%  
% imagesc([min_x max_x], [min_y max_y], flipdim(img,1));
% % NOTE: if your image is RGB, you should use flipdim(img, 1) instead of flipud.
% hold on;
%  
% %绘制自己的图形
% plot(alteredX,alteredY,'r','MarkerSize',10);
% set(gca,'ydir','normal');


%sRGB
% xyz_primaries = rgb2xyz([1 0 0; 0 1 0; 0 0 1]);
% 
% xyzMag = sum(xyz_primaries,2);
% x_primary = xyz_primaries(:,1)./xyzMag;
% y_primary = xyz_primaries(:,2)./xyzMag;
% 
% wp = whitepoint('D65');
% 
% wpMag = sum(wp,2);
% x_whitepoint = wp(:,1)./wpMag;
% y_whitepoint = wp(:,2)./wpMag;
% 
% plotChromaticity
% 
% hold on
% scatter(x_whitepoint,y_whitepoint,36,'black')
% scatter(x_primary,y_primary,36,'black')
% plot([x_primary; x_primary],[y_primary; y_primary],'k')
% hold off


%sRGB
xyz_primaries_srgb = rgb2xyz([1 0 0; 0 1 0; 0 0 1]);

xyzMag_srgb = sum(xyz_primaries_srgb,2);
x_primary_srgb = xyz_primaries_srgb(:,1)./xyzMag_srgb;
y_primary_srgb = xyz_primaries_srgb(:,2)./xyzMag_srgb;

%adobeRGB
xyz_primaries_adobergb = rgb2xyz([1 0 0; 0 1 0; 0 0 1],'ColorSpace','adobe-rgb-1998');

xyzMag_adobergb = sum(xyz_primaries_adobergb,2);
x_primary_adobergb = xyz_primaries_adobergb(:,1)./xyzMag_adobergb;
y_primary_adobergb = xyz_primaries_adobergb(:,2)./xyzMag_adobergb;


%DCI-P3
x_primary_dcip3 = [0.68; 0.265; 0.15];
y_primary_dcip3 = [0.32; 0.69; 0.06];


%Tx
% x_primary = [0.6774; 0.1888; 0.1313];%RGB
% y_primary = [0.2903; 0.6980; 0.0688];%RGB
x_primary = [0.6544; 0.1776; 0.1307];%RGB
y_primary = [0.3205; 0.7188; 0.0711];%RGB


% wp = whitepoint('D65');
% 
% wpMag = sum(wp,2);
% x_whitepoint = wp(:,1)./wpMag;
% y_whitepoint = wp(:,2)./wpMag;


figure(2)
plotChromaticity
grid off;

hold on
% scatter(x_whitepoint,y_whitepoint,36,'black')
scatter(x_primary_adobergb,y_primary_adobergb,36,'black')
plot([x_primary_adobergb; x_primary_adobergb],[y_primary_adobergb; y_primary_adobergb],'k-o','MarkerFaceColor','k','MarkerSize',8,'linewidth',2)
scatter(x_primary_srgb,y_primary_srgb,36,'w')
plot([x_primary_srgb; x_primary_srgb],[y_primary_srgb; y_primary_srgb],'w-o','linewidth',1,'MarkerSize',6)

scatter(x_primary_dcip3,y_primary_dcip3,36,'w')
plot([x_primary_dcip3; x_primary_dcip3],[y_primary_dcip3; y_primary_dcip3],'w-o','linewidth',1,'MarkerSize',6)
% scatter(x_primary,y_primary,36,'black')
% plot([x_primary; x_primary],[y_primary; y_primary],'k--s','MarkerSize',8,'linewidth',2)
ax=gca(figure(2))
labelWavelengths(ax);



function labelWavelengths(ax)
%labelWavelengths Label wavelengths on spectral boundary.

lambda = [440 460 480 490 500 510 520 540 ...
   560 580 600 690];

tick_length = 0.02;

for k = 1:length(lambda)
   lambda_k = lambda(k);
   xy = xyz2xyy(lambda2xyz(lambda_k));
   
   % Use complex values as a convenient way to estimate the local
   % tangent slope and normal directions.
   xy = xy(1) + 1i*xy(2);
   v = xyz2xyy(lambda2xyz(lambda_k + 1)) - ...
      xyz2xyy(lambda2xyz(lambda_k - 1));
   v = v(1) + 1i*v(2);
   v = v/abs(v);
   n = v * exp(1i * pi/2);
   
   % Draw the tick.
   xy2 = xy + tick_length*n;
   line('XData',[real(xy) real(xy2)],...
      'YData',[imag(xy) imag(xy2)],...
      'LineWidth',2,...
      'Color','k',...
      'Parent',ax);
   
   % Draw the text label at the appropriate angle.
   text_angle = rad2deg(angle(n));
   if ((90 < text_angle) && (text_angle <= 180)) || ...
         ((-180 <= text_angle) && (text_angle < -90))
      text_angle = text_angle + 180;
      h_align = 'right';
   else
      h_align = 'left';
   end
   xy3 = xy + 1.5*tick_length*n;
   text(real(xy3),imag(xy3),string(lambda_k),'Color','k',...
      'Rotation',text_angle,...
      'HorizontalAlignment',h_align)
end
end
