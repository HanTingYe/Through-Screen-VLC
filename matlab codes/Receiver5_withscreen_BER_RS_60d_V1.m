%% Best performance for most screen intensity 13000 0.02 0.02
clc
clear
close all


%%

load Results_RS_original8CSK_31_60d3.mat
premble_index=0;
p_flag=1;%1 represents cal preamble; otherwise 0

%%


for i=0:length(data)-3
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
    if y(j)>0.8
        x(j)=0.655;
        y(j)=0.31;
    end
end

figure(4)
plotChromaticity
hold on
scatter(x,y,48,'black');



%% BER calculation
M = 8;
%CSK_x = [0.381942857142857,0.188576022289933,0.401307346709709,0.214136614140756,0.477260268541437,0.310811373701920,0.173615146256616,0.654400000000000];
%CSK_y = [0.548100000000000,0.578542622160750,0.403195840982403,0.376153382924473,0.309090389478264,0.231160699731439,0.0915373448088586,0.320500000000000];


%30 degree
CSK_x = [0.292,0.245,0.313,0.23,0.348,0.234,0.133,0.64];
CSK_y = [0.642,0.631,0.531,0.54,0.391,0.34,0.156,0.28];

% CSK_x_screen = 0.654400000000000;
% CSK_y_screen = 0.320500000000000;
CSK_x_screen = 0.64;%0.665
CSK_y_screen = 0.325;%0.3
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





%% Distinguish between screen signal points and non-screen signal points
screen_threshold=13000;%mean(X(premble_index:length_min)) 0 for intensity 31
symbol_Txscreen_index = [];
symbol_Tx_index = [];
symbol_Txscreen_index = find(X(1:length_min)>screen_threshold);
symbol_Tx_index = find(X(1:length_min)<=screen_threshold);

%Draw screen signal points
figure(5)
plotChromaticity
hold on
scatter(x(symbol_Txscreen_index),y(symbol_Txscreen_index),48,'black');

%Draw screen signal points
figure(6)
plotChromaticity
hold on
scatter(x(symbol_Tx_index),y(symbol_Tx_index),48,'black');


%%  slope detection V1
% symbol_test=[];
% symbol_test=symbol_received;
% T_screen=diff(symbol_Txscreen_index);
% Slope_threshold=0.02;
% delta_dis=[];
% for ii=1:length(symbol_Txscreen_index)
%     delta_k=[];
%     %     if symbol_Txscreen_index(ii)==3433
%     %         tttt=1;
%     %     end
%     for jj=1:M-1
%         delta_k(jj)=abs((y(symbol_Txscreen_index(ii))-CSK_y_screen)/(x(symbol_Txscreen_index(ii))-CSK_x_screen)-(CSK_y(jj)-CSK_y_screen)/(CSK_x(jj)-CSK_x_screen));
%     end
%     delta_dis(ii) = sqrt((x(symbol_Txscreen_index(ii))-CSK_x(M))^2+(y(symbol_Txscreen_index(ii))-CSK_y(M))^2)
%     [kvalue_min, kindex_min]=min(delta_k);
%     switch(kindex_min)
%         case 1 %not specific number, just an order
%             symbol_received(symbol_Txscreen_index(ii)) = 0;
%         case 2
%             symbol_received(symbol_Txscreen_index(ii)) = 1;
%         case 3
%             symbol_received(symbol_Txscreen_index(ii)) = 3;
%         case 4
%             symbol_received(symbol_Txscreen_index(ii)) = 2;
%         case 5
%             symbol_received(symbol_Txscreen_index(ii)) = 6;
%         case 6
%             symbol_received(symbol_Txscreen_index(ii)) = 7;
%         case 7
%             symbol_received(symbol_Txscreen_index(ii)) = 5;
%     end
%     if delta_dis(ii)<Slope_threshold
%         symbol_received(symbol_Txscreen_index(ii))=4;
%     end
% end
% 
% test_ans1=symbol_test(symbol_Txscreen_index)
% test_ans2=symbol_received(symbol_Txscreen_index)


%%  slope detection V2
symbol_test=[];
symbol_test=symbol_received;
% CSK_x_underscreen = [0.608, 0.624, 0.623, 0.596, 0.632, 0.617, 0.586, 0.656];
% CSK_y_underscreen = [0.349, 0.332, 0.324, 0.319, 0.310, 0.303, 0.278, 0.311];
% CSK_x_underscreen = [0.610, 0.622, 0.616, 0.591, 0.624, 0.599, 0.572, 0.655];
% CSK_y_underscreen = [0.347, 0.331, 0.320, 0.316, 0.307, 0.294, 0.271, 0.311];

%30 degree
% CSK_x_underscreen = [0.557, 0.592, 0.585, 0.570, 0.609, 0.597, 0.585, 0.643];
% CSK_y_underscreen = [0.404, 0.369, 0.361, 0.364, 0.335, 0.329, 0.309, 0.321];

