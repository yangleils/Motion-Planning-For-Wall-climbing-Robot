%���ĩ�˵�λ������+ƫ��
%%��λ�趨��
% xp: mm
% zp: mm
% th: ��

function Y = ObjFun(Input)

% ����ȫ�ֱ���:Xp
global Xp;
% ����ȫ�ֱ���:Joint2/Joint3/Joint4
global Joint2;
global Joint3;
global Joint4;

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
    
    % �˶�����ָ��:maxJoint    ===> ���ؽڽ�λ�����仯��
    Joint = [abs(theta2 - Joint2), abs(theta3 - Joint3), abs(theta4 - Joint4)];  
    maxJoint = max(Joint);
  
    % �ȶ���ָ��:Zcr           ===> ����λ��
    Zcr = CenterOfMass(0, theta2, theta3, theta4);
    
    % �ؽ��ƶ���������flag 
    if (Joint2 - theta2 >0)
        flag = 0;
    else
        flag = 1;
    end
    
    % ��Ӧ�Ⱥ���(��С��):�ۺϸ���ָ��   ===> �Ŵ��㷨�ĺ��Ĳ���
    % Ȩ��ϵ��:  w1==>�ȶ���ָ��Ȩ��   w2==>�˶�����Ȩ��
    w1 = 1;
    w2 = 1;
   
    ObjV(tmp) = w1*Zcr + w2*maxJoint + 500*flag; 
    tmp = tmp +1;
end
% ����������
Y = ObjV;






