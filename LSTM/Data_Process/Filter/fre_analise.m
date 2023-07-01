% 加载数据
% data = load('joint_torque_data.mat'); % 假设数据文件为 joint_torque_data.mat
% torque = torque_array(2,:); 
torque = filtered_torque;
% 设置小波滤波参数
wavelet = 'db4'; % 小波基函数，这里选择 Daubechies 4 小波
level = 5; % 分解的尺度级数

% 进行小波分解
[c, l] = wavedec(torque, level, wavelet); % 小波分解

% 计算频谱
power_spectrum = abs(c).^2; % 功率谱密度
frequency = 0:(length(power_spectrum)-1); % 频率范围

% 绘制频谱图
figure;
plot(frequency(1:2000), power_spectrum(1:2000));
title('关节力矩数据频谱分析');
xlabel('频率');
ylabel('功率谱密度');

% 找到主要频率成分
[max_power, max_index] = max(power_spectrum);
main_frequency = frequency(max_index);
fprintf('主要频率成分: %.2f Hz\n', main_frequency);
