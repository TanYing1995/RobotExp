function chrom_new = Initialize(N,N_chrom,chrom_range)
%   返回初始化的随机种群
%   
chrom_new = rand(N,N_chrom);
for i = 1:N_chrom
    chrom_new(:,i) = floor(chrom_new(:,i)*(chrom_range(2,i)-chrom_range(1,i)))+chrom_range(1,i);
end
end

