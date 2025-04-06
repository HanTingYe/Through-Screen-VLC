clear

e = 0.000001;
p = 4.5;

% load 746 standard xyz and cmyk values
load train.mat
% separate X,Y,Z into one single column
ciexstd = xyz(:,1);
cieystd = xyz(:,2);
ciezstd = xyz(:,3);
% separate X,Y,Z into one single column
cstd = cmyk(:,1);
mstd = cmyk(:,2);
ystd = cmyk(:,3);
kstd = cmyk(:,4);

% load 104 test xyz and cmyk values
load test.mat
ctest = cmyk(:,1);
mtest = cmyk(:,2);
ytest = cmyk(:,3);
ktest = cmyk(:,4);

% calculate the distance between standard and test RGBs
for j=1:104

 % compute the errors for the jth samples
 for i=1:746
  distance(i) = ((ctest(j)-cstd(i))^2+(mtest(j)-mstd(i))^2+(ytest(j)-ystd(i))^2+(ktest(j)-kstd(i))^2)^(1/2);
  distance(i) = (distance(i))^(p) + e;
 end
 
 % now sort the values
 temp = [ciexstd cieystd ciezstd cstd mstd ystd kstd distance'];
 temp1 = sortrows(temp,8);
 % find the first 10 with smallest distance 
 temp2 = temp1(1:10,:);
 
  for n=1:10
   cdis(n) = (ctest(j)-temp2(n,4));
   mdis(n) = (mtest(j)-temp2(n,5));
   ydis(n) = (ytest(j)-temp2(n,6));
   kdis(n) = (ktest(j)-temp2(n,7));
  end
 
 temp3 = [temp2 cdis' mdis' ydis' kdis']; 
 temp4 = sortrows(temp3,8); 
 temp5 = sortrows(temp3,9); 
 temp6 = sortrows(temp3,10); 
 temp7 = sortrows(temp3,11); 
 
 % find the smallest positive and smallest negative values for each plane
 index1=0;
 for n=1:9
     if temp4(n,8)*temp4(n+1,8) <= 0
      index1 = n;
      index2 = n+1;
     end
 end
 if (index1==0)
  t = sprintf('no switch point found in sample %d cyan plane', j);
  disp(t)
  index1 = 1;
  index2 = 2;
 end
 
 index3 = 0;
 for n=1:9
     if temp5(n,9)*temp5(n+1,9) <= 0
      index3 = n;
      index4 = n+1;
     end
 end
 if (index3==0)
  t = sprintf('no switch point found in sample %d megenta plane', j);
  disp(t)
  index3 = 1;
  index4 = 2;
 end
 
 index5 = 0;
 for n=1:9
     if temp6(n,10)*temp6(n+1,10) <= 0
      index5 = n;
      index6 = n+1;
     end
 end
 if (index5==0)
  t = sprintf('no switch point found in sample %d yellow plane', j);
  disp(t)
  index5 = 1;
  index6 = 2;
 end

  index7 = 0;
 for n=1:9
     if temp7(n,11)*temp7(n+1,11) <= 0
      index7 = n;
      index8 = n+1;
     end
 end
 if (index7==0)
  t = sprintf('no switch point found in sample %d black plane', j);
  disp(t)
  index7 = 1;
  index8 = 2;
 end
 
 temp7(1,:) = temp4(index1,:);
 temp7(2,:) = temp4(index2,:);
 temp7(3,:) = temp5(index3,:);
 temp7(4,:) = temp5(index4,:);
 temp7(5,:) = temp6(index5,:);
 temp7(6,:) = temp6(index6,:);
 temp7(7,:) = temp6(index7,:);
 temp7(8,:) = temp6(index8,:);
  
 sample = 1./temp7(:,8);
 
 sample = sample/sum(sample);

 temp7(:,8) = sample;

 % find estimated XYZs for test samples
 Xest = temp7(:,1).*temp7(:,8);
 Xest = sum(Xest);
 
 Yest = temp7(:,2).*temp7(:,8);
 Yest = sum(Yest);
 
 Zest = temp7(:,3).*temp7(:,8);
 Zest = sum(Zest);
 
 xyzest(j,:) = [Xest Yest Zest];
end

Xest = xyzest(:,1);
Yest = xyzest(:,2);
Zest = xyzest(:,3);

disp([xyz xyzest])