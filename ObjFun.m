%活动足末端的位置坐标+偏角
%%单位设定：
% xp: mm
% zp: mm
% th: 。

function Y = ObjFun(Input)

global Xp;

[row col] = size(Input);
ObjV = zeros(row,1);
tmp = 1;

while tmp <=row
    
zp = Input(tmp,1);
th = Input(tmp,2);

A = NegativeSolution(Xp, zp, th);
theta2 = A(1);
theta3 = A(2);
theta4 = A(3);

XYZ = CenterOfMass(0, theta2, theta3, theta4);
Zcr = XYZ;
ObjV(tmp) = Zcr;
tmp = tmp +1;
end

%定义最小值
Y = ObjV;






