%{
    输入为12xn的序列，输出为单个关节的力矩序列，修改output为对应关节的1xn序列
%}

% 数据所在的父目录
data_dir = 'I:\Experiments\LSTM\力矩数据';

% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

% 定义LSTM网络结构
numFeatures = 2; % 输入数据特征数量
numResponses = 1; % 输出数据响应数量
numHiddenUnits = 128; % LSTM隐藏层神经元数量
% dropoutLayer(0.1)
%bilstmLayer(2*numHiddenUnits,'OutputMode','sequence')
% lstmLayer(numHiddenUnits,'OutputMode','sequence')

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(2*numHiddenUnits,'OutputMode','sequence')
    
    lstmLayer(32,'OutputMode','sequence')
    fullyConnectedLayer(numResponses)
    regressionLayer];
% 

miniBatchSize = 2;
% 定义训练选项和结果评估指标
options = trainingOptions('adam', ...
    'MaxEpochs',600, ...
    'GradientThreshold',1, ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.5, ...
    'LearnRateDropPeriod',100, ...
    'Verbose',1);
% , ...
%      'Plots','training-progress'
% 循环遍历每个子目录，读取并预处理输入输出数据，并使用已经创建的LSTM网络进行训练

%% 输入输出归一化
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

%% 构造输入输出
n = num_subdirs-2;
zTrain_cell = cell(n,1);
tTrain_cell = cell(n,1);
tTrain_mat = zeros(n,1);

for i = 1:num_subdirs  
    
    % 获取当前子目录名称
    subdir_name = all_subdirs(i).name;
    disp(['正在训练第',subdir_name,'个样本']);
    % 如果当前项不是一个子目录，则忽略
    if strcmp(subdir_name, '.') || strcmp(subdir_name, '..') || ~isdir(fullfile(data_dir, subdir_name))
        continue;
    end

    % 读取输入和输出数据文件
    input_data_filename = fullfile(data_dir, subdir_name, 'input.mat');
    output_data_filename = fullfile(data_dir, subdir_name, 'torque.mat');
    input_data = load(input_data_filename).input;
    output_data = load(output_data_filename).x;

    xTrain = input_data;
    tTrain = output_data; 
    
    % 训练输入数据归一化 [-1,1]
    [nrows, ncols] = size(xTrain);
    for k=1:nrows
        row = xTrain(k,:);
        max_val = input_max(k,1);
        min_val = input_min(k,1);
        if min_val == max_val
            xTrain(k,:) = 0;
        else
            xTrain(k,:) = ((row - min_val) / (max_val - min_val))*2-1;
        end
    end
    
    % 训练输出数据归一化 [-1,1]
     for k=1:6
        row = tTrain(k,:);
        max_val = output_max(k,1);
        min_val = output_min(k,1);
        if min_val == max_val
            tTrain(k,:) = 0;
        else
            tTrain(k,:) = ((row - min_val) / (max_val - min_val))*2-1;
        end
     end
    
    % 训练过程中的输出,单独出一列
    zTrain = zeros(2,ncols);
    zTrain(1,:) = xTrain(1,:);
    zTrain(2,:) = xTrain(7,:);
    
%     zTrain = zTrain'; % nx2    
%     yTrain = tTrain(1,:)'; % nx1
     
   if i > 2
        zTrain_cell{i-2} = zTrain;
        tTrain_cell{i-2} = tTrain(1,:);
%         tTrain_mat(i-2,1) = tTrain;
   end
    
end

    % 输入为nx2的序列，输出为nx1的序列，训练和输出均为元胞数组
    % 使用已经创建的LSTM网络结构进行训练
    net = trainNetwork(zTrain_cell, tTrain_cell, layers, options);
    
    

    