% 定义系统模型和测量模型
data = torque_array(2,:); % 关节力矩序列信号
n = length(data); % 数据长度

window_size = 10; % 滑动窗口大小

% 状态转移函数和测量函数
F = 1; % 假设状态转移函数为常数1，即状态直接复制
H = 1; % 假设测量函数也为常数1，即直接测量到状态

% 状态协方差矩阵和测量噪声协方差矩阵
Q = 0.001; % 假设状态过程噪声方差为0.01
R = 5; % 假设测量噪声方差为0.1

% 初始化滤波器参数
x_hat = zeros(window_size, 1); % 状态估计向量
P_hat = eye(window_size); % 状态协方差矩阵

% 存储预测后的序列结果
results = zeros(1, n);

% 循环处理每个时间步的数据
for k = 1 : n
    % 更新滤波器观测窗口
    if k > window_size
        x_hat(1:end-1) = x_hat(2:end);
        P_hat(1:end-1, :) = P_hat(2:end, :);
        P_hat(:, 1:end-1) = P_hat(:, 2:end);
    end
    
    % 预测步骤
    x_predict = F * x_hat; % 状态预测
    P_predict = F * P_hat * F' + Q; % 状态协方差预测
    
    % 更新步骤
    residual = data(k) - H * x_predict(end); % 残差
    S = H * P_predict(end, end) * H' + R; % 残差协方差矩阵
    K = P_predict(end, end) * H' / S; % 卡尔曼增益
    
    x_hat(end) = x_predict(end) + K * residual; % 更新状态估计
    
    % 更新状态协方差矩阵
    P_hat(end, end) = (1 - K * H) * P_predict(end, end);
    
    % 存储结果
    results(k) = x_hat(end);
end

% 绘制预测结果图像
% figure (0);
% plot(1:n, data, 'b-', 'LineWidth', 1.5); % 原始数据
% hold on;
% 
% plot(1:n, results, 'r--', 'LineWidth', 1.5); % 预测结果
% legend('原始数据', '预测结果');
% xlabel('时间步');
% ylabel('状态值');
% title('卡尔曼滤波预测结果');

% 绘制原始数据图像
figure;
subplot(2,1,1);
plot(1:n, data, 'b-', 'LineWidth', 1); % 原始数据
xlabel('时间步');
ylabel('状态值');
title('原始数据');

% 绘制预测结果图像
subplot(2,1,2);
plot(1:n, data, 'b-', 'LineWidth', 1); % 原始数据
hold on;
plot(1:n, results, 'r--', 'LineWidth', 1); % 预测结果
legend('原始数据', '预测结果');
xlabel('时间步');
ylabel('状态值');
title('卡尔曼滤波预测结果');
