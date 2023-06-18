%% 输入输出归一化
input_max = -10000000*ones(12,1); %12x1最大值向量
input_min = 10000000*ones(12,1); %12x1最小值向量

output_max = -10000000; %6x1最大值向量
output_min = 10000000; %6x1最小值向量

data_dir = 'I:\Experiments\LSTM\力矩数据';

% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

% 获取最值
for i = 1:num_subdirs  
    
    % 获取当前子目录名称
    subdir_name = all_subdirs(i).name;
    
    % 如果当前项不是一个子目录，则忽略
    if strcmp(subdir_name, '.') || strcmp(subdir_name, '..') || ~isdir(fullfile(data_dir, subdir_name))
        continue;
    end

    % 读取输入和输出数据文件
    input_data_filename = fullfile(data_dir, subdir_name, 'input.mat');
    output_data_filename = fullfile(data_dir, subdir_name, 'energy.mat');
    input_data = load(input_data_filename).input;% 12xn输入向量
    output_data = load(output_data_filename).energy; % 1x1输出
    
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
    
    if output_data(1,1) > output_max
        output_max = output_data(1,1);
    end
    if output_data(1,1) < output_min
        output_min = output_data(1,1);
    end
   
end

%% 预测
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
    output_data_filename = fullfile(data_dir, subdir_name, 'energy.mat');
    input_data = load(input_data_filename).input;
    output_data = load(output_data_filename).energy;

    xTrain = input_data;
%     tTrain = output_data; 
    
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
     
    max_val = output_max;
    min_val = output_min;
    row = output_data(1,1);
    tTrain = 0;
    if min_val ~= max_val
         tTrain = ((row - min_val) / (max_val - min_val))*2-1;
    end
    
    
    % 训练过程中的输出,单独出一列
    zTrain = zeros(2,ncols);
    zTrain(1,:) = xTrain(1,:);
    zTrain(2,:) = xTrain(7,:);
    
    %将训练的序列数据换成cell数组
   if i > 2
        zTrain_cell{i-2} = zTrain;
        tTrain_cell{i-2} = tTrain;
        tTrain_mat(i-2,1) = output_data(1,1);
   
   end
end

tOut = predict(net,zTrain_cell);

max_val = output_max; % 获取当前行的最小值
min_val = output_min; % 获取当前行的最大值

tOut = 0.5*(tOut+1)*(max_val - min_val) + min_val;   

%% 网络预测

% for i = 1:num_subdirs  
%      % 获取当前子目录名称
%     subdir_name = all_subdirs(i).name;
%     
%     % 如果当前项不是一个子目录，则忽略
%     if strcmp(subdir_name, '.') || strcmp(subdir_name, '..') || ~isdir(fullfile(data_dir, subdir_name))
%         continue;
%     end
% 
%     % 读取输入和输出数据文件
%     input_data_filename = fullfile(data_dir, subdir_name, 'input.mat');
%     output_data_filename = fullfile(data_dir, subdir_name, 'energy.mat');
%     input_data = load(input_data_filename).input;% 12xn输入向量
%     output_data = load(output_data_filename).energy; % 1x1输出
%     
%     % 将数据分成训练数据和测试数据
%     xTrain = input_data;
%     tTrain = output_data;
% 
%     % 记录实际的能耗值
%     act_output(end+1) = tTrain(1,1);
%     
%     % 输入数据归一化处理
%     [nrows, ncols] = size(xTrain);
%         for k=1:nrows
%             row = xTrain(k,:);
%             max_val = input_max(k,1);
%             min_val = input_min(k,1);
%             if min_val == max_val
%                 xTrain(k,:) = 0;
%             else
%                 xTrain(k,:) = ((row - min_val) / (max_val - min_val))*2-1;
%             end
%         end
% 
%     % 2xn输入序列
%     zTrain = zeros(2,ncols);
%     zTrain(1,:) = xTrain(1,:);
%     zTrain(2,:) = xTrain(7,:);    
%     
%     tOut = predict(net, zTrain);
%     tOut = double(tOut);
% 
%     max_val = output_max; % 获取当前行的最小值
%     min_val = output_min; % 获取当前行的最大值
% 
%     tOut = 0.5*(tOut+1)*(max_val - min_val) + min_val;
%     
%     prd_output(end+1) = tOut;
% end

%% 结果对比图
%act_output = [];
% prd_output = [];
% 创建两个示例向量
% A = act_output;
% B = prd_output;

A = tTrain_mat';
B = tOut';
n = size(A,2);

% 数值对比图
figure;
bar(1:n, [A', B'], 'grouped')
title('数值对比图');
xlabel('位置');
ylabel('数值');
legend('实际能耗', '预测能耗');

% 相应的误差图
error = A - B;
figure;
bar(1:n, error, 'FaceColor', [0.4940 0.1840 0.5560], 'EdgeColor', 'none');
title('误差图');
xlabel('位置');
ylabel('误差');
