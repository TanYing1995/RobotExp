function [chrom_new, fitness_new] = ReplaceWorse(chrom, chrom_best, fitness)

max_num = max(fitness);
min_num = min(fitness);

limit = (max_num-min_num)*0.2+min_num;

replace_corr = fitness<limit;% 找出小于limit的位置数组

replace_num = sum(replace_corr); % 统计需要替换的染色体个数

% 将比较差的位置替换为 最优表现染色体
chrom(replace_corr, :) = ones(replace_num, 1)*chrom_best(1:end-1);
fitness(replace_corr) = ones(replace_num, 1)*chrom_best(end);

chrom_new = chrom;
fitness_new = fitness;
end

