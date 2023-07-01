% 加载数据
% data = load('joint_torque_data.mat'); % 假设数据文件为 joint_torque_data.mat
torque = torque_array(2,:); % 关节力矩数据

% 设置小波滤波参数
wavelet = 'db4'; % 小波基函数，这里选择 Daubechies 4 小波
level = 5; % 分解的尺度级数

% 对关节力矩数据进行小波分解和重构滤波
[c, l] = wavedec(torque, level, wavelet); % 小波分解
% c(1:l(1)) = 0; % 去除低频成分（趋势）
c(l(1)+1:end) = 0; % 去除高频成分（噪声）
filtered_torque = waverec(c, l, wavelet); % 小波重构

% 绘制原始数据和滤波后的曲线
t = 1:length(torque); % 时间轴
figure;
subplot(2,1,1);
plot(t, torque);
title('原始关节力矩数据');
xlabel('时间');
ylabel('力矩');
subplot(2,1,2);
plot(t, filtered_torque);
title('滤波后的关节力矩数据');
xlabel('时间');
ylabel('力矩');
