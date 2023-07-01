function mse = calculateMSE(data, results)
    diff = data - results;
    squaredDiff = diff.^2;
    mse = mean(squaredDiff);
end
