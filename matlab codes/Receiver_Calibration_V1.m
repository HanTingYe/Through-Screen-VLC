clc
clear
close all
%%

load Calibration_abnormalscreenred2_green.mat

for i=0:length(data)-1
    if channel_label(2*i+1)=='X'
        
        X=  [X,abs(data(i+1))]%所以在Arduino程序里要使用Serial.println()
        
        
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


%% Calculate screen color coordinates (white for 5000, )
% index=find(X>5000)
% 
% x_screen=[];
% y_screen=[];
% z_screen=[];
% for ii=1:length(index)
%     if index(ii)<=length(X) && index(ii)<=length(Y) && index(ii)<=length(Z)
%     x_screen(ii)=X(index(ii))/(X(index(ii))+Y(index(ii))+Z(index(ii)));
%     y_screen(ii)=Y(index(ii))/(X(index(ii))+Y(index(ii))+Z(index(ii)));
%     z_screen(ii)=Z(index(ii))/(X(index(ii))+Y(index(ii))+Z(index(ii)));
%     end
% end
% 
% x_screen_output = mean(x_screen);
% y_screen_output = mean(y_screen);
% z_screen_output = mean(z_screen);
% 
% 
% index_no=find(X<2500)
% 
% 
% 
% x_screen_no=[];
% y_screen_no=[];
% z_screen_no=[];
% for ii=1:length(index_no)
%     if index_no(ii)<=length(X) && index_no(ii)<=length(Y) && index_no(ii)<=length(Z)
%     x_screen_no(ii)=X(index_no(ii))/(X(index_no(ii))+Y(index_no(ii))+Z(index_no(ii)));
%     y_screen_no(ii)=Y(index_no(ii))/(X(index_no(ii))+Y(index_no(ii))+Z(index_no(ii)));
%     z_screen_no(ii)=Z(index_no(ii))/(X(index_no(ii))+Y(index_no(ii))+Z(index_no(ii)));
%     end
% end
% 
% x_screen_no(find(isnan(x_screen_no)))=[];
% y_screen_no(find(isnan(y_screen_no)))=[];
% z_screen_no(find(isnan(z_screen_no)))=[];
% 
% x_screen_output = mean(x_screen);
% y_screen_output = mean(y_screen);
% z_screen_output = mean(z_screen);
% 
% x_screen_output_no = mean(x_screen_no);
% y_screen_output_no = mean(y_screen_no);
% z_screen_output_no = mean(z_screen_no);


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

%% Calculate Tx color coordinates (white for 5000, )
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


%% Receive calibration  Tx: red 

% X(find(X==0))=[];
% X(find(isnan(X)))=[];
% Y(find(Y==0))=[];
% Y(find(isnan(Y)))=[];
% Z(find(Z==0))=[];
% Z(find(isnan(Z)))=[];
% % err=[];
% % for jj=1:1:length_min
% %     if x(jj)<0.2&&y(jj)>0.7
% %         err=[err jj];
% %     end
% % end
% 
% all_index=find(x)
% error_index=find(x<0.3)
% %error_index=find(X<6000) %6000 for abnormal screen 1
% normal_index=setdiff(all_index,error_index)
% X_err=X(error_index);
% Y_err=Y(error_index);
% Z_err=Z(error_index);
% X_nor=X(normal_index);
% Y_nor=Y(normal_index);
% Z_nor=Z(normal_index);
% figure(5)
% plotChromaticity
% hold on
% scatter(x(error_index),y(error_index),48,'black');
% 
% %Draw screen signal points
% figure(6)
% plotChromaticity
% hold on
% scatter(x(normal_index),y(normal_index),48,'black');
% 
% %recover
% %red
% for ii=1:length(error_index)
% X_recover(ii)=X(error_index(ii))+3839;%4000
% Y_recover(ii)=Y(error_index(ii))-28416;%28000
% Z_recover(ii)=Z(error_index(ii))-3058;%3000
% end
% 
% for jj=1:1:length(error_index)
%     x_recover(jj)=X_recover(jj)/(X_recover(jj)+Y_recover(jj)+Z_recover(jj));
%     y_recover(jj)=Y_recover(jj)/(X_recover(jj)+Y_recover(jj)+Z_recover(jj));
%     z_recover(jj)=Z_recover(jj)/(X_recover(jj)+Y_recover(jj)+Z_recover(jj));
% end
% 
% 
% figure(7)
% plotChromaticity
% hold on
% scatter(x_recover,y_recover,48,'black');
% 
% %display
% %red
% for ii=1:length(error_index)
% X(error_index(ii))=X(error_index(ii))+3839;%4000
% Y(error_index(ii))=Y(error_index(ii))-28416;%28000
% Z(error_index(ii))=Z(error_index(ii))-3058;%3000
% end
% 
% for jj=1:1:length(error_index)
%     x(error_index(jj))=X(error_index(jj))/(X(error_index(jj))+Y(error_index(jj))+Z(error_index(jj)));
%     y(error_index(jj))=Y(error_index(jj))/(X(error_index(jj))+Y(error_index(jj))+Z(error_index(jj)));
%     z(error_index(jj))=Z(error_index(jj))/(X(error_index(jj))+Y(error_index(jj))+Z(error_index(jj)));
% end
% 
% figure(8)
% plotChromaticity
% hold on
% scatter(x,y,48,'black');


