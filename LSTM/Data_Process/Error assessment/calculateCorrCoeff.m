function corrCoeff = calculateCorrCoeff(data, results)

%
% 相关系数（Correlation Coefficient）：衡量滤波后序列与真实数据之间的线性相关性。
% 相关系数介于-1到1之间，越接近1表示滤波效果越好
%
%
    corrMatrix = corrcoef(data, results);
    corrCoeff = corrMatrix(1, 2);
end
