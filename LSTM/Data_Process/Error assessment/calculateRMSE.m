function rmse = calculateRMSE(data, results)
    mse = calculateMSE(data, results);
    rmse = sqrt(mse);
end
