% 假设你已经得到了传感器测量的非线性关节力矩数据 M
M = torque_array(2,:);

% 定义滑动窗口的长度和多项式拟合的阶数
window_length = 71; % 滑动窗口的长度，需要根据实际情况进行调整
polynomial_order = 3; % 多项式拟合的阶数，需要根据实际情况进行调整

% 使用Savitzky-Golay滤波器对信号进行平滑处理
smoothed_signal = sgolayfilt(M, polynomial_order, window_length);

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
