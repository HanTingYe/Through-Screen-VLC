function F3=myfun3(x,x_s,y_s,M,alpha_t,beta_t)
for i=1:M
    k(i)=(x(2*i)-y_s)/(x(2*i-1)-x_s);
end
for i=M:-1:2
    for j=1:i-1
    tan_theta(i-1,j)=abs((k(i)-k(j))/(1+k(i)*k(j)));
    end
end
temp1=0
for i=M:-1:2
    for j=1:i-1
        if j==i-1
            temp1=temp1
        else
            temp1=temp1+exp(-beta_t*abs((tan_theta(i-1,i-1)-tan_theta(i-1,j))/(1+tan_theta(i-1,i-1)*tan_theta(i-1,j))));
        end
    
    end
end
temp2=0
for i=M:-1:2
    for j=1:i-1
    temp2=temp2+exp(-beta_t*sqrt((x(2*i)-x(2*j))^2+(x(2*i-1)-x(2*j-1))^2));
    end
end
% r_1=r_max;
% r_final=r_min;
% d = x(M-2);
% F3 = exp(-beta_t*(r_1^2+x(1)^2-2*r_1*x(1)*cos_theta));
% for ii=1:M-3        
%     F3 = F3+ exp(-beta_t*(x(ii)^2+x(ii+1)^2-2*x(ii)*x(ii+1)*cos_theta));
% end
% F3 = F3+exp(-beta_t*d^2);
F3 = ((1-alpha_t)*log(temp1)+alpha_t*log(temp2))/beta_t;
end  