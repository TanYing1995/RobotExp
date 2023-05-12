function fitness_ave = CalAveFitness(fitness)
% 返回这一代的平均适应度
[N,c] = size(fitness);
fitness_ave = sum(fitness)/N;
end

