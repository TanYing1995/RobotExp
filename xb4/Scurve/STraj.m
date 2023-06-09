function traj = STraj(from,to,velRatio,accRatio)

% from 起点关节向量  to 终点关节向量
% velRatio 速度百分比   accRatio  加速度百分比

% vel = [5.76  4.53  6.98  7.85  6.98  1.05]*velRatio*0.4;
% acc = [1.7 1.7 1.7 1.7 1.7 1.7]*accRatio;
% jerk = [5 5 5 5 5 5]*0.4;

%vel = [5.76  4.53  6.98  7.85  6.98  1.05]*velRatio*0.4; %v(6)改变数据节点441
vel = [2.88  2.26  3.5  3.9  3.5  1.5]*velRatio*0.4;
acc = [1.5 1.4 1.6 1.6 1.6 0.7]*accRatio;
jerk = [5 5 5 5 5 5]*0.35;

p1 = STrajPara(from(1),to(1),0,0,vel(1),acc(1),jerk(1));
p2 = STrajPara(from(2),to(2),0,0,vel(2),acc(2),jerk(2));
p3 = STrajPara(from(3),to(3),0,0,vel(3),acc(3),jerk(3));
p4 = STrajPara(from(4),to(4),0,0,vel(4),acc(4),jerk(4));
p5 = STrajPara(from(5),to(5),0,0,vel(5),acc(5),jerk(5));
p6 = STrajPara(from(6),to(6),0,0,vel(6),acc(6),jerk(6));

% 计算各轴单独规划运动时间
t1 = p1(1)+p1(2)+p1(3);t2 = p2(1)+p2(2)+p2(3);t3 = p3(1)+p3(2)+p3(3);
t4 = p4(1)+p4(2)+p4(3);t5 = p5(1)+p5(2)+p5(3);t6 = p6(1)+p6(2)+p6(3);

% 计算同步运动时间
time = [t1 t2 t3 t4 t5 t6];
T = max(time);

r1 = t1/T;r2 = t2/T;r3 = t3/T;
r4 = t4/T;r5 = t5/T;r6 = t6/T;

% 根据同步时间对运动约束进行松弛
p1_new = STrajPara(from(1),to(1),0,0,vel(1)*r1,acc(1)*power(r1,2),jerk(1)*power(r1,3));
p2_new = STrajPara(from(2),to(2),0,0,vel(2)*r2,acc(2)*power(r2,2),jerk(2)*power(r2,3));
p3_new = STrajPara(from(3),to(3),0,0,vel(3)*r3,acc(3)*power(r3,2),jerk(3)*power(r3,3));
p4_new = STrajPara(from(4),to(4),0,0,vel(4)*r4,acc(4)*power(r4,2),jerk(4)*power(r4,3));
p5_new = STrajPara(from(5),to(5),0,0,vel(5)*r5,acc(5)*power(r5,2),jerk(5)*power(r5,3));
p6_new = STrajPara(from(6),to(6),0,0,vel(6)*r6,acc(6)*power(r6,2),jerk(6)*power(r6,3));

