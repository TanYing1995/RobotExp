function fitness = CalFit(chrom, N, N_chrom,torque,P)
% 返回当前种群的适应度
fitness = zeros(N,1);
% 计算适应度
for i = 1:N
    %计算每一组个体的适应度
    puge = chrom(i,:);%获取当前解,行向量
    t = 0;
    for j = 2 : N_chrom
        pre = P{j-1};%获取每个关键点对应的逆解元胞数组
        cur = P{j};
        prejoints = pre{puge(i,j-1)};%当前染色体中对应基因的逆解序号
        curjoints = cur{puge(i,j)};
        for m = 1:6
            t = t-torque(1,m)*abs(curjoints(1,m)-prejoints(1,m));
        end
    end
    fitness(i) = t;
end
end

