
data_dir = 'I:\Experiments\LSTM\力矩数据\12';

input_test = load(fullfile(data_dir, 'input.mat')).input;
output_test = load(fullfile(data_dir, 'torque.mat')).x;

% 将数据分成训练数据和测试数据
xTrain = input_test;
tTrain = output_test;

tPred = predict(net, xTrain);
tPred = double(tPred); % 将LSTM网络的输出cell数组转换为矩阵

rmse = [];
for i = 1:6
    rmse(i) = sqrt(mean((tTrain(i,:)-tPred(i,:)).^2));
end

% i = 6;
% figure(1);
% plot(tTrain(i,:),'b');
% % plot(tPred(1,:),'r');
% xlabel('时间');
% ylabel('力矩');
% % hold on;
% plot(tPred(i,:),'r');
% legend('实际力矩', '预测力矩');

for i = 1 : 3
   figure(i); 
   plot(tTrain(i,:),'b');
   xlabel('时间');
   ylabel('力矩');
   hold on;
   plot(tPred(i,:),'r');
   legend('实际力矩', '预测力矩');
   title(['第', num2str(i), '关节力矩']);
end