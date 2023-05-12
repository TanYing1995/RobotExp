function fkine6 = Fkine6(theta)
% 输入六个关节角度，返回 6x1 的位姿向量
% Z-Y-X 欧拉角旋转
% R - X - alpha   P - Y - beta   Y - Z - gama
T = Fkine(theta);
r11 = T(1,1);r12 = T(1,2);r13 = T(1,3);
r21 = T(2,1);r22 = T(2,2);r23 = T(2,3);
r31 = T(3,1);r32 = T(3,2);r33 = T(3,3);
x = T(1,4);y = T(2,4);z = T(3,4);

% 过程描述（动轴旋转），先绕本坐标系Z轴旋转gama角，再绕本坐标系Y轴旋转beta角，再绕X轴旋转alpha角
% Z gama(Y-Rz)  Y beta(P-Ry)  X  alpha(R-Rx)  
temp = sqrt(power(r11,2)+power(r21,2));
beta = atan2(-r31,temp);
gama = 0;
alpha = 0;
if beta == pi/2
    gama = 0;
    alpha = atans(r12,r22);
elseif beta == -pi/2
    gama = 0;
    alpha = -atans(r12,r22);
else
    alpha = atan2(r32/cos(beta),r33/cos(beta));%X  alpha
    gama = atan2(r21/cos(beta),r11/cos(beta));%Z gama
end
fkine6 = [x,y,z,rad2deg(alpha),rad2deg(beta),rad2deg(gama)];
end

