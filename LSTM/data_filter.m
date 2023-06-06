% 6xn格式数据
% generated by m=6; n=100; data=randn(m,n);

% 定义状态变量、测量变量和观测矩阵
A = eye(6);         % 状态转移矩阵
C = eye(6);         % 观测矩阵
Q = eye(6)*0.001;    % 过程噪声
R = eye(6)*10;     % 测量噪声

path = 'I:\Experiments\LSTM\力矩数据\33';

% s = load('C:\Users\admin\Desktop\轨迹\力矩数据\1\torque_array');
s = load([path '\torque_array']);
data = s.torque_array;
% 初始化
x(:,1) = data(2:7,1); % 初始状态向量，设为第一组数据

P = eye(6);         % 初始协方差矩阵

n = size(data,2);

% 卡尔曼滤波
for k = 2:n
    % 预测
    x_pre(:,k) = A*x(:,k-1);
    P_pre = A*P*A' + Q;

    % 更新
    K = P_pre*C'/(C*P_pre*C' + R);
    x(:,k) = x_pre(:,k) + K*(data(2:7,k) - C*x_pre(:,k));
    P = (eye(6) - K*C)*P_pre;
end

save(fullfile(path,'torque.mat'),'x'); 

% save('torque.mat','x');

% 绘制原始数据和滤波结果的对比图
% plot(data')
% hold on
% plot(x')
% legend('原始数据','滤波结果')



