function mae = calculateMAE(data, results)
    absDiff = abs(data - results);
    mae = mean(absDiff);
end
