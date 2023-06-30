% 假设你已经有了一个1xn的关节力矩信号序列，命名为torque_signal
torque_signal = torque_array(3,:);
% 采样频率
Fs = 1000; % 假设采样频率为1000Hz

% 窗函数选择（这里选择汉宁窗）
window = hann(length(torque_signal));

% 傅里叶变换
N = length(torque_signal); % 信号长度
torque_fft = fft(torque_signal .* window, N); % 应用窗函数，并进行FFT变换
torque_fft = torque_fft(1:N/2+1); % 只保留正频率部分

% 计算功率谱密度
power_spectrum_density = (1/(Fs*N)) * abs(torque_fft).^2;
power_spectrum_density(2:end-1) = 2*power_spectrum_density(2:end-1); % 对于双边频谱，需要乘以2

% 频率轴
frequencies = 0:Fs/N:Fs/2;

% 绘制频谱图
plot(frequencies, 10*log10(power_spectrum_density));
xlabel('Frequency (Hz)');
ylabel('Power Spectral Density (dB/Hz)');
title('Power Spectral Density');

% 可选：计算总能量
total_energy = sum(power_spectrum_density)*(Fs/N);
fprintf('Total Energy: %f\n', total_energy);
