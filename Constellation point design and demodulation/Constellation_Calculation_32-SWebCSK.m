%Version 31 angles 
clc
clear
close all
% Operation_accuracy=64;
% digits(Operation_accuracy);
%%
x_primary = [0.6544; 0.1776; 0.1307];%RGB
y_primary = [0.3205; 0.7188; 0.0711];%RGB

x_s = 0.3350;
y_s = 0.3722;


M=32;
for ii=1:3
    r_range(ii)= norm([x_s y_s]-[x_primary(ii) y_primary(ii)]);
end
r_max=max(r_range);
r_min=0;
r_eq= r_max/(M-1);




k_rg = (y_primary(1)-y_primary(2))/(x_primary(1)-x_primary(2));
k_rb = (y_primary(1)-y_primary(3))/(x_primary(1)-x_primary(3));
k_gb = (y_primary(2)-y_primary(3))/(x_primary(2)-x_primary(3));

k_sr = (y_s-y_primary(1))/(x_s-x_primary(1));
k_sg = (y_s-y_primary(2))/(x_s-x_primary(2));
k_sb = (y_s-y_primary(3))/(x_s-x_primary(3));


Starting_edge = k_sg;

theta_sum = tan(2*pi);
s_max=max([sqrt((y_primary(1)-y_primary(2))^2+(x_primary(1)-x_primary(2))^2) sqrt((y_primary(1)-y_primary(3))^2+(x_primary(1)-x_primary(3))^2) sqrt((y_primary(3)-y_primary(2))^2+(x_primary(3)-x_primary(2))^2)]);
theta_s = 2*pi/(M-1);%1 screen point, (M-1) lines(other points), (M-1-1) angles

theta_BGs_tan = (k_sg-k_gb)/(1+k_sg*k_gb);% angle BGs
theta_RBs_tan = (k_sb-k_rb)/(1+k_sb*k_rb);% angle BGs
theta_GRs_tan = (k_sr-k_rg)/(1+k_sr*k_rg);% angle BGs

theta_BGs = atan(abs((k_sg-k_gb)/(1+k_sg*k_gb)));
theta_RBs = atan(abs((k_sb-k_rb)/(1+k_sb*k_rb)));
theta_GRs = atan(abs((k_sr-k_rg)/(1+k_sr*k_rg)));

% if theta_BGs_tan>0
%     theta_BGs = atan(abs((k_sg-k_gb)/(1+k_sg*k_gb)));
% else
%     theta_BGs = pi-atan(abs((k_sg-k_gb)/(1+k_sg*k_gb)));
% end
%
% if theta_RBs_tan>0
%     theta_RBs = atan(abs((k_sb-k_rb)/(1+k_sb*k_rb)));
% else
%     theta_RBs = pi-atan(abs((k_sb-k_rb)/(1+k_sb*k_rb)));
% end
%
% if theta_GRs_tan>0
%     theta_GRs = atan(abs((k_sr-k_rg)/(1+k_sr*k_rg)));
% else
%     theta_GRs = pi-atan(abs((k_sr-k_rg)/(1+k_sr*k_rg)));
% end


theta_gsb_tan = (k_sg-k_sb)/(1+k_sg*k_sb);
theta_bsr_tan = (k_sb-k_sr)/(1+k_sb*k_sr);
theta_rsg_tan = (k_sr-k_sg)/(1+k_sr*k_sg);

theta_gsb = pi-atan(abs((k_sg-k_sb)/(1+k_sg*k_sb)));
theta_bsr = pi-atan(abs((k_sb-k_sr)/(1+k_sb*k_sr)));
theta_rsg = pi-atan(abs((k_sr-k_sg)/(1+k_sr*k_sg)));

% if theta_gsb_tan>0
%     theta_gsb = atan(abs((k_sg-k_sb)/(1+k_sg*k_sb)));
% else
%     theta_gsb = pi-atan(abs((k_sg-k_sb)/(1+k_sg*k_sb)));
% end
%
% if theta_bsr_tan>0
%     theta_bsr = atan(abs((k_sb-k_sr)/(1+k_sb*k_sr)));
% else
%     theta_bsr = pi-atan(abs((k_sb-k_sr)/(1+k_sb*k_sr)));
% end
%
% if theta_rsg_tan>0
%     theta_rsg = atan(abs((k_sr-k_sg)/(1+k_sr*k_sg)));
% else
%     theta_rsg = pi-atan(abs((k_sr-k_sg)/(1+k_sr*k_sg)));
% end

