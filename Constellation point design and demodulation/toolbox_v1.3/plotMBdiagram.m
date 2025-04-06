function plotMBdiagram
% plotMBdiagram Plot the MacLeod and Boynton (1979) chromaticity diagram.
% To plot the spectral locus in the diagram I have performed a series of 
% computations starting from the linear cone fundamentals in quantal units.
% The locus is also available at www.cvrl.org
% 
%--------------------------------------------------------------------------
% plotMBdiagram
% =========
% 
% 30-Nov -2011   kr Wrote it.
% Load MB chromaticity coordinates in the rage {390,830} at 1nm interval.
load MBlocus
wavelength=linspace(390,830,441);
close all;
figure(1)
set(gcf,'color','w')
plot(rMB,bMB,'k-', 'LineWidth',4); hold on
% Highlight single coordinates at specific wavelengths as in MB(1979)
% paper. 
plot(rMB(1),bMB(1),'ko', 'LineWidth',4); hold on % 390nm
text(rMB(1)+0.02,bMB(1)+0.02, '390');
plot(rMB(31),bMB(31),'ko', 'LineWidth',4); hold on % 420nm
text(rMB(31)-0.02,bMB(31)-0.08, '420');
plot(rMB(51),bMB(51),'ko', 'LineWidth',4); hold on % 440nm
text(rMB(51)-0.07,bMB(51), '440');
plot(rMB(71),bMB(71),'ko', 'LineWidth',4); hold on % 460nm
text(rMB(71)-0.07,bMB(71), '460');
plot(rMB(91),bMB(91),'ko', 'LineWidth',4); hold on % 480nm
text(rMB(91)-0.07,bMB(91), '480');
plot(rMB(131),bMB(131),'ko', 'LineWidth',4); hold on % 520nm
text(rMB(131),bMB(131)+0.03, '520');
plot(rMB(211),bMB(211),'ko', 'LineWidth',4); hold on % 600nm
text(rMB(211),bMB(211)+0.03, '600');
plot(rMB(311),bMB(311),'ko', 'LineWidth',4); hold on % 520nm
text(rMB(311),bMB(311)+0.03, '700');
% Plot confusion lines.
plot([0 1],[0 1],'g-', 'LineWidth',2); hold on % D line
text(0.9,0.81, 'D');
plot([1 0],[0 1],'r-.', 'LineWidth',2); hold on % P line
text(0.1,0.81, 'P');
plot([0.52 0.52],[0 1],'b--', 'LineWidth',2); hold on % T line

text(0.55,0.81, 'T');

xlabel('rMB','FontSize',9); ylabel('bMB','FontSize',9);
axis([0 1 0 1]);