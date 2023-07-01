function filtered_data = mean_filter(input_data, window_size)
    % 输入：
    % input_data：1xn的力矩序列输入
    % window_size：窗口大小，表示计算平均值时考虑的数据点数量
    % 输出：
    % filtered_data：均值滤波后的力矩序列输出

    data_length = length(input_data);
    filtered_data = zeros(1, data_length);

    % 根据窗口大小计算滑动窗口起始和结束索引
    start_index = 1;
    end_index = window_size;

    % 对每个窗口进行均值滤波
    while end_index <= data_length
        % 取出当前窗口内的数据并计算平均值
        window_data = input_data(start_index:end_index);
        window_mean = mean(window_data);
        
        % 将平均值赋给当前窗口内的所有数据点
        filtered_data(start_index:end_index) = window_mean;
        
        % 窗口向后滑动
        start_index = start_index + 1;
        end_index = end_index + 1;
    end
    
    % 处理最后一段不完整的窗口
    if start_index <= data_length
        window_data = input_data(start_index:data_length);
        window_mean = mean(window_data);
        filtered_data(start_index:data_length) = window_mean;
    end
end
