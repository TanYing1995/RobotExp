% 准备数据
X = rand(100, 12);
y = rand(100, 1);

% 划分训练集和测试集
ratio = 0.7;
offset = floor(size(X, 1) * ratio);
X_train = X(1:offset, :);
y_train = y(1:offset);
X_test = X(offset+1:end, :);
y_test = y(offset+1:end);

% 训练模型并计算 OOB 错误
model = TreeBagger(50, X_train, y_train, 'Method', 'regression', 'Surrogate', 'on', 'OOBPrediction', 'on');
oob_error = oobError(model);

% 对于每个特征，随机地将该列所有值打乱，并计算新的 OOB 错误
num_features = size(X_train, 2);
importances = zeros(num_features, 1);
for i = 1:num_features
    X_permuted = X_train;
    X_permuted(:, i) = X_permuted(randperm(size(X_permuted, 1)), i);
    model_permuted = TreeBagger(50, X_permuted, y_train, 'Method', 'regression', 'Surrogate', 'on', 'OOBPrediction', 'on');
    oob_error_permuted = oobError(model_permuted);
    importances(i) = oob_error_permuted - oob_error;
end

% 将结果可视化
[sorted_importances, index] = sort(importances, 'descend');
figure;
bar(sorted_importances);
title('Feature Importance');
xlabel('Features');
ylabel('Importance');
xticklabels(index);
xtickangle(45);


