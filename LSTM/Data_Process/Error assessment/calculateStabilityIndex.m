function stabilityIndex = calculateStabilityIndex(filteredData)

% 稳定性指标（Stability Index）：评估滤波后序列的波动程度，
% 可以通过计算序列的一阶差分
% 或二阶差分来获得。稳定性指标越小，表示滤波效果越好
%     diff1 = diff(filteredData);
%     stabilityIndex = mean(abs(diff1));

 % 数据间隔提升到5ms

    k = 5;
    downsampledData = filteredData(1:k:end);
    
    % 计算一阶差分
    diff1 = diff(downsampledData);
    
    % 计算稳定性指标
    stabilityIndex = mean(abs(diff1));
end
