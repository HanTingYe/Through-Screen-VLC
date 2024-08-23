syms P_R P_G P_B;
% x_R = 0.647955994499312;
% x_G = 0.226765799256506;
% x_B = 0.116719242902208;
% y_R = 0.336042005250656;
% y_G = 0.684014869888476;
% y_B = 0.094637223974763;

x_R = 0.169;
x_G = 0.402;
x_B = 0.734;
y_R = 0.007;
y_G = 0.597;
y_B = 0.265;

x = 0.27;
y = 0.23;
P = 1;

% x = P_R*x_R+P_G*x_G+P_B*x_B;
% y = P_R*y_R+P_G*y_G+P_B*y_B;
% P = P_R+P_G+P_B;
% [P_1, P_2, P_3] = solve(x,y,P,P_R,P_G,P_B);
% double([P_1, P_2, P_3])


%BC=A, solve C=B\A
A = [x;y;P];
B = [x_R x_G x_B; y_R y_G y_B; 1 1 1];
C = B\A;