% theta_gsb = atan(abs((k_sg-k_sb)/(1+k_sg*k_sb)));
% theta_bsr = atan(abs((k_sb-k_sr)/(1+k_sb*k_sr)));
% theta_rsg = atan(abs((k_sr-k_sg)/(1+k_sr*k_sg)));



%%
x=0:0.001:r_max;
y=0:0.001:r_max;
[xx,yy]=meshgrid(x,y);
f=xx.^2+yy.^2-xx.*yy.*cos(theta_s);

% figure
% mesh(xx,yy,f)%surf

%% fix theta, let each d be equal
% for i=1:M-2
%     theta_ri(i)=pi-theta_rgb-theta_s*i;
% end
%
% count=1000;
% d_final=0;
% while (count)
%     r=@(x) myfun1(x,r_max,r_min,M,cos(theta_s))
%     lb=ones(M-2,1)*r_min;
%     %ub=ones(M-2,1)*r_max;
%     for ii=1:M-2
%         ub(ii,1)=r_max*sin(theta_rgb)/sin(theta_ri(ii));
%     end
%     %A=[];%[-1, 1, 0, 0 ,0, 0;0, -1, 1, 0 ,0, 0;0, 0, -1, 1 ,0, 0;0, 0, 0, -1 ,1, 0;0, 0, 0, 0 ,-1, 1];%[];
%     %b=[];%[0;0;0;0;0];%[];
%     A=[-1, 1, 0, 0 ,0, 0;0, -1, 1, 0 ,0, 0;0, 0, -1, 1 ,0, 0;0, 0, 0, -1 ,1, 0;0, 0, 0, 0 ,-1, 1];%[];
%     b=[0;0;0;0;0];%[];
%
%     [x,f_min]=fmincon(r,rand(M-2,1),A,b,[],[],lb,ub,[],[]);
%
%     r_final = zeros(M,1);
%     r_final(1) = r_max;
%     r_final(M) = r_min;
%     for i=1:M-2
%         r_final(i+1)= x(i);
%     end
%
%     for i=1:M-1
%         d_near(i)=sqrt(r_final(i)^2+r_final(i+1)^2-2*r_final(i)*r_final(i+1)*cos(theta_s));
%     end
%     %d_all=zeros(M-1,M-1);
%     for i=M:-1:2
%         for j=1:i-1
%             d_all(i-1,j)=sqrt(r_final(i)^2+r_final(j)^2-2*r_final(i)*r_final(j)*cos(theta_s*(i-j)));
%         end
%     end
%     d_all(find(d_all==0))=Inf;
%     [d_min,d_index]=min(d_all);
%
%     d_max=sqrt((y_primary(3)-y_primary(2))^2+(x_primary(3)-x_primary(2))^2)/(M-1);
%     if min(d_min)>d_final
%         d_final = min(d_min);
%         r_output= r_final;
%     end
%     count=count-1
% end
% for ii=1:M
%     r_M(ii)=sqrt(r_output(ii)^2+x_s^2+y_s^2-2*r_output(ii)*sqrt(x_s^2+y_s^2)*cos(atan(abs((y_s-y_primary(2))/(x_s-x_primary(2))))-theta_s*(ii-1)+atan(y_s/x_s)));
%     theta_M(ii)=acos((r_M(ii)^2+x_s^2+y_s^2-r_output(ii)^2)/(2*r_M(ii)*sqrt(x_s^2+y_s^2)))+atan(y_s/x_s);
%     x_output_final(ii)=r_M(ii)*cos(theta_M(ii));
%     y_output_final(ii)=r_M(ii)*sin(theta_M(ii));
% end

