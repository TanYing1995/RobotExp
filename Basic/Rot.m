function rm = Rot(TcpPos)
% 机器人逆解函数 ：输入机器人末端6x1位姿向量[x,y,z,R,P,Y]
% 1. 先将位姿向量转换为位姿矩阵
px = TcpPos(1);py = TcpPos(2);pz = TcpPos(3);
%% Z-Y-X欧拉角旋转 
% 过程描述（动轴旋转），先绕本坐标系Z轴旋转gama角，再绕本坐标系Y轴旋转beta角，再绕X轴旋转alpha角
% Z gama(Y)  Y beta(P)  X  alpha(R)  
alpha = TcpPos(4);beta = TcpPos(5);gama = TcpPos(6);%角度值
sa = sind(alpha);ca = cosd(alpha);
sb = sind(beta);cb = cosd(beta);
sy = sind(gama);cy = cosd(gama);
rm = [cy*cb cy*sb*sa-sy*ca cy*sb*ca+sa*sy;
       sy*cb sy*sb*sa+ca*cy sy*sb*ca-cy*sa;
       -sb         cb*sa          cb*ca];
end

