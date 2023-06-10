function [input_max,input_min,output_max,output_min] = get_max_min()
%  获取训练集中的输入和输出序列数据的最值

% 数据所在的父目录
data_dir = 'I:\Experiments\LSTM\力矩数据';

% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

input_max = -10000000*ones(12,1); %12x1最大值向量
input_min = 10000000*ones(12,1); %12x1最小值向量

output_max = -10000000*ones(6,1); %6x1最大值向量
output_min = 10000000*ones(6,1); %6x1最小值向量

for i = 1:num_subdirs  
    
    % 获取当前子目录名称
    subdir_name = all_subdirs(i).name;
    
    % 如果当前项不是一个子目录，则忽略
    if strcmp(subdir_name, '.') || strcmp(subdir_name, '..') || ~isdir(fullfile(data_dir, subdir_name))
        continue;
    end

    % 读取输入和输出数据文件
    input_data_filename = fullfile(data_dir, subdir_name, 'input.mat');
    output_data_filename = fullfile(data_dir, subdir_name, 'torque.mat');
    input_data = load(input_data_filename).input;% 12xn输入向量
    output_data = load(output_data_filename).x; % 6xn输出向量
    
    % 输入最大值和最小值
    for j = 1 : 12
        row = input_data(j,:);
        max_val = max(row);
        min_val = min(row);
        if max_val > input_max(j,1)
            input_max(j,1) = max_val;
        end
        if min_val < input_min(j,1)
            input_min(j,1) = min_val;
        end
    end
    
    % 输出最大值和最小值
    for j = 1 : 6
        row = output_data(j,:);
        max_val = max(row);
        min_val = min(row);
        if max_val > output_max(j,1)
            output_max(j,1) = max_val;
        end
        if min_val < output_min(j,1)
            output_min(j,1) = min_val;
        end
    end
end


end

