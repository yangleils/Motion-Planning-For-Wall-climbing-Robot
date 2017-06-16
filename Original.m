function y = Original()
ThArray = zeros(1,3);
PosArray = zeros(1,3);

centroid = zeros(5, 1);
centroid_Xcr = zeros(5, 1);
X = zeros(1,1);
Position1 = [-203, 0, 270];
Position2 = [203, 10, -90];
Theta1 = NegativeSolution(Position1(1), Position1(2), Position1(3));
Theta2 = NegativeSolution(Position2(1), Position2(2), Position2(3));
for i = 0:1:82
	Th2 = Theta1(1) + i * (Theta2(1) - Theta1(1))/82;
	Th3 = Theta1(2) + i * (Theta2(2) - Theta1(2))/82;
	Th4 = Theta1(3) + i * (Theta2(3) - Theta1(3))/82;

	ThArray(i+1, :) = [Th2, Th3, Th4]; 
    temp =  PositiveSolution(Th2, Th3, Th4);
    PosArray(i+1, :) = temp;
    X(i+1) = temp(1);
    val = CenterOfMass(0, Th2, Th3, Th4);
    centroid(i+1, :) = val(1);
    centroid_Xcr(i+1, :) =val(2);
end

%% 质心位置曲线 ------- 按末端坐标
hold on;
plot(X, centroid, 'b');
xlim([-330 420]);
ylim([0, 300]);
xlabel('末端 X/mm');
ylabel('质心 Zcr/mm');
title('Compare Between  Original with FSM-Key Point Interpolation');
legend('Origin','FSM');

%% 曲线关键点标注
KeyP1_y = centroid(1);
text(-203, KeyP1_y, '\leftarrow 起始位置');

KeyP2_y = centroid(82);
text(203, KeyP2_y, '\leftarrow 终止位置');
%% 过程数据保存
fid_pos = fopen('angle_init.txt', 'w');
[row, col] = size(PosArray);

for i=1:1:row
    for j=1:1:col
        if(j == col)
            fprintf(fid_pos, '%g\r\n', PosArray(i, j));
        else
            fprintf(fid_pos, '%g\t', PosArray(i, j));
        end
    end
end
% 关闭文件
fclose(fid_pos);

fid_angle = fopen('pos_init.txt', 'w');
[row, col] = size(ThArray);

for i=1:1:row
    for j=1:1:col
        if(j == col)
            fprintf(fid_angle, '%g\r\n', ThArray(i, j));
        else
            fprintf(fid_angle, '%g\t', ThArray(i, j));
        end
    end
end
% 关闭文件
fclose(fid_angle);
y = 1;
