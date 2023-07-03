% 选取测试集中的数据，进行指标测试

% 数据所在的父目录
% data_dir = 'I:\Experiments\LSTM\力矩数据';
data_dir = 'I:\Experiments\LSTM\Data';

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
    
%     zTrain = zTrain'; % nx2
%     yTrain = tTrain(1,:)'; % nx1
     
   if i > 2
        zTrain_cell{i-2} = xTrain;
%         zTrain_cell{i-2} = zTrain;
        tTrain_cell{i-2} = tTrain(1,:);
%         tTrain_mat(i-2,1) = tTrain;
   end
    
end

k = 30;
mae_list = zeros(1,k);
rsme_list = zeros(1,k);
cnt = zeros(1,k);

for i = 1 : k

    idx = randi(n,1,1);
    tPred = predict(net,zTrain_cell{idx}); % 输出为矩阵
    
    minval = output_min(1,1);
    maxval = output_max(1,1);
    
    tPred = 0.5*(tPred+1)*(maxval-minval)+minval;
    tAct = tTrain_cell{idx};
    tAct = 0.5*(tAct+1)*(maxval-minval)+minval;
    
    % 对预测结果平滑处理
    tPred = kalmanFileter(tPred);
    mae_list(1,i) = mae(tAct,tPred);
    rsme_list(1,i) = rsme(tAct,tPred);
%     figure(i)
%     plot(tAct);
%     hold on
%     plot(tPred);
    for k = 1 : size(tAct,2)
        if abs(tPred(1,k)-tAct(1,k)) > mae_list(1,i) && abs(tPred(1,k)-tAct(1,k)) > 2
            cnt(1,i) = cnt(1,i)+1;
        end
    end

    cnt(1,i) = cnt(1,i)/size(tAct,2);
end

len = size(tAct,2);
% figure;
% subplot(3,1,1);
% plot(mae_list);
% 
% % xlabel("样本序号")
% ylabel("平均绝对误差")
% title("平均绝对误差 MAE")
% subplot(3,1,2);
% plot(rsme_list);
% 
% title("均方根误差 RSME")
% 
% subplot(3,1,3);
% plot(cnt);
% 
% title("较大偏离值点比率")
% xlabel("样本序号")

plot_scatter_with_line_and_circle(n,mae_list);
plot_scatter_with_line_and_circle(n,rsme_list);
plot_scatter_with_line_and_circle(n,cnt);