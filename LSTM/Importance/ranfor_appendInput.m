
% 数据所在的父目录
% data_dir = 'I:\Experiments\LSTM\力矩数据';
data_dir = 'I:\Experiments\LSTM\Data';

% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

% 获取数据最值
[input_max,input_min,output_max,output_min] = get_max_min();

%% 处理数据
% 将所有输入序列存储在一个cell数组X_cell中
n = num_subdirs-2;

% 定义序列最大长度
%max_len = 4500;

X_cell = {};

% 存储输出序列
y_cell = {};

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
    
    % 对数组进行截断或者补充
%     [num_samples, seq_len] = size(x);
%     if seq_len >= max_len
%         xTrain = x(:, 1:max_len);
%         tTrain = y(:, 1:max_len);
%     else
%         xTrain = zeros(num_samples, max_len);
%         xTrain(:, 1:seq_len) = x;
%         tTrain = zeros(num_samples/2, max_len);
%         tTrain(:, 1:seq_len) = y;
%     end

    if i > 2
        X_cell{end+1} = x;
        y_cell{end+1} = y(6,:);% 回归数据为关节1力矩曲线
    end
end

%% Train

% 定义5折交叉验证分区对象
cv = cvpartition(n, 'KFold', 5);


% 定义imp_all数组
% imp_all = zeros(size(X_cell{1}, 2), n, cv.NumTestSets);
%imp_all = zeros(12, n, cv.NumTestSets);
imp_all = {};

% 循环处理每个分区
for i = 1:cv.NumTestSets
    
    % 获取当前训练集和测试集的索引
    trainIdx = cv.training(i);
    testIdx = cv.test(i);
    
    % 将所有输入序列堆叠成一个矩阵
%     X_train = cell2mat(X_cell(trainIdx));
%     X_test = cell2mat(X_cell(testIdx));
% k = cell2mat(y_cell(trainIdx));
    cc = X_cell(trainIdx);
    X_train = cat(2,cc{:});%输入矩阵按列拼接
    dd = X_cell(testIdx);
    X_test = cat(2,dd{:});

    ee = y_cell(trainIdx);
    k = cat(2,ee{:});
    
    
    % 使用训练集训练随机森林回归模型
    Mdl = TreeBagger(50, X_train', k', 'Method', 'regression', 'OOBPredictorImportance', 'on');
    
    % 获取模型在测试集上的预测结果和真实结果
    y_pred = predict(Mdl, X_test');
    ff = y_cell(testIdx);
    y_true = cell2mat(ff);
    
    % 计算模型的均方误差
    % mse = mean((y_pred - y_true).^2);
    % disp(['MSE of fold ', num2str(i), ': ', num2str(mse)]);
    
    % 获取特征重要性
    imp_cell = Mdl.OOBPermutedVarDeltaError;
    
    % 将imp添加到imp_all中，按列存储
    
    imp_all{end+1} = imp_cell;
    
end

% 计算特征权重
imp_mean = mean(cat(1,imp_all{:}));

% 可视化特征重要性
draw(imp_mean)
