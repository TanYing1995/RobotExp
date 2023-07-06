% 选取测试集中的数据，进行指标测试

% 数据所在的父目录
% data_dir = 'I:\Experiments\LSTM\力矩数据';
data_dir = 'I:\Experiments\LSTM\Data';

torque_idx = 6;


% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

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
    input_data = load(input_data_filename).input; % 12xn输入向量
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
%     disp(['正在训练第',subdir_name,'个样本']);
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
     
   if i > 2
        zTrain_cell{i-2} = xTrain;
%         zTrain_cell{i-2} = zTrain;
        tTrain_cell{i-2} = tTrain;%这里将6xn的矩阵直接放入
%         tTrain_mat(i-2,1) = tTrain;
   end
    
end

%计算总能耗

k = 10;
actual_energy = [];
expect_energy = [];
for i = 1 : k

    idx = randi(n,1,1);
    input = zTrain_cell{idx};%12xn
    output = tTrain_cell{idx};%6xn
    
    tPred = zeros(6,size(output,2));
    tAct = zeros(6,size(output,2));

    curLen = size(input,2);
    for j = 1:6
         
        % 获取当前网络的名称
        network_name = ['t', num2str(j)];

        tPred(j,:) = predict(eval(network_name),input); % 输出为矩阵
        
        minval = output_min(j,1);
        maxval = output_max(j,1);
        
        tPred(j,:) = 0.5*(tPred(j,:)+1)*(maxval-minval)+minval;

        tAct(j,:) = output(j,:);
        tAct(j,:) = 0.5*(tAct(j,:)+1)*(maxval-minval)+minval;
           
    end

    for j = 1 : 6
        tPred(j,:) = kalmanFileter(tPred(j,:));
    end

    for j = 1 : 12
        minval = input_min(j,1);
        maxval = input_max(j,1);

        input(j,:) = 0.5*(input(j,:)+1)*(maxval-minval)+minval;
    end

    %计算实际能耗 和计算能耗
    % 忽略掉前100个时间点，防止因头部误差带来更大误差
    x = 0;y = 0; 

    for l = 1 : 6
        tx = sum(abs(dot(input(l+6,101:curLen),tAct(l,101:curLen))));
        x = x + tx;
        ty = sum(abs(dot(input(l+6,101:curLen),tPred(l,101:curLen))));
        y = y + ty;
    end
    
    actual_energy(end+1) = x;
    expect_energy(end+1) = y;
end
actual_energy = actual_energy*0.001;
expect_energy = expect_energy*0.001;
figure;
bar([actual_energy', expect_energy']);
legend('实际能耗', '预测能耗');
xlabel('样本组别');
ylabel('能耗');
title('离线能耗预测对比'); 