clear;clc;

% ����ȫ�ֱ���:Xp   ===>ĩ��λ��X�᷽������
global Xp;
% ����ȫ�ֱ���:Joint2/Joint3/Joint4    ===>�ؽ�2/3/4��ʷλ��
global Joint2;
global Joint3;
global Joint4;

% �Ŵ��㷨�е���ز����趨
NIND = 60;                %������Ŀ
MAXGEN = 500;             %����Ŵ�����
PRECI = 30;               %����������λ��
NVAR = 2;                 %����ά��
GGAP = 0.8;               %����

% ��ͬXp�����£�����λ������ʱ��Ӧ�Ĺؽ�2/3/4�Ƕ�ֵ
angle = zeros(100, 3);
% ��ͬXp�����£�����λ������ʱ��Ӧĩ�˵�λ�˲���
pose = zeros(100, 3);

% ��ͬXp�����£����ĵ�����λ��
centroid = zeros(15, 1);


FieldD = [rep(PRECI, [1, NVAR]); [0,-90;300,270]; rep([1;0;1;1], [1, NVAR])];
Chrom_0 = crtbp(NIND, NVAR*PRECI);

% ��ʼ��ȫ�ֱ���
Xp = -263;
% �ݴ��ʼֵ
Xtemp = Xp;

% ��ʼ��ȫ�ֱ�����Joint2/Joint3/Joint4
joint = NegativeSolution(Xp, 0, 270);
Joint2 = joint(1);
Joint3 = joint(2);
Joint4 = joint(3);

index = 1;                    %�����������

% ��ⷶΧ�� Xp-->-3  ȡֵ�����10mm
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
        
        % һ���Ŵ��㷨�����У�Ŀ��ֵ�仯/�Ż�����
        trace(gen, 1) = temp;
    end
        
        variable = bs2rv(Chrom, FieldD);
        
        [Y, I] = min(ObjV);
        ret = variable(I, :);
        P = NegativeSolution(Xp, ret(1), ret(2))
        X = [Xp, ret(1), ret(2)]
        X1 = PositiveSolution(P(1), P(2), P(3)); 
                
        % ����ȫ�ֱ�����Joint2/Joint3/Joint4
        Joint2 = P(1);
        Joint3 = P(2);
        Joint4 = P(3);
        
        centroid(index,:) = CenterOfMass(0, P(1), P(2), P(3));
        angle(index,:) = P;
        pose(index,:) = X;
        index = index + 1;
        
        % ����ȫ�ֱ�����Xp
        Xp = Xp + 10;
end

% ���ƻ�����ĩ���ڲ�ͬX�����µ�Zcr����
X = Xtemp:10:-3;
plot(X, centroid);
xlim([Xtemp, -3]);
set(gca, 'xtick', Xtemp:20:-3);
title(strcat('X=', int2str(Xtemp)));
xlabel('X/mm')
ylabel('Zcr/mm')

% ����λ�������йؽ�2/3/4�ĽǶ�ֵ��data.txt�ļ���
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

% ����λ�������У�ĩ��λ��������pos.txt�ļ���
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




    