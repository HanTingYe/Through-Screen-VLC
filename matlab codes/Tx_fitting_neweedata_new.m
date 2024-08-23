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

% k_R_test=P_R/U;
% k_G_test=P_G/U;
% k_B_test=P_B/U;
% 
% f_R=k_R_test.*U
% f_G=k_G_test.*U
% f_B=k_B_test.*U

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

% U_GMAX = (f_R(11))/k_G_test(1);
% U_BMAX = (f_R(11))/k_B_test(1);

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
%     Normalized_R(i)=(k_R_test.*u_R(i))/f_R(11);
% end
% 
% for i=1: length_G
%     Normalized_G(i)=(k_G_test.*u_G(i))/f_R(11);
% end
% 
% for i=1: length_B
%     Normalized_B(i)=(k_B_test.*u_B(i))/f_R(11);
% end

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

%r:0.6544,0.3205; y: 0.44,0.50; w: 0.3350,0.3722
x_screen=0.44;
y_screen=0.50;
Modulation_index=16;
for ii=1:3
    r_range(ii)= norm([x_screen y_screen]-[x_primary(ii) y_primary(ii)]);
end
r_max=max(r_range);
r_interval=r_max/(Modulation_index-1);
r=r_max;

figure(19)
plotChromaticity

hold on
scatter(x_primary,y_primary,36,'black')
plot([x_primary; x_primary],[y_primary; y_primary],'k')
scatter(x_screen,y_screen,60,'s','b');


%scatter(x_primary(1),y_primary(1),60,'s','b');
%  r=norm([x_primary(3) y_primary(3)]-[x_primary(2) y_primary(2)]);
%  r_interval=r/(8-2);
% for i=1:6
% rectangle('Position',[x_primary(2)-r,y_primary(2)-r,2*r,2*r],'Curvature',[1,1],'LineStyle','--','EdgeColor','r');
% r = r - r_interval;
% end


for i=1:(Modulation_index-1)
    rectangle('Position',[x_screen-r,y_screen-r,2*r,2*r],'Curvature',[1,1],'LineStyle','--','EdgeColor','r');
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

M = 16;
%BC=A, solve C=B\A

% 8CSK
%CSK_x = [0.381942857142857,0.188576022289933,0.401307346709709,0.214136614140756,0.477260268541437,0.310811373701920,0.173615146256616,0.654400000000000];
%CSK_y = [0.548100000000000,0.578542622160750,0.403195840982403,0.376153382924473,0.309090389478264,0.231160699731439,0.0915373448088586,0.320500000000000];


% 16CSK
CSK_x = [0.304623906437435,0.188639064287826,0.337431561944085,0.228533369105713,0.163743245605396,0.311647333141467,0.159647955376461,0.281964920045401,0.264158415923665,0.405627310200754,0.433841209610942,0.482552469715515,0.483795136853823,0.589608591569439,0.575376093562565,0.440000000000000];
CSK_y = [0.612882199967566,0.627884788419153,0.525779517349434,0.504619092791794,0.443263373712647,0.441606484194902,0.286273440615087,0.310473469012415,0.154378713395761,0.363242082592113,0.218044492140950,0.292807434204047,0.403735499856101,0.303753568763523,0.387117800032435,0.500000000000000];

% 32CSK
%CSK_x = [0.177600000000000,0.247507371202734,0.169651433567280,0.270922778704673,0.159405570668702,0.212785675822036,0.151963485421363,0.265099212441360,0.207936061103362,0.171840501761319,0.134967634237187,0.290797562850767,0.290646203756801,0.336181379001850,0.350851272319626,0.406083870967742,0.407910523997722,0.481976503495751,0.463154442590653,0.580832201063817,0.518321486266945,0.432619474441941,0.509751968896600,0.451475277321919,0.380322082844082,0.427872169818446,0.379202437149231,0.371961496869333,0.334000371613819,0.279520546881310,0.177600000000000,0.334999992156471];
%CSK_y = [0.718800000000000,0.490767996753402,0.518879391741236,0.408565398362488,0.427820809338954,0.384131484336881,0.351591448992984,0.348914545620182,0.297580395471148,0.223089401726650,0.0925500916271361,0.270908871830739,0.155664245119308,0.212570398641686,0.300248143506635,0.215670967741935,0.273393336038831,0.241818318452235,0.299469203275024,0.294330866925464,0.354302773494679,0.383191227203741,0.430413635949547,0.440601304151447,0.413619610631483,0.502037457458832,0.473491128169263,0.552646462400577,0.507271201149343,0.624031497726778,0.718800000000000,0.372200007059597];


% 32CSK V2
% CSK_x = [0.177600000000000,0.176069104646800,0.235174042314699,0.166127881807545,0.253787225425391,0.164561726186322,0.212519117483886,0.157691361262253,0.269545233120592,0.143978825276449,0.233574413500627,0.191663396153545,0.273255834451801,0.326120918532612,0.357462384129743,0.354601208242104,0.403007454546130,0.457874569699968,0.413923307766305,0.546570657724000,0.490340921838158,0.592756095170265,0.431771158187497,0.506351929303565,0.448111363850386,0.378606297129744,0.423434036693189,0.376449292997415,0.368296805341531,0.332175405747283,0.275097586929384,0.334999992156471];
% CSK_y = [0.718800000000000,0.590653393312113,0.463194542743229,0.472617544085947,0.400361124067497,0.394673305738552,0.363417359689053,0.322312880693794,0.338376842551958,0.217844189554572,0.248928528485223,0.100729004399182,0.159967461486955,0.262041432434744,0.189381731375356,0.314015225585733,0.255494324204035,0.234981494816653,0.313706578515272,0.273853832440257,0.335427683121247,0.364527427534507,0.389103011826753,0.439769182085109,0.446031212943729,0.415422288102574,0.505100061852160,0.474648544185597,0.553358496344369,0.507245363875049,0.635624781400050,0.372200007059597];


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
