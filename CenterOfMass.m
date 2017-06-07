function Y = CenterOfMass(theta1, theta2, theta3, theta4)
m1 = 0.5;
m2 = 0.7;
m3 = 0.8;
m4 = 0.4;
M = m1+m2+m3+m4;

xc22 = -70;
yc22 = 0;
zc22 = 0;
xc33 = -81;
yc33 = 0;
zc33 = 0;
xc44 = -30;
yc44 = 0;
zc44 = 0;

xc1 = 0;
yc1 = 0;
zc1 = 50;

% 排除异常情况1：数值不可行解
if isreal(theta2) && isreal(theta3) && isreal(theta4)
    M2 = Transform0_2(theta1, theta2)*[xc22 yc22 zc22 1]';
    xc2 = M2(1);
    yc2 = M2(2);
    zc2 = M2(3);
    M3 = Transform0_3(theta1, theta2, theta3)*[xc33 yc33 zc33 1]';
    xc3 = M3(1);
    yc3 = M3(2);
    zc3 = M3(3);
    M4 = Transform0_4(theta1, theta2, theta3, theta4)*[xc44 yc44 zc44 1]';
    xc4 = M4(1);
    yc4 = M4(2);
    zc4 = M4(3);
    Xcr = (m1*xc1+m2*xc2+m3*xc3+m4*xc4)/M;
    Ycr = (m1*yc1+m2*yc2+m3*yc3+m4*yc4)/M;
    Zcr = (m1*zc1+m2*zc2+m3*zc3+m4*zc4)/M;
    % 排除异常情况2：位置超出关节实际运动范围的解 
    if (theta2>0 && theta2<180) && (theta3>-102 && theta3<102) && (theta4>-103 && theta4<103)
        Y = Zcr;  
    else
        Y = 500;
    end
else
    Y = 500;
end