Sigma = [sign(to(1)-from(1)) sign(to(2)-from(2)) sign(to(3)-from(3)) sign(to(4)-from(4)) sign(to(5)-from(5)) sign(to(6)-from(6))];
q1 = [];q2 = [];q3 = [];q4 = [];q5 = [];q6 = [];
qd1 = [];qd2 = [];qd3 = [];qd4 = [];qd5 = [];qd6 = [];
qdd1 = [];qdd2 = [];qdd3 = [];qdd4 = [];qdd5 = [];qdd6 = [];
i = 1;
for t = 0 : 0.001 : T
    q1(i) = S_position(t, p1_new(1), p1_new(2), p1_new(3), p1_new(4), p1_new(5), p1_new(6), p1_new(7), p1_new(8), p1_new(9), p1_new(10),p1_new(11), p1_new(12), p1_new(13), p1_new(14), p1_new(15), p1_new(16));
    q2(i) = S_position(t, p2_new(1), p2_new(2), p2_new(3), p2_new(4), p2_new(5), p2_new(6), p2_new(7), p2_new(8), p2_new(9), p2_new(10),p2_new(11), p2_new(12), p2_new(13), p2_new(14), p2_new(15), p2_new(16));
    q3(i) = S_position(t, p3_new(1), p3_new(2), p3_new(3), p3_new(4), p3_new(5), p3_new(6), p3_new(7), p3_new(8), p3_new(9), p3_new(10),p3_new(11), p3_new(12), p3_new(13), p3_new(14), p3_new(15), p3_new(16));
    q4(i) = S_position(t, p4_new(1), p4_new(2), p4_new(3), p4_new(4), p4_new(5), p4_new(6), p4_new(7), p4_new(8), p4_new(9), p4_new(10),p4_new(11), p4_new(12), p4_new(13), p4_new(14), p4_new(15), p4_new(16));
    q5(i) = S_position(t, p5_new(1), p5_new(2), p5_new(3), p5_new(4), p5_new(5), p5_new(6), p5_new(7), p5_new(8), p5_new(9), p5_new(10),p5_new(11), p5_new(12), p5_new(13), p5_new(14), p5_new(15), p5_new(16));
    q6(i) = S_position(t, p6_new(1), p6_new(2), p6_new(3), p6_new(4), p6_new(5), p6_new(6), p6_new(7), p6_new(8), p6_new(9), p6_new(10),p6_new(11), p6_new(12), p6_new(13), p6_new(14), p6_new(15), p6_new(16));
%     qd1(i) = S_velocity(t, p1_new(1), p1_new(2), p1_new(3), p1_new(4), p1_new(5), p1_new(6), p1_new(7), p1_new(8), p1_new(9), p1_new(10),p1_new(11), p1_new(12), p1_new(13), p1_new(14), p1_new(15), p1_new(16));
%     qd2(i) = S_velocity(t, p2_new(1), p2_new(2), p2_new(3), p2_new(4), p2_new(5), p2_new(6), p2_new(7), p2_new(8), p2_new(9), p2_new(10),p2_new(11), p2_new(12), p2_new(13), p2_new(14), p2_new(15), p2_new(16));
%     qd3(i) = S_velocity(t, p3_new(1), p3_new(2), p3_new(3), p3_new(4), p3_new(5), p3_new(6), p3_new(7), p3_new(8), p3_new(9), p3_new(10),p3_new(11), p3_new(12), p3_new(13), p3_new(14), p3_new(15), p3_new(16));
%     qd4(i) = S_velocity(t, p4_new(1), p4_new(2), p4_new(3), p4_new(4), p4_new(5), p4_new(6), p4_new(7), p4_new(8), p4_new(9), p4_new(10),p4_new(11), p4_new(12), p4_new(13), p4_new(14), p4_new(15), p4_new(16));
%      qd5(i) = S_velocity(t, p5_new(1), p5_new(2), p5_new(3), p5_new(4), p5_new(5), p5_new(6), p5_new(7), p5_new(8), p5_new(9), p5_new(10),p5_new(11), p5_new(12), p5_new(13), p5_new(14), p5_new(15), p5_new(16));
     qd6(i) = S_velocity(t, p6_new(1), p6_new(2), p6_new(3), p6_new(4), p6_new(5), p6_new(6), p6_new(7), p6_new(8), p6_new(9), p6_new(10),p6_new(11), p6_new(12), p6_new(13), p6_new(14), p6_new(15), p6_new(16));
