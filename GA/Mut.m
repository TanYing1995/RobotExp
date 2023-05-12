function chrom_new = Mut(chrom, mut, N, N_chrom, chrom_range, t, iter)
% 用于对每代的N个染色体进行变异处理
for i = 1 : N
    for j = 1 : N_chrom
        mut_rand = rand; %随机生成一个数，代表自然里的基因突变，决定是否产生突变
        if mut_rand <= mut %小于阈值，产生突变
            mut_pm = rand;%决定增加还是减少
            if mut_pm <= 0.5
                chrom(i,j) = chrom(i,j) + floor((chrom_range(2,j)-chrom(i,j)+1)*rand(1,1));
            else
                chrom(i,j) = chrom(i,j) - floor(chrom(i,j)*rand(1,1));
            end
        end
    end
end
chrom_new = chrom; %将变异后的结果放到新矩阵中
end