%% Receive calibration  Tx: blue

% X(find(X==0))=[];
% X(find(isnan(X)))=[];
% Y(find(Y==0))=[];
% Y(find(isnan(Y)))=[];
% Z(find(Z==0))=[];
% Z(find(isnan(Z)))=[];
% % err=[];
% % for jj=1:1:length_min
% %     if x(jj)<0.2&&y(jj)>0.7
% %         err=[err jj];
% %     end
% % end
% 
% all_index=find(x)
% error_index=find(y>0.3)
% %error_index=find(X<2000) %2000 for abnormal screen 1
% normal_index=setdiff(all_index,error_index)
% X_err=X(error_index);
% Y_err=Y(error_index);
% Z_err=Z(error_index);
% X_nor=X(normal_index);
% Y_nor=Y(normal_index);
% Z_nor=Z(normal_index);
% figure(5)
% plotChromaticity
% hold on
% scatter(x(error_index),y(error_index),48,'black');
% 
% %Draw screen signal points
% figure(6)
% plotChromaticity
% hold on
% scatter(x(normal_index),y(normal_index),48,'black');
% 
% %recover
% %red
% for ii=1:length(error_index)
% X_recover(ii)=X(error_index(ii))+3839;
% Y_recover(ii)=Y(error_index(ii))-28416;
% Z_recover(ii)=Z(error_index(ii))-3058;
% end
% 
% for jj=1:1:length(error_index)
%     x_recover(jj)=X_recover(jj)/(X_recover(jj)+Y_recover(jj)+Z_recover(jj));
%     y_recover(jj)=Y_recover(jj)/(X_recover(jj)+Y_recover(jj)+Z_recover(jj));
%     z_recover(jj)=Z_recover(jj)/(X_recover(jj)+Y_recover(jj)+Z_recover(jj));
% end
% 
% 
% figure(7)
% plotChromaticity
% hold on
% scatter(x_recover,y_recover,48,'black');
% 
% %display
% %red
% for ii=1:length(error_index)
% X(error_index(ii))=X(error_index(ii))+5839;%4000 3839
% Y(error_index(ii))=Y(error_index(ii))-23040;%28000 28416
% Z(error_index(ii))=Z(error_index(ii))-2304;%3000 3058
% end
% 
% for jj=1:1:length(error_index)
%     x(error_index(jj))=X(error_index(jj))/(X(error_index(jj))+Y(error_index(jj))+Z(error_index(jj)));
%     y(error_index(jj))=Y(error_index(jj))/(X(error_index(jj))+Y(error_index(jj))+Z(error_index(jj)));
%     z(error_index(jj))=Z(error_index(jj))/(X(error_index(jj))+Y(error_index(jj))+Z(error_index(jj)));
% end
% 
% figure(8)
% plotChromaticity
% hold on
% scatter(x,y,48,'black');


%% Receive calibration  Tx: green Screen:red 2
X(find(X==0))=[];
X(find(isnan(X)))=[];
Y(find(Y==0))=[];
Y(find(isnan(Y)))=[];
Z(find(Z==0))=[];
Z(find(isnan(Z)))=[];
% err=[];
% for jj=1:1:length_min
%     if x(jj)<0.2&&y(jj)>0.7
%         err=[err jj];
%     end
% end