%     qdd1(i) = S_acceleration(t, p1_new(1), p1_new(2), p1_new(3), p1_new(4), p1_new(5), p1_new(6), p1_new(7), p1_new(8), p1_new(9), p1_new(10),p1_new(11), p1_new(12), p1_new(13), p1_new(14), p1_new(15), p1_new(16));
%     qdd2(i) = S_acceleration(t, p2_new(1), p2_new(2), p2_new(3), p2_new(4), p2_new(5), p2_new(6), p2_new(7), p2_new(8), p2_new(9), p2_new(10),p2_new(11), p2_new(12), p2_new(13), p2_new(14), p2_new(15), p2_new(16));
%     qdd3(i) = S_acceleration(t, p3_new(1), p3_new(2), p3_new(3), p3_new(4), p3_new(5), p3_new(6), p3_new(7), p3_new(8), p3_new(9), p3_new(10),p3_new(11), p3_new(12), p3_new(13), p3_new(14), p3_new(15), p3_new(16));
%     qdd4(i) = S_acceleration(t, p4_new(1), p4_new(2), p4_new(3), p4_new(4), p4_new(5), p4_new(6), p4_new(7), p4_new(8), p4_new(9), p4_new(10),p4_new(11), p4_new(12), p4_new(13), p4_new(14), p4_new(15), p4_new(16));
%     qdd5(i) = S_acceleration(t, p5_new(1), p5_new(2), p5_new(3), p5_new(4), p5_new(5), p5_new(6), p5_new(7), p5_new(8), p5_new(9), p5_new(10),p5_new(11), p5_new(12), p5_new(13), p5_new(14), p5_new(15), p5_new(16));
%     qdd6(i) = S_acceleration(t, p6_new(1), p6_new(2), p6_new(3), p6_new(4), p6_new(5), p6_new(6), p6_new(7), p6_new(8), p6_new(9), p6_new(10),p6_new(11), p6_new(12), p6_new(13), p6_new(14), p6_new(15), p6_new(16));

    i = i+1;
end
q1 = Sigma(1)*q1;q2 = Sigma(2)*q2;q3 = Sigma(3)*q3;
q4 = Sigma(4)*q4;q5 = Sigma(5)*q5;q6 = Sigma(6)*q6;

traj = [];

traj(1,:) = q1;traj(2,:) = q2;traj(3,:) = q3;
traj(4,:) = q4;traj(5,:) = q5;traj(6,:) = q6;

%% 保存生成的轨迹曲线
 save traj_460 traj;

figure(1);
% % plot(traj(1,:));
% subplot(3,1,1)
plot(traj(1,:));
% subplot(3,1,2)
% plot(traj(2,:));
% subplot(3,1,3)
% plot(traj(3,:));

% figure(2);
% subplot(3,1,1)
% plot(traj(4,:));
% subplot(3,1,2)
% plot(traj(5,:));
% subplot(3,1,3)
% plot(traj(6,:));


vel = [];
% vel(1,:) = qd1;
% vel(2,:) = qd2;
% vel(3,:) = qd3;
% vel(4,:) = qd4;
% vel(5,:) = qd5;
%  vel(6,:) = qd6;
% 
% figure(3);
% plot(vel(1,:));
% plot(vel(2,:));
% subplot(3,1,1)
% plot(vel(1,:));
% subplot(3,1,2)
% plot(vel(2,:));
% subplot(3,1,3)
% plot(vel(3,:));
% 
% figure(4);
% subplot(3,1,1)
% plot(vel(4,:));
% subplot(3,1,2)
% plot(vel(5,:));
% subplot(3,1,3)
%  plot(vel(6,:));

% acc = [];
% acc(1,:) = qdd1;acc(2,:) = qdd2;acc(3,:) = qdd3;
% acc(4,:) = qdd4;acc(5,:) = qdd5;acc(6,:) = qdd6;
% 
% figure(5);
% % plot(traj(1,:));
% subplot(3,1,1)
% plot(acc(1,:));
% subplot(3,1,2)
% plot(acc(2,:));
% subplot(3,1,3)
% plot(acc(3,:));
% 
% figure(6);
% subplot(3,1,1)
% plot(acc(4,:));
% subplot(3,1,2)
% plot(acc(5,:));
% subplot(3,1,3)
% plot(acc(6,:));

end

