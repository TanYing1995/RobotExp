% 获取所有子目录的路径 
subdirs = dir('/path/to/parent_dir/*', '-d');   % 替换为父目录所在路径

% 遍历所有子目录
for i = 1:length(subdirs)
    subdir_name = subdirs(i).name;
    if strcmp(subdir_name, '.') || strcmp(subdir_name, '..')
        continue;   % 跳过当前目录和上一级目录
    end
    
    subdir = ['/path/to/parent_dir/', subdir_name];  % 替换为子目录的路径
    file1_name = [subdir, '/file1.mat'];
    file2_name = [subdir, '/file2.mat'];
    
    if ~exist(file1_name, 'file') || ~exist(file2_name, 'file')
        warning(['File does not exist in directory: ', subdir]);
        continue;   % 跳过没有 file1.mat 或 file2.mat 文件的子目录
    end
    
    % 读取 file1 和 file2 文件中的数据
    file1_data = load(file1_name);
    file2_data = load(file2_name);
    
    % 将 file1 和 file2 文件中的数据按行连接作为一个输入，组成一个样本
    sample_input = [file1_data.data; file2_data. data]; 

    % 将样本添加到训练集中 
    train_input = [train_input, sample_input];
    ...
end
