
% 数据所在的父目录
data_dir = 'I:\Experiments\LSTM\力矩数据';

% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

% 获取数据最值
[input_max,input_min,output_max,output_min] = get_max_min();

%% 处理数据

n = num_subdirs-2;  
imp_all = zeros(n,size(x,2)); % 初始化特征重要性数组

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
    input_data = load(input_data_filename).input;
    output_data = load(output_data_filename).x;

    [x , y] = Normalize(input_data,output_data,input_max,input_min,output_max,output_min);

    x = x';
    y = y(1,:)';% 取关节1的力矩数据

    % 随机森林回归模型训练
    Mdl = TreeBagger(50, x, y, 'Method', 'regression','OOBPredictorImportance','on');
    
    % 计算特征重要性
    
    imp = Mdl.OOBPermutedPredictorDeltaError;
    
    if i > 2
        % 保存每次回归后的特征重要性值
        imp_all(i-2,:) = imp;
    end

end

% 计算各特征的平均重要性值
imp_mean = mean(imp_all);

% 可视化特征重要性
figure;
bar(imp_mean);
title('Feature Importance');
xlabel('Feature Index');
ylabel('Importance');
