clear;clc;

%% 前期准备
% 全局变量:Xp   ===>末端位置X轴方向坐标
global Xp;
% 全局变量:Joint2/Joint3/Joint4    ===>关节2/3/4历史位置
global Joint2;
global Joint3;
global Joint4;

% 遗传算法中的相关参数设定
NIND = 60;                %个体数目
MAXGEN = 500;             %最大遗传代数
PRECI = 30;               %变量二进制位数
NVAR = 2;                 %变量维度
GGAP = 0.8;               %代沟

% 第一阶段：关节2/3/4位置序列
angle001 = zeros(10, 3);
% 第二阶段：关节2/3/4位置序列
angle002 = zeros(10, 3);
% 第三阶段：关节2/3/4位置序列
angle003 = zeros(10, 3);

% 第一阶段：末端位姿序列
pose001 = zeros(10, 3);
% 第二阶段：末端位姿序列
pose002 = zeros(10, 3);
% 第三阶段：末端位姿序列
pose003 = zeros(10, 3);

% 质心位置序列/Zcr
centroid = zeros(5, 1);
% 质心位置序列/Xcr
centroid_Xcr = zeros(5, 1);
% 质心位置索引
index = 1; 

%% 第一阶段      -193---->0    
% 初始化全局变量:初始位置
Xp = -203;
% 终止位置
Xend = 0;   
% 暂存初始值
Xtemp = Xp;
        
% 初始化全局变量：Joint2/Joint3/Joint4
joint = NegativeSolution(Xp, 0, 270);
Joint2 = joint(1);
Joint3 = joint(2);
Joint4 = joint(3);

FieldD = [rep(PRECI, [1, NVAR]); [0,-90;300,270]; rep([1;0;1;1], [1, NVAR])];
Chrom_0 = crtbp(NIND, NVAR*PRECI);

% 索引
index001 = 1; 

% 求解范围： Xp-->-3  取值间隔：10mm
for dis = 1:10:(floor(abs((Xtemp-Xend)/10))+1)*10
    trace = zeros(MAXGEN, 2);
    Chrom = Chrom_0;
    variable = bs2rv(Chrom, FieldD);
    ObjV = ObjFun(variable);
    for gen = 1:MAXGEN
        FitnV = ranking(ObjV);
        SelCh = select('sus', Chrom, FitnV, GGAP);
        SelCh = recombin('xovsp', SelCh, 0.7);
        SelCh = mut(SelCh);
        variable = bs2rv(SelCh, FieldD);

        ObjVSel = ObjFun(variable);
        [Chrom ObjV] = reins(Chrom, SelCh, 1, 1, ObjV, ObjVSel);
        gen = gen + 1;     

        temp = min(ObjV);
        if ~isreal(temp)
            temp = real(temp);
        end
        
        % 一个遗传算法流程中，目标值变化/优化趋势
        trace(gen, 1) = temp;
    end
        
        variable = bs2rv(Chrom, FieldD);
        
        [Y, I] = min(ObjV);
        ret = variable(I, :);
        P = NegativeSolution(Xp, ret(1), ret(2))
        X = [Xp, ret(1), ret(2)] 
                
        % 更新全局变量：Joint2/Joint3/Joint4
        Joint2 = P(1);
        Joint3 = P(2);
        Joint4 = P(3);
        
        val = CenterOfMass(0, P(1), P(2), P(3));
        centroid(index,:) = val(1);
        centroid_Xcr(index,:) = val(2);
        angle001(index,:) = P;
        pose001(index,:) = X;
        index = index + 1;
        
        % 更新全局变量：Xp
        Xp = Xp + 10;
end

%% 第二阶段
% 更新局部变量
theta2 = Joint2;
theta3 = Joint3;
theta4 = Joint4;

% 索引
index002 = 1; 
% X坐标
X02 = zeros(1,1);
% 关节2位置更新
while(theta2 > 0.1)
    if(theta2 > 5)
        theta2 = theta2 - 5;
        angle002(index002, :) = [theta2, theta3, theta4];
        val = CenterOfMass(0, theta2,theta3, theta4);
        centroid(index,:) = val(1);
        centroid_Xcr(index,:) = val(2);
        temp = PositiveSolution(theta2, theta3, theta4);
        pose002(index002, :) = temp;
        X02(index002,:) = temp(1);
        
    else
        theta2 = 0;
        angle002(index002, :) = [theta2, theta3, theta4];
        val = CenterOfMass(0, theta2,theta3, theta4);
        centroid(index,:) = val(1);
        centroid_Xcr(index,:) = val(2);
        temp = PositiveSolution(theta2, theta3, theta4);
        pose002(index002, :) = temp;
        X02(index002,:) = temp(1);
        
    end
    index = index + 1;
    index002 = index002 + 1;
end

% 关节3位置更新
while(theta3 > 0.1)
    if(theta3 > 5)
        theta3 = theta3 - 5;
        angle002(index002, :) = [theta2, theta3, theta4];
        val = CenterOfMass(0, theta2,theta3, theta4);
        centroid(index,:) = val(1);
        centroid_Xcr(index,:) = val(2);
        temp = PositiveSolution(theta2, theta3, theta4);
        pose002(index002, :) = temp;
        X02(index002,:) = temp(1);
       
    else
        theta3 = 0;
        angle002(index002, :) = [theta2, theta3, theta4];
        val = CenterOfMass(0, theta2,theta3, theta4);
        centroid(index,:) = val(1);
        centroid_Xcr(index,:) = val(2);
        temp = PositiveSolution(theta2, theta3, theta4);
        pose002(index002, :) = temp;
        X02(index002,:) = temp(1);
       
    end
    index = index + 1;
    index002 = index002 + 1;