%% fix theta, solve problem(with constraint)
% for i=1:M-2
%     theta_ri(i)=pi-theta_rgb-theta_s*i;
% end
%
% count=1000;
% d_final=0;
% beta_t=10000;%best performance in 10000
% while (count)
%     r=@(x) myfun2(x,r_max,r_min,M,cos(theta_s),beta_t)
%     lb=ones(M-2,1)*r_min;
%     %ub=ones(M-2,1)*r_max;
%     for ii=1:M-2
%         ub(ii,1)=r_max*sin(theta_rgb)/sin(theta_ri(ii));
%     end
%     %constraint 1 empty
%     %     A=[];%[-1, 1, 0, 0 ,0, 0;0, -1, 1, 0 ,0, 0;0, 0, -1, 1 ,0, 0;0, 0, 0, -1 ,1, 0;0, 0, 0, 0 ,-1, 1];%[];
%     %     b=[];%[0;0;0;0;0];%[];
%
%     %constraint 2 inside the triangle
%     %     A=zeros(M-2,M-2);
%     %     for ii=1:M-2
%     %         A(ii,ii)=1;
%     %         b(ii,1)=r_max*sin(theta_rgb)/sin(theta_ri(ii));
%     %     end
%
%     %constraint 3 r-i<r_i+1
%     A=[-1, 1, 0, 0 ,0, 0;0, -1, 1, 0 ,0, 0;0, 0, -1, 1 ,0, 0;0, 0, 0, -1 ,1, 0;0, 0, 0, 0 ,-1, 1];%[];
%     b=[0;0;0;0;0];%[];
%     x_0 =rand(M-2,1);
%     %options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
%     F2 = exp(-beta_t*(r_max^2+x_0 (1)^2-2*r_max*x_0 (1)*cos(theta_s)));
%     for ii=1:M-3
%         F2 = F2+ exp(-beta_t*(x_0 (ii)^2+x(ii+1)^2-2*x_0 (ii)*x_0 (ii+1)*cos(theta_s)));
%     end
%     F2 = F2+exp(-beta_t*x_0(M-2)^2);
%
%     % if (F2-0)<10^-1||(F2-0)>1
%     %     continue;
%     % end
%
%     [x,f_min,exitflag,output]=fmincon(r,x_0,A,b,[],[],lb,ub,[],[]);
%
%     r_final = zeros(M,1);
%     r_final(1) = r_max;
%     r_final(M) = r_min;
%     for i=1:M-2
%         r_final(i+1)= x(i);
%     end
%
%     for i=1:M-1
%         d_near(i)=sqrt(r_final(i)^2+r_final(i+1)^2-2*r_final(i)*r_final(i+1)*cos(theta_s));
%     end
%     %d_all=zeros(M-1,M-1);
%     for i=M:-1:2
%         for j=1:i-1
%             d_all(i-1,j)=sqrt(r_final(i)^2+r_final(j)^2-2*r_final(i)*r_final(j)*cos(theta_s*(i-j)));
%         end
%     end
%     d_all(find(d_all==0))=Inf;
%     [d_min,d_index]=min(d_all);
%
%     d_max=sqrt((y_primary(3)-y_primary(2))^2+(x_primary(3)-x_primary(2))^2)/(M-1);
%     if min(d_min)>d_final
%         d_final = min(d_min);
%         r_output= r_final;
%     end
%     count=count-1
% end
%
% %wrong code
% %
% % for ii=1:M
% %     r_M=sqrt(x_s^2+y_s^2-(r_output(ii)*cos(theta_s*(ii-1)))^2)-r_output(ii)*sin(theta_s*(ii-1));
% %     theta_M=asin(r_output(ii)/sqrt(x_s^2+y_s^2)*sin(pi/2+theta_s*(ii-1)))+atan(y_s/x_s);
% %     x_output_final(ii)=r_M*cos(theta_M);
% %     y_output_final(ii)=r_M*sin(theta_M);
% % end
%
% %%y_primary(2),x_primary(2) can be fixed as reference
% for ii=1:M
%     r_M(ii)=sqrt(r_output(ii)^2+x_s^2+y_s^2-2*r_output(ii)*sqrt(x_s^2+y_s^2)*cos(atan(abs((y_s-y_primary(2))/(x_s-x_primary(2))))-theta_s*(ii-1)+atan(y_s/x_s)));
%     theta_M(ii)=acos((r_M(ii)^2+x_s^2+y_s^2-r_output(ii)^2)/(2*r_M(ii)*sqrt(x_s^2+y_s^2)))+atan(y_s/x_s);
%     x_output_final(ii)=r_M(ii)*cos(theta_M(ii));
%     y_output_final(ii)=r_M(ii)*sin(theta_M(ii));
% end


