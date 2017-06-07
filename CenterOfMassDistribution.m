clear;clc;

X = 213;
z = 0:1:400;
th = -90:1:270;
[Y,TH] = meshgrid(z, th);

[m,n] = size(Y);
Zcr = zeros(m, n);

for i = 1:m
    for j = 1:n
       theta =  NegativeSolution(X, Y(i,j), TH(i,j));
       if isreal(theta(1))
          th2 = theta(1);
       else
          th2 = real(theta(1));
       end
       if isreal(theta(2))
          th3 = theta(2);
       else
          th3 = real(theta(2));
       end
       if isreal(theta(3))
          th4 = theta(3);
       else 
          th4 = real(theta(3));
       end
       
       Zcr(i, j) = CenterOfMass(0, th2, th3, th4);
    end
end
str = 'X = 150';
% 绘制曲面图
figure(1)
mesh(Zcr);
title(str);
% 绘制二维等高线图
figure(2)
[c,h]=contour(Y, TH, Zcr, 100);
title(str);
% set(h,'ShowText','on')         
%绘制三维等高线图
figure(3)
[c,h]=contour(Y, TH, Zcr, 100);
title(str);
% set(h,'ShowText','on')