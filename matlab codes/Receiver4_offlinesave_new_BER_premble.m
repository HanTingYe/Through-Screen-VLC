clc
clear
close all
%%

port = 'com6';
baudrate = 250000;
s = serialport(port,baudrate);% new function in R2019b
configureTerminator(s,"CR");



interval = 10000;
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

%% BER calculation
M = 8;
CSK_x = [0.381942857142857,0.188576022289933,0.401307346709709,0.214136614140756,0.477260268541437,0.310811373701920,0.173615146256616,0.654400000000000];
CSK_y = [0.548100000000000,0.578542622160750,0.403195840982403,0.376153382924473,0.309090389478264,0.231160699731439,0.0915373448088586,0.320500000000000];
symbol=[];
for ii=1:length_min
    delta_d=[];
    for jj=1:M
        delta_d(jj)=sqrt((x(ii)-CSK_x(jj))^2+(y(ii)-CSK_y(jj))^2);
    end
    [value_min, index_min]=min(delta_d);
    symbol(ii)=index_min-1;
end
bit_received=[];
% grey code
for ii=1:length_min
    switch(symbol(ii))
        case 0 %not specific number, just an order
            bit_received = [bit_received, 0,0,0]; 
        case 1
            bit_received = [bit_received, 0,0,1];
        case 2
            bit_received = [bit_received, 0,1,1];
        case 3
            bit_received = [bit_received, 0,1,0];
        case 4
            bit_received = [bit_received, 1,1,0];
        case 5
            bit_received = [bit_received, 1,1,1];
        case 6
            bit_received = [bit_received, 1,0,1];
        case 7
            bit_received = [bit_received, 1,0,0];
    end
end

symbol_received=[];
for ii=1:length_min
    switch(symbol(ii))
        case 0 %not specific number, just an order
            symbol_received = [symbol_received, 0];
        case 1
            symbol_received = [symbol_received, 1];
        case 2
            symbol_received = [symbol_received, 3];
        case 3
            symbol_received = [symbol_received, 2];
        case 4
            symbol_received = [symbol_received, 6];
        case 5
            symbol_received = [symbol_received, 7];
        case 6
            symbol_received = [symbol_received, 5];
        case 7
            symbol_received = [symbol_received, 4];
    end
end




premble_flag=0;
premble_location=find(symbol_received==4)
for i=1:length(premble_location)-2
    if premble_location(i+1)-premble_location(i)==1
        premble_flag=premble_flag+1;
    elseif premble_location(i+2)-premble_location(i)==1
        premble_flag=premble_flag+1;
        i=i+2;
    else
        premble_flag=0;
    end
    if premble_flag>=4
        premble_index=premble_location(i+1)+1;
    end
end




% premble_index =740;
% symbol_received = symbol_test;
symbol_received_recovered=[];
temp_com = symbol_received(premble_index-1);
for ii=premble_index:length_min
    if symbol_received(ii) ~= temp_com 
        if (symbol_received(ii)-temp_com) ==1 || symbol_received(ii)==0
           symbol_received_recovered = [symbol_received_recovered, symbol_received(ii)];
           temp_com = symbol_received(ii);
        end
    end
end


symbol_original(premble_index) = 0;

%single sample
for ii=premble_index+1:length_min
    symbol_original(ii)=symbol_original(ii-1)+1;
    if symbol_original(ii)>=M
        symbol_original(ii)=0;
    end
end
symbol_original(1:premble_index-1)=[];

%Two sample
% for ii=1:length_min/2-1
%     symbol_original(2*ii)=symbol_original(2*ii-1);
%     symbol_original(2*ii+1)=symbol_original(2*ii-1)+1;
%     if symbol_original(2*ii+1)>=M
%         symbol_original(2*ii+1)=0;
%     end
% end
% symbol_original(2*ii+2)=symbol_original(2*ii+1);
bit_received_recovered=[];
for ii=1:length(symbol_received_recovered)
    switch(symbol_received_recovered(ii))
        case 0 %not specific number, just an order
            bit_received_recovered = [bit_received_recovered, 0,0,0];
        case 1
            bit_received_recovered = [bit_received_recovered, 0,0,1];
        case 2
            bit_received_recovered = [bit_received_recovered, 0,1,0];
        case 3
            bit_received_recovered = [bit_received_recovered, 0,1,1];
        case 4
            bit_received_recovered = [bit_received_recovered, 1,0,0];
        case 5
            bit_received_recovered = [bit_received_recovered, 1,0,1];
        case 6
            bit_received_recovered = [bit_received_recovered, 1,1,0];
        case 7
            bit_received_recovered = [bit_received_recovered, 1,1,1];
    end
end
bit_original=[];
for ii=1:length(symbol_original)
    switch(symbol_original(ii))
        case 0 %not specific number, just an order
            bit_original = [bit_original, 0,0,0];
        case 1
            bit_original = [bit_original, 0,0,1];
        case 2
            bit_original = [bit_original, 0,1,0];
        case 3
            bit_original = [bit_original, 0,1,1];
        case 4
            bit_original = [bit_original, 1,0,0];
        case 5
            bit_original = [bit_original, 1,0,1];
        case 6
            bit_original = [bit_original, 1,1,0];
        case 7
            bit_original = [bit_original, 1,1,1];
    end
end
BER_CSK=sum(abs(bit_received_recovered(1:length(symbol_received_recovered))-bit_original(1:length(symbol_received_recovered))))/(length(symbol_received_recovered)*log2(M))%sum(bit_received~=bit_original)

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

%%

delete (s);