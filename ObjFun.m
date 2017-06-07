%活动足末端的位置坐标+偏角
%%单位设定：
% xp: mm
% zp: mm
% th: 。

function Y = ObjFun(Input)

% 调用全局变量:Xp
global Xp;
% 调用全局变量:Joint2/Joint3/Joint4
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
    
    % 运动代价指标:maxJoint    ===> 各关节角位移最大变化量
    Joint = [abs(theta2 - Joint2), abs(theta3 - Joint3), abs(theta4 - Joint4)];  
    maxJoint = max(Joint);
  
    % 稳定性指标:Zcr           ===> 质心位置
    Zcr = CenterOfMass(0, theta2, theta3, theta4);
    
    % 关节移动方向限制flag 
    if (Joint2 - theta2 >0)
        flag = 0;
    else
        flag = 1;
    end
    
    % 适应度函数(最小化):综合各项指标   ===> 遗传算法的核心部分
    % 权重系数:  w1==>稳定性指标权重   w2==>运动代价权重
    w1 = 1;
    w2 = 1;
   
    ObjV(tmp) = w1*Zcr + w2*maxJoint + 500*flag; 
    tmp = tmp +1;
end
% 传出计算结果
Y = ObjV;






