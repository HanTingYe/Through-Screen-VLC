P_R=[0	256	512	768	9.753600000000000e+02	1.231360000000000e+03	1.477120000000000e+03	1536	1.807360000000000e+03		2048	2304];
P_G=[0	1.277440000000000e+03	3.015680000000000e+03	5.299200000000000e+03	7.086080000000000e+03	8.957440000000000e+03	1.074688000000000e+04	1.267712000000000e+04	1.498112000000000e+04		1.688064000000000e+04	1.893120000000000e+04];
P_B=[0	256	512	768	1024	1280	1536	1792	2.257920000000000e+03		2.485760000000000e+03	2816];
for i=0:10
    U(i+1)=0.1*i*5;
end

k_R=polyfit(U,P_R,2);%Polynomial function fitting
k_G=polyfit(U,P_G,2);%Polynomial function fitting
k_B=polyfit(U,P_B,2);%Polynomial function fitting

f_R=k_R(1).*U.^2+k_R(2).*U+k_R(3);
f_G=k_G(1).*U.^2+k_G(2).*U+k_G(3);
f_B=k_B(1).*U.^2+k_B(2).*U+k_B(3);

% k_R=polyfit(U,P_R,1);%Polynomial function fitting
% k_G=polyfit(U,P_G,1);%Polynomial function fitting
% k_B=polyfit(U,P_B,1);%Polynomial function fitting
% 
% f_R=k_R(1).*U+k_R(2);
% f_G=k_G(1).*U+k_G(2);
% f_B=k_B(1).*U+k_B(2);



figure(17)
plot(U,P_R,'ro');hold on
plot(U,P_G,'go');hold on
plot(U,P_B,'bo');hold on

plot(U,f_R,'k-');hold on
plot(U,f_G,'k-');hold on
plot(U,f_B,'k-');hold on



