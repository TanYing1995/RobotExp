% 定义输入 a 和输出 c 的维度
input_dim = 12;
output_dim = 6;

% 初始化训练集的输入和输出
train_input = [];
train_output = [];

% 获取所有子目录的路径
subdirs = dir('/path/to/parent_dir/*', '-d');   % 替换为父目录所在路径

% 遍历所有子目录
for i = 1:length(subdirs)
    subdir_name = subdirs(i).name;
    if strcmp(subdir_name, '.') || strcmp(subdir_name, '..')
        continue;   % 跳过当前目录和上一级目录
    end
    
    subdir = ['/path/to/parent_dir/', subdir_name];  % 替换为子目录的路径
    a_file = [subdir, '/a.mat'];
    c_file = [subdir, '/c.mat'];
    
    if ~exist(a_file, 'file') || ~exist(c_file, 'file')
        warning(['File does not exist in directory: ', subdir]);
        continue;   % 跳过没有 a.mat 或 c.mat 文件的子目录
    end
    
    % 读取 a 和 c 文件中的数据
    a_data = load(a_file);
    c_data = load(c_file);
    
    % 按行连接 a 和 c 数据，组成一个样本
    sample = [a_data.a; c_data.c];
    
    % 将样本添加到训练集中
    train_input = [train_input, sample(1:input_dim, :)];   % 取前 input_dim 行作为输入
    train_output = [train_output, sample(input_dim+1:end, :)];   % 取后 output_dim 行作为输出
end