all_index=find(x)
error_index=find(y>0.7)
%error_index=find(X<2000) %2000 for abnormal screen 1
normal_index=setdiff(all_index,error_index)
X_err=X(error_index);
Y_err=Y(error_index);
Z_err=Z(error_index);
X_nor=X(normal_index);
Y_nor=Y(normal_index);
Z_nor=Z(normal_index);
figure(5)
plotChromaticity
hold on
scatter(x(error_index),y(error_index),48,'black');

%Draw screen signal points
figure(6)
plotChromaticity
hold on
scatter(x(normal_index),y(normal_index),48,'black');

%recover
%red
for ii=1:length(error_index)
X_recover(ii)=X(error_index(ii))+3839;
Y_recover(ii)=Y(error_index(ii))-28416;
Z_recover(ii)=Z(error_index(ii))-3058;
end

for jj=1:1:length(error_index)
    x_recover(jj)=X_recover(jj)/(X_recover(jj)+Y_recover(jj)+Z_recover(jj));
    y_recover(jj)=Y_recover(jj)/(X_recover(jj)+Y_recover(jj)+Z_recover(jj));
    z_recover(jj)=Z_recover(jj)/(X_recover(jj)+Y_recover(jj)+Z_recover(jj));
end


figure(7)
plotChromaticity
hold on
scatter(x_recover,y_recover,48,'black');

%display
%red
for ii=1:length(error_index)
X(error_index(ii))=X(error_index(ii))+2049;%4000 3839
Y(error_index(ii))=Y(error_index(ii))-26880;%28000 28416
Z(error_index(ii))=Z(error_index(ii))-2816;%3000 3058
end

for jj=1:1:length(error_index)
    x(error_index(jj))=X(error_index(jj))/(X(error_index(jj))+Y(error_index(jj))+Z(error_index(jj)));
    y(error_index(jj))=Y(error_index(jj))/(X(error_index(jj))+Y(error_index(jj))+Z(error_index(jj)));
    z(error_index(jj))=Z(error_index(jj))/(X(error_index(jj))+Y(error_index(jj))+Z(error_index(jj)));
end

