clear;clc;

% 创建全局变量:Xp   ===>末端位置X轴方向坐标
global Xp;
% 创建全局变量:Joint2/Joint3/Joint4    ===>关节2/3/4历史位置
global Joint2;
global Joint3;
global Joint4;

NIND = 60;                %个体数目
MAXGEN = 500;             %最大遗传代数
PRECI = 30;               %变量二进制位数
NVAR = 2;                 %变量维度
GGAP = 0.8;               %代沟


result = zeros(100, 3);
centroid = zeros(15, 1);

FieldD = [rep(PRECI, [1, NVAR]); [0,-90;300,270]; rep([1;0;1;1], [1, NVAR])];
Chrom_0 = crtbp(NIND, NVAR*PRECI);

% 初始化全局变量
Xp = -235;
% 初始化全局变量：Joint2/Joint3/Joint4
joint = NegativeSolution(Xp, 0, 270);
Joint2 = joint(1);
Joint3 = joint(2);
Joint4 = joint(3);

i = 1;                    %结果矩阵索引
for dis = 1:10:200
    % 更新全局变量：Xp
    Xp = Xp + 10;
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
        trace(gen, 1) = temp;
    end
%        subplot(2,5,dis);
%        plot(trace(:, 1));
        
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
        
        centroid(i,:) = CenterOfMass(0, P(1), P(2), P(3));
        result(i,:) = P; 
        i = i + 1;
end

plot(centroid);
fid = fopen('data.txt', 'w');
[row, col] = size(result);
row = i - 1;
for i=1:1:row
    for j=1:1:col
        if(j == col)
            fprintf(fid, '%g\r\n', result(i, j));
        else
            fprintf(fid, '%g\t', result(i, j));
        end
    end
end

fclose(fid);






    