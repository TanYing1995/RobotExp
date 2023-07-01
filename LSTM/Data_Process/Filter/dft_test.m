% 假设已经有一个包含5500个数据点的非线性序列，存储在名为"sequence"的向量中
sequence = torque_array(2,:);
% 设置采样频率和时间间隔
fs = 1000;  % 采样频率，单位为Hz
dt = 1/fs;  % 采样时间间隔，单位为秒
N = length(sequence); % 数据点数

% 计算DFT矩阵
dft_matrix = dftmtx(N);

% 应用离散傅里叶变换（DFT）
X = dft_matrix * sequence';  % 执行离散傅里叶变换

% 计算频谱幅度谱和频率向量
P2 = abs(X/N);      % 双边频谱
P1 = P2(1:N/2+1);   % 单边频谱
P1(2:end-1) = 2*P1(2:end-1);  % 标准化幅度

f = (0:N/2)*(fs/N); % 频率向量

% 绘制频谱图
figure;
plot(f, P1);
title('频谱图');
xlabel('频率 (Hz)');
ylabel('振幅');

% 可选：找到主要频率成分和峰值
[max_val, max_idx] = max(P1); % 找到最大值及其索引
main_frequency = f(max_idx); % 对应的主要频率成分
