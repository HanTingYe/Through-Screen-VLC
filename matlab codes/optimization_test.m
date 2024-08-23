clc
clear
close all

alpha=0.5;
beta=1000;
x=0.1:0.1:1;
for j=1:length(x)
for i=1:1:56
    dis1(i)=exp(-beta*x(j));
    dis2(i)=exp(-beta*x(j));
end

f(j)=((alpha-1)*log(sum(dis2))-alpha*log(sum(dis1)))/beta;
end
figure
plot(f)