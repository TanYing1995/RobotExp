%% 处理获取各个动作的计算能耗

% 数据所在的父目录
data_dir = 'I:\Experiments\LSTM\力矩数据';

% 获取所有子目录信息
all_subdirs = dir(data_dir);
num_subdirs = length(all_subdirs);

for i = 1:num_subdirs  
    
    % 获取当前子目录名称
    subdir_name = all_subdirs(i).name;
    
    % 如果当前项不是一个子目录，则忽略
    if strcmp(subdir_name, '.') || strcmp(subdir_name, '..') || ~isdir(fullfile(data_dir, subdir_name))
        continue;
    end

    % 读取输入和输出数据文件
    torque_data_filename = fullfile(data_dir, subdir_name, 'torque.mat');
    velocity_data_filename = fullfile(data_dir, subdir_name, 'velocity.mat');
    torque_data = load(torque_data_filename).x;% 6xn 关节力矩矩阵
    velocity_data = load(velocity_data_filename).vel; % 6xn 关节速度矩阵
    
    [row,col] = size(torque_data);
    
    energy = zeros(1,1);
    for kk = 1 : row
        for pp = 1 : col
            energy(1,1) = energy(1,1) + 0.001*abs(torque_data(kk,pp)*velocity_data(kk,pp));
        end
    end
    
    save(fullfile(data_dir,subdir_name,'energy.mat'),'energy');
end

