% ===================================================
% *** FUNCTION camera_demo
% ***
% *** function camera_demo(linflag, spflag)
% *** demonstrates camera characterization
% *** performs linearization and spatial correction if
% *** linflag and spflag are set respectively
% *** requires cc.tif and grey.mat are in the path
% *** see also camera_demo1
% ===================================================
function camera_demo(linflag, spflag)
data = double(imread('cc.tif','tif'))/255;
imshow(uint8(255*data))

if (linflag) % perform linearization
    load grey.mat
    % greyy 13x1
    % greyrgb 13x3

    figure
    greyrgb=greyrgb/255;
    plot(greyrgb(:,1),greyy,'ro') 
    hold on
    plot(greyrgb(:,2),greyy,'go') 
    hold on
    plot(greyrgb(:,3),greyy,'bo') 

    % compute nonlinearity of each channel
    x1=linspace(0,1,101);
    % red channel
    x = 1;
    options = optimset;
    x = fminsearch(@gtest,x,options,greyrgb(:,1), greyy(:,1)); 
    gamma(1) = x;
    y1 = x1.^gamma(1);
    hold on
    plot(x1,y1,'r-');
    % green channel
    x = 1;
    options = optimset;
    x = fminsearch(@gtest,x,options,greyrgb(:,2), greyy(:,1)); 
    gamma(2) = x;
    y1 = x1.^gamma(2);
    hold on
    plot(x1,y1,'g-');
    % blue channel
    x = 1;
    options = optimset;
    x = fminsearch(@gtest,x,options,greyrgb(:,3), greyy(:,1)); 
    gamma(3) = x;
    y1 = x1.^gamma(3);
    hold on
    plot(x1,y1,'b-');

    greyrgb(:,1) = greyrgb(:,1).^gamma(1);
    greyrgb(:,2) = greyrgb(:,2).^gamma(2);
    greyrgb(:,3) = greyrgb(:,3).^gamma(3);

    figure
    plot(greyrgb(:,1),greyy,'ro') 
    hold on
    plot(greyrgb(:,2),greyy,'go') 
    hold on
    plot(greyrgb(:,3),greyy,'bo') 
    
    data(:,:,1)=data(:,:,1).^gamma(1);
    data(:,:,2)=data(:,:,2).^gamma(2);
    data(:,:,3)=data(:,:,3).^gamma(3);
    
    disp(gamma)

    imwrite(uint8(255*data),'cc_lin.tif','tif');
    figure
    imshow(uint8(255*data))
else
    gamma = [1 1 1]; % needed in case spatial correction is called
end

if (spflag)
    % spatial correction
    grey = (double(imread('ccgrey.tif','tif')))/255;
    grey(:,:,1)=grey(:,:,1).^gamma(1);
    grey(:,:,2)=grey(:,:,2).^gamma(2);
    grey(:,:,3)=grey(:,:,3).^gamma(3);
    black = (double(imread('ccblack.tif','tif')))/255;
    black(:,:,1)=black(:,:,1).^gamma(1);
    black(:,:,2)=black(:,:,2).^gamma(2);
    black(:,:,3)=black(:,:,3).^gamma(3);

    meangrey = mean(mean(grey));
    meanblack = mean(mean(black));

    data(:,:,1) = (meangrey(1)-meanblack(1))*(data(:,:,1)-black(:,:,1))./(grey(:,:,1)-black(:,:,1));
    data(:,:,2) = (meangrey(2)-meanblack(2))*(data(:,:,2)-black(:,:,2))./(grey(:,:,3)-black(:,:,2));
    data(:,:,3) = (meangrey(3)-meanblack(3))*(data(:,:,3)-black(:,:,3))./(grey(:,:,3)-black(:,:,3));

    imwrite(uint8(255*data),'cc_lin_sp.tif','tif');
    figure
    imshow(uint8(255*data))
end

index = 0;
for col = 80:35:745
    for row=65:35:450
        index = index+1;
        rgb(index,:)=mean(mean(data(row-5:row+5,col-5:col+5,:)));       
    end
end
save 'rgb_cc.mat' rgb

end

function [err] = gtest(x,rgb,y)
% force to be row matrices
rgb = rgb(:)';
y = y(:)';
gamma=x;
if (length(rgb) ~= length(y))
   disp('vectors must be the same length'); 
   err = 0;
   return
end

% compute predictions with gamma
for i=1:length(rgb)
   if (rgb(i)) <= 0
      pred(i)=0;      
   else
      pred(i)=rgb(i)^gamma;    
   end
end
pred = pred(:)';
% compute rms error
err = sqrt((sum((y-pred).*(y-pred)))/length(y));
end
