clc
clear
close all
%%

if~isempty(instrfind)
    fclose(instrfind)
    delete(instrfind)
end
global s


s = serial('COM6');
set(s,'BaudRate',115200);
fopen(s);
interval = 5000;
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
    channel_label = [channel_label, fgetl(s)];  %用函数fget(s)从缓冲区读取串口数据，当出现终止符（换行符）停止
    data = [data, str2num(fgetl(s))];  %用函数fget(s)从缓冲区读取串口数据，当出现终止符（换行符）停止
    t = t+passo
end

count=1;
color='Test_save';
save([color num2str(count)]);



fclose(s);  %关闭串口对象s
