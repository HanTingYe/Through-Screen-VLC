clc
clear
close all

if~isempty(instrfind)
    fclose(instrfind)
    delete(instrfind)
end
global s


s = serial('COM5');
set(s,'BaudRate',115200);
fopen(s);
interval = 100;
passo = 1;
t = 1;

X = [];
Y = [];
Z = [];

x = [];
y = [];

i=1;
j=0;
p=0;

while(t<interval)
    i=i+1;
    b = str2num(fgetl(s));  %用函数fget(s)从缓冲区读取串口数据，当出现终止符（换行符）停止
    if mod(i,3)==1
        if (isempty(b))
            %i=i-1;
            continue;
        else
            X=[X,abs(b)]%所以在Arduino程序里要使用Serial.println()
            t = t+passo;
            figure(1)
            plot(X,'-o');
            grid;
            drawnow;
            hold on
        end
    elseif  mod(i,3)==2
        if (isempty(b))
            %i=i-2;
            if (~isempty(X))
            X(end)=[];
            end
            continue;
        else
            Y = [Y,abs(b)];
            t = t+passo;
            figure(2)
            plot(Y,'-o');
            grid;
            drawnow;
            hold on
        end
        
    else
        if (isempty(b))
            %i=i-3;
            if (~isempty(X))
            X(end)=[];
            end
            if (~isempty(Y))
            Y(end)=[];
            end
            continue;
        else
            Z = [Z,abs(b)];
            t = t+passo;
            figure(3);
            plot(Z,'-o');
            grid;
            drawnow;
            hold on
        end
        
        
        %         if (~isempty(X)) && (~isempty(Y)) && (~isempty(Z))
        %             j=j+1;
        %             x(j)=X(j)/(X(j)+Y(j)+Z(j));
        %             y(j)=Y(j)/(X(j)+Y(j)+Z(j));
        %         end
        

    end
end

length_min = min([length(X) length(Y) length(Z)]);
for j=1:1:length_min
    x(j)=Z(j)/(X(j)+Y(j)+Z(j));
    y(j)=X(j)/(X(j)+Y(j)+Z(j));
end

figure(4)
plotChromaticity
hold on
scatter(x,y,48,'black');


Lab = xyz2lab([X(1:length_min)' Y(1:length_min)' Z(1:length_min)']);
Lab = lab2double(Lab);

figure(5)
L = Lab(:,1);
a =  Lab(:,2);
b =  Lab(:,3);
plot3(a,b,L,'o')

fclose(s);  %关闭串口对象s
