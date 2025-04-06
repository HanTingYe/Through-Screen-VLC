function plotFundamentals
% PLOTFUNDAMENTALS Plot the selected cone sensitivities.
%--------------------------------------------------------------------------
% plotFundamentals
% =========
% 
% The function plots the cone fundamentls.
%
% Usage
% =====
% plotFuntadentals(fundamentals)
%
% Parameters
% ==========
%
% fundamentals            - This is a matrix Nx3 containing the selected
%                    cone sensitivities.
%
%
% 28-Nov -2011   kr Wrote it.

% Define wavelength range.
wavelength=linspace(390,780,391)
load fundamentals_ss

figure(1)
set(gcf,'color','w')
plot(wavelength, fundamentals(:,1),'r-', 'LineWidth',2)  ; hold on
plot(wavelength, fundamentals(:,2),'g-', 'LineWidth',2)  ; hold on
plot(wavelength, fundamentals(:,3),'b-', 'LineWidth',2)  ; hold on

xlabel('wavelength (nm)','FontSize',9); ylabel('sensitivity','FontSize',9);
axis([390 780 0 1]);