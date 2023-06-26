A = rand(4, 2);
B = rand(3, 2);

% 转置A和B
A_transpose = A';
B_transpose = B';

% 将转置后的矩阵存储在cell数组中
C{1} = A_transpose;
C{2} = B_transpose;

% 按列拼接转置后的矩阵
D_transpose = cat(2, C{:});

% 将结果转置回来
D = D_transpose';

% 验证结果
disp(D);
