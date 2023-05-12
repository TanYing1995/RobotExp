function chrom_new = Acr(chrom, acr, N, N_chrom)
% 交叉处理
for i = 1 : N
    acr_rand = rand;%生成随机概率决定是否交叉
    if acr_rand < acr
        acr_chrom = floor((N-1)*rand+1); %要交叉的染色体编号
        acr_node = floor((N_chrom-1)*rand+1);%要交叉的节点
        %开始交叉
        temp = chrom(i,acr_node);
        chrom(i,acr_node) = chrom(acr_chrom,acr_node);
        chrom(acr_chrom,acr_node) = temp;
    end
end
chrom_new = chrom; % 保存交叉结果
end

