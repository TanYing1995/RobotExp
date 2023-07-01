
addpath('I:\Experiments\LSTM\Data_Process\Filter')

% 原始数据
data = torque_array(2,:);

% 滤波数据
% filter_data = EKF_EX(data);
filter_data = EKF(data);
% filter_data = EKF_window(data);

% 平均绝对误差（Mean Absolute Error, MAE）
MAE = calculateMAE(data,filter_data);


% 均方误差（Mean Square Error, MSE）
MSE = calculateMSE(data,filter_data);

% 均方根误差（Root Mean Square Error, RMSE）
RMSE = calculateRMSE(data,filter_data);

% 相关系数（Correlation Coefficient）
% e4 = calculateCorrCoeff(data,filter_data);

% 一阶差分稳定性指标
SI = calculateStabilityIndex(filter_data);
SI_1 = calculateStabilityIndex(data);

% 二阶差分稳定性指标
SSI = calculateStabilityIndex_1(filter_data);
SSI_1 = calculateStabilityIndex_1(data);

% 计算方差
% e7 = calculateVariance(filter_data)

% Spearman相关系数
% e7 = calculateSpearmanCorr(data,filter_data);
