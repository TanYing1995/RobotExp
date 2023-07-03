% 假设你已经得到了传感器测量的非线性关节力矩数据 M
M = torque_array(2,:);

% 定义小波基函数的名称和相关参数
wavelet_name = 'db4'; % 小波基函数的名称，这里以 Daubechies 4（db4）为例
level = 6; % 小波变换的层数，需要根据实际情况进行调整

% 对信号进行小波变换
[c, l] = wavedec(M, level, wavelet_name);

% 设计滤波器并对细节系数进行阈值处理
threshold = 5; % 阈值大小，需要根据实际情况进行调整
c_filtered = c; % 初始化滤波后的细节系数
c_filtered(abs(c) < threshold) = 0; % 根据阈值进行滤波

% 重构滤波后的信号
filtered_signal = waverec(c_filtered, l, wavelet_name);

% 绘制原始信号和滤波后的信号
figure;
subplot(2,1,1);
plot(M,'b');
title('原始信号');
xlabel('样本点');
ylabel('信号值');

subplot(2,1,2);
plot(filtered_signal,'r');
title('滤波后的信号');
xlabel('样本点');
ylabel('信号值');
