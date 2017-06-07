clear; clc;

theta2 = 100;
theta3 = 0;
theta4 = 0;


for thetaVal = -102:5:102
    theta4 = thetaVal;
    TH_init = [theta2, theta3, theta4];
    p = PositiveSolution(theta2, theta3, theta4);
    x = p(1);
    y = p(2);
    th = p(3);
    theta = NegativeSolution(x,y,th);
    if isreal(theta(1))
        th2 = theta(1);
    else
        th2 = real(theta(1));
    end
    if isreal(theta(2))
        th3 = theta(2);
    else
        th3 = real(theta(2));
    end
    if isreal(theta(3))
        th4 = theta(3);
    else 
        th4 = real(theta(3));
    end
    TH_ret = [th2, th3, th4];
    if abs(theta2 - th2)<0.1 && abs(theta3 - th3)<0.1 && abs(theta4 - th4)<0.1
        thetaVal 
        
    end
    
end