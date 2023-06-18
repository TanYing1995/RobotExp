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

% 定义模型
model = TreeBagger(50, X_train, y_train,'OOBPredictorImportance', 'on', 'Method', 'regression', 'Surrogate', 'on');
% 
% 特征重要性评估
importances = oobPermutedPredictorImportance(model);
[sorted_importances, index] = sort(importances, 'descend');
fprintf('Feature Importance:\n');
for i = 1:size(X, 2)
    fprintf('Feature %d: %.4f\n', index(i), sorted_importances(i));
end

% 画出每个特征的重要性得分的 bar 图
figure;
bar(sorted_importances);
title('Feature Importance');
xlabel('Features');
ylabel('Importance');

xticklabels(index);
xtickangle(45);

