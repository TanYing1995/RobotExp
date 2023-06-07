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
    
%     tTrain = output_data;
    % 基于上面的数据，定义LSTM模型并进行训练
    
    % 将数据分成训练数据和测试数据
    xTrain = input_data;
    tTrain = output_data;
    
    % 假设输入数据为 X，大小为 12 x n
    % Step 1: 简单归一化
%     minValue = min(x_input,[],2);
%     maxValue = max(x_input,[],2);
%     tmp = (x_input-minValue)./repmat(maxValue-minValue,[1 size(x_input,2)]);
%     
%     % Step 2: 映射到[-1,1]
%      tTrain = tmp - 0.5;
%      tTrain = 2.* tTrain;
    
    % 数据归一化处理，预处理到区间[-1,1]
%     [rows, cols] = size(x_input);
%     xTrain = zeros(rows,cols);
%     
%     % 归一化输入数据
%     for j = 1:rows
%         % 对每行的数据做简单归一化（变换到[0,1]范围内）
%         tmp = x_input(j,:);
%         tmp = (tmp - min(tmp)) / (max(tmp) - min(tmp));
%         % 将归一化后的数据缩放到[-1,1]范围内
%         xTrain(j,:) = (tmp - 0.5) * 2;
%     end
    
    % 归一化预测数据
%     tTrain = zeros(6,cols);
%     for k = 1:6
%         % 对每行的数据做简单归一化（变换到[0,1]范围内）
%         tmp = t_output(k,:);
%         tmp = (tmp - min(tmp)) / (max(tmp) - min(tmp));
%         tTrain(k,:) = (tmp - 0.5) * 2;
%     end
    
    % 定义LSTM网络结构
    numFeatures = size(input_data,1); % LSTM网络中输入特征数量
    numResponses = size(output_data,1); % LSTM网络中输出响应数量
    numHiddenUnits = 64; % LSTM网络中隐藏层神经元数量
    layers = [ ...
        sequenceInputLayer(numFeatures)
        lstmLayer(numHiddenUnits,'OutputMode','sequence')
        lstmLayer(2*numHiddenUnits,'OutputMode','sequence')
        fullyConnectedLayer(numResponses)
        regressionLayer];

    % 定义LSTM网络超参数和选项
    options = trainingOptions('adam', ...
        'MaxEpochs',500, ... % 最大迭代次数
        'GradientThreshold',1, ... % 梯度截断值
        'InitialLearnRate',0.01, ... % 初始学习率
        'LearnRateSchedule','piecewise', ...
        'LearnRateDropFactor',0.8, ...
        'LearnRateDropPeriod',100, ...
        'Verbose',1, ...
        'Plots','training-progress');

    % 使用所有数据作为训练数据训练LSTM网络
    net = trainNetwork(xTrain, tTrain, layers, options);
    
    % 对训练数据进行预测
    YPred = predict(net, xTrain);
    YPred = double(YPred); % 将LSTM网络的输出cell数组转换为矩阵

    % 计算训练误差
    rmse = sqrt(mean((tTrain-YPred).^2)); % RMSE误差定义为两个序列（目标序列和网络输出序列）的均方根误差
    fprintf('Training RMSE: %.4f\n', rmse);
  
end
