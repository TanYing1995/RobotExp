% 生成示例数据
X = randn(1000, 12);  % 将X的行列换位
y = sum(X(:, 1:6), 2) + randn(1000, 1)*0.1;  % 将y改为列向量

% 随机森林回归模型训练
Mdl = TreeBagger(50, X, y, 'Method', 'regression','OOBPredictorImportance','on');

% 计算特征重要性

imp = Mdl.OOBPermutedPredictorDeltaError;

% 可视化特征重要性
figure;
bar(imp);
title('Feature Importance');
xlabel('Feature Index');
ylabel('Importance'); 