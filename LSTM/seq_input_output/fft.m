% 关节力矩数据
% torque_data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
% t = 0:0.01:10; % 时间向量
% f1 = 1; % 信号1的频率
% f2 = 10; % 信号2的频率
% x = sin(2*pi*f1*t) + sin(2*pi*f2*t); % 输入信号
% 傅里叶变换
fft_result = fft(torque_array(2,:));
% fft_result = fft(x);

% 计算频率范围
N = length(torque_array);         % 数据点数
fs = 100;                         % 采样频率
frequencies = fs*(0:(N/2))/N;    % 频率范围

% 计算频谱幅度（取正半部分）
amplitudes = abs(fft_result(1:N/2+1));

% 绘制频域分析图
plot(frequencies, amplitudes);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Domain Analysis');
