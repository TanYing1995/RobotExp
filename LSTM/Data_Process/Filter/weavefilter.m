% 假设你已经得到了传感器测量的真实信号关节力矩序列 M
M = torque_array(2,:);

% 定义小波变换的相关参数
wavelet_name = 'db4'; % 小波基函数的名称，这里以 Daubechies 4（db4）为例
level = 3; % 小波变换的层数，需要根据实际情况进行调整

% 对信号进行离散小波变换
[c, l] = wavedec(M, level, wavelet_name);

% 获取细节系数
det_coeff = detcoef(c, l, 'all');

% 将 cell 数组转换为数值类型的向量
det_coeff_vec = cell2mat(det_coeff);

% 设计滤波器并对细节系数进行阈值处理
threshold = 0.2; % 阈值大小，需要根据实际情况进行调整
det_coeff_filtered = det_coeff_vec; % 初始化滤波后的细节系数
det_coeff_filtered(abs(det_coeff_vec) < threshold) = 0; % 根据阈值进行滤波

% 重构滤波后的信号
filtered_signal = waverec([c(1:end-level), det_coeff_filtered], l, wavelet_name);

% 打印滤波前后的信号
disp('滤波前的信号:');
disp(M);
disp('滤波后的信号:');
disp(filtered_signal);
