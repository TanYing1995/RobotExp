function a = draw(data)
% 根据输入进来的1x12维向量画图
%   此处提供详细说明

b = bar(data);
b.FaceColor = 'flat';
% colors = {[1 0 0], [0 1 0], [0 0 1], [0 1 1], [1 0 1], [1 1 0], [0 0 0], [0.5 0.5 0.5], [0.8 0.2 0.2], [0.2 0.8 0.2], [0.2 0.2 0.8], [1 0.6 0.2]};

colors = {[0 0 0],[0.5 0.5 0.5], [0.8 0.2 0.2], [0.2 0.8 0.2], [0.2 0.2 0.8], [1 0.6 0.2]};
b.CData(1,:) = colors{1};
b.CData(2,:) = colors{2};
b.CData(3,:) = colors{3};
b.CData(4,:) = colors{4};
b.CData(5,:) = colors{5};
b.CData(6,:) = colors{6};
b.CData(7,:) = colors{1};
b.CData(8,:) = colors{2};
b.CData(9,:) = colors{3};
b.CData(10,:) = colors{4};
b.CData(11,:) = colors{5};
b.CData(12,:) = colors{6};

% 设置x轴标签和标题
title('特征重要性评估');
xlabel('Feature Index');
ylabel('Importance');

end