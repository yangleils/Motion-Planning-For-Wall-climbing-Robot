clear;clc;

%% ǰ��׼��
% ȫ�ֱ���:Xp   ===>ĩ��λ��X�᷽������
global Xp;
% ȫ�ֱ���:Joint2/Joint3/Joint4    ===>�ؽ�2/3/4��ʷλ��
global Joint2;
global Joint3;
global Joint4;

% �Ŵ��㷨�е���ز����趨
NIND = 60;                %������Ŀ
MAXGEN = 500;             %����Ŵ�����
PRECI = 30;               %����������λ��
NVAR = 2;                 %����ά��
GGAP = 0.8;               %����

% ��һ�׶Σ��ؽ�2/3/4λ������
angle001 = zeros(10, 3);
% �ڶ��׶Σ��ؽ�2/3/4λ������
angle002 = zeros(10, 3);
% �����׶Σ��ؽ�2/3/4λ������
angle003 = zeros(10, 3);

% ��һ�׶Σ�ĩ��λ������
pose001 = zeros(10, 3);
% �ڶ��׶Σ�ĩ��λ������
pose002 = zeros(10, 3);
% �����׶Σ�ĩ��λ������
pose003 = zeros(10, 3);

% ����λ������/Zcr
centroid = zeros(5, 1);
% ����λ������/Xcr
centroid_Xcr = zeros(5, 1);
% ����λ������
index = 1; 

%% ��һ�׶�      -193---->0    
% ��ʼ��ȫ�ֱ���:��ʼλ��
Xp = -203;
% ��ֹλ��
Xend = 0;   
% �ݴ��ʼֵ
Xtemp = Xp;
        
% ��ʼ��ȫ�ֱ�����Joint2/Joint3/Joint4
joint = NegativeSolution(Xp, 0, 270);
Joint2 = joint(1);
Joint3 = joint(2);
Joint4 = joint(3);

FieldD = [rep(PRECI, [1, NVAR]); [0,-90;300,270]; rep([1;0;1;1], [1, NVAR])];
Chrom_0 = crtbp(NIND, NVAR*PRECI);

% ����
index001 = 1; 

% ��ⷶΧ�� Xp-->-3  ȡֵ�����10mm
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
        
        % һ���Ŵ��㷨�����У�Ŀ��ֵ�仯/�Ż�����
        trace(gen, 1) = temp;
    end
        
        variable = bs2rv(Chrom, FieldD);
        
        [Y, I] = min(ObjV);
        ret = variable(I, :);
        P = NegativeSolution(Xp, ret(1), ret(2))
        X = [Xp, ret(1), ret(2)] 
                
        % ����ȫ�ֱ�����Joint2/Joint3/Joint4
        Joint2 = P(1);
        Joint3 = P(2);
        Joint4 = P(3);
        
        val = CenterOfMass(0, P(1), P(2), P(3));
        centroid(index,:) = val(1);
        centroid_Xcr(index,:) = val(2);
        angle001(index,:) = P;
        pose001(index,:) = X;
        index = index + 1;
        
        % ����ȫ�ֱ�����Xp
        Xp = Xp + 10;
end

%% �ڶ��׶�
% ���¾ֲ�����
theta2 = Joint2;
theta3 = Joint3;
theta4 = Joint4;

% ����
index002 = 1; 
% X����
X02 = zeros(1,1);
% �ؽ�2λ�ø���
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

% �ؽ�3λ�ø���
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

% �ؽ�4λ�ø���
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

%% �����׶�
% ��ʼ��ȫ�ֱ���:��ʼλ��
Xp = 363;
% ��ֹλ��
Xend = 203;   
% �ݴ��ʼֵ
Xtemp = Xp;
        
% ��ʼ��ȫ�ֱ�����Joint2/Joint3/Joint4
joint = [0,0,0];
Joint2 = joint(1);
Joint3 = joint(2);
Joint4 = joint(3);

% ȡֵ��Χ����
FieldD = [rep(PRECI, [1, NVAR]); [10,-90;126,0]; rep([1;0;1;1], [1, NVAR])];
Chrom_0 = crtbp(NIND, NVAR*PRECI);

% ����
index003 = 1; 
% ��ⷶΧ�� Xp-->-3  ȡֵ�����10mm
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
        
        % һ���Ŵ��㷨�����У�Ŀ��ֵ�仯/�Ż�����
        trace(gen, 1) = temp;
    end
        
        variable = bs2rv(Chrom, FieldD);
        
        [Y, I] = min(ObjV);
        ret = variable(I, :);
        P = NegativeSolution(Xp, ret(1), ret(2))
        X = [Xp, ret(1), ret(2)] 
                
        % ����ȫ�ֱ�����Joint2/Joint3/Joint4
        Joint2 = P(1);
        Joint3 = P(2);
        Joint4 = P(3);
        
        val = CenterOfMass(0, P(1), P(2), P(3));
        centroid(index,:) = val(1);
        centroid_Xcr(index,:) = val(2);
        angle003(index003,:) = P;
        pose003(index003,:) = X;
        % X����
             
        index = index + 1;
        index003 = index003 + 1;
        
        % ����ȫ�ֱ�����Xp
        Xp = Xp - 10;
end

%% ����λ������-----���ڵ�
% plot(centroid, 'b*');
% hold on;
% plot(centroid_Xcr,'b','LineWidth',2);
% legend('Zcr','Xcr');
% xlabel('�ڵ�k');
% ylabel('����λ��/mm');

%% ����λ������-----��ĩ��X����
X01 = -203:10:-3;
X03 = 363:-10:203;
X = [X01, X02'];
X = [X, X03];
plot(X, centroid);
xlim([-230, 420]);
ylim([0, 250]);
xlabel('ĩ�� X/mm');
ylabel('���� Zcr/mm');
title('Compare Between GA with FSM-Key Point Interpolation');
%% ���߹ؼ����ע
KeyP1_y = centroid(1);
text(-203, KeyP1_y, '\leftarrow ״̬1');

KeyP2_y = centroid(21);
text(-3, KeyP2_y, '\leftarrow ״̬2');

KeyP3_y = centroid(65);
text(374, KeyP3_y, '\leftarrow ״̬3');

KeyP4_y = centroid(82);
text(203, KeyP4_y, '\leftarrow ״̬4')

%% �����ļ��洢

% data.txt�ļ�������ؽ�2/3/4��λ������
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
% �ر��ļ�
fclose(fid_angle);

% pos.txt�ļ�������ĩ��λ������
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
%�ر��ļ�
fclose(fid_pos);
    