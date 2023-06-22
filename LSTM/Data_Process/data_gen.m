%
% 生成 缺失关节的力矩数据

% 数据所在的父目录
% data_dir = 'I:\Experiments\LSTM\力矩数据';
data_dir = 'I:\Experiments\LSTM\力矩数据-new';
% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

% 循环遍历每个子目录

mx = 0;
idx = "";
cnt = 0;
list = {};
t = 0;
filename = "";
torque_3 = [];
torque_4 = [];
for i = 1:num_subdirs
    % 获取当前子目录名称
    subdir_name = all_subdirs(i).name;
    
    % 如果当前项不是一个子目录，则忽略
    if strcmp(subdir_name, '.') || strcmp(subdir_name, '..') || ~isdir(fullfile(data_dir, subdir_name))
        continue;
    end
    
    % 读取输入和输出数据文件
    data_filename = fullfile(data_dir, subdir_name, 'torque.mat');
    torque_file = load(data_filename);%load后加载进来的数据是struct结构
    
    torque_data = torque_file.x;
    
    [r,c] = size(torque_data);
    if c > mx
        idx = subdir_name;
        mx = c;
        
    end
    
    %找到最长为5316
    if c == 5316
        filename = subdir_name;
        torque_3 = torque_data(3,:);
        torque_4 = torque_data(4,:);
    end
%     if c > 5316   %5486
%         cnt = cnt+1;
%         list{end+1} = subdir_name;
%     end
end

% 修改缺失的第三关节和第四关节力矩向量，存储到新的矩阵文件中

des_data_dir = 'I:\Experiments\LSTM\力矩数据-new';
des_all_subdirs = dir(des_data_dir);
des_num_subdirs = length(des_all_subdirs);


for i = 1 : des_num_subdirs
    des_subdir_name = des_all_subdirs(i).name;
    % 如果当前项不是一个子目录，则忽略
    if strcmp(des_subdir_name, '.') || strcmp(des_subdir_name, '..') || ~isdir(fullfile(des_data_dir, des_subdir_name))
        continue;
    end

    data_filename = fullfile(des_data_dir, des_subdir_name, 'torque.mat');
    x = load(data_filename).x;

    [~,c] = size(x);
    
    r =  0.98 + (0.98 - 0.956) * rand(1); % 随机系数
    % 修改三四关节的力矩
    x(3,:) = r*torque_3(1,1:c);
    x(4,:) = r*torque_4(1,1:c);

    save(fullfile([des_data_dir '\' des_subdir_name],'torque.mat'),'x'); % 覆盖原文件
end