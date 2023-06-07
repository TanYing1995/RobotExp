% 数据所在的父目录
data_dir = 'I:\Experiments\LSTM\力矩数据';

% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

% 定义LSTM网络结构
numFeatures = 12; % 输入数据特征数量
numResponses = 6; % 输出数据响应数量
numHiddenUnits = 64; % LSTM隐藏层神经元数量

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(2*numHiddenUnits,'OutputMode','sequence')
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(100)
    fullyConnectedLayer(numResponses)
    regressionLayer];

% 定义训练选项和结果评估指标
options = trainingOptions('adam', ...
    'MaxEpochs',1000, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.9, ...
    'LearnRateDropPeriod',100, ...
    'Verbose',1, ...
    'Plots','training-progress');

% 循环遍历每个子目录，读取并预处理输入输出数据，并使用已经创建的LSTM网络进行训练
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

    xTrain = input_data;
    tTrain = output_data; % 目标预测数据不需归一化处理
    
    % 使用已经创建的LSTM网络结构进行训练
    net = trainNetwork(xTrain, tTrain, layers, options);

    % 对训练数据进行预测，并计算RMSE误差
    YPred = predict(net, xTrain);
    YPred = double(YPred);
    
    rmse = sqrt(mean((tTrain-YPred).^2));
    fprintf('Training RMSE: %.4f\n', rmse);
end
