% 加载数据
% data = load('joint_torque_data.mat'); % 假设数据文件为 joint_torque_data.mat
torque = torque_array(2,:); % 关节力矩数据
torque1 = torque_array(3,:)
% 设置小波滤波参数
wavelet = 'db4'; % 小波基函数，这里选择 Daubechies 4 小波
level = 6; % 分解的尺度级数


% 对关节力矩数据进行小波分解和重构滤波
[c, l] = wavedec(torque, level, wavelet); % 小波分解
% c(1:l(1)) = 0; % 去除低频成分（趋势）
c(l(1)+1:end) = 0; % 去除高频成分（噪声）

% % 对每个细节系数应用阈值滤波
% threshold = 12;
% c(abs(c) < threshold) = 0;  % 将小于阈值的近似分量和细节分量置零

filtered_torque = waverec(c, l, wavelet); % 小波重构

[c2, l2] = wavedec(torque1, level, wavelet); % 小波分解
% c(1:l2(1)) = 0; % 去除低频成分（趋势）
c2(l2(1)+1:end) = 0; % 去除高频成分（噪声）

% % 对每个细节系数应用阈值滤波
% threshold = 12;
% c(abs(c) < threshold) = 0;  % 将小于阈值的近似分量和细节分量置零

filtered_torque2 = waverec(c2, l2, wavelet); % 小波重构

% 绘制原始数据和滤波后的曲线
t = 1:length(torque); % 时间轴
figure (2);
subplot(2,1,1);
plot(t, torque);
hold on
plot(t, filtered_torque,'r');
title('原始关节力矩数据');
xlabel('时间');
ylabel('力矩');
subplot(2,1,2);
plot(t, filtered_torque);
title('滤波后的关节力矩数据');
xlabel('时间');
ylabel('力矩');

figure(1);
% subplot(level+2, 1, 1);
% plot(torque);
% title('原始信号');

subplot(level+1, 1, 1);
plot(c(1:l(1)));
title('近似分量','FontSize', 14);

for i = 1:level
    start_index = sum(l(1:i)) + 1;
    end_index = sum(l(1:i+1));

    subplot(level+1, 1, i+1);
    plot(c(start_index:end_index));
    title(['第', num2str(level-i+1), '层细节分量'], 'FontSize', 14);
end

% xlabel('时间');
xlabel('系数长度', 'FontSize', 14);

for i = 1:level
    start_index = sum(l(1:i-1)) + 1;
    end_index = sum(l(1:i));
    
    detail_coefficients = c(start_index:end_index);
    fprintf('第%d层细节分量：%s\n', i, mat2str(detail_coefficients));
end

approximation_coefficients = c(end_index+1:end);
fprintf('近似分量：%s\n', mat2str(approximation_coefficients));

figure (3);
subplot(2,1,1);
plot(t, filtered_torque);
title('关节1 滤波关节力矩');
% xlabel('时间/ms');
ylabel('力矩/Nm');

subplot(2,1,2);
plot(t, filtered_torque2);
title('关节2 滤波关节力矩');

ylabel('力矩/Nm');

xlabel('时间/ms');
