%% 输入输出归一化
input_max = -10000000*ones(12,1); %12x1最大值向量
input_min = 10000000*ones(12,1); %12x1最小值向量

output_max = -10000000; %6x1最大值向量
output_min = 10000000; %6x1最小值向量

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

data_dir = 'I:\Experiments\LSTM\力矩数据';

% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);
% 随机选取训练数据
% idx = randi(20);
idx = 1;
adir = ['I:\Experiments\LSTM\力矩数据\',num2str(idx)]; 
% adir = ['I:\Experiments\LSTM\数据\',num2str(idx)]; 
% data_dir = 'I:\Experiments\LSTM\数据\2';

input_test = load(fullfile(adir, 'input.mat')).input;
output_test = load(fullfile(adir, 'energy.mat')).energy;

% 将数据分成训练数据和测试数据
xTrain = input_test;
tTrain = output_test;

% 输入数据归一化处理
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

% 2xn输入序列
zTrain = zeros(2,ncols);
zTrain(1,:) = xTrain(1,:);
zTrain(2,:) = xTrain(7,:);    
tOut = predict(net, zTrain);
tOut = double(tOut);

max_val = output_max; % 获取当前行的最小值
min_val = output_min; % 获取当前行的最大值

tOut = 0.5*(tOut+1)*(max_val - min_val) + min_val;

% for i = 1 : 1
%    figure(i); 
%    plot(tTrain(i,:),'b');
%    xlabel('时间');
%    ylabel('力矩');
%    hold on;
%    plot(tPred(i,:),'r');
%    legend('实际力矩', '预测力矩');
%    title(['第',num2str(idx),'组数据', num2str(i), '关节力矩']);
% end