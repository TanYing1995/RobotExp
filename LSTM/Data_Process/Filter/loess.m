% 假设你已经得到了传感器测量的非线性关节力矩数据 M
M = torque_array(2,:);

% 定义LOESS滤波器的参数
span = 80; % 控制每个数据点周围的邻域大小，需要根据实际情况进行调整

% 使用LOESS滤波器对信号进行平滑处理
smoothed_signal = smoothdata(M, 'loess', span);

% 绘制原始信号和平滑后的信号
figure;
subplot(2,1,1);
plot(M,'b');
title('原始信号');
xlabel('样本点');
ylabel('信号值');

subplot(2,1,2);
plot(smoothed_signal,'r');
title('平滑后的信号');
xlabel('样本点');
ylabel('信号值');
