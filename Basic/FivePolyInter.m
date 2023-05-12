function [a0,a1,a2,a3,a4,a5] = FivePolyInter(q0,q1,v0,v1,acc0,acc1,t0,t1)
%五次多项式插值 -- 关节空间
% 两点之间配置关节【起点，终点，初始速度，末端速度，初始时间，结束时间】的五次多项式插值
% 单位：rad  rad/s s
dq = q1-q0;%初始角度差
dt = t1-t0;%时间差
% 返回五次多项式插值函数的各项系数
a0 = q0;
a1 = v0;
a2 = acc0/2;
a3 = (20*dq-(8*v1+12*v0)*dt-(3*acc0-acc1)*dt^2)/(2*dt^3);
a4 = (-30*dq+(14*v1+16*v0)*dt+(3*acc0-2*acc1)*dt^2)/(2*dt^4);
a5 = (12*dq-6*(v1+v0)*dt-(acc0-acc1)*dt^2)/(2*dt^5);

%%------------------------------------%%
%以下为画图观察部分
t= t0:0.01:t1;
q = a0+a1*t+a2*t.^2+a3*t.^3+a4*t.^4+a5*t.^5;%角度
v = a1+2*a2*t+3*a3*t.^2+4*a4*t.^3+5*a5*t.^4;%角速度
a = 2*a2+6*a3*t+12*a4*t.^2+20*a5*t.^3;%角速度
subplot(3,1,1),plot(t,q,'r'),ylabel('关节位移');grid on;%subplot(3,1,1),plot(t,q,'r'),xlabel('t'),ylabel('关节位移')
% title('关节位移曲线');
subplot(3,1,2),plot(t,v,'b'),ylabel('关节角速度');grid on;
% title('关节速度曲线');
subplot(3,1,3),plot(t,a,'g'),ylabel('关节角加速度');grid on;
% title('关节加速度曲线');
end

