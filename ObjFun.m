%���ĩ�˵�λ������+ƫ��
%%��λ�趨��
% xp: mm
% zp: mm
% th: ��

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

%������Сֵ
Y = ObjV;






