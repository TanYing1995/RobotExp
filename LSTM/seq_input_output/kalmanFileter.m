function x_estimate = kalmanFileter(input)
% 1xn 序列的卡尔曼滤波

% 生成模拟数据

x = input;
n = size(input,2);

% n = 100;
% x = sin(0.1*(1:n)) + randn(1,n)*0.1;

% 定义初始状态和观测量
x0 = [0; 0];        % 初始状态向量，包括位置和速度
P0 = eye(2);        % 初始协方差矩阵
A = [1 1; 0 1];     % 状态转移矩阵
H = [1 0];          % 观测矩阵
Q = [0.001 0; 0 0.001];  % 系统噪声协方差矩阵
R = 10;              % 测量噪声方差

% 卡尔曼滤波处理
x_estimate = zeros(size(x));  % 预测值
P = P0;
x_hat = x0;

for i=1:n
    % 预测状态
    x_hat = A * x_hat;
    P = A * P * A' + Q;

    % 更新状态
    K = P * H' / (H * P * H' + R);
    x_hat = x_hat + K * (x(i) - H * x_hat);
    P = (eye(2) - K * H) * P;

    % 记录预测值
    x_estimate(i) = x_hat(1);
end

% 绘制原始数据和预测数据的图像
% plot(1:n, x, 'b-', 1:n, x_estimate, 'r--');
% legend('原始数据', '卡尔曼滤波预测数据');

end