%40 degree
% CSK_x_underscreen = [0.581, 0.603, 0.602, 0.590, 0.617, 0.610, 0.605, 0.639];
% CSK_y_underscreen = [0.385, 0.361, 0.356, 0.361, 0.339, 0.337, 0.326, 0.327];

%50 degree
% CSK_x_underscreen = [0.594, 0.611, 0.611, 0.599, 0.622, 0.615, 0.609, 0.639];
% CSK_y_underscreen = [0.372, 0.355, 0.348, 0.354, 0.336, 0.335, 0.328, 0.327];

%60 degree
% CSK_x_underscreen = [0.618, 0.616, 0.626, 0.616, 0.630, 0.622, 0.617, 0.640];
% CSK_y_underscreen = [0.347, 0.346, 0.338, 0.340, 0.332, 0.333, 0.331, 0.326];

%60 degree V2
CSK_x_underscreen = [0.618, 0.626, 0.626, 0.616, 0.630, 0.622, 0.617, 0.640];
CSK_y_underscreen = [0.347, 0.340, 0.338, 0.340, 0.332, 0.333, 0.331, 0.326];

T_screen=diff(symbol_Txscreen_index);
Slope_threshold=0.05;
delta_dis=[];
for ii=1:length(symbol_Txscreen_index)
    delta_k=[];
        if symbol_Txscreen_index(ii)==2604
            tttt=1;
        end
    
    
    if sqrt((x(symbol_Txscreen_index(ii))-CSK_x_underscreen(M))^2+(y(symbol_Txscreen_index(ii))-CSK_y_underscreen(M))^2)>Slope_threshold
        delta_k=[];
            for jj=1:M-1
                delta_k(jj)=abs((y(symbol_Txscreen_index(ii))-CSK_y_screen)/(x(symbol_Txscreen_index(ii))-CSK_x_screen)-(CSK_y(jj)-CSK_y_screen)/(CSK_x(jj)-CSK_x_screen));
            end
            [kvalue_min, kindex_min]=min(delta_k);
        switch(kindex_min)
        case 1 %not specific number, just an order
            symbol_received(symbol_Txscreen_index(ii)) = 0;
        case 2
            symbol_received(symbol_Txscreen_index(ii)) = 1;
        case 3
            symbol_received(symbol_Txscreen_index(ii)) = 3;
        case 4
            symbol_received(symbol_Txscreen_index(ii)) = 2;
        case 5
            symbol_received(symbol_Txscreen_index(ii)) = 6;
        case 6
            symbol_received(symbol_Txscreen_index(ii)) = 7;
        case 7
            symbol_received(symbol_Txscreen_index(ii)) = 5;
        end
    else
        delta_d=[];
        for jj=1:M
            delta_d(jj)=sqrt((x(symbol_Txscreen_index(ii))-CSK_x_underscreen(jj))^2+(y(symbol_Txscreen_index(ii))-CSK_y_underscreen(jj))^2);
        end
        [value_min, index_min]=min(delta_d);
        switch(index_min)
        case 1 %not specific number, just an order
            symbol_received(symbol_Txscreen_index(ii)) = 0;
        case 2
            symbol_received(symbol_Txscreen_index(ii)) = 1;
        case 3
            symbol_received(symbol_Txscreen_index(ii)) = 3;
        case 4
            symbol_received(symbol_Txscreen_index(ii)) = 2;
        case 5
            symbol_received(symbol_Txscreen_index(ii)) = 6;
        case 6
            symbol_received(symbol_Txscreen_index(ii)) = 7;
        case 7
            symbol_received(symbol_Txscreen_index(ii)) = 5;
        case 8
            symbol_received(symbol_Txscreen_index(ii)) = 4;
        end
    end
end

test_ans1=symbol_test(symbol_Txscreen_index)
test_ans2=symbol_received(symbol_Txscreen_index)
%% search for premble
if (p_flag==1)
premble_flag=0;
premble_number = 24; %4 for 500us; 8 for 1ms; 24 for intensity 31
premble_location=find(symbol_received==4)
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
end
%%  slope detection calibration V1

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
%     switch(kindex_min)
%         case 1 %not specific number, just an order
%             symbol_received(symbol_Txscreen_index(ii)) = 0;
%         case 2
%             symbol_received(symbol_Txscreen_index(ii)) = 1;
%         case 3
%             symbol_received(symbol_Txscreen_index(ii)) = 3;
%         case 4
%             symbol_received(symbol_Txscreen_index(ii)) = 2;
%         case 5
%             symbol_received(symbol_Txscreen_index(ii)) = 6;
%         case 6
%             symbol_received(symbol_Txscreen_index(ii)) = 7;
%         case 7
%             symbol_received(symbol_Txscreen_index(ii)) = 5;
%     end
%     if delta_dis(ii)<Slope_threshold
%         symbol_received(symbol_Txscreen_index(ii))=4;
%     end
% end
% 
% test_ans1=symbol_test(symbol_Txscreen_index)
% test_ans2=symbol_received(symbol_Txscreen_index)

