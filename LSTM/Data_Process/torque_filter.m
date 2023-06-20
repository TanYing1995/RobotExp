%% 过滤获取的力矩数据

% 数据所在的父目录
data_dir = 'I:\Experiments\LSTM\力矩数据-new';
% data_dir = 'C:\Users\admin\Desktop\轨迹\test';
% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

% 循环遍历每个子目录
for i = 1:num_subdirs

    % 获取当前子目录名称
    subdir_name = all_subdirs(i).name;
    
    % 如果当前项不是一个子目录，则忽略
    if strcmp(subdir_name, '.') || strcmp(subdir_name, '..') || ~isdir(fullfile(data_dir, subdir_name))
        continue;
    end

    %处理得到关节速度
    
    % 读取输入和输出数据文件
    data_filename = fullfile(data_dir, subdir_name, 'torque_array.mat');
    torque_file = load(data_filename);%load后加载进来的数据是struct结构
    
    torque_data = torque_file.torque_array(2:7,:);
    x = kalman_filter(torque_data);

    save(fullfile([data_dir '\' subdir_name],'torque.mat'),'x'); 
%   save(fullfile([data_dir '\' subdir_name],'velocity.mat'),'vel'); 
    
end


