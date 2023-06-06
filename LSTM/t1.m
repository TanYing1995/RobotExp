% 定义文件夹路径
pos_folder = "path/to/position_files/";
vel_folder = "path/to/velocity_files/";
torque_folder = "path/to/torque_files/";

% 获取所有.mat文件的文件名列表
pos_file_list = dir(fullfile(pos_folder, "*.mat"));
vel_file_list = dir(fullfile(vel_folder, "*.mat"));
torque_file_list = dir(fullfile(torque_folder, "*.mat"));

% 读取.mat文件并将数据存储到cell数组中
joint_position = cell(length(pos_file_list), 1);
joint_velocity = cell(length(vel_file_list), 1);
joint_torque = cell(length(torque_file_list), 1);
for i = 1:length(pos_file_list)
    pos_data = load(fullfile(pos_file_list(i).folder, pos_file_list(i).name));
    vel_data = load(fullfile(vel_file_list(i).folder, vel_file_list(i).name));
    torque_data = load(fullfile(torque_file_list(i).folder, torque_file_list(i).name));
    
    joint_position{i} = pos_data.position;
    joint_velocity{i} = vel_data.velocity;
    joint_torque{i} = torque_data.torque;
end

% 将时序数据按长度从长到短排序
[~,idx] = sort(cellfun(@(c) size(c,2), joint_position),'descend');
joint_position = joint_position(idx);
joint_velocity = joint_velocity(idx);
joint_torque = joint_torque(idx);

% 将变长时序数据填充到等长时间序列
max_len = max(cellfun(@(c) size(c,2), joint_position));
XData = zeros(length(joint_position), size(joint_position{1},1), max_len);
YData = zeros(length(joint_torque), size(joint_torque{1},1), max_len);
for i=1:length(joint_position)
    XData(i,:,1:size(joint_position{i},2)) = joint_position{i};
    XData(i+length(joint_position),:,1:size(joint_velocity{i}, 2)) = joint_velocity{i};
    YData(i,:,1:size(joint_torque{i},2)) = joint_torque{i};
end

% 划分训练集和测试集
train_ratio = 0.8; % 训练集比率
[trainData, trainDataResponse, testData, testDataResponse] = splitData(XData, YData, train_ratio);

% 构建LSTM网络结构
inputSize = size(trainData, 2);
outputSize = size(trainDataResponse, 2);
numHiddenUnits = 200;
layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(outputSize)
    regressionLayer];

% 设置训练参数
options = trainingOptions('adam', ...
    'MaxEpochs',30, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.1, ...
    'LearnRateDropPeriod',20, ...
    'ExecutionEnvironment','cpu');

% 训练LSTM网络
net = trainNetwork(trainData',trainDataResponse',layers,options);

% 测试LSTM网络
testDataResponsePred = predict(net,testData');
testDataResponsePred = reshape(testDataResponsePred', size(testDataResponse));
mseError = mse(testDataResponsePred-testData');
