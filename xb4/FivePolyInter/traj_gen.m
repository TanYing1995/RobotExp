function path = traj_gen(from,to,velPercent,accPercent)
% 根据输入的起点和终点 和运动参数生成各关节的同步运动轨迹
% 关节空间插补方式采用五次多项式，利用PSO算法进行同步时间求解，二次规划获得各个关节的轨迹插值
% start 1x6 关节向量 / end 1x6 关节向量/ vel 最大速度百分比 /acc 最大加速度百分比
vel = [4.9,  4,   5,  5.2, 4.1, 6.8]*velPercent; %关节最大运动速度
acc = [7.8, 6.4, 8.2, 9.8, 7.8, 13.3]*accPercent; %关节最大运动加速度
%acc = [2.4, 1.8, 3.2, 2.1, 1.7, 2.6]*accPercent; %关节最大运动加速度

% 原始设置参数
% vel = [4.9, 4, 5, 5.2, 4.1, 7.8]; %关节最大运动速度
% acc = [7.8, 6.4, 8.2, 9.8, 7.8, 13.3]; %关节最大运动加速度

T = [0 0 0 0 0 0];%各关节的运动时间

T(1) = jointTime(from(1),to(1),vel(1),acc(1));
T(2) = jointTime(from(2),to(2),vel(2),acc(2));
T(3) = jointTime(from(3),to(3),vel(3),acc(3));
T(4) = jointTime(from(4),to(4),vel(4),acc(4));
T(5) = jointTime(from(5),to(5),vel(5),acc(5));
T(6) = jointTime(from(6),to(6),vel(6),acc(6));

t = max(T);% 关节同步运动时间

path = [];

%% 计算各个关节的插值轨迹
q1 = FivePolyInter(from(1),to(1),0,0,0,0,0,t);
% q2 = FivePolyInter(from(2),to(2),0,0,0,0,0,t);
% q3 = FivePolyInter(from(3),to(3),0,0,0,0,0,t);
% q4 = FivePolyInter(from(4),to(4),0,0,0,0,0,t);
% q5 = FivePolyInter(from(5),to(5),0,0,0,0,0,t);
% q6 = FivePolyInter(from(6),to(6),0,0,0,0,0,t);
% 
% path(1,:) = q1;
% path(2,:) = q2;
% path(3,:) = q3;
% path(4,:) = q4;
% path(5,:) = q5;
% path(6,:) = q6;

% figure(1);
% plot(path(1,:));
% figure(2);
% plot(path(2,:));
% figure(3);
% plot(path(3,:));
% figure(4);
% plot(path(4,:));
% figure(5);
% plot(path(5,:));
% figure(6);
% plot(path(6,:));
save path path;
end

