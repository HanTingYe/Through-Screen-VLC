function plotDeviceSPDs
% PLOTFUNDAMENTALS Plot the selected cone sensitivities.
%--------------------------------------------------------------------------
% plotFundamentals
% =========
% 
% The function plots the display device SPDs.
%
% Usage
% =====
% plotDeviceSPDs
%
% Parameters
% ==========
%
% phosphors            - This is a matrix Nx3 containing the spectral power
%                         distributions of the monitor. 
%                       
%
% 28-Nov -2011   kr Wrote it.

% Define wavelength range.
wavelength = linspace(390,780,391)
load phosphors

figure(2)
set(gcf,'color','w')
plot(wavelength, phosphors(:,1),'r-', 'LineWidth',2)  ; hold on
plot(wavelength, phosphors(:,2),'g-', 'LineWidth',2)  ; hold on
plot(wavelength, phosphors(:,3),'b-', 'LineWidth',2)  ; hold on

xlabel('wavelength (nm)','FontSize',9); ylabel('radiance (W/sr*sqm)','FontSize',9);
% Scale y-axis according to maximum peak.
peak1=max(phosphors(:,1));
peak2=max(phosphors(:,2));
peak3=max(phosphors(:,3));
peaks=[peak1 peak2 peak3];
[Ymax Imax]=max(peaks);
axis([390 780 0 Ymax]);