figure(8)
plotChromaticity
hold on
scatter(x,y,48,'black');
%% BER calculation
% M = 8;
% CSK_x = [0.381942857142857,0.188576022289933,0.401307346709709,0.214136614140756,0.477260268541437,0.310811373701920,0.173615146256616,0.654400000000000];
% CSK_y = [0.548100000000000,0.578542622160750,0.403195840982403,0.376153382924473,0.309090389478264,0.231160699731439,0.0915373448088586,0.320500000000000];
% CSK_x_screen = 0.654400000000000;
% CSK_y_screen = 0.320500000000000;
% symbol=[];
% for ii=1:length_min
%     delta_d=[];
%     for jj=1:M
%         delta_d(jj)=sqrt((x(ii)-CSK_x(jj))^2+(y(ii)-CSK_y(jj))^2);
%     end
%     [value_min, index_min]=min(delta_d);
%     symbol(ii)=index_min-1;
% end
% bit_received=[];
% % grey code
% for ii=1:length_min
%     switch(symbol(ii))
%         case 0 %not specific number, just an order
%             bit_received = [bit_received, 0,0,0];
%         case 1
%             bit_received = [bit_received, 0,0,1];
%         case 2
%             bit_received = [bit_received, 0,1,1];
%         case 3
%             bit_received = [bit_received, 0,1,0];
%         case 4
%             bit_received = [bit_received, 1,1,0];
%         case 5
%             bit_received = [bit_received, 1,1,1];
%         case 6
%             bit_received = [bit_received, 1,0,1];
%         case 7
%             bit_received = [bit_received, 1,0,0];
%     end
% end
% 
% symbol_received=[];
% for ii=1:length_min
%     switch(symbol(ii))
%         case 0 %not specific number, just an order
%             symbol_received = [symbol_received, 0];
%         case 1
%             symbol_received = [symbol_received, 1];
%         case 2
%             symbol_received = [symbol_received, 3];
%         case 3
%             symbol_received = [symbol_received, 2];
%         case 4
%             symbol_received = [symbol_received, 6];
%         case 5
%             symbol_received = [symbol_received, 7];
%         case 6
%             symbol_received = [symbol_received, 5];
%         case 7
%             symbol_received = [symbol_received, 4];
%     end
% end
% 
% 
% 
% % search for premble
% premble_flag=0;
% premble_number = 8; %4 for 500us; 8 for 1ms
% premble_location=find(symbol_received==4)
% for i=1:length(premble_location)-2
%     if premble_location(i+1)-premble_location(i)==1
%         premble_flag=premble_flag+1;
%     elseif premble_location(i+2)-premble_location(i)==1
%         premble_flag=premble_flag+1;
%         i=i+2;
%     else
%         premble_flag=0;
%     end
%     if premble_flag>=premble_number
%         premble_index=premble_location(i+1)+1;
%     end
% end
% 
% %Distinguish between screen signal points and non-screen signal points
% screen_threshold=12000;%mean(X(premble_index:length_min))
% symbol_Txscreen_index = [];
% symbol_Tx_index = [];
% symbol_Txscreen_index = find(X(premble_index:length_min)>screen_threshold)+premble_index-1;
% symbol_Tx_index = find(X(premble_index:length_min)<=screen_threshold)+premble_index-1;
% 
% %Draw screen signal points
% figure(5)
% plotChromaticity
% hold on
% scatter(x(symbol_Txscreen_index),y(symbol_Txscreen_index),48,'black');
% 
% %Draw screen signal points
% figure(6)
% plotChromaticity
% hold on
% scatter(x(symbol_Tx_index),y(symbol_Tx_index),48,'black');
% 
% 
% %%  slope detection
% symbol_test=[];
% symbol_test=symbol_received;
% T_screen=diff(symbol_Txscreen_index);
% delta_dis=zeros(1,length_min);
% for ii=1:length(symbol_Txscreen_index)
%     delta_k=[];
%     for jj=1:M-1
%         delta_k(jj)=abs((y(symbol_Txscreen_index(ii))-CSK_y_screen)/(x(symbol_Txscreen_index(ii))-CSK_x_screen)-(CSK_y(jj)-CSK_y_screen)/(CSK_x(jj)-CSK_x_screen));
%     end
%     delta_dis(symbol_Txscreen_index(ii)) = sqrt((x(symbol_Txscreen_index(ii))-CSK_x(M))^2+(y(symbol_Txscreen_index(ii))-CSK_y(M))^2)
%     [kvalue_min, kindex_min]=min(delta_k);
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
%     if delta_dis(symbol_Txscreen_index(ii))<0.02
%         symbol_received(symbol_Txscreen_index(ii))=4;
%     end
% end
% 
% test_ans1=symbol_test(symbol_Txscreen_index)
% test_ans2=symbol_received(symbol_Txscreen_index)
% 
% 
% %% detection stage
% % premble_index =740;
% % symbol_received = symbol_test;
% symbol_received_recovered=[];
% symbol_index=[];
% temp_com = symbol_received(premble_index-1);
% count_flag=0;
% symbol_flag=0;
% 
% % identical
% for ii=premble_index:length_min
% %     if length(symbol_received_recovered)==503
% %         tttt=1;
% %     end
%     if symbol_received(ii)==temp_com
%         count_flag=count_flag+1;
%         symbol_flag=symbol_flag+1;
%     else
%         if ii~=length_min
%             symbol_flag=symbol_flag+1;
%             if symbol_received(ii+1)~=temp_com 
%                 count_flag=0;
%                 temp_com = symbol_received(ii);
%             end
%         end
%     end
%     if count_flag == 2 %
%         symbol_received_recovered = [symbol_received_recovered, symbol_received(ii-1)];
%         symbol_index = [symbol_index, ii-1];
%         symbol_flag=0;
%         if symbol_received(ii)==temp_com && symbol_received(ii-1)==temp_com  %排除5个一样的符号被判定为两个符号
%             count_flag=-1;
%         else
%             count_flag=0;
%         end
%         
%     end
%     if symbol_flag > 4 %没有3个相同的符号也要从中去一个符号
%         symbol_received_recovered = [symbol_received_recovered, symbol_received(ii-1)];
%         symbol_index = [symbol_index, ii-1];
%         symbol_flag=0;
%         count_flag=0;
%         %temp_com = symbol_received(ii);
%     end
% end
% 
% %Draw the detected symbols
% figure(7)
% plotChromaticity
% hold on
% scatter(x(symbol_index),y(symbol_index),48,'black');
% 
% %% BER calculation stage
% 
% 
% symbol_original(premble_index) = 0;
% 
% %single sample
% for ii=premble_index+1:length_min
%     symbol_original(ii)=symbol_original(ii-1)+1;
%     if symbol_original(ii)>=M
%         symbol_original(ii)=0;
%     end
% end
% symbol_original(1:premble_index-1)=[];
% 
% %Two sample
% % for ii=1:length_min/2-1
% %     symbol_original(2*ii)=symbol_original(2*ii-1);
% %     symbol_original(2*ii+1)=symbol_original(2*ii-1)+1;
% %     if symbol_original(2*ii+1)>=M
% %         symbol_original(2*ii+1)=0;
% %     end
% % end
% % symbol_original(2*ii+2)=symbol_original(2*ii+1);
% bit_received_recovered=[];
% for ii=1:length(symbol_received_recovered)
%     switch(symbol_received_recovered(ii))
%         case 0 %not specific number, just an order
%             bit_received_recovered = [bit_received_recovered, 0,0,0];
%         case 1
%             bit_received_recovered = [bit_received_recovered, 0,0,1];
%         case 2
%             bit_received_recovered = [bit_received_recovered, 0,1,0];
%         case 3
%             bit_received_recovered = [bit_received_recovered, 0,1,1];
%         case 4
%             bit_received_recovered = [bit_received_recovered, 1,0,0];
%         case 5
%             bit_received_recovered = [bit_received_recovered, 1,0,1];
%         case 6
%             bit_received_recovered = [bit_received_recovered, 1,1,0];
%         case 7
%             bit_received_recovered = [bit_received_recovered, 1,1,1];
%     end
% end
% bit_original=[];
% for ii=1:length(symbol_original)
%     switch(symbol_original(ii))
%         case 0 %not specific number, just an order
%             bit_original = [bit_original, 0,0,0];
%         case 1
%             bit_original = [bit_original, 0,0,1];
%         case 2
%             bit_original = [bit_original, 0,1,0];
%         case 3
%             bit_original = [bit_original, 0,1,1];
%         case 4
%             bit_original = [bit_original, 1,0,0];
%         case 5
%             bit_original = [bit_original, 1,0,1];
%         case 6
%             bit_original = [bit_original, 1,1,0];
%         case 7
%             bit_original = [bit_original, 1,1,1];
%     end
% end
% BER_CSK=sum(abs(bit_received_recovered(1:length(bit_received_recovered))-bit_original(1:length(bit_received_recovered))))/(length(bit_received_recovered))%sum(bit_received~=bit_original)
% 
% %%
% 
% % Lab = xyz2lab([x(1:length_min)' y(1:length_min)' z(1:length_min)']);
% % Lab = lab2double(Lab);
% %
% % figure(5)
% % L = Lab(:,1);
% % a =  Lab(:,2);
% % b =  Lab(:,3);
% % plot3(a,b,L,'o')
% % xlabel('a')
% % ylabel('b')
% % zlabel('L')
% % xlim([-128 128])
% % ylim([-128 128])
% % zlim([0 100])
% %
% % figure(6)
% % scatter(a,b);
% % xlabel('a')
% % ylabel('b')
% % xlim([-128 128])
% % ylim([-128 128])
% %
% 
% 
% % x(find(x==0))=[];
% % x(find(isnan(x)))=[];
% % y(find(y==0))=[];
% % y(find(isnan(y)))=[];
% % z(find(z==0))=[];
% % z(find(isnan(z)))=[];
% %
% % x_output = mean(x);
% % y_output = mean(y);
% % z_output = mean(z);
% % X_output = mean(X);
% % Y_output = mean(Y);
% % Z_output = mean(Z);
% 
% 
% % L_output = mean(L);
% %
% % % duty=10;
% % % color='B_';
% % % save([color num2str(duty)]);
% % % xlswrite(['X_' color num2str(duty) '.xlsx'],X_output);
% % % xlswrite(['Y_' color num2str(duty) '.xlsx'],Y_output);
% % % xlswrite(['Z_' color num2str(duty) '.xlsx'],Z_output);
% %
% % rgb_8 = xyz2rgb([x' y' (1-x-y)']);
% % figure(7)
% % colorSwatches(rgb_8(:,:));
% % %set(gca,'yticklabel',[]);
% % %set(gca,'ytick',[])
% % %xlim([0 50])
% % set(gca,'ytick',[],'yticklabel',[])
% % xlabel('Samples')
% % ylabel('Color')

%%

