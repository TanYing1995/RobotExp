function [T,Ta,Tv,Td] = TrapeVelPlan(p0,p1,v0,v1,t0,vmax,aa,ad)
% 梯形速度曲线规划
% 一般情况下，用户给定起始速度、终止速度、加速度、减速度、最大速度以及起始时刻和终止时刻的位移参数，
% 需要计算出加速段、匀速段以及减速段对应的时间Ta、Tv、Td，然后再根据位移、速度以及加速度公式计算轨迹
% 得到整个规划阶段的用时为 T = Ta+Tv+Td
%% 需要注意减速阶段ad的符号,输入为正值时需要 转换成负值 ，
if(ad > 0) 
    ad = -ad;
end
h = p1-p0;%位移差值
% 可到达得最大速度
vf = sqrt((2.0*aa*ad*h - aa*v1^2 + ad*v0^2) / (ad - aa));

% 确定匀速阶段 的速度 vv
if(vf < vmax)
    vv = vf;
else
    vv = vmax;
end

% 计算加速阶段的时间和位移
Ta = (vv - v0)/aa;
La = v0*Ta + (1.0/2.0)*aa*Ta^2;

% 计算匀速阶段的时间和位移
Tv = (h - (vv^2 - v0^2)/(2.0*aa) - (v1^2 - vv^2)/(2.0*ad)) / vv;
Lv = vv*Tv;

% 计算减速阶段的时间和位移
Td = (v1 - vv) / ad;
Ld = vv*Td + (1.0/2.0)*ad*Td^2;

%梯形速度规划总用时
T = Ta+Tv+Td;
k = 1;
ts = 0.001;
% 计算轨迹的离散点
for t = t0: ts: (t0+Ta+Tv+Td)
    time(k) = t;
    t = t - t0;
    if (t >= 0 && t < Ta)
        p(k) = p0 + v0*t + (1.0/2.0)*aa*t^2;
        pd(k) = v0 + aa*t;
        pdd(k) = aa;
    elseif (t >= Ta && t < Ta+Tv)
        p(k) = p0 + La + vv*(t - Ta);
        pd(k) = vv;
        pdd(k) = 0;
    elseif (t >= Ta+Tv && t <= Ta+Tv+Td)
        p(k) = p0 + La + Lv + vv*(t - Ta - Tv) + (1.0/2.0)*ad*power(t - Ta - Tv, 2);
        pd(k) = vv + ad*(t - Ta - Tv);
        pdd(k) = ad;
    end
    k = k + 1;
end
%画图
figure(1)
subplot(3, 1, 1)
plot(time, p, 'r', 'LineWidth', 1.5)
ylabel('position')
grid on
subplot(3, 1, 2)
plot(time, pd, 'b', 'LineWidth', 1.5)
ylabel('velocity')
grid on
subplot(3, 1, 3)
plot(time, pdd, 'g', 'LineWidth', 1.5)
ylabel('acceleration')
grid on
end

