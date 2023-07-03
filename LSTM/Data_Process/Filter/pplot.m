figure (1);

plot(input(1,:),'r');

hold on

plot(input(7,:),'b');

title('关节1位移和速度曲线');
xlabel('时间/ ms');
ylabel('rad | rad/s');
% 添加标注信息，并将图例放置在右上角
legend('关节位移', '关节速度', 'Location', 'northeast')


figure (2);
plot(torque_array(2,:),'b');
title('关节1力矩曲线');
xlabel('时间/ ms');
ylabel('N.m');