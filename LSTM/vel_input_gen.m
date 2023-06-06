%% 根据位移曲线构造速度矩阵和 LSTM输入矩阵
%%
% 数据所在的父目录
data_dir = 'I:\Experiments\LSTM\力矩数据';
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
    angle_data_filename = fullfile(data_dir, subdir_name, 'expext_angle_array.mat');
    angle_data_file = load(angle_data_filename);
    
    angle_data = angle_data_file.expext_angle_array(2:7,:);
    m = size(angle_data,2);% 获取数据的列数，即数据点个数
    t = (0:m-1)*0.001; % 根据数据点个数生成时间序列，时间间隔为0.001秒
    
    % 3.求解速度序列
    time_interval = 0.001; % 时间间隔为1毫秒
    velocity = diff(angle_data,1,2) ./ time_interval; % 对数据进行沿行差分计算速度
    velocity = [zeros(6,1) velocity];
    
    %速度矩阵平滑处理，防止数据的突变
%     [p,q] = size(velocity);
%     vel = zeros(p,q);
%     for i = 1 : p
%         row_data= velocity(i,:);% 取出第i行数据
%         row_data_smooth = smooth(row_data,5,'loess');  % 平滑处理
%         vel(i,:) = row_data_smooth;
%     end
    vel = kalman_filter(velocity);
    
    input = [angle_data ; vel];
    save(fullfile([data_dir '\' subdir_name],'velocity.mat'),'vel'); 
    save(fullfile([data_dir '\' subdir_name],'input.mat'),'input'); 
end