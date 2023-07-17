%% 根据位移曲线构造速度矩阵和 LSTM输入矩阵
%%
% 数据所在的父目录
% data_dir = 'I:\Experiments\LSTM\力矩数据-new';
% data_dir = 'C:\Users\admin\Desktop\轨迹\test';
data_dir = 'I:\Experiments\LSTM\Data';
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
    
    % 读取输入和输出数据文件
    data_filename = fullfile(data_dir, subdir_name, 'accleration.mat');
    delete(data_filename);
end