% 准备数据
X = rand(300, 12);
y = rand(300, 1);

% 划分训练集和测试集
ratio = 0.7;
offset = floor(size(X, 1) * ratio);
X_train = X(1:offset, :);
y_train = y(1:offset);
X_test = X(offset+1:end, :);
y_test = y(offset+1:end);

% 定义模型
% model = fitrensemble(X_train, y_train);
% model = fitensemble(X_train, y_train);
model = TreeBagger(100, X_train, y_train,'OOBPredictorImportance', 'on');

% 特征重要性评估

importances= model.OOBPermutedVarDeltaError;

[sorted_importances, index] = sort(importances, 'descend');
fprintf('Feature Importance:\n');
for i = 1:size(X, 2)
    fprintf('Feature %d: %.4f\n', index(i), sorted_importances(i));
end

% 根据特征重要性绘制条形图
figure;
bar(importances);
xlabel('Feature index');
ylabel('Importance score');
title('Feature importance');
