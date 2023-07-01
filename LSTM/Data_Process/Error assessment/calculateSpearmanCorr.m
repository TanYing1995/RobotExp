function spearman_corr = calculateSpearmanCorr(measurement_data, filtered_data)
    % 将原始测量数据和滤波后数据排序
    sorted_measurement = sort(measurement_data);
    sorted_filtered = sort(filtered_data);

    % 计算等级差
    rank_diff = tiedrank(sorted_measurement) - tiedrank(sorted_filtered);

    % 计算Spearman相关系数
    spearman_corr = cov(rank_diff) / (std(rank_diff) * std(sorted_filtered));
end
