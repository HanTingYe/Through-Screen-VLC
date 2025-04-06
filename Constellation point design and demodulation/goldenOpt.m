function [x_opt,f_opt,stepNum] = goldenOpt(f,a,b,Theta_error)

r=(sqrt(5)-1)/2;
a1=b-r*(b-a);
a2=a+r*(b-a);
stepNum=0;
while abs(b-a)>Theta_error
    stepNum=stepNum+1;
    f1=feval(f,a1);
    f2=feval(f,a2);
    if f1>f2
       a=a1;
       f1=f2;
       a1=a2;
       a2=a+r*(b-a);     
    else
       b=a2;
       a2=a1;
       f2=f1;
       a1=b-r*(b-a);       
    end 
   x_opt=(a+b)/2;
   f_opt=feval(f,x_opt); 
end
