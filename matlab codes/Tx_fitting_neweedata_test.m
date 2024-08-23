clc
clear
close all
%%
%old data
%P_R=[0	1.418604000000000e+04	2.127906000000000e+04	4.255812000000000e+04	4.965113999999999e+04	6.383717999999999e+04	7.802321999999999e+04	9.213832979999999e+04	1.063953000000000e+05		1.205813400000000e+05	1.347673799999999e+05]; %+[0	7.638640000000005e+03	1.329122620000000e+04	2.123540919999999e+04	2.879766280000001e+04	3.055455000000001e+04	3.819318999999998e+04	4.583181999999998e+04	5.347045999999999e+04	5.912305360000001e+04	6.874773000000000e+04]+[0	4.102190000000001e+03	4.102190000000001e+03	4.102190000000001e+03	4.102190000000001e+03	4.102190000000001e+03	4.102190000000001e+03	4.102190000000001e+03	4.102190000000001e+03	4.102190000000001e+03	4.102190000000001e+03];
%P_G=[0	2.291590999999999e+04	5.897028080000000e+04	9.930227999999998e+04	1.369607659000001e+05	1.729387496000000e+05	2.062432000000001e+05	2.442836172000000e+05	2.908793095999998e+05	3.284614100000001e+05	4.619083917000001e+05]; %+[0	7.093020000000000e+03	2.127906000000000e+04	2.837208000000000e+04	4.255812000000000e+04	4.965113999999999e+04	5.674416000000000e+04	7.093019999999997e+04	8.511624000000000e+04		9.220925999999998e+04	1.276743600000000e+05] + [0	4.102190000000001e+03	8.204390000000005e+03	1.640877000000000e+04	2.051096999999999e+04	2.461315999999999e+04	2.871534999999998e+04	3.281755000000001e+04	4.102193000000002e+04	4.512412000000001e+04	5.332852000000001e+04];
%P_B=[0	2.461315999999999e+04	6.563509000000003e+04	1.189636100000000e+05	1.640048576767677e+05	2.032864700000000e+05	2.460487176767676e+05	2.871535300000002e+05	3.406063687878786e+05	3.853990071717172e+05	4.716279403030304e+05]; %+[0	7.093020000000000e+03	2.127906000000000e+04	3.546509999999998e+04	4.965113999999999e+04	5.993601899999999e+04	7.093019999999997e+04	8.511624000000000e+04	9.930227999999998e+04		1.134883200000000e+05	1.288092432000000e+05] + [0	7.638640000000005e+03	1.397870290000000e+04	2.291590999999999e+04	2.917959480000001e+04	3.628352999999998e+04	4.422770769999998e+04	5.163718639999998e+04	5.981053120000001e+04	6.691445880000000e+04	7.638637999999996e+04];

%new data
%P_R=[0	1.418604000000000e+04	3.546509999999998e+04	4.965113999999999e+04	7.000810739999998e+04	9.220925999999998e+04	1.063243698000000e+05	1.205813400000000e+05	1.418604100000000e+05		1.560464400000000e+05	1.702324800000000e+05];
%P_G=[0	2.245759159999999e+04	5.194273199999998e+04	7.630999349999995e+04	1.069409200000000e+05	1.451341099999999e+05	1.734734544000001e+05	2.044863128000000e+05	2.348117036000000e+05	2.649843315999999e+05	3.131841300000000e+05];
%P_B=[0	3.281755000000001e+04	8.204387000000004e+04	1.353723800000000e+05	1.845987000000001e+05	2.502337999999999e+05	3.035623099999998e+05	3.568908099999998e+05	4.102193399999999e+05	4.635478399999999e+05	5.537961300000002e+05];

