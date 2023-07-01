function stabilityIndex = calculateStabilityIndex(filteredData)
    diff2 = diff(diff(filteredData));
    stabilityIndex = mean(abs(diff2));
end
