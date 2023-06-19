function [xTrain , tTrain] = Normalize(input_data,output_data,input_max,input_min,output_max,output_min)
% 数据归一化
%   

    xTrain = input_data;
    tTrain = output_data; 
    
    % 训练输入数据归一化 [-1,1]
    [nrows, ~] = size(xTrain);
    for k=1:nrows
        row = xTrain(k,:);
        max_val = input_max(k,1);
        min_val = input_min(k,1);
        if min_val == max_val
            xTrain(k,:) = 0;
        else
            xTrain(k,:) = ((row - min_val) / (max_val - min_val))*2-1;
        end
    end
    
    % 训练输出数据归一化 [-1,1]
     for k=1:6
        row = tTrain(k,:);
        max_val = output_max(k,1);
        min_val = output_min(k,1);
        if min_val == max_val
            tTrain(k,:) = 0;
        else
            tTrain(k,:) = ((row - min_val) / (max_val - min_val))*2-1;
        end
     end
end