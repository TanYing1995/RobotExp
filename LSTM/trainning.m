% 数据所在的父目录
data_dir = 'I:\Experiments\LSTM\力矩数据';

% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

% 循环遍历每个子目录
for i = 1:num_subdirs
    % 获取当前子目录名称
    subdir_name = all_subdirs(i).name;
    
    % 如果当前项不是一个子目录，则忽略
    if strcmp(subdir_name, '.') || strcmp(subdir_name, '..') || ~isdir(fullfile(data_dir, subdir_name))
        continue;
    end

    % 读取输入和输出数据文件
    input_data_filename = fullfile(data_dir, subdir_name, 'input.mat');%
    output_data_filename = fullfile(data_dir, subdir_name, 'torque.mat');
    input_data = load(input_data_filename).input;
    output_data = load(output_data_filename).x;
    data = {input_data, output_data};

    % 基于上面的数据，定义LSTM模型并进行训练
    
    % 获取数据
    X_all = input_data;
    Y_all = output_data;
    
    numTimeSteps = size(input_data,2);
    
    
    
    
    
    % 使用该网络模型进行训练
    [net, trainInfo] = trainNetwork(X_all,Y_all,layers,options);

    % 输出训练指标的历史值，以便分析和可视化训练过程
    figure;
    subplot(2,1,1);
    plot(trainInfo.TrainingLoss,'o');
    hold on;
    plot(trainInfo.ValidationLoss,'x');
    xlabel('Training Epochs');
    ylabel('Loss');
    legend('Training','Validation');
end
