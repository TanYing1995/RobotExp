% 原始关节力矩数据
torque = torque_array(3,:); % 替换为您的实际数据

% 定义滤波参数
order = 15; % 滤波器阶数
maxIterations = 50; % 最大迭代次数

% 迭代最小二乘滤波
filteredTorque = torque; % 初始化滤波后的力矩数据
for i = 1:maxIterations
    % 构建设计矩阵
    X = zeros(length(torque)-order, order);
    for j = 1:order
        X(:, j) = torque(order-j+1:end-j);
    end
    
    % 更新滤波器参数
    theta = X \ torque(order+1:end)';
    
    % 更新滤波后的力矩数据
    filteredTorque(order+1:end) = X * theta;
end

% 绘制原始数据和滤波结果
figure;
subplot(2,1,1);
plot(1:length(torque), torque, 'b-', 'LineWidth', 1.5); % 原始数据
xlabel('时间步');
ylabel('关节力矩');
title('原始数据');

subplot(2,1,2);
plot(1:length(filteredTorque), filteredTorque, 'r--', 'LineWidth', 1.5); % 滤波结果
xlabel('时间步');
ylabel('关节力矩');
title('迭代最小二乘滤波结果');
