clc
clear
close all
%% calculation
x_primary = [0.6544; 0.1776; 0.1307];%RGB
y_primary = [0.3205; 0.7188; 0.0711];%RGB

k_rg = (y_primary(1)-y_primary(2))/(x_primary(1)-x_primary(2));
k_rb = (y_primary(1)-y_primary(3))/(x_primary(1)-x_primary(3));

theta_sum = abs((k_rg-k_rb)/(1+k_rg*k_rb));
theta_s = atan(theta_sum);
r_max=sqrt((y_primary(1)-y_primary(2))^2+(x_primary(1)-x_primary(2))^2);

%% Optimization

% cvx_begin
% variable r(8)
% f_1 = 0;
% for ii=1:7
%     f_1=f_1+power(r(ii),2)+power(r(ii+1),2)-2*r(ii)*r(ii+1)*sqrt(1/(theta_sum^2+1));
% end
% 
% maximize( f_1 );
% subject to
% for ii=1:8
%     if ii==1
%         r(ii)>=0;
%     else
%     r(ii)> r(ii-1);
%     end
% end
% r(8)<=r_max;
% cvx_end


% cvx_begin
% variables r(8) gamma_min
% 
% % for ii=1:7
% %     f_1=f_1+power(r(ii),2)+power(r(ii+1),2)-2*r(ii)*r(ii+1)*sqrt(1/(theta_sum^2+1));
% % end
% 
% maximize( gamma_min );
% subject to
% for ii=1:8
%     if ii==1
%         r(ii)>=0;
%     else
%     r(ii)> r(ii-1);
%     end
% end
% r(8)<=r_max;
% for ii=1:7
%     %power(r(ii),2)+power(r(ii+1),2) >= gamma_min+2*quad_over_lin(r(ii),1)*sqrt(1/(theta_sum^2+1))*quad_over_lin(r(ii+1),1);
%     power(r(ii+1)-r(ii),2) <= -gamma_min;
% end
% cvx_end


% cvx_begin
% variables r(8) f_1 
% beta_test = 1000;
% for ii=1:7
%     f_1=f_1+exp(-beta_test*power(r(ii+1)-r(ii),2));%power(r(ii),2)+power(r(ii+1),2)-2*r(ii)*r(ii+1)*sqrt(1/(theta_sum^2+1));
% end
% f_1 = -log(f_1)/beta_test;
% 
% maximize( f_1 );
% subject to
% for ii=1:8
%     if ii==1
%         r(ii)>=0;
%     else
%     r(ii)> r(ii-1);
%     end
% end
% r(8)<=r_max;
% %  x>0;
% %  x<r_max;
% % for ii=1:7
% %     %power(r(ii),2)+power(r(ii+1),2) >= gamma_min+2*quad_over_lin(r(ii),1)*sqrt(1/(theta_sum^2+1))*quad_over_lin(r(ii+1),1);
% %     power(r(ii+1)-r(ii),2) <= -gamma_min;
% % end
% cvx_end


cvx_begin
variables r(8) x(7) f_1 
beta_test = 1000;
for ii=1:7
    x(ii) = power(r(ii+1)-r(ii),2);%power(r(ii),2)+power(r(ii+1),2)-2*r(ii)*r(ii+1)*sqrt(1/(theta_sum^2+1));
end
f_1 = -logsumexp(beta_test*x)/beta_test;

maximize( f_1 );
subject to
for ii=1:8
    if ii==1
        r(ii)>=0;
    else
    r(ii)> r(ii-1);
    end
end
r(8)<=r_max;
%  x>0;
%  x<r_max;
% for ii=1:7
%     %power(r(ii),2)+power(r(ii+1),2) >= gamma_min+2*quad_over_lin(r(ii),1)*sqrt(1/(theta_sum^2+1))*quad_over_lin(r(ii+1),1);
%     power(r(ii+1)-r(ii),2) <= -gamma_min;
% end
cvx_end