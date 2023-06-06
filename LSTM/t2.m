% 设置数据路径
data_path = ''; % 数据所在文件夹完整路径
train_ratio = 0.8; % 训练集占比

% 读取所有数据文件路径
data_files = dir(fullfile(data_path,'*.mat')); 
num_files = length(data_files);

% 初始化输入和输出变量
inputs = zeros(6, num_files); % 输入为6关节的位置和速度
outputs = zeros(6, num_files); % 输出为六个关节的力矩

% 循环读取每个数据文件并提取信息
for i=1:num_files
    load(fullfile(data_path, data_files(i).name));
    inputs(:,i) = [joint_positions; joint_velocities]; % 将6关节的位置和速度存入输入矩阵中
    outputs(:,i) = joint_torques; % 将6个关节的力矩存入输出矩阵中
end

% 将数据集拆分成训练集和测试集
num_train = round(num_files*train_ratio);
train_inputs = inputs(:,1:num_train);
train_outputs = outputs(:,1:num_train);
test_inputs = inputs(:,num_train+1:end);
test_outputs = outputs(:,num_train+1:end);

% 使用LSTM模型进行训练
num_features = size(train_inputs,1); % 输入特征数量
num_hidden_units = 128; % 隐藏层神经元数量
output_size = size(train_outputs,1); % 输出大小
num_epochs = 50; % 迭代次数

layers = [ ...
    sequenceInputLayer(num_features)
    lstmLayer(num_hidden_units,'OutputMode','last')
    fullyConnectedLayer(output_size)
    regressionLayer];
options = trainingOptions('adam', ...
    'MaxEpochs',num_epochs, ...
    'MiniBatchSize',16, ...
    'ValidationData',{test_inputs,test_outputs}, ...
    'ValidationFrequency',30, ...
    'SequenceLength','shortest', ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.01);

net = trainNetwork(train_inputs,train_outputs,layers,options);

% 使用训练好的LSTM模型进行测试，并输出预测力矩曲线和实际力矩曲线对比图
net_outputs = predict(net,test_inputs);
num_plots = size(outputs,1);
figure;
hold on
for i=1:num_plots
    subplot(num_plots,1,i);
    plot(test_outputs(i,:),'b');
    hold on;
    plot(net_outputs(i,:),'r');
end
legend({'实际力矩','预测力矩'},'FontSize',12);
xlabel('时间 (秒)','FontSize',12);
ylabel('力矩大小','FontSize',12);
