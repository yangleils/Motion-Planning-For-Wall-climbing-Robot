clear;clc;

global Xp;
NIND = 60;                %������Ŀ
MAXGEN = 500;            %����Ŵ�����
PRECI = 30;               %����������λ��
NVAR = 2;                 %����ά��
GGAP = 0.8;               %����

Xp = -213;
result = zeros(100, 3);
centroid = zeros(15, 1);

FieldD = [rep(PRECI, [1, NVAR]); [0,-90;300,270]; rep([1;0;1;1], [1, NVAR])];
Chrom_0 = crtbp(NIND, NVAR*PRECI);

i = 1;                %�����������
for dis = 1:10:400
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
        
        
        centroid(i,:) = CenterOfMass(0, P(1), P(2), P(3));
        result(i,:) = P; 
        i = i + 1;
end
plot(centroid);
%title('X = -133');
%set(gca,'XTick',1:10:160);  
%set(gca,'XTickLabel',{'-213','-203','-193','-183','-173','-163','-153','-143', '-133', '-123', '-113', '-103', '-93', '-83', '-73', '-63'});  

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






    