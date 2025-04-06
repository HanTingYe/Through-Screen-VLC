% ===================================================
% *** FUNCTION cieplot
% ***
% *** function = cieplot()
% *** colour representation of chromaticity diagram
% ===================================================
function [] = cieplot()
% load spectral locus xy values at 1-nm intervals
load locus.mat
plot(locus(:,1),locus(:,2),'k','LineWidth',2)
grid on
hold on
axis([0.0 0.85 0.0 0.85])
xlabel('x')
ylabel('y')
% plot the non-spectral locus
plot([locus(1,1) locus(end,1)], [locus(1,2) locus(end,2)],'k','LineWidth',2)
% chromaticity coordinates of spectrum locus
x = [ 0.175596 0.172787 0.170806 0.170085 0.160343 0.146958 0.139149 ...
      0.133536 0.126688 0.115830 0.109616 0.099146 0.091310 0.078130 ...
      0.068717 0.054675 0.040763 0.027497 0.016270 0.008169 0.004876 ...
      0.003983 0.003859 0.004646 0.007988 0.013870 0.022244 0.027273 ...
      0.032820 0.038851 0.045327 0.052175 0.059323 0.066713 0.074299 ...
      0.089937 0.114155 0.138695 0.154714 0.192865 0.229607 0.265760 ...
      0.301588 0.337346 0.373083 0.408717 0.444043 0.478755 0.512467 ...
      0.544767 0.575132 0.602914 0.627018 0.648215 0.665746 0.680061 ...
      0.691487 0.700589 0.707901 0.714015 0.719017 0.723016 0.734674 ]';
y = [ 0.005295 0.004800 0.005472 0.005976 0.014496 0.026643 0.035211 ...
      0.042704 0.053441 0.073601 0.086866 0.112037 0.132737 0.170464 ...
     0.200773 0.254155 0.317049 0.387997 0.463035 0.538504 0.587196 ...
      0.610526 0.654897 0.675970 0.715407 0.750246 0.779682 0.792153 ...
      0.802971 0.812059 0.819430 0.825200 0.829460 0.832306 0.833833 ...
      0.833316 0.826231 0.814796 0.805884 0.781648 0.754347 0.724342 ...
      0.692326 0.658867 0.624470 0.589626 0.554734 0.520222 0.486611 ...
      0.454454 0.424252 0.396516 0.372510 0.351413 0.334028 0.319765 ...
      0.308359 0.299317 0.292044 0.285945 0.280951 0.276964 0.265326 ]';
N = length(x);
i = 1;
e = 1/3;
steps = 25;
xy4rgb = zeros(N*steps*4,5,'double');
for w = 1:N                                     % wavelength
    w2 = mod(w,N)+1;
    a1 = atan2(y(w)  -e,x(w)  -e);              % start angle
    a2 = atan2(y(w2) -e,x(w2) -e);              % end angle
    r1 = ((x(w)  - e)^2 + (y(w)  - e)^2)^0.5;   % start radius
    r2 = ((x(w2) - e)^2 + (y(w2) - e)^2)^0.5;   % end radius
    for c = 1:steps                               % colourfulness
        % patch polygon
        xyz(1,1) = e+r1*cos(a1)*c/steps;
        xyz(1,2) = e+r1*sin(a1)*c/steps;
        xyz(1,3) = 1 - xyz(1,1) - xyz(1,2);
        xyz(2,1) = e+r1*cos(a1)*(c-1)/steps;
        xyz(2,2) = e+r1*sin(a1)*(c-1)/steps;
        xyz(2,3) = 1 - xyz(2,1) - xyz(2,2);
        xyz(3,1) = e+r2*cos(a2)*(c-1)/steps;
        xyz(3,2) = e+r2*sin(a2)*(c-1)/steps;
        xyz(3,3) = 1 - xyz(3,1) - xyz(3,2);
        xyz(4,1) = e+r2*cos(a2)*c/steps;
        xyz(4,2) = e+r2*sin(a2)*c/steps;
        xyz(4,3) = 1 - xyz(4,1) - xyz(4,2);
        % compute sRGB for vertices
        rgb = xyz2srgb(xyz');
        % store the results
        xy4rgb(i:i+3,1:2) = xyz(:,1:2);
        xy4rgb(i:i+3,3:5) = rgb';
        i = i + 4;
    end
end
[rows cols] = size(xy4rgb);
f = [1 2 3 4];
v = zeros(4,3,'double');
for i = 1:4:rows
    v(:,1:2) = xy4rgb(i:i+3,1:2);
    patch('Vertices',v, 'Faces',f, 'EdgeColor','none', ...
    'FaceVertexCData',xy4rgb(i:i+3,3:5),'FaceColor','interp')
end
end
function [rgb] = xyz2srgb(xyz)
    M = [ 3.2406 -1.5372 -0.4986; -0.9689 1.8758 0.0415; 0.0557 -0.2040 1.0570 ];
    [rows cols ] = size(xyz);
    rgb = M*xyz;
    for c = 1:cols
        for ch = 1:3
            if rgb(ch,c) <= 0.0031308
                rgb(ch,c) = 12.92*rgb(ch,c);
            else
                rgb(ch,c) = 1.055*(rgb(ch,c)^(1.0/2.4)) - 0.055;
            end
            % clip RGB
            if rgb(ch,c) < 0
                rgb(ch,c) = 0;
            elseif rgb(ch,c) > 1
                rgb(ch,c) = 1;
            end
        end
    end
end
% ====================================================
% *** END FUNCTION cieplot
% ==================================================== 