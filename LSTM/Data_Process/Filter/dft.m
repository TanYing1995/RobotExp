% 假设你已经有了离散信号数据 x，以及采样频率 Fs
x = torque_array(2,:);
% Fs = 0.875;
% 
% % 计算离散傅里叶变换
% X = fft(x);
% 
% % 计算频率轴
% N = length(x);
% f = (0:N-1)*(Fs/N);
% 
% % 绘制频谱图
% stem(f, abs(X));
% title('频谱图');
% xlabel('频率 (Hz)');
% ylabel('幅度');


% 假设已经有一个包含5500个数据点的非线性关节力矩信号，存储在名为"force"的向量中
force = torque_array(2,:);
% 设置采样频率和时间间隔
fs = 1000;  % 采样频率，单位为Hz
dt = 1/fs;  % 采样时间间隔，单位为秒

% 应用傅里叶变换
N = length(force);  % 数据点数
t = (0:N-1)*dt;     % 时间向量
f = fs*(0:(N/2))/N; % 频率向量

% 加窗处理（以汉宁窗为例）
window = hann(N);   % 汉宁窗函数
force_windowed = force.*window'; % 加窗处理后的信号

% 计算傅里叶变换
force_fft = fft(force_windowed); % 执行傅里叶变换
P2 = abs(force_fft/N);            % 双边频谱
P1 = P2(1:N/2+1);                 % 单边频谱
P1(2:end-1) = 2*P1(2:end-1);      % 标准化幅度

% 绘制频谱图
figure;
plot(f, P1);
title('频谱图');
xlabel('频率 (Hz)');
ylabel('振幅');

% 可选：使用MATLAB内置函数找到主要频率成分和峰值
[max_val, max_idx] = max(P1); % 找到最大值及其索引
main_frequency = f(max_idx); % 对应的主要频率成分
