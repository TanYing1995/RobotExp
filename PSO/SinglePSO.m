% 粒子群优化算法
% 主函数程序
clc;
clear all;
m = 150;%初始化150个粒子
pgf(1) = 20;%最大适应度pgx
h = 1;
wmax = 0.9;
wmin = 0.3;
c1 = 1.5;
c2 = 1.5;
Nmax = 200;%最大迭代次数
theta_1 = pi/4;
theta_0 = 0;
kk = 1;
pnf(1) = pgf(1);
for i = 1 : m
    x(i) = rand*(10-0.1)+0.1; %初始粒子
    v(i) = -2+4*rand;
    
    px(i) = x(i); % 每个粒子最优位置
    pf(i) = px(i); % 每个粒子最优位置的适应度，也就是时间
    
    if pgf(h) > pf(i)
        a0 = theta_0; %初始位置
        a1 = 0;
        a2 = 0;
        a3 = 10*(theta_1-theta_0)/power(x(i),3);%初始速度和加速度均为0
        a4 = -15*(theta_1-theta_0)/power(x(i),4);
        a5 = 6*(theta_1-theta_0)/power(x(i),5);
        F = 1;
        for t = 0 : 0.01 :x(i)
            %速度限制
            if(abs(5*a5*t^4 + 4*a4*t^3 + 3*a3*t^2 + 2*a2*t + a1)) > 7.8
                F = 0;
            end
            %加速度限制
            if(abs(20*a5*t^3 + 12*a4*t^2 + 6*a3*t + 2*a2)) > 13.3
                F = 0;
            end
        end
       if F == 1
            h = h+1;
            pgx = px(i); %全局最优解
            pgf(h) = pf(i); %全局最优适应度
       end
    end
    kk = kk + 1;
    pnf(kk) = pgf(h);
end

% 更新各粒子的速度，位置
for k = 2 : Nmax
    w = wmax-(wmax-wmin)*k/Nmax;
    % 对种群中的粒子进行迭代
    for i = 1 : m
        v(i) = w*v(i) + c1*rand*(px(i)-x(i)) + c2*rand*(pgx-x(i));
        
        %速度是否超出限制
        if v(i) < -2
            v(i) = -2;
            x(i) = x(i) - abs(v(i));
        elseif v(i) > 2
            v(i) = 2;
            x(i) = x(i) - abs(v(i));
        else
             x(i) = x(i) + v(i);
        end
        
        %时间是否超限
        if x(i) < 0.1
            x(i) = 0.1;
        end
        if x(i) > 10
            x(i) = 10;
        end
        
        f = x(i);
        if pf(i) > f % 如果第i个粒子的最优适应度 出现更优的结果
            % 通过 x(i)的值计算五次多项式的 a0 a1 a2 a3 a4 a5
            a0 = theta_0; %初始位置
            a1 = 0;
            a2 = 0;
            a3 = 10*(theta_1-theta_0)/power(x(i),3);%初始速度和加速度均为0
            a4 = -15*(theta_1-theta_0)/power(x(i),4);
            a5 = 6*(theta_1-theta_0)/power(x(i),5);
            
            F = 1;
            for t = 0 : 0.01 :x(i)
                %速度限制
                if(abs(5*a5*t^4 + 4*a4*t^3 + 3*a3*t^2 + 2*a2*t + a1)) > 7.8
                    F = 0;
                end
                %加速度限制
                if(abs(20*a5*t^3 + 12*a4*t^2 + 6*a3*t + 2*a2)) > 13.3
                    F = 0;
                end
            end
             if F == 1
                px(i) = x(i); %更新第i个粒子的最优位置和最优适应度
                pf(i) = f;
                if pgf(h) > pf(i)
                    h = h+1;
                    pgf(h) = pf(i);%群体最优适应度
                    pgx = px(i); %群体最优时间
                end
             end
        end
%         if pgf(h) > pf(i)
%             h = h+1;
%             pgf(h) = pf(i);%群体最优适应度
%             pgx = px(i); %群体最优时间
%         end
    end
    kk = kk + 1;
    pnf(kk) = pgf(h); 
end

%画图
figure(1);

plot(pgf);
title('粒子群算法迭代收敛图');
xlabel('迭代次数');
ylabel('最优个体适应度');