end

% 关节4位置更新
while(theta4 > 0.1)
    if(theta4 >5)
        theta4 = theta4 - 5;
        angle002(index002, :) = [theta2, theta3, theta4];
        val = CenterOfMass(0, theta2,theta3, theta4);
        centroid(index,:) = val(1);
        centroid_Xcr(index,:) = val(2);
        temp = PositiveSolution(theta2, theta3, theta4);
        pose002(index002, :) = temp;
        X02(index002,:) = temp(1);
       
    else
        theta4 = 0;
        angle002(index002, :) = [theta2, theta3, theta4];
        val = CenterOfMass(0, theta2,theta3, theta4);
        centroid(index,:) = val(1);
        centroid_Xcr(index,:) = val(2);
        temp = PositiveSolution(theta2, theta3, theta4);
        pose002(index002, :) = temp;
        X02(index002,:) = temp(1);
        
    end   
    index = index + 1;
    index002 = index002 + 1;
end

%% 第三阶段
% 初始化全局变量:初始位置
Xp = 363;
% 终止位置
Xend = 203;   
% 暂存初始值
Xtemp = Xp;
        
% 初始化全局变量：Joint2/Joint3/Joint4
joint = [0,0,0];
Joint2 = joint(1);
Joint3 = joint(2);
Joint4 = joint(3);

% 取值范围定义
FieldD = [rep(PRECI, [1, NVAR]); [10,-90;126,0]; rep([1;0;1;1], [1, NVAR])];
Chrom_0 = crtbp(NIND, NVAR*PRECI);

% 索引
index003 = 1; 
% 求解范围： Xp-->-3  取值间隔：10mm
for dis = 1:10:(floor(abs((Xtemp-Xend)/10))+1)*10
    trace = zeros(MAXGEN, 2);
    Chrom = Chrom_0;
    variable = bs2rv(Chrom, FieldD);
    ObjV = ObjFun(variable);
    for gen = 1:MAXGEN
        FitnV = ranking(ObjV);
        SelCh = select('sus', Chrom, FitnV, GGAP);
        SelCh = recombin('xovsp', SelCh, 0.7);
        SelCh = mut(SelCh);
        variable = bs2rv(SelCh, FieldD);

        ObjVSel = ObjFun(variable);
        [Chrom ObjV] = reins(Chrom, SelCh, 1, 1, ObjV, ObjVSel);
        gen = gen + 1;     

        temp = min(ObjV);
        if ~isreal(temp)
            temp = real(temp);
        end
        
        % 一个遗传算法流程中，目标值变化/优化趋势
        trace(gen, 1) = temp;
    end
        
        variable = bs2rv(Chrom, FieldD);
        
        [Y, I] = min(ObjV);
        ret = variable(I, :);
        P = NegativeSolution(Xp, ret(1), ret(2))
        X = [Xp, ret(1), ret(2)] 
                
        % 更新全局变量：Joint2/Joint3/Joint4
        Joint2 = P(1);
        Joint3 = P(2);
        Joint4 = P(3);
        
        val = CenterOfMass(0, P(1), P(2), P(3));
        centroid(index,:) = val(1);
        centroid_Xcr(index,:) = val(2);
        angle003(index003,:) = P;
        pose003(index003,:) = X;
        % X坐标
             
        index = index + 1;
        index003 = index003 + 1;
        
        % 更新全局变量：Xp
        Xp = Xp - 10;
end

%% 质心位置曲线-----按节点
% plot(centroid, 'b*');
% hold on;
% plot(centroid_Xcr,'b','LineWidth',2);
% legend('Zcr','Xcr');
% xlabel('节点k');
% ylabel('质心位置/mm');

%% 质心位置曲线-----按末端X坐标
X01 = -203:10:-3;
X03 = 363:-10:203;
X = [X01, X02'];
X = [X, X03];
plot(X, centroid);
xlim([-230, 420]);
ylim([0, 250]);
xlabel('末端 X/mm');
ylabel('质心 Zcr/mm');
title('Compare Between GA with FSM-Key Point Interpolation');
%% 曲线关键点标注
KeyP1_y = centroid(1);
text(-203, KeyP1_y, '\leftarrow 状态1');

KeyP2_y = centroid(21);
text(-3, KeyP2_y, '\leftarrow 状态2');

KeyP3_y = centroid(65);
text(374, KeyP3_y, '\leftarrow 状态3');

KeyP4_y = centroid(82);
text(203, KeyP4_y, '\leftarrow 状态4')

%% 数据文件存储

% data.txt文件：保存关节2/3/4的位置序列
fid_angle = fopen('angle.txt', 'w');

angle = angle001;
angle = [angle; angle002];
angle = [angle; angle003];

[row, col] = size(angle);
row = index - 1;

for i=1:1:row
    for j=1:1:col
        if(j == col)
            fprintf(fid_angle, '%g\r\n', angle(i, j));
        else
            fprintf(fid_angle, '%g\t', angle(i, j));
        end
    end
end
% 关闭文件
fclose(fid_angle);

% pos.txt文件：保存末端位姿序列
fid_pos = fopen('pos.txt', 'w');
pose = pose001;
pose = [pose; pose002];
pose = [pose; pose003];
[row, col] = size(pose);
row = index - 1;

for i=1:1:row
    for j=1:1:col
        if(j == col)
            fprintf(fid_pos, '%g\r\n', pose(i, j));
        else
            fprintf(fid_pos, '%g\t', pose(i, j));
        end
    end
end
%关闭文件
fclose(fid_pos);
    