% 假设你已经有了一个大小为12的数据数组data
data = rand(1, 12);

% 定义一个颜色单元数组colors，这里使用了12种不同的颜色
colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k', [0.5 0.5 0.5], [0.8 0.2 0.2], [0.2 0.8 0.2], [0.2 0.2 0.8], [1 0.6 0.2]};

% 绘制条形图
figure;
h = bar(data);

% 循环遍历每个条形柱，并设置不同的颜色
for i = 1:numel(h)
    set(h(i), 'FaceColor', colors{i});
end

% 设置x轴标签和标题
xlabel('X Axis');
ylabel('Y Axis');
title('Bar Chart with Different Colors for Each Bar');
