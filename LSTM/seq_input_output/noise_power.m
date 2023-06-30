% 假设原始序列为1xn的数据data，滤波后的序列为1xn的数据res

% 提取噪声样本
noise_samples = data - results;

% 计算滤波前信号的噪声功率
% Pn = var(noise_samples);
Pn = var(data);

% 输出滤波前信号的噪声功率
disp(['滤波前信号的噪声功率：', num2str(Pn)]);

% 提取滤波后信号的噪声样本
filtered_noise_samples = results;

% 计算滤波后信号的噪声功率
Pn_filtered = var(filtered_noise_samples);

% 输出滤波后信号的噪声功率
disp(['滤波后信号的噪声功率：', num2str(Pn_filtered)]);

% 计算噪声抑制比（NRR）
NRR = 10 * log10(Pn / Pn_filtered);

% 输出噪声抑制比
disp(['噪声抑制比（NRR）：', num2str(NRR)]);