%% fix theta, solve problem(without constraint)+all ponits
% for i=1:M-1
%     theta_ri(i)=pi-theta_rgb-theta_s*(i-1);
% end
%
% count=1000;
% d_final=0;
% beta_t=10000;%best performance in 1000
% while (count)
%     r=@(x) myfun2_test(x,M-1,cos(theta_s),beta_t)%% without fix startpoint and endpoint
%     lb=ones(M-1,1)*r_min;
%     A=[];%[-1, 1, 0, 0 ,0, 0;0, -1, 1, 0 ,0, 0;0, 0, -1, 1 ,0, 0;0, 0, 0, -1 ,1, 0;0, 0, 0, 0 ,-1, 1];%[];
%     b=[];%[0;0;0;0;0];%[];
% %     A=zeros(M,M);
%     for ii=1:M-1
% %         A(ii,ii)=1;
% %         b(ii,1)=r_max*sin(theta_rgb)/sin(theta_ri(ii));
%         ub(ii,1)=r_max*sin(theta_rgb)/sin(theta_ri(ii));
%     end
%     % A=[-1, 1, 0, 0 ,0, 0;0, -1, 1, 0 ,0, 0;0, 0, -1, 1 ,0, 0;0, 0, 0, -1 ,1, 0;0, 0, 0, 0 ,-1, 1];%[];
%     % b=[0;0;0;0;0];%[];
%     x_0 =rand(M-1,1);
%     %options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
% %     F2 = exp(-beta_t*(r_max^2+x_0 (1)^2-2*r_max*x_0 (1)*cos(theta_s)));
% %     for ii=1:M-3
% %         F2 = F2+ exp(-beta_t*(x_0 (ii)^2+x(ii+1)^2-2*x_0 (ii)*x_0 (ii+1)*cos(theta_s)));
% %     end
% %     F2 = F2+exp(-beta_t*x_0(M-2)^2);
%
%     % if (F2-0)<10^-1||(F2-0)>1
%     %     continue;
%     % end
%
%     [x,f_min,exitflag,output]=fmincon(r,x_0,A,b,[],[],lb,ub,[],[]);
%
%     r_final = zeros(M,1);
%     for i=1:M-1
%         r_final(i)= x(i);
%     end
%     r_final(M) = 0;
%
%     for i=1:M-1
%         d_near(i)=sqrt(r_final(i)^2+r_final(i+1)^2-2*r_final(i)*r_final(i+1)*cos(theta_s));
%     end
%     %d_all=zeros(M-1,M-1);
%     for i=M:-1:2
%         for j=1:i-1
%             d_all(i-1,j)=sqrt(r_final(i)^2+r_final(j)^2-2*r_final(i)*r_final(j)*cos(theta_s*(i-j)));
%         end
%     end
%     d_all(find(d_all==0))=Inf;
%     [d_min,d_index]=min(d_all);
%
%     d_max=sqrt((y_primary(3)-y_primary(2))^2+(x_primary(3)-x_primary(2))^2)/(M-1);
%     if min(d_min)>d_final
%         d_final = min(d_min);
%         r_output= r_final;
%     end
%     count=count-1
% end
%
% %wrong code
% % for ii=1:M
% %     r_M=sqrt(x_s^2+y_s^2-(r_output(ii)*cos(theta_s*(ii-1)))^2)-r_output(ii)*sin(theta_s*(ii-1));
% %     theta_M=asin(r_output(ii)/sqrt(x_s^2+y_s^2)*sin(pi/2+theta_s*(ii-1)))+atan(y_s/x_s);
% %     x_output_final(ii)=r_M*cos(theta_M);
% %     y_output_final(ii)=r_M*sin(theta_M);
% % end
%
% %%y_primary(2),x_primary(2) can be fixed as reference
% for ii=1:M
%     r_M(ii)=sqrt(r_output(ii)^2+x_s^2+y_s^2-2*r_output(ii)*sqrt(x_s^2+y_s^2)*cos(atan(abs((y_s-y_primary(2))/(x_s-x_primary(2))))-theta_s*(ii-1)+atan(y_s/x_s)));
%     theta_M(ii)=acos((r_M(ii)^2+x_s^2+y_s^2-r_output(ii)^2)/(2*r_M(ii)*sqrt(x_s^2+y_s^2)))+atan(y_s/x_s);
%     x_output_final(ii)=r_M(ii)*cos(theta_M(ii));
%     y_output_final(ii)=r_M(ii)*sin(theta_M(ii));
% end
%% solve the whole problem
% count=100;
% d_final=0;
% beta_t=5000;%best performance in 5000
% alpha_t=1;
% y_gr=y_primary(2)-y_primary(1);
% x_gr=x_primary(2)-x_primary(1);
% y_br=y_primary(3)-y_primary(1);
% x_br=x_primary(3)-x_primary(1);
% y_gb=y_primary(2)-y_primary(3);
% x_gb=x_primary(2)-x_primary(3);
% x_test=1/3;
% y_test=1/3;
% line_1 = y_gr*x_test-x_gr*y_test-(x_primary(1)*y_gr-y_primary(1)*x_gr);
% line_2 = y_br*x_test-x_br*y_test-(x_primary(1)*y_br-y_primary(1)*x_br);
% line_3 = y_gb*x_test-x_gb*y_test-(x_primary(3)*y_gb-y_primary(3)*x_gb);
% while (count)
%     r=@(x) myfun3(x,x_primary(1),y_primary(1),M,alpha_t,beta_t)
%     %r=@(x) myfun4_test(x,x_primary(1),y_primary(1),M,alpha_t,beta_t,atan(theta_sum),s_max)
%     lb=zeros(M*2,1);
%     ub=ones(M*2,1);
%     % A=[];%[-1, 1, 0, 0 ,0, 0;0, -1, 1, 0 ,0, 0;0, 0, -1, 1 ,0, 0;0, 0, 0, -1 ,1, 0;0, 0, 0, 0 ,-1, 1];%[];
%     % b=[];%[0;0;0;0;0];%[];
%     %A(1:3,:)=[y_gr, -x_gr, zeros(1, 2*(M-1)); y_br, -x_br, zeros(1,2*(M-1)); y_gb, -x_gb, zeros(1, 2*(M-1))];%[];
%     for ii=1:M
%         A(((3*ii-2):3*ii),:)=[zeros(1, 2*(ii-1)), y_gr, -x_gr, zeros(1, 2*(M-ii)); zeros(1, 2*(ii-1)), -y_br, x_br, zeros(1, 2*(M-ii));zeros(1, 2*(ii-1)), -y_gb, x_gb, zeros(1, 2*(M-ii))];
%     end
%     b=[(x_primary(1)*y_gr-y_primary(1)*x_gr);-(x_primary(1)*y_br-y_primary(1)*x_br);-(x_primary(3)*y_gb-y_primary(3)*x_gb)];%[];
%     %b=b(:,ones(1,M));%vector to matrix
%     b=repmat(b,M,1);%vector to matrix
%     x_0 =rand(M*2,1)+100;
%     %options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
%     F2 = exp(-beta_t*(r_max^2+x_0 (1)^2-2*r_max*x_0 (1)*cos(theta_s)));
%     for ii=1:M-3
%         F2 = F2+ exp(-beta_t*(x_0 (ii)^2+x(ii+1)^2-2*x_0 (ii)*x_0 (ii+1)*cos(theta_s)));
%     end
%     F2 = F2+exp(-beta_t*x_0(M-2)^2);
%
%     % if (F2-0)<10^-1||(F2-0)>1
%     %     continue;
%     % end
%
%     [xy,f_min,exitflag,output]=fmincon(r,x_0,A,b,[],[],lb,ub,[],[]);
%
%     for ii=1:M
%         x_output(ii)=xy(2*ii-1);
%         y_output(ii)=xy(2*ii);
%     end
%
%
%
%     for i=1:M-1
%         d_near(i)=sqrt((y_output(i+1)-y_output(i))^2+(x_output(i+1)-x_output(i))^2);
%     end
%
%     for i=1:M
%         k(i)=(y_output(i)-y_primary(1))/(x_output(i)-x_primary(1));
%     end
%
%     for i=M:-1:2
%         theta_near(i-1)=atan(abs((k(i)-k(i-1))/(1+k(i)*k(i-1))));
%     end
%
%     for i=M:-1:2
%         for j=1:i-1
%             theta_all(i-1,j)=atan(abs((k(i)-k(j))/(1+k(i)*k(j))));
%         end
%     end
%
%     theta_sum_test=sum(theta_near);
%     theta_all(find(theta_all==0))=Inf;
%     [theta_min,theta_index]=min(theta_all);
%     %d_all=zeros(M-1,M-1);
%     for i=M:-1:2
%         for j=1:i-1
%             d_all(i-1,j)=sqrt((y_output(i)-y_output(j))^2+(x_output(i)-x_output(j))^2);
%         end
%     end
%     d_all(find(d_all==0))=Inf;
%     [d_min,d_index]=min(d_all);
%
%     d_max = sqrt((y_primary(3)-y_primary(2))^2+(x_primary(3)-x_primary(2))^2)/(M-1);
%     theta_max = theta_sum;
%     if min(d_min)>d_final
%         d_final = min(d_min);
%         x_output_final= x_output;
%         y_output_final= y_output;
%         theta_final=min(theta_min);
%         theta_sum_final=theta_sum_test;
%     end
%     count=count-1
% end
%% Heuristic algorithms--greedy algorithm  Ascending order
for i=1:M-1
    if theta_s*(i-1)<=theta_gsb
        r_maxi(i)=r_max*sin(theta_BGs)/sin(pi-theta_BGs-theta_s*(i-1));
    elseif theta_s*(i-1)> theta_gsb && theta_s*(i-1) <=(theta_gsb+theta_bsr)
        r_maxi(i)=r_range(3)*sin(theta_RBs)/sin(pi-theta_RBs-(theta_s*(i-1)-theta_gsb));
    elseif theta_s*(i-1) >(theta_gsb+theta_bsr)
        r_maxi(i)=r_range(1)*sin(theta_GRs)/sin(pi-theta_GRs-(theta_s*(i-1)-(theta_gsb+theta_bsr)));
    end
