clc
clear
close all
%%

port = 'com6';
baudrate = 115200;
s = serialport(port,baudrate);% new function in R2019b
configureTerminator(s,"CR");



interval = 15000;
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

count=2;
color='Results_RS_32CSK_0_';
save([color num2str(count)]);
%save('32CSK_Test');
delete (s);
%%
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

% for j=1:1:length_min
%     if X(j)==0 && Y(j)==0
%         X(j)=[];
%         Y(j)=[];
%         Z(j)=[];
%     end
% end
% length_min = min([length(X) length(Y) length(Z)]);
for j=1:1:length_min
    x(j)=X(j)/(X(j)+Y(j)+Z(j));
    y(j)=Y(j)/(X(j)+Y(j)+Z(j));
    z(j)=Z(j)/(X(j)+Y(j)+Z(j));
%     if y(j)<0.1 || x(j)<0.1
%         x(j)=0.3350;
%         y(j)=0.3722;
%     end
end

figure(4)
plotChromaticity
hold on
scatter(x,y,48,'black');



%% BER calculation
M = 32;

normalcode_dec=0:31;
normalcode_bin_char=dec2bin(normalcode_dec,5);
for ii=1:length(normalcode_dec)
    for jj=1:5
        normalcode_bin(ii,jj)=str2num(normalcode_bin_char(ii,jj))
    end
end

