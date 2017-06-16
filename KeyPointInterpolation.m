function y = KeyPointInterpolation(num)
%% 
ThArray01 = zeros(1,3);
ThArray02 = zeros(1,3);
ThArray03 = zeros(1,3);
PosArray01 = zeros(1,3);
PosArray02 = zeros(1,3);
PosArray03 = zeros(1,3);
X_01 = zeros(1,1);
X_02 = zeros(1,1);
X_03 = zeros(1,1);
centroid = zeros(5, 1);
centroid_Xcr = zeros(5, 1);
index = 1;


%% 第一阶段
Position1 = [-203, 0, 270];
Position2 = [-3, 287.1549, 208.0286];
Theta1 = NegativeSolution(Position1(1), Position1(2), Position1(3));
Theta2 = NegativeSolution(Position2(1), Position2(2), Position2(3));

for i = 0:1:20
	Th2 = Theta1(1) + i * (Theta2(1) - Theta1(1))/20;
	Th3 = Theta1(2) + i * (Theta2(2) - Theta1(2))/20;
	Th4 = Theta1(3) + i * (Theta2(3) - Theta1(3))/20;
    
    ThArray01(i+1, :) = [Th2, Th3, Th4]; 
    temp = PositiveSolution(Th2, Th3, Th4);
    PosArray01(i+1, :) = temp;
    X_01(i+1, :) = temp(1);
end
%% 第二阶段
Position1 = [-3, 287.1549, 208.0286];
Position2 = [374, 126, 0];
Theta1 = NegativeSolution(Position1(1), Position1(2), Position1(3));
Theta2 = NegativeSolution(Position2(1), Position2(2), Position2(3));

for i = 0:1:43
	Th2 = Theta1(1) + i * (Theta2(1) - Theta1(1))/43;
	Th3 = Theta1(2) + i * (Theta2(2) - Theta1(2))/43;
	Th4 = Theta1(3) + i * (Theta2(3) - Theta1(3))/43;

	ThArray02(i+1, :) = [Th2, Th3, Th4]; 
    temp = PositiveSolution(Th2, Th3, Th4);
    PosArray02(i+1, :) = temp;
    X_02(i+1, :) = temp(1);
end
%% 第三阶段
Position1 = [374, 126, 0];
Position2 = [203, 10, -90];
Theta1 = NegativeSolution(Position1(1), Position1(2), Position1(3));
Theta2 = NegativeSolution(Position2(1), Position2(2), Position2(3));

for i = 0:1:16
	Th2 = Theta1(1) + i * (Theta2(1) - Theta1(1))/16;
	Th3 = Theta1(2) + i * (Theta2(2) - Theta1(2))/16;
	Th4 = Theta1(3) + i * (Theta2(3) - Theta1(3))/16;

	ThArray03(i+1, :) = [Th2, Th3, Th4];
    temp = PositiveSolution(Th2, Th3, Th4);
    PosArray03(i+1, :) = temp;
    X_03(i+1, :) = temp(1);
end

%% 整个过程---质心位置序列/关节位置序列/末端位置序列
ThArray = ThArray01;
ThArray = [ThArray; ThArray02];
ThArray = [ThArray; ThArray03];

PosArray = PosArray01;
PosArray = [PosArray; PosArray02];
PosArray = [PosArray; PosArray03];
for i = 1:1:82
	
    val = CenterOfMass(0, ThArray(i, 1), ThArray(i, 2), ThArray(i, 3));
    centroid(index, :) = val(1);
    centroid_Xcr(index, :) =val(2);     
    index = index + 1;
end
X = X_01;
X = [X; X_02];
X = [X; X_03];
%% 质心位置曲线-----按节点




%% 质心位置曲线-----按末端X坐标

% plot(centroid, '--');
% hold on;
% plot(centroid_Xcr,'m');
% legend('Zcr','Xcr');
% xlabel('节点');
% ylabel('质心位置/mm');

hold on
plot(X, centroid, 'r');
ylim([0, 250]);
xlim([-230, 420]);
legend('GA', 'FSM - Key Point Interpolation');
%% 过程数据保存---关节位置序列/末端位置序列
fid_angle = fopen('angle_keyPoint.txt', 'w');
[row, col] = size(ThArray);
row = index - 1;

for i=1:1:row
    for j=1:1:col
        if(j == col)
            fprintf(fid_angle, '%g\r\n', ThArray(i, j));
        else
            fprintf(fid_angle, '%g\t', ThArray(i, j));
        end
    end
end
fclose(fid_angle);

fid_pos = fopen('pos_keyPoint.txt', 'w');
[row, col] = size(PosArray);
row = index - 1;
for i=1:1:row
    for j=1:1:col
        if(j == col)
            fprintf(fid_pos, '%g\r\n', PosArray(i, j));
        else
            fprintf(fid_pos, '%g\t', PosArray(i, j));
        end
    end
end
fclose(fid_pos);
y = 1;