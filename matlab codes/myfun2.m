function F2=myfun2(x,r_max,r_min,M,cos_theta,beta_t)
r_1=r_max;
r_final=r_min;
d = x(M-2);
F2 = exp(-beta_t*(r_1^2+x(1)^2-2*r_1*x(1)*cos_theta));
for ii=1:M-3        
    F2 = F2+ exp(-beta_t*(x(ii)^2+x(ii+1)^2-2*x(ii)*x(ii+1)*cos_theta));
end
F2 = F2+exp(-beta_t*d^2);
F2 = log(F2)/beta_t;
end  