M = torque_array(2,:);
window_size = 15; % 移动平均滤波窗口大小
F = movmean(M, window_size); % 使用移动平均滤波器平滑数据
figure;
subplot(2,1,1);
plot(M,'b');
title('测量信号');
xlabel('样本点');
ylabel('信号值');
hold on
plot(filtered_signal,'r');


subplot(2,1,2);
plot(F,'r');
title('滤波后的信号');
xlabel('样本点');
ylabel('信号值');