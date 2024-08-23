% function F=find_r(x,K,gama,a,b)
% d=r_max^2+x^2-2*r_max*x*cos_theta;
% F=x^2 
% lamda=(gama(K)*b(K))/(1+gama(K)*x_K)+x;
% F=((gama(K)*b(K)-1)/lambertw(0,(gama(K)*b(K)-1)*exp(-x-1))-1)/gama(K);
% if K>=2
%     for i=K-1:-1:1
%         F=(1/-lambertw(0,-exp((gama(i+1)*a(i+1))/(1+gama(i+1)*F)-lamda-1))-1)/gama(i);
%     end
% end
% 
% F=lamda-(gama(1)*b(1))/(1+gama(1)*F);
% end         %end��������


% function F1=myfun1(x,K,N,Theta0,Theta1,a,s,L)
% r_1=r_max;
% r_final=r_min;
% d = x;
% for ii=1:M
%     F = d^2-(r_1^2+x^2-2*r_1*x);
%     for jj=1:N
%         for k=1:L(jj)
%             F1=F1+(1-x)/L(jj)*a(ii,jj)*s(ii,k,jj)*log(1+(x*Theta0(ii)*L(jj)+(1-x)*Theta1(ii)*(k-1))/(1-x))
%         end
%     end
% end
% F1=-F1
% end         %end��������

function F1=myfun1(x,r_max,r_min,M,cos_theta)
r_1=r_max;
r_final=r_min;
d = x(M-2);
F1 = abs(d^2-(r_1^2+x(1)^2-2*r_1*x(1)*cos_theta));
for ii=1:M-3        
    F1 = F1+ abs(d^2-(x(ii)^2+x(ii+1)^2-2*x(ii)*x(ii+1)*cos_theta));
end
end         %end��������