P_R_path_list=dir(strcat('.\R_X\','*.xlsx'));
P_R_path_list_name =natsortfiles({P_R_path_list.name});
P_R_NN=length(P_R_path_list);
P_R(:,1)=0;
for ii=1:P_R_NN
    P_R(:,ii+1)=xlsread([P_R_path_list(ii).folder,'\',P_R_path_list_name{ii}]);
end

P_G_path_list=dir(strcat('.\G_Y\','*.xlsx'));
P_G_path_list_name =natsortfiles({P_G_path_list.name});
P_G_NN=length(P_G_path_list);
P_G(:,1)=0;
for ii=1:P_G_NN
    P_G(:,ii+1)=xlsread([P_G_path_list(ii).folder,'\',P_G_path_list_name{ii}]);
end

P_B_path_list=dir(strcat('.\B_Z\','*.xlsx'));
P_B_path_list_name =natsortfiles({P_B_path_list.name});
P_B_NN=length(P_B_path_list);
P_B(:,1)=0;
for ii=1:P_B_NN
    P_B(:,ii+1)=xlsread([P_B_path_list(ii).folder,'\',P_B_path_list_name{ii}]);
end



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

k_R=polyfit(U,P_R,1);%Polynomial function fitting
k_G=polyfit(U,P_G,1);%Polynomial function fitting
k_B=polyfit(U,P_B,1);%Polynomial function fitting

f_R=k_R(1).*U+k_R(2);
f_G=k_G(1).*U+k_G(2);
f_B=k_B(1).*U+k_B(2);

% myfun = @(k,U) k(1)*log(1+k(2)*U);
% X0=[1 1];
% [k_R,resnorm]=lsqcurvefit(myfun,X0,U,P_R)%convex quadratic function fitting
% [k_G,resnorm]=lsqcurvefit(myfun,X0,U,P_G)%convex quadratic function fitting
% [k_B,resnorm]=lsqcurvefit(myfun,X0,U,P_B)%convex quadratic function fitting
%
% f_R=k_R(1)*log(1+k_R(2)*U);
% f_G=k_G(1)*log(1+k_G(2)*U);
% f_B=k_B(1)*log(1+k_B(2)*U);



figure(17)
plot(PWM,P_R,'ro');hold on
plot(PWM,P_G,'go');hold on
plot(PWM,P_B,'bo');hold on

plot(PWM,f_R,'r-');hold on
plot(PWM,f_G,'g-');hold on
plot(PWM,f_B,'b-');hold on

xlabel('Duty cycle')
ylabel('Input light irradiance (\muW/cm^3)')

%%
U_RMAX = 5;

% U_GMAX = (exp(f_R(11)/k_G(1))-1)/k_G(2);
% U_BMAX = (exp(f_R(11)/k_B(1))-1)/k_B(2);

% [U_GMAX,fval,exitflag]=fsolve(@(x) k_G(1).*x.^2+k_G(2).*x+k_G(3)-f_R(11),1);
% [U_BMAX,fval,exitflag]=fsolve(@(x) k_B(1).*x.^2+k_B(2).*x+k_B(3)-f_R(11),1);

U_GMAX = (f_R(11)-k_G(2))/k_G(1);
U_BMAX = (f_R(11)-k_B(2))/k_B(1);

% U_GMAX = (f_R(11))/k_G(1);
% U_BMAX = (f_R(11))/k_B(1);


u_R = 0: U_RMAX/10:U_RMAX;
u_G = 0: U_GMAX/10:U_GMAX;
u_B = 0: U_BMAX/10:U_BMAX;

length_R = length(u_R);
length_G = length(u_G);
length_B = length(u_B);


% for i=1: length_R
%     Normalized_R(i)=k_R(1)*log(1+k_R(2)*u_R(i))/f_R(11);
% end
%
% for i=1: length_G
%     Normalized_G(i)=k_G(1)*log(1+k_G(2)*u_G(i))/f_R(11);
% end
%
% for i=1: length_B
%     Normalized_B(i)=k_B(1)*log(1+k_B(2)*u_B(i))/f_R(11);
% end

% for i=1: length_R
%     Normalized_R(i)=(k_R(1).*u_R(i).^2+k_R(2).*u_R(i)+k_R(3))/f_R(11);
% end
%
% for i=1: length_G
%     Normalized_G(i)=(k_G(1).*u_G(i).^2+k_G(2).*u_G(i)+k_G(3))/f_R(11);
% end
%
% for i=1: length_B
%     Normalized_B(i)=(k_B(1).*u_B(i).^2+k_B(2).*u_B(i)+k_B(3))/f_R(11);
% end

for i=1: length_R
    Normalized_R(i)=(k_R(1).*u_R(i)+k_R(2))/f_R(11);
end

for i=1: length_G
    Normalized_G(i)=(k_G(1).*u_G(i)+k_G(2))/f_R(11);
end

for i=1: length_B
    Normalized_B(i)=(k_B(1).*u_B(i)+k_B(2))/f_R(11);
end

% for i=1: length_R
%     Normalized_R(i)=(k_R(1).*u_R(i))/f_R(11);
% end
%
% for i=1: length_G
%     Normalized_G(i)=(k_G(1).*u_G(i))/f_R(11);
% end
%
% for i=1: length_B
%     Normalized_B(i)=(k_B(1).*u_B(i))/f_R(11);
% end


figure(18)
plot(PWM,Normalized_R,'ro-');hold on
plot(PWM,Normalized_G,'go-');hold on
plot(PWM,Normalized_B,'bo-');hold on

xlabel('Duty cycle')
ylabel('Input light irradiance (\muW/cm^3)')


%%



% x_primary = [0.6774; 0.1888; 0.1313];%RGB
% y_primary = [0.2903; 0.6980; 0.0688];%RGB

x_primary = [0.6544; 0.1776; 0.1307];%RGB
y_primary = [0.3205; 0.7188; 0.0711];%RGB

%screen red
%(0.6567, 0.3007)
% r_max=norm([x_primary(1) y_primary(1)]-[x_primary(2) y_primary(2)]);
% r_interval=r_max/8;


% r_max=norm([x_primary(1) y_primary(1)]-[x_primary(3) y_primary(3)]);
% r_interval=r_max/8;


r_max=norm([x_primary(1) y_primary(1)]-[x_primary(2) y_primary(2)]);
r_interval=r_max/7;
r=r_max;

figure(19)
plotChromaticity

hold on
scatter(x_primary,y_primary,36,'black')
plot([x_primary; x_primary],[y_primary; y_primary],'k')

% r=r_max;
% for i=1:8
% rectangle('Position',[x_primary(1)-r,y_primary(1)-r,2*r,2*r],'Curvature',[1,1],'LineStyle','--','EdgeColor','r');
% r = r - r_interval;
% end


for i=1:7
    rectangle('Position',[x_primary(1)-r,y_primary(1)-r,2*r,2*r],'Curvature',[1,1],'LineStyle','--','EdgeColor','r');
    r = r - r_interval;
end



%%

% x_test = abs(x_primary(1)-x_primary(3))/2;
% y_test = abs(y_primary(1)-y_primary(3))/2;

x_test = 0.26;
y_test = 0.37;
% scatter(x_test,y_test,10,'black')

hold off
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
                P_G_output=C(2)*U_GMAX/5;
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

M = 8;
%BC=A, solve C=B\A
CSK_x = [0.381942857142857,0.188576022289933,0.401307346709709,0.214136614140756,0.477260268541437,0.310811373701920,0.173615146256616,0.654400000000000];
CSK_y = [0.548100000000000,0.578542622160750,0.403195840982403,0.376153382924473,0.309090389478264,0.231160699731439,0.0915373448088586,0.320500000000000];
CSK_P = ones(1,M)
A = [CSK_x;CSK_y;CSK_P];
B = [x_primary'; y_primary'; 1 1 1];
C = B\A;
%C(1) = 0.5;
%C(3) = 0.5;
for m=1:M
    for i=1:3
        switch(i)
            case 1
                if C(1,m)>0
                    P_R_output(m)=round(C(1,m)*U_RMAX/5*100);
                else
                    P_R_output(m)=0;
                end
            case 2
                if C(2,m)>0
                    P_G_output(m)=round(C(2,m)*U_GMAX/5*100);
                else
                    P_G_output(m)=0;
                end
            case 3
                if C(3,m)>0
                    P_B_output(m)=round(C(3,m)*U_BMAX/5*100);
                else
                    P_B_output(m)=0;
                end
        end
    end
end
