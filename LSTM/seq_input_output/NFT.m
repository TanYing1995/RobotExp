% 假设你已经安装了非线性傅里叶变换工具箱

% 假设有一个1xn的非线性关节力矩信号序列，命名为torque_signal
torque_signal = torque_array(3,:);

% 采样频率
Fs = 1000; % 假设采样频率为1000Hz

% 设置非线性傅里叶变换参数
nftOptions = nft('tspan', 1/Fs:1/Fs:length(torque_signal)/Fs, 'N', length(torque_signal), 'L', 10);

% 执行非线性傅里叶变换
torque_nft = nft(torque_signal, nftOptions);

% 绘制非线性傅里叶变换系数随频率的幅度图
figure;
plot(2*pi*nftOptions.freq, abs(torque_nft.coeffs));
xlabel('Normalized Frequency (rad/sample)');
ylabel('Coefficient Amplitude');
title('Nonlinear Fourier Transform');

% 可选：绘制非线性傅里叶变换系数随频率的相位图
figure;
plot(2*pi*nftOptions.freq, angle(torque_nft.coeffs));
xlabel('Normalized Frequency (rad/sample)');
ylabel('Coefficient Phase');
title('Nonlinear Fourier Transform Phase');

% 可选：绘制非线性傅里叶变换系数随频率的幅度调制图
figure;
plot(2*pi*nftOptions.freq, torque_nft.am);
xlabel('Normalized Frequency (rad/sample)');
ylabel('Amplitude Modulation');
title('Nonlinear Fourier Transform Amplitude Modulation');

% 可选：绘制非线性傅里叶变换系数随频率的相位调制图
figure;
plot(2*pi*nftOptions.freq, torque_nft.pm);
xlabel('Normalized Frequency (rad/sample)');
ylabel('Phase Modulation');
title('Nonlinear Fourier Transform Phase Modulation');
