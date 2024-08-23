clc
clear
close all
%%

port = 'com6';
baudrate = 115200;
s = serialport(port,baudrate);% new function in R2019b
configureTerminator(s,"CR");



interval = 1000;
passo = 1;
t = 1;

X = [];
Y = [];
Z = [];
channel_label = [];
data = [];

x = [];
y = [];

i=0;
j=0;
p=0;

while(t<interval)
    channel_label = [channel_label, convertStringsToChars(readline(s))];  %用函数fget(s)从缓冲区读取串口数据，当出现终止符（换行符）停止 %read(s,1,"char")
    data = [data, str2num(readline(s))];  %用函数fget(s)从缓冲区读取串口数据，当出现终止符（换行符）停止 %read(s,1,"uint16")
    t = t+passo
end

count=1;
color='Test_save_';
save([color num2str(count)]);

for i=0:length(data)-1
    if channel_label(2*i+1)=='X'
        
        X=[X,abs(data(i+1))]%所以在Arduino程序里要使用Serial.println()

        
    elseif  channel_label(2*i+1)=='Y'
        
        Y = [Y,abs(data(i+1))];
        
        
    elseif channel_label(2*i+1)=='Z'
        
        Z = [Z,abs(data(i+1))];
        
        
    end
end

%% X Y Z Graphic


figure(1)
plot(X,'-o');
grid;
hold on

figure(2)
plot(Y,'-o');
grid;
hold on

figure(3);
plot(Z,'-o');
grid;
hold on

%% 

length_min = min([length(X) length(Y) length(Z)]);
for j=1:1:length_min
    x(j)=X(j)/(X(j)+Y(j)+Z(j));
    y(j)=Y(j)/(X(j)+Y(j)+Z(j));
    z(j)=Z(j)/(X(j)+Y(j)+Z(j));
end

figure(4)
plotChromaticity
hold on
scatter(x,y,48,'black');



%%

% Lab = xyz2lab([x(1:length_min)' y(1:length_min)' z(1:length_min)']);
% Lab = lab2double(Lab);
% 
% figure(5)
% L = Lab(:,1);
% a =  Lab(:,2);
% b =  Lab(:,3);
% plot3(a,b,L,'o')
% xlabel('a')
% ylabel('b')
% zlabel('L')
% xlim([-128 128])
% ylim([-128 128])
% zlim([0 100])
% 
% figure(6)
% scatter(a,b);
% xlabel('a')
% ylabel('b')
% xlim([-128 128])
% ylim([-128 128])
% 
x(find(x==0))=[];
x(find(isnan(x)))=[];
y(find(y==0))=[];
y(find(isnan(y)))=[];
z(find(z==0))=[];
z(find(isnan(z)))=[];

x_output = mean(x);
y_output = mean(y);
z_output = mean(z);
X_output = mean(X);
Y_output = mean(Y);
Z_output = mean(Z);
% L_output = mean(L);
% 
% % duty=10;
% % color='B_';
% % save([color num2str(duty)]);
% % xlswrite(['X_' color num2str(duty) '.xlsx'],X_output);
% % xlswrite(['Y_' color num2str(duty) '.xlsx'],Y_output);
% % xlswrite(['Z_' color num2str(duty) '.xlsx'],Z_output);
% 
% rgb_8 = xyz2rgb([x' y' (1-x-y)']);
% figure(7)
% colorSwatches(rgb_8(:,:));
% %set(gca,'yticklabel',[]);
% %set(gca,'ytick',[])
% %xlim([0 50])
% set(gca,'ytick',[],'yticklabel',[])
% xlabel('Samples')
% ylabel('Color')
