% 获取训练数据集中的最值向量
[input_max,input_min,output_max,output_min] = get_max_min();

% data_dir = 'I:\Experiments\LSTM\力矩数据';
% 
% % 获取所有子目录信息
% all_subdirs = dir(data_dir);
% num_subdirs = length(all_subdirs);
% 随机选取训练数据
% idx = randi(20);
idx = 8;
% adir = ['I:\Experiments\LSTM\力矩数据\',num2str(idx)]; 
adir = ['I:\Experiments\LSTM\数据\',num2str(idx)]; 
% data_dir = 'I:\Experiments\LSTM\数据\2';

input_test = load(fullfile(adir, 'input.mat')).input;
output_test = load(fullfile(adir, 'torque.mat')).x;

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

% tOut = predict(net, xTrain);
% tOut = double(tOut); % 将LSTM网络的输出cell数组转换为矩阵

tPred = zeros(6,ncols);
tPred(1,:) = tOut;
output_size = 1;

% % 对数据进行反归一化处理
for i = 1:output_size
    normalized_row = tPred(i,:); % 获取当前行的数据
    max_val = output_max(i,1); % 获取当前行的最小值
    min_val = output_min(i,1); % 获取当前行的最大值
    
    % 利用反归一化公式，将归一化后的数据还原回原始取值范围
    original_row = 0.5*(normalized_row+1)*(max_val - min_val) + min_val;
    tPred(i,:) = original_row; % 将还原后的数据存回矩阵中
end

% rmse = [];
% for i = 1:output_size
%     rmse(i) = sqrt(mean((tTrain(i,:)-tPred(i,:)).^2));
% end

%% 输出滤波
tPred = kalman_filter(tPred);

for i = 1 : 1
   figure(i); 
   plot(tTrain(i,:),'b');
   xlabel('时间');
   ylabel('力矩');
   hold on;
   plot(tPred(i,:),'r');
   legend('实际力矩', '预测力矩');
   title(['第',num2str(idx),'组数据', num2str(i), '关节力矩']);
end