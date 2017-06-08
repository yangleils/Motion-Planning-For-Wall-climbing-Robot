clear;clc;

% 创建全局变量:Xp   ===>末端位置X轴方向坐标
global Xp;
% 创建全局变量:Joint2/Joint3/Joint4    ===>关节2/3/4历史位置
global Joint2;
global Joint3;
global Joint4;

% 遗传算法中的相关参数设定
NIND = 60;                %个体数目
MAXGEN = 500;             %最大遗传代数
PRECI = 30;               %变量二进制位数
NVAR = 2;                 %变量维度
GGAP = 0.8;               %代沟

% 不同Xp条件下，质心位置最优时对应的关节2/3/4角度值
angle = zeros(100, 3);
% 不同Xp条件下，质心位置最优时对应末端的位姿参数
pose = zeros(100, 3);

% 不同Xp条件下，质心的最优位置
centroid = zeros(15, 1);


FieldD = [rep(PRECI, [1, NVAR]); [0,-90;300,270]; rep([1;0;1;1], [1, NVAR])];
Chrom_0 = crtbp(NIND, NVAR*PRECI);

% 初始化全局变量
Xp = -263;
% 暂存初始值
Xtemp = Xp;

% 初始化全局变量：Joint2/Joint3/Joint4
joint = NegativeSolution(Xp, 0, 270);
Joint2 = joint(1);
Joint3 = joint(2);
Joint4 = joint(3);

index = 1;                    %结果矩阵索引

% 求解范围： Xp-->-3  取值间隔：10mm
for dis = 1:10:(floor(abs(Xtemp/10))+1)*10
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
        X1 = PositiveSolution(P(1), P(2), P(3)); 
                
        % 更新全局变量：Joint2/Joint3/Joint4
        Joint2 = P(1);
        Joint3 = P(2);
        Joint4 = P(3);
        
        centroid(index,:) = CenterOfMass(0, P(1), P(2), P(3));
        angle(index,:) = P;
        pose(index,:) = X;
        index = index + 1;
        
        % 更新全局变量：Xp
        Xp = Xp + 10;
end

% 绘制机器人末端在不同X坐标下的Zcr曲线
X = Xtemp:10:-3;
plot(X, centroid);
xlim([Xtemp, -3]);
set(gca, 'xtick', Xtemp:20:-3);
title(strcat('X=', int2str(Xtemp)));
xlabel('X/mm')
ylabel('Zcr/mm')

% 保存位置序列中关节2/3/4的角度值于data.txt文件中
fid_angle = fopen('angle.txt', 'w');
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
fclose(fid_angle);

% 保存位置序列中，末端位姿数据于pos.txt文件中
fid_pos = fopen('pos.txt', 'w');
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
fclose(fid_pos);




    