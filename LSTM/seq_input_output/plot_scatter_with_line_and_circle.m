function plot_scatter_with_line_and_circle(n, x_val,bt)
    
% plot_scatter_with_line_and_circle(size(mae_list,2),mae_list,"平均绝对误差 MAE")
% plot_scatter_with_line_and_circle(size(rsme_list,2),rsme_list,"均方根误差 RSME") 
% plot_scatter_with_line_and_circle(size(cnt,2),cnt,"较大偏离值点比率")

% 生成x轴和y轴数据
    x = 1:length(x_val);
    y = x_val;
    
    % 创建散点图
    scatter(x, y, 'filled');
    hold on;
    
    % 添加竖线和圆圈
    for i = 1:length(x_val)
        % 绘制竖线
        x_line = [i, i];
        y_line = [x_val(i), 0];
        plot(x_line, y_line, 'r--');
        
        % 绘制圆圈
        y_circle = x_val(i);
        radius = 0.1;
        theta = linspace(0, 2*pi, 100);
%         x_circle_points = i + radius*cos(theta);
%         y_circle_points = y_circle + radius*sin(theta);
%         plot(x_circle_points, y_circle_points, 'b');
    end
    
    % 设置图形属性
    xlabel('样本');
%     ylabel('y轴');
    title(bt);
%     grid on;
    
    hold off;
end