end

for i=1:M-1 %line
    for j=1:M %circle
        if (r_max-(j-1)*r_eq)<=r_maxi(i)
            line_capacity(i)=M-(j-1);
            break;
        end
    end
end
[line_ascend, line_index]=sort(line_capacity);
start_point=line_index(3);%2 for 8CSK; 20 for 32CSK
r_output(M) =(1-1)*r_eq;%(line_capacity(1)-1)*r_eq 1, 4, 8
r_output(start_point) =(line_capacity(start_point)-1)*r_eq;%(line_capacity(1)-1)*r_eq 1, 4, 8
flag_0=1;%When start point is 0, this flag should be marked as 1




% max-min metric

for i=start_point-1:-1:1
    r_temp=[];
    for m=1:line_capacity(i)
        for j=start_point:-1:(i+1)
            r_temp(j,m) = sqrt(r_output(j)^2+((m-1)*r_eq)^2-2*r_output(j)*(m-1)*r_eq*cos(theta_s*(abs(i-j))));
        end
        r_temp(i,m)=(m-1)*r_eq;%ditance to 8th point
    end
    r_temp(find(r_temp==0))=NaN;
    if flag_0 == 1
        r_temp(:,1)=NaN;
    end
    [max_value(i),max_index(i)]=max(min(r_temp));
    if max_index(i)==1;
        flag_0=1;
    end
    r_output(i) = (max_index(i)-1)*r_eq;
