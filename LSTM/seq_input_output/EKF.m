% 定义系统模型和测量模型
data = torque_array(2,:); % 关节力矩序列信号
n = length(data); % 数据长度

% 状态转移函数和测量函数
F = 1; % 假设状态转移函数为常数1，即状态直接复制
H = 1; % 假设测量函数也为常数1，即直接测量到状态

% 状态协方差矩阵和测量噪声协方差矩阵
Q = 0.001; % 假设状态过程噪声方差为0.01
R = 3; % 假设测量噪声方差为0.1

% 初始化滤波器参数
% x_hat = zeros(1, 1); % 初始状态估计
% 初始状态估计采用前十个数值的平均值估计
x_hat = mean(data(1:10));

P_hat = eye(1); % 初始状态协方差矩阵

% 存储预测后的序列结果
results = zeros(1, n);

% 循环处理每个时间步的数据
for k = 1 : n
    % 预测步骤
    x_predict = F * x_hat; % 状态预测
    P_predict = F * P_hat * F' + Q; % 状态协方差预测
    
    % 更新步骤
    residual = data(k) - H * x_predict; % 残差
    S = H * P_predict * H' + R; % 残差协方差矩阵
    K = P_predict * H' / S; % 卡尔曼增益
    
    x_hat = x_predict + K * residual; % 更新状态估计
    P_hat = (eye(1) - K * H) * P_predict; % 更新状态协方差矩阵
    
    % 存储结果
    results(k) = x_hat;
end

% 绘制预测结果图像
% figure;
% plot(1:n, data, 'b-', 'LineWidth', 1.5); % 原始数据
% hold on;
% plot(1:n, results, 'r--', 'LineWidth', 1.5); % 预测结果
% legend('原始数据', '预测结果');
% xlabel('时间步');
% ylabel('状态值');
% title('卡尔曼滤波预测结果');

% 绘制原始数据图像
figure;
subplot(2,1,1);
plot(1:n, results, 'b-', 'LineWidth', 1); % 原始数据
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