%%  slope detection calibration V2
% symbol_test=[];
% symbol_test=symbol_received;
% CSK_x_underscreen = [0.608, 0.624, 0.623, 0.596, 0.632, 0.617, 0.586, 0.656];
% CSK_y_underscreen = [0.349, 0.332, 0.324, 0.319, 0.310, 0.303, 0.278, 0.311];
% T_screen=diff(symbol_Txscreen_index);
% Slope_threshold=0.075;
% delta_dis=[];
% for ii=1:length(symbol_Txscreen_index)
%     delta_k=[];
%         if symbol_Txscreen_index(ii)==2604
%             tttt=1;
%         end
%     
%     
%     if sqrt((x(symbol_Txscreen_index(ii))-CSK_x_underscreen(M))^2+(y(symbol_Txscreen_index(ii))-CSK_y_underscreen(M))^2)>Slope_threshold
%         delta_k=[];
%             for jj=1:M-1
%                 delta_k(jj)=abs((y(symbol_Txscreen_index(ii))-CSK_y_screen)/(x(symbol_Txscreen_index(ii))-CSK_x_screen)-(CSK_y(jj)-CSK_y_screen)/(CSK_x(jj)-CSK_x_screen));
%             end
%             [kvalue_min, kindex_min]=min(delta_k);
%         switch(kindex_min)
%         case 1 %not specific number, just an order
%             symbol_received(symbol_Txscreen_index(ii)) = 0;
%         case 2
%             symbol_received(symbol_Txscreen_index(ii)) = 1;
%         case 3
%             symbol_received(symbol_Txscreen_index(ii)) = 3;
%         case 4
%             symbol_received(symbol_Txscreen_index(ii)) = 2;
%         case 5
%             symbol_received(symbol_Txscreen_index(ii)) = 6;
%         case 6
%             symbol_received(symbol_Txscreen_index(ii)) = 7;
%         case 7
%             symbol_received(symbol_Txscreen_index(ii)) = 5;
%         end
%     else
%         delta_d=[];
%         for jj=1:M
%             delta_d(jj)=sqrt((x(symbol_Txscreen_index(ii))-CSK_x_underscreen(jj))^2+(y(symbol_Txscreen_index(ii))-CSK_y_underscreen(jj))^2);
%         end
%         [value_min, index_min]=min(delta_d);
%         switch(index_min)
%         case 1 %not specific number, just an order
%             symbol_received(symbol_Txscreen_index(ii)) = 0;
%         case 2
%             symbol_received(symbol_Txscreen_index(ii)) = 1;
%         case 3
%             symbol_received(symbol_Txscreen_index(ii)) = 3;
%         case 4
%             symbol_received(symbol_Txscreen_index(ii)) = 2;
%         case 5
%             symbol_received(symbol_Txscreen_index(ii)) = 6;
%         case 6
%             symbol_received(symbol_Txscreen_index(ii)) = 7;
%         case 7
%             symbol_received(symbol_Txscreen_index(ii)) = 5;
%         case 8
%             symbol_received(symbol_Txscreen_index(ii)) = 4;
%         end
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

FEC_symbol=[1 0 5 5 4 7 4 2 2 6 2 1 4 5 3 1];
symbol_original_RS=[];
for ii=1:fix(length(symbol_received_recovered)/48)
    symbol_original_RS=[symbol_original_RS symbol_original(1:32)];
    symbol_original_RS=[symbol_original_RS FEC_symbol];
end

symbol_error=symbol_original_RS-symbol_received_recovered(1:length(symbol_original_RS));

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

%% RS decode

msglen=12;
ecclen=6;
message_original_ASCII = [5,57,119,5,57,119,5,57,119,5,57,119];


for jj=1:fix(length(bit_received_recovered)/8)
    message(jj)= bi2de(bit_received_recovered(8*jj:-1:8*(jj-1)+1));
    message_encoded(jj)=char(message(jj));
end

message_encoded_ASCII=abs(message_encoded)
message_decoded=[];

% received char type
% for ii=1:fix(length(message_encoded_ASCII)/(msglen+ecclen))
%     temp=[];
%     temp=Decode_BER(message_encoded_ASCII((msglen+ecclen)*(ii-1)+1:(msglen+ecclen)*ii));
%     if length(temp)>=msglen
%         message_decoded=[message_decoded temp(1:msglen)];% Input: ASCII code of message
%     else
%         message_decoded=[message_decoded message_encoded((ii-1)*(msglen+ecclen)+1:(ii-1)*(msglen+ecclen)+msglen)];
%     end  
% end


% received ASCII type
for ii=1:fix(length(message_encoded_ASCII)/(msglen+ecclen))
    temp=[];
    temp=Decode_BER(message_encoded_ASCII((msglen+ecclen)*(ii-1)+1:(msglen+ecclen)*ii));
    temp(find(temp<0))=temp(find(temp<0))+256;
    temp = char(temp);
    if length(temp)>=msglen && isequal(abs(temp(1:msglen)), message_original_ASCII)
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