end


r_temp=[];
for i=start_point+1:M-1
    r_temp=[];
    for m=1:line_capacity(i)
        for j=1:(i-1)%start_point
            r_temp(j,m) = sqrt(r_output(j)^2+((m-1)*r_eq)^2-2*r_output(j)*(m-1)*r_eq*cos(theta_s*(abs(i-j))));
        end
        r_temp(i,m)=(m-1)*r_eq;
    end
    r_temp(find(r_temp==0))=NaN;
    if flag_0 == 1
        r_temp(:,1)=NaN;
    end
    [max_value(i),max_index(i)]=max(min(r_temp));
    if max_index(i)==1;
        flag_0=1;
    end
    r_output(i) = (max_index(i)-1)*r_eq;
end




for i=1:M-1
    d_near(i)=sqrt(r_output(i)^2+r_output(i+1)^2-2*r_output(i)*r_output(i+1)*cos(theta_s));
end
%d_all=zeros(M-1,M-1);
for i=M:-1:2
    for j=1:i-1
        d_all(i-1,j)=sqrt(r_output(i)^2+r_output(j)^2-2*r_output(i)*r_output(j)*cos(theta_s*(i-j)));
    end
end
d_all(find(d_all==0))=Inf;
[d_min,d_index]=min(d_all);
d_final = min(d_min);

