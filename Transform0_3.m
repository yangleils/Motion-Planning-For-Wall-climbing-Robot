function T03 = Transform0_3(theta1, theta2, theta3)
 L1 = 126;
 L2 = 140;
 L3 = 163;
 theta1 = theta1*pi/180;
 theta2 = theta2*pi/180;
 theta3 = theta3*pi/180;
 
M11 = [1,0,0,0; 0,0,-1,0; 0,1,0,0; 0,0,0,1];
M12 = [1,0,0,0; 0,1,0,L1; 0,0,1,0; 0,0,0,1];
M13 = [cos(theta1),0,sin(theta1),0; 0,1,0,0; -sin(theta1),0,cos(theta1),0; 0,0,0,1];
T01 = M11*M12*M13;

M21 = [cos(theta2),-sin(theta2),0,0; sin(theta2),cos(theta2),0,0; 0,0,1,0; 0,0,0,1];
M22 = [1,0,0,L2; 0,1,0,0; 0,0,1,0; 0,0,0,1];
T12 = M21*M22;

M31 = [cos(theta3),-sin(theta3),0,0; sin(theta3),cos(theta3),0,0; 0,0,1,0; 0,0,0,1];
M32 = [1,0,0,L3; 0,1,0,0; 0,0,1,0; 0,0,0,1];
T23 = M31*M32;

T03 = T01*T12*T23;
