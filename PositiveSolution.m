function R = PositiveSolution(theta2, theta3, theta4)

L1 = 126;
L2 = 140;
L3 = 163;
L4 = 71;
th1 = theta2/180*pi;
th2 = theta3/180*pi;
th3 = theta4/180*pi;
x = L2*cos(th1)+L3*cos(th1+th2)+L4*cos(th1+th2+th3);
z = L1+L2*sin(th1)+L3*sin(th1+th2)+L4*sin(th1+th2+th3);
th = theta2+theta3+theta4;
R(1) = x;
R(2) = z;
R(3) = th;


