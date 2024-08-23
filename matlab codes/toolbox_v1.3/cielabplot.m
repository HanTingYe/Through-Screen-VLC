% ===================================================
% *** FUNCTION cielabplot
% ***
% *** function cielabplot
% *** creates a CIELAB figure representation
% *** see also cieplot
% ===================================================
plot([0 0],[-60 60],'k','LineWidth',2)
hold on
plot([-60 60],[0 0],'k','LineWidth',2)
axis([-60 60 -60 60])
gr = [0.7 0.7 0.7];
r = [.9 0 0];
g = [0 .9 0];
y = [.9 .9 0];
bl = [0 0 .9];
index = 0;
% first quadrant
index = index+1;
a = 50;
b = 0;
ab(index,:)=[a b];
col(index,:) = r;
for i=5:5:85
    index = index+1;
    a = cos(i*pi/180)*50;
    b = sin(i*pi/180)*50;
    ab(index,:)=[a b];
    c = (a*r+(50-a)*y)/50;
    col(index,:)=c; 
end
index = index+1;
a = 0;
b = 50;
ab(index,:)=[a b];
col(index,:) = y;
% grey
index = index+1;
a = 0;
b = 0;
ab(index,:)=[a b];
col(index,:) = gr;
 
patch('Vertices',ab, 'Faces',[1:size(ab,1)], 'EdgeColor','none', ...
    'FaceVertexCData',col,'FaceColor','interp')
clear ab;
 
index=0;
% second quadrant
index = index+1;
a = 0;
b = 50;
ab(index,:)=[a b];
col(index,:) = y;
for i=95:5:175
    index = index+1;
    a = cos(i*pi/180)*50;
    b = sin(i*pi/180)*50;
    ab(index,:)=[a b];
    c=(b*y+(50-b)*g)/50;   
    col(index,:)=c;   
end
index = index+1;
a = -50;
b = 0;
ab(index,:)=[a b];
col(index,:) = g;
% grey
index = index+1;
a = 0;
b = 0;
ab(index,:)=[a b];
col(index,:) = gr;
 
 
patch('Vertices',ab, 'Faces',[1:size(ab,1)], 'EdgeColor','none', ...
    'FaceVertexCData',col,'FaceColor','interp')
clear ab;
 
index=0;
% third quadrant
index = index+1;
a = -50;
b = 0;
ab(index,:)=[a b];
col(index,:) = g;
for i=185:5:265
    index = index+1;
    a = cos(i*pi/180)*50;
    b = sin(i*pi/180)*50;
    ab(index,:)=[a b];
    c=(-b*bl+(50+b)*g)/50;  
    col(index,:)=c;  
end
index = index+1;
a = 0;
b = -50;
ab(index,:)=[a b];
col(index,:) = bl;
% grey
index = index+1;
a = 0;
b = 0;
ab(index,:)=[a b];
col(index,:) = gr;
 
patch('Vertices',ab, 'Faces',[1:size(ab,1)], 'EdgeColor','none', ...
    'FaceVertexCData',col,'FaceColor','interp')
clear ab;
index=0;
% fourth quadrant
index = index+1;
a = 0;
b = -50;
ab(index,:)=[a b];
col(index,:) = bl;
for i=275:5:355
    index = index+1;
    a = cos(i*pi/180)*50;
    b = sin(i*pi/180)*50;
    ab(index,:)=[a b];
    c = (a*r+(50-a)*bl)/50;
    col(index,:)=c; 
end
index = index+1;
a = 50;
b = 0;
ab(index,:)=[a b];
col(index,:) = r;
% grey
index = index+1;
a = 0;
b = 0;
ab(index,:)=[a b];
col(index,:) = gr;
 
patch('Vertices',ab, 'Faces',[1:size(ab,1)], 'EdgeColor','none', ...
    'FaceVertexCData',col,'FaceColor','interp')
clear ab;
plot([0 0],[-60 60],'k','LineWidth',2)
plot([-60 60],[0 0],'k','LineWidth',2)

% ====================================================
% *** END FUNCTION cband
% ====================================================
