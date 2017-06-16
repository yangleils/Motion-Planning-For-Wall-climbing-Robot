%单位设定：
% xp: mm
% zp: mm
% th: 。

function R = NegativeSolution(xp, zp, th)

L1 = 126;
L2 = 140;
L3 = 163;
L4 = 71;


x = xp;
y = zp-L1;
r = th/180*pi;
AC = sqrt((x-L4*cos(r))*(x-L4*cos(r))+(y-L4*sin(r))*(y-L4*sin(r)));
c2 = (AC*AC-L2*L2-L3*L3)/(2*L2*L3);
cb = (AC*AC+L2*L2-L3*L3)/(2*L2*AC);
x1 = sign(x);
x2 = x1;

ta = (y-(L4*sin(r)))/(x-(L4*cos(r)));
if (abs(ta) > 10000)                                     % alpha 异常值处理
    alpha = 90*pi/180;
else
    alpha = atan(ta);                                    % alpha 正负情况处理  
end

beta = acos(cb);
if(alpha<0)&&(x>0)&&(zp>100)
    x1 = -1;
end
if(alpha>0)&&(x<0)&&(zp>100)
    x1 = 1;   
end
theta2 = ((1-x1)/2*pi+alpha+x2*beta)/pi*180;
theta3 = -x2*acos(c2)/pi*180;
theta4 = th-theta2-theta3;
R(1) = theta2;
R(2) = theta3;
R(3) = theta4;
