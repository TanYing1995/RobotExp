% 假设你已经得到了传感器测量的真实信号关节力矩序列 M
M = torque_array(2,:);
% window_size = 15; % 移动平均滤波窗口大小
% M = movmean(M, window_size); % 使用移动平均滤波器平滑数据
% 定义小波变换的相关参数
wavelet_name = 'db4'; % 小波基函数的名称，这里以 Daubechies 4（db4）为例
level = 6; % 小波变换的层数，需要根据实际情况进行调整

% 对信号进行离散小波变换
[c, l] = wavedec(M, level, wavelet_name);

% 获取细节系数
det_coeff = detcoef(c, l, 'all');

% 将 cell 数组转换为数值类型的向量
det_coeff_vec = cell2mat(det_coeff);

% 设计滤波器并对细节系数进行阈值处理
threshold = 0.7; % 阈值大小，需要根据实际情况进行调整
det_coeff_filtered = det_coeff_vec; % 初始化滤波后的细节系数
det_coeff_filtered(abs(det_coeff_vec) < threshold) = 0; % 根据阈值进行滤波

% 重构滤波后的信号
% filtered_signal = waverec([c(1:end-level), det_coeff_filtered], l, wavelet_name);
% 使用小波阈值滤波
filtered_signal = wdencmp('gbl', M, wavelet_name, level, threshold, 's', 1);

% 绘制测量信号和滤波后的信号
figure;
subplot(2,1,1);
plot(M,'b');
title('测量信号');
xlabel('样本点');
ylabel('信号值');
hold on
plot(filtered_signal,'r');


subplot(2,1,2);
plot(filtered_signal,'r');
title('滤波后的信号');
xlabel('样本点');
ylabel('信号值');
