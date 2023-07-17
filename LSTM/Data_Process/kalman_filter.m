function res = kalman_filter(input)
% 针对输入的6xn矩阵的每一行序列数据进行卡尔曼滤波

% 定义状态变量、测量变量和观测矩阵
A = eye(6);         % 状态转移矩阵
C = eye(6);         % 观测矩阵

Q = eye(6)*0.001;    % 过程噪声
R = eye(6)*5;     % 测量噪声

% 初始化
x(:,1) = input(:,1); % 初始状态向量，设为第一组数据

P = eye(6);         % 初始协方差矩阵

n = size(input,2);

% 卡尔曼滤波
for k = 2:n
    % 预测
    x_pre(:,k) = A*x(:,k-1);
    P_pre = A*P*A' + Q;

    % 更新
    K = P_pre*C'/(C*P_pre*C' + R);
    x(:,k) = x_pre(:,k) + K*(input(:,k) - C*x_pre(:,k));
    P = (eye(6) - K*C)*P_pre;
end
res = x;

end

