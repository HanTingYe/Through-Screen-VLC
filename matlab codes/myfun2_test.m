%% without fix startpoint and endpoint
function F2=myfun2_test(x,M,cos_theta,beta_t)
F2 = exp(-beta_t*(x(M)^2));
for ii=1:M-1        
    F2 = F2+ exp(-beta_t*(x(ii)^2+x(ii+1)^2-2*x(ii)*x(ii+1)*cos_theta));
end
F2 = log(F2)/beta_t;
end  