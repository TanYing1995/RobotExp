function p = RobotModel(theta)
% 使用matlab机器人工具箱建立机器人模型，验证正、逆运动学
%   M-DH 参数表
clear L;

alpha1 = 0;     a1 = 0;    d1 = 0; theta1 = 0;
alpha2 = pi/2;  a2 = 40;   d2 = 0; theta2 = 0;
alpha3 = 0;     a3 = 275;  d3 = 0; theta3 = 0;
alpha4 = pi/2;  a4 = 25;   d4 = 280; theta4 = 0;
alpha5 = -pi/2; a5 = 0;  d5 = 0; theta5 = 0;
alpha6 = pi/2;  a6 = 0;  d6 = 73; theta6 = 0;
angle = pi/180;
%            theta   d   a   alpha  sigma offset
L(1) = Link([0, d1, a1, alpha1, 0, 0], 'modified');L(1).qlim =[-170*angle, 170*angle];
L(2) = Link([0, d2, a2, alpha2, 0,pi/2], 'modified');L(2).qlim =[-144*angle, 80*angle];
L(3) = Link([0, d3, a3, alpha3, 0,0], 'modified');L(3).qlim =[-119*angle, 265*angle];
L(4) = Link([0, d4, a4, alpha4, 0,0], 'modified');L(4).qlim =[-170*angle, 170*angle];
L(5) = Link([0, d5, a5, alpha5, 0,0], 'modified');L(5).qlim =[-119*angle, 119*angle];
L(6) = Link([0, d6, a6, alpha6, 0,pi/2], 'modified');L(6).qlim =[-360*angle, 360*angle];

%% 正向运动学
figure(1);
robot = SerialLink(L,'name','six');
thetas = [theta(1),theta(2),theta(3),theta(4),theta(5),theta(6)].*angle;
robot.display();
robot.plot(thetas);
%teach(robot);
title('SR4B六轴机械臂模型');
p = robot.fkine(thetas);
%% 示教
% figure(2);
% robot1 = SerialLink(L,'name','six');
% robot1.teach();
% p = robot1.fkine(theta.*angle);
end

