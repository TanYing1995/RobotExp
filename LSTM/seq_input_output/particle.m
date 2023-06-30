force_sequence = torque_array(3,:);

% 初始化参数
n = size(force_sequence, 2); % 状态向量维度
N = 1000; % 粒子数量

% 初始化粒子和权重
particles = randn(n, N); % 随机初始化粒子
weights = ones(1, N) / N; % 初始权重均匀分布

% 初始化存储变量
x_filtered = zeros(n, N); % 存储滤波后的状态估计结果

% 粒子滤波过程
for k = 1:size(force_sequence, 1)
    % 预测步骤
    for i = 1:N
        particles(:, i) = f(particles(:, i), force_sequence(k, :)); % 状态预测
    end
    
    % 更新步骤
    for i = 1:N
        likelihood = compute_likelihood(particles(:, i), measurement_sequence(k, :)); % 计算粒子的似然度
        weights(i) = weights(i) * likelihood; % 更新权重
    end
    
    % 权重归一化
    weights = weights / sum(weights);
    
    % 重采样
    indices = randsample(1:N, N, true, weights);
    particles = particles(:, indices);
    weights = ones(1, N) / N;
    
    % 存储滤波后的状态估计结果
    x_filtered(:, k) = mean(particles, 2);
end

% 绘制滤波后的状态估计结果
figure;
plot(1:size(force_sequence, 1), x_filtered);
xlabel('时间步');
ylabel('状态值');
title('粒子滤波结果');