graycode_bin = gen_gray_code(5);
graycode_dec = reshape([16 8 4 2 1]*reshape(graycode_bin.',5,[]),size(graycode_bin)./[1 5]);
% 8CSK
%CSK_x = [0.381942857142857,0.188576022289933,0.401307346709709,0.214136614140756,0.477260268541437,0.310811373701920,0.173615146256616,0.654400000000000];
%CSK_y = [0.548100000000000,0.578542622160750,0.403195840982403,0.376153382924473,0.309090389478264,0.231160699731439,0.0915373448088586,0.320500000000000];

% 32CSK
CSK_x = [0.177600000000000,0.176069104646800,0.235174042314699,0.166127881807545,0.253787225425391,0.164561726186322,0.212519117483886,0.157691361262253,0.269545233120592,0.143978825276449,0.233574413500627,0.191663396153545,0.273255834451801,0.326120918532612,0.357462384129743,0.354601208242104,0.403007454546130,0.457874569699968,0.413923307766305,0.546570657724000,0.490340921838158,0.592756095170265,0.431771158187497,0.506351929303565,0.448111363850386,0.378606297129744,0.423434036693189,0.376449292997415,0.368296805341531,0.332175405747283,0.275097586929384,0.334999992156471];
CSK_y = [0.718800000000000,0.590653393312113,0.463194542743229,0.472617544085947,0.400361124067497,0.394673305738552,0.363417359689053,0.322312880693794,0.338376842551958,0.217844189554572,0.248928528485223,0.100729004399182,0.159967461486955,0.262041432434744,0.189381731375356,0.314015225585733,0.255494324204035,0.234981494816653,0.313706578515272,0.273853832440257,0.335427683121247,0.364527427534507,0.389103011826753,0.439769182085109,0.446031212943729,0.415422288102574,0.505100061852160,0.474648544185597,0.553358496344369,0.507245363875049,0.635624781400050,0.372200007059597];


% 32CSK V2
% CSK_x = [];
% CSK_y = [];
% CSK_x_screen = 0.654400000000000;
% CSK_y_screen = 0.320500000000000;
CSK_x_screen = 0.3350;%0.3350 0.3650
CSK_y_screen = 0.3722;%0.3722 0.3650
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
    bit_received = [bit_received, graycode_bin(symbol(ii)+1,:)];
end

symbol_received=[];
for ii=1:length_min
    symbol_received = [symbol_received, graycode_dec(symbol(ii)+1,:)];
end





%% Distinguish between screen signal points and non-screen signal points
screen_threshold=13000;%mean(X(premble_index:length_min))
symbol_Txscreen_index = [];
symbol_Tx_index = [];
symbol_Txscreen_index = find(X(1:length_min)>screen_threshold);
symbol_Tx_index = find(X(1:length_min)<=screen_threshold);

%Draw screen signal points with screen interference
figure(5)
plotChromaticity
hold on
scatter(x(symbol_Txscreen_index),y(symbol_Txscreen_index),48,'black');

%Draw screen signal points without screen interference
figure(6)
plotChromaticity
hold on
scatter(x(symbol_Tx_index),y(symbol_Tx_index),48,'black');


%%  slope detection V2
symbol_test=[];
symbol_test=symbol_received;
CSK_x_underscreen = [0.35, 0.355, 0.354, 0.35, 0.36, 0.349, 0.353, 0.346, 0.362, 0.345, 0.355, 0.348, 0.36, 0.364, 0.367, 0.369, 0.374, 0.384, 0.376, 0.397, 0.39, 0.402, 0.38, 0.39, 0.383, 0.37, 0.378, 0.372, 0.368, 0.365, 0.357, 0.365]
CSK_y_underscreen = [0.4, 0.386, 0.377, 0.376, 0.37, 0.368, 0.366, 0.361, 0.362, 0.347, 0.351, 0.328, 0.337, 0.35, 0.338, 0.355, 0.347, 0.345, 0.356, 0.353, 0.359, 0.364, 0.367, 0.373, 0.374, 0.372, 0.383, 0.381, 0.391, 0.382, 0.397, 0.365]
Slope_threshold=0.041;
y_threshold=0.365;
CSK_high_y = find(CSK_y > y_threshold);
CSK_low_y = find(CSK_y < y_threshold);
CSK_high_y(CSK_high_y==32)=[];

for ii=1:length(symbol_Txscreen_index)
%     if symbol_Txscreen_index(ii)==731
%         tttt=1;
%     end
    if ~IsPointInTriangle(x(symbol_Txscreen_index(ii)),y(symbol_Txscreen_index(ii)))%sqrt((x(symbol_Txscreen_index(ii))-CSK_x_underscreen(M))^2+(y(symbol_Txscreen_index(ii))-CSK_y_underscreen(M))^2)>Slope_threshold
        delta_k=[];
        if y(symbol_Txscreen_index(ii))>y_threshold
            for jj=1:length(CSK_high_y)
                delta_k(jj)=abs((y(symbol_Txscreen_index(ii))-CSK_y_screen)/(x(symbol_Txscreen_index(ii))-CSK_x_screen)-(CSK_y(CSK_high_y(jj))-CSK_y_screen)/(CSK_x(CSK_high_y(jj))-CSK_x_screen));
            end
            [kvalue_high_min, kindex_high_min]=min(delta_k);
            kindex_min=CSK_high_y(kindex_high_min);
        else
            for jj=1:length(CSK_low_y)
                delta_k(jj)=abs((y(symbol_Txscreen_index(ii))-CSK_y_screen)/(x(symbol_Txscreen_index(ii))-CSK_x_screen)-(CSK_y(CSK_low_y(jj))-CSK_y_screen)/(CSK_x(CSK_low_y(jj))-CSK_x_screen));
            end
            [kvalue_low_min, kindex_low_min]=min(delta_k);
            kindex_min=CSK_low_y(kindex_low_min);
        end
        symbol_received(symbol_Txscreen_index(ii)) = graycode_dec(kindex_min,:);
    else
        delta_d=[];
        for jj=1:M
            delta_d(jj)=sqrt((x(symbol_Txscreen_index(ii))-CSK_x_underscreen(jj))^2+(y(symbol_Txscreen_index(ii))-CSK_y_underscreen(jj))^2);
        end
        [value_min, index_min]=min(delta_d);
        symbol_received(symbol_Txscreen_index(ii)) = graycode_dec(index_min,:);
    end
end

test_ans1=symbol_test(symbol_Txscreen_index)
test_ans2=symbol_received(symbol_Txscreen_index)

%% search for premble
premble_flag=0;
premble_number = 8; %4 for 500us; 8 for 1ms
premble_symbol = 16;
premble_location=find(symbol_received==premble_symbol);
for i=1:length(premble_location)-2
    %     if premble_location(i+1)==2156
    %         tttt=1;
    %     end
    % 5 for other premble detection (like intensity 9) except for intensity 3
    if premble_location(i+1)-premble_location(i)==1 || premble_location(i+1)-premble_location(i)==2 || premble_location(i+1)-premble_location(i)==3 || premble_location(i+1)-premble_location(i)==4 || premble_location(i+1)-premble_location(i)==5
        premble_flag=premble_flag+1;
    else
        premble_flag=0;
    end
    if premble_flag>=premble_number
        premble_index=premble_location(i+1)+1;
    end
end
%premble_index=2798;
%%  slope detection calibration
% symbol_test=[];
% symbol_test=symbol_received;
% T_screen=diff(symbol_Txscreen_index);
% Slope_threshold=0.02;
% delta_dis=[];
% for ii=1:length(symbol_Txscreen_index)
%     delta_k=[];
%     %     if symbol_Txscreen_index(ii)==2604
%     %         tttt=1;
%     %     end
%     for jj=1:M-1
%         delta_k(jj)=abs((y(symbol_Txscreen_index(ii))-CSK_y_screen)/(x(symbol_Txscreen_index(ii))-CSK_x_screen)-(CSK_y(jj)-CSK_y_screen)/(CSK_x(jj)-CSK_x_screen));
%     end
%     delta_dis(ii) = sqrt((x(symbol_Txscreen_index(ii))-CSK_x(M))^2+(y(symbol_Txscreen_index(ii))-CSK_y(M))^2)
%     [kvalue_min, kindex_min]=min(delta_k);
%     symbol_received(symbol_Txscreen_index(ii)) = graycode_dec(kindex_min+1,:);
%     if delta_dis(ii)<Slope_threshold
%         symbol_received(symbol_Txscreen_index(ii))=16;
%     end
% end
% 
% test_ans1=symbol_test(symbol_Txscreen_index)
% test_ans2=symbol_received(symbol_Txscreen_index)


%% detection stage
% premble_index =740;
% symbol_received = symbol_test;
symbol_received_recovered=[];
symbol_index=[];
temp_com = symbol_received(premble_index-1);
count_flag=0;
symbol_flag=0;

% identical
for ii=premble_index:length_min
    %     if length(symbol_received_recovered)==503
    %         tttt=1;
    %     end
    if symbol_received(ii)==temp_com
        count_flag=count_flag+1;
        symbol_flag=symbol_flag+1;
    else
        if ii~=length_min
            symbol_flag=symbol_flag+1;
            if symbol_received(ii+1)~=temp_com
                count_flag=0;
                temp_com = symbol_received(ii);
            end
        end
    end
    if symbol_flag > 4 %没有3个相同的符号也要从中去一个符号
        symbol_received_recovered = [symbol_received_recovered, symbol_received(ii-1)];
        symbol_index = [symbol_index, ii-1];
        symbol_flag=0;
        count_flag=0;
        %temp_com = symbol_received(ii);
    end
    if count_flag == 2 %
        symbol_received_recovered = [symbol_received_recovered, symbol_received(ii-1)];
        symbol_index = [symbol_index, ii-1];
        symbol_flag=0;
        if symbol_received(ii)==temp_com && symbol_received(ii-1)==temp_com  %排除5个一样的符号被判定为两个符号
            count_flag=-1;
        else
            count_flag=0;
        end
        
    end
end

%Draw the detected symbols
figure(7)
plotChromaticity
hold on
scatter(x(symbol_index),y(symbol_index),48,'black');

%% BER calculation stage


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
    bit_received_recovered = [bit_received_recovered, normalcode_bin(symbol_received_recovered(ii)+1,:)];
end
bit_original=[];
for ii=1:length(symbol_original)
    bit_original = [bit_original, normalcode_bin(symbol_original(ii)+1,:)];
end

%% RS decode
msglen=20;
ecclen=10;

message_original_ASCII = [0,68,50,20,199,66,84,182,53,207,132,101,58,86,215,198,117,190,119,223];
for jj=1:fix(length(bit_received_recovered)/8)
    message(jj)= bi2de(bit_received_recovered(8*jj:-1:8*(jj-1)+1));
    message_encoded(jj)=char(message(jj));
end

message_encoded_ASCII=abs(message_encoded)
message_decoded=[];

% received char type
% for ii=1:fix(length(message_encoded_ASCII)/(msglen+ecclen))
%     temp=[];
%     temp=Decode_BER_32(message_encoded_ASCII((msglen+ecclen)*(ii-1)+1:(msglen+ecclen)*ii));
%     if length(temp)>=msglen
%         message_decoded=[message_decoded temp(1:msglen)];% Input: ASCII code of message
%     else
%         message_decoded=[message_decoded message_encoded((ii-1)*(msglen+ecclen)+1:(ii-1)*(msglen+ecclen)+msglen)];
%     end  
% end

% received ASCII type
for ii=1:fix(length(message_encoded_ASCII)/(msglen+ecclen))
    temp=[];
    temp=Decode_BER_32(message_encoded_ASCII((msglen+ecclen)*(ii-1)+1:(msglen+ecclen)*ii));
    temp(find(temp<0))=temp(find(temp<0))+256;
    temp = char(temp);
    if length(temp)>=msglen && isequal(abs(temp), message_original_ASCII)
        message_decoded=[message_decoded temp(1:msglen)];% Input: ASCII code of message
    else
        message_decoded=[message_decoded message_encoded((ii-1)*(msglen+ecclen)+1:(ii-1)*(msglen+ecclen)+msglen)];
    end  
end



message_decoded_ASCII=abs(message_decoded);
message_decoded_bit_temp=dec2bin(message_decoded_ASCII,8);
bit_received_recovered_RS=[];
for i=1:length(message_decoded_bit_temp)
    for j=1:8
         bit_received_recovered_RS(1,8*(i-1)+j) = str2num(message_decoded_bit_temp(i,j));
    end
end



BER_CSK=sum(abs(bit_received_recovered_RS(1:length(bit_received_recovered_RS))-bit_original(1:length(bit_received_recovered_RS))))/(length(bit_received_recovered_RS))%sum(bit_received~=bit_original)

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


% x(find(x==0))=[];
% x(find(isnan(x)))=[];
% y(find(y==0))=[];
% y(find(isnan(y)))=[];
% z(find(z==0))=[];
% z(find(isnan(z)))=[];
%
% x_output = mean(x);
% y_output = mean(y);
% z_output = mean(z);
% X_output = mean(X);
% Y_output = mean(Y);
% Z_output = mean(Z);


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



