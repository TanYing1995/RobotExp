clc;
clear;
% 用于多组逆解的遗传算法优化 - GA
% 目前选择六个点的机器人动作进行仿真
torque = [2500 2600 2490 1800 1500 1300];%各关节的力矩系数
p1 = {};
p2 = {};
p3 = {};
p4 = {};
p5 = {};
p6 = {};
%采用整数编码方式 {a0,a1,a2,a3,a4,a5}表示各个情况下
num = [size(p1) size(p2) size(p3) size(p4) size(p5) size(p6)];%各个关键点逆解的数目
N = 100; % 种群内个体数目
N_chrom = 6; 
iter = 1000; %迭代次数 
mut = 0.2; %突变概率
acr = 0.2; %交叉概率
best = 1;
chrom_range = [1 1 1 1 1 1;size(p1) size(p2) size(p3) size(p4) size(p5) size(p6)];
chrom = zeros(N,N_chrom); %存放染色体矩阵
fitness = zeros(N,1); %存放染色体的适应度
fitness_ave = zeros(1,iter);%存放每一代的平均适应度
fitness_best = zeros(1,iter);%存放每一代的最优适应度
chrom_best = zeros(1,N_chrom+1);%存放当前代的最优染色体与适应度

%%初始化，这部分只用于生成第一代个体，并计算其适应度函数
chrom = Initialize(N,N_chrom,chrom_range); %初始化染色体 NxN_chrom
fitness = CalFit(chrom, N, N_chrom,torque,P);%计算适应度 Nx1
chrome_best = FindBest(chrom,fitness,N_chrome);%寻找最优染色体 
fitness_best(1) = chrome_best(end);%将当前最优解存入矩阵中
fitness_ave(1) = CalAveFitness(fitness);

for t = 2:iter
    chrom = Mut(chrom, mut, N, N_chrom, chrom_range, t, iter);%变异
    chrom = Acr(chrom, acr, N, N_chrom);%交叉
    fitness = CalFit(chrom, N, N_chrom,torque,P);%计算适应度
    chrom_best_temp = FindBest(chrom, fitness, N_chrom); %寻找最优染色体
    if chrom_best_temp(end) > chrom_best(end) %替换掉当前存储的最优
        chrom_best = chrom_best_temp;
    end
    % 替换掉最劣
    [chrom, fitness] = ReplaceWorse(chrom, chrom_best, fitness);
    fitness_best(t) = chrome_best(end);%将当前最优解存入矩阵中
    fitness_ave(t) = CalAveFitness(fitness);%将当前平均适应度存入矩阵当中
end