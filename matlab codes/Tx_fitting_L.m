clc
clear
close all
%%
P_R=[0	7.205540881132442e+02	9.119999999999999e+02	1.046294817089492e+03	1.132688285544402e+03	1.226162726058075e+03	1.304073156554967e+03	1.322407601245275e+03	1.396864003754925e+03	1.457108176226489e+03	1.516094243487106e+03];
P_G=[0	1.242577824203092e+03	1.659544921433368e+03	2.006151866590317e+03	2.211894181403137e+03	2.393083243590952e+03	2.543867835063997e+03	2.688643337261608e+03	2.843660033610471e+03	2.959676108929149e+03	3.075595186023358e+03];
P_B=[0	7.205540881132442e+02	9.119999999999999e+02	1.046294817089492e+03	1.153206734302443e+03	1.243489774100038e+03	1.322407601245275e+03	1.392977282950308e+03	1.505369503985176e+03	1.554815864214589e+03	1.622081627591294e+03];
for i=0:1:10
    U(i+1)=0.1*i*5;
end

for i=0:1:10
    PWM(i+1)=0.1*i;
end

% k_R=polyfit(U,P_R,3);%Polynomial function fitting
% k_G=polyfit(U,P_G,3);%Polynomial function fitting
% k_B=polyfit(U,P_B,3);%Polynomial function fitting
%
% f_R=k_R(1).*U.^3+k_R(2).*U.^2+k_R(3).*U+k_R(4);
% f_G=k_G(1).*U.^3+k_G(2).*U.^2+k_G(3).*U+k_G(4);
% f_B=k_B(1).*U.^3+k_B(2).*U.^2+k_B(3).*U+k_B(4);

% k_R=polyfit(U,P_R,2);%Polynomial function fitting
% k_G=polyfit(U,P_G,2);%Polynomial function fitting
% k_B=polyfit(U,P_B,2);%Polynomial function fitting
%
% f_R=k_R(1).*U.^2+k_R(2).*U+k_R(3);
% f_G=k_G(1).*U.^2+k_G(2).*U+k_G(3);
% f_B=k_B(1).*U.^2+k_B(2).*U+k_B(3);

% k_R=polyfit(U,P_R,1);%Polynomial function fitting
% k_G=polyfit(U,P_G,1);%Polynomial function fitting
% k_B=polyfit(U,P_B,1);%Polynomial function fitting
%
% f_R=k_R(1).*U+k_R(2);
% f_G=k_G(1).*U+k_G(2);
% f_B=k_B(1).*U+k_B(2);

myfun = @(k,U) k(1)*log(1+k(2)*U);
X0=[1 1];
[k_R,resnorm]=lsqcurvefit(myfun,X0,U,P_R)%convex quadratic function fitting
[k_G,resnorm]=lsqcurvefit(myfun,X0,U,P_G)%convex quadratic function fitting
[k_B,resnorm]=lsqcurvefit(myfun,X0,U,P_B)%convex quadratic function fitting

f_R=k_R(1)*log(1+k_R(2)*U);
f_G=k_G(1)*log(1+k_G(2)*U);
f_B=k_B(1)*log(1+k_B(2)*U);



figure(17)
plot(PWM,P_R,'ro-');hold on
plot(PWM,P_G,'go-');hold on
plot(PWM,P_B,'bo-');hold on

plot(PWM,f_R,'k-');hold on
plot(PWM,f_G,'k-');hold on
plot(PWM,f_B,'k-');hold on

xlabel('duty cycle')
ylabel('luminosity')

%%
U_RMAX = 5;
U_GMAX = (exp(f_R(11)/k_G(1))-1)/k_G(2);
U_BMAX = (exp(f_R(11)/k_B(1))-1)/k_B(2);


u_R = 0: U_RMAX/10:U_RMAX;
u_G = 0: U_GMAX/10:U_GMAX;
u_B = 0: U_BMAX/10:U_BMAX;

length_R = length(u_R);
length_G = length(u_G);
length_B = length(u_B);


for i=1: length_R
    Normalized_R(i)=k_R(1)*log(1+k_R(2)*u_R(i))/f_R(11);
end

for i=1: length_G
    Normalized_G(i)=k_G(1)*log(1+k_G(2)*u_G(i))/f_R(11);
end

for i=1: length_B
    Normalized_B(i)=k_B(1)*log(1+k_B(2)*u_B(i))/f_R(11);
end


figure(18)
plot(PWM,Normalized_R,'ro-');hold on
plot(PWM,Normalized_G,'go-');hold on
plot(PWM,Normalized_B,'bo-');hold on

xlabel('duty cycle')
ylabel('luminosity')


%%



x_primary = [0.6774; 0.1888; 0.1313];%RGB
y_primary = [0.2903; 0.6980; 0.0688];%RGB


figure(19)
plotChromaticity

hold on
scatter(x_primary,y_primary,36,'black')
plot([x_primary; x_primary],[y_primary; y_primary],'k')
hold off

%%

% x_test = abs(x_primary(1)-x_primary(3))/2;
% y_test = abs(y_primary(1)-y_primary(3))/2;
x_test = 0.21;
y_test = 0.40;
P = 1;


%BC=A, solve C=B\A
A = [x_test;y_test;P];
B = [x_primary'; y_primary'; 1 1 1];
C = B\A;
%C(1) = 0.5;
%C(3) = 0.5;

for i=1:3
    switch(i)
        case 1
            if C(1)>0
                P_R_output=C(1)*U_RMAX/5;
            else
                P_R_output=0;
            end
        case 2
            if C(2)>0
                P_G_output=C(2)*U_GMAX/5*2;
            else
                P_G_output=0;
            end
        case 3
            if C(3)>0
                P_B_output=C(3)*U_BMAX/5;
            else
                P_B_output=0;
            end
    end
end