d_max=sqrt((y_primary(3)-y_primary(2))^2+(x_primary(3)-x_primary(2))^2)/(M-1);

%%y_primary(2),x_primary(2) can be fixed as reference
for ii=1:M
    if atan(abs((y_s-y_primary(2))/(x_s-x_primary(2))))-theta_s*(ii-1)+atan(y_s/x_s) >=0
        r_M(ii)=sqrt(r_output(ii)^2+x_s^2+y_s^2-2*r_output(ii)*sqrt(x_s^2+y_s^2)*cos(atan(abs((y_s-y_primary(2))/(x_s-x_primary(2))))-theta_s*(ii-1)+atan(y_s/x_s)));
        theta_M(ii)=acos((r_M(ii)^2+x_s^2+y_s^2-r_output(ii)^2)/(2*r_M(ii)*sqrt(x_s^2+y_s^2)))+atan(y_s/x_s);
    else
        if atan(abs((y_s-y_primary(2))/(x_s-x_primary(2))))-theta_s*(ii-1)+atan(y_s/x_s) >=-pi
            r_M(ii)=sqrt(r_output(ii)^2+x_s^2+y_s^2-2*r_output(ii)*sqrt(x_s^2+y_s^2)*cos(-(atan(abs((y_s-y_primary(2))/(x_s-x_primary(2))))-theta_s*(ii-1)+atan(y_s/x_s))));
            theta_M(ii)=atan(y_s/x_s)-acos((r_M(ii)^2+x_s^2+y_s^2-r_output(ii)^2)/(2*r_M(ii)*sqrt(x_s^2+y_s^2)));
        else
            r_M(ii)=sqrt(r_output(ii)^2+x_s^2+y_s^2-2*r_output(ii)*sqrt(x_s^2+y_s^2)*cos(pi-(-(atan(abs((y_s-y_primary(2))/(x_s-x_primary(2))))-theta_s*(ii-1)+atan(y_s/x_s))-pi)));
            theta_M(ii)=acos((r_M(ii)^2+x_s^2+y_s^2-r_output(ii)^2)/(2*r_M(ii)*sqrt(x_s^2+y_s^2)))+atan(y_s/x_s);
        end
    end
    x_output_final(ii)=r_M(ii)*cos(theta_M(ii));
    y_output_final(ii)=r_M(ii)*sin(theta_M(ii));
end


%% theta
for i=1:M-1
    k(i)=(y_output_final(i)-y_output_final(M))/(x_output_final(i)-x_output_final(M));
end
%d_all=zeros(M-1,M-1);
for i=M-1:-1:2
    for j=1:i-1
        theta_all(i-1,j)=atan(abs((k(i)-k(j))/(1+k(i)*k(j))))
    end
end
theta_all(find(theta_all==0))=Inf;
[theta_min,theta_index]=min(theta_all);
theta_final = min(theta_min);

%% Test
% for i=1:M-1
%     d_near(i)=sqrt((y_output_final(i+1)-y_output_final(i))^2+(x_output_final(i+1)-x_output_final(i))^2);
% end
% 
% for i=1:M
%     k(i)=(y_output_final(i)-y_s)/(x_output_final(i)-x_s);
% end
% 
% for i=M:-1:2
%     theta_near(i-1)=atan(abs((k(i)-k(i-1))/(1+k(i)*k(i-1))));
% end
% 
% for i=M:-1:2
%     for j=1:i-1
%         theta_all(i-1,j)=atan(abs((k(i)-k(j))/(1+k(i)*k(j))));
%     end
% end
% theta_sum_test=sum(theta_near);
% theta_all(find(theta_all==0))=Inf;
% [theta_min,theta_index]=min(theta_all);

%% Draw
color0={'r', 'g', 'b', 'c' , 'm', 'y', 'k', 'w'};
figure(19)
plotChromaticity

hold on
%scatter(x_primary,y_primary,36,'black')
plot([x_primary; x_primary],[y_primary; y_primary],'k')


for ii=1:M
    scatter(x_output_final(ii),y_output_final(ii),36,'k');%color0{ii}
end

%scatter(x_output_final,y_output_final,36,'k')
hold off
