function [T1, T2, T3 ,T4, T5 ,T6 ,T7 ,T8] = Ikine(TcpPos)
% 返回具有合理逆解的元胞数组 res
%[T1, T2, T3 ,T4, T5 ,T6 ,T7 ,T8]
% 机器人逆解函数 ：输入机器人末端6x1位姿向量[x,y,z,R,P,Y]
% 1. 先将位姿向量转换为位姿矩阵
px = TcpPos(1);py = TcpPos(2);pz = TcpPos(3);
%% Z-Y-X欧拉角旋转 
% 过程描述（动轴旋转），先绕本坐标系Z轴旋转gama角，再绕本坐标系Y轴旋转beta角，再绕X轴旋转alpha角
% Z gama(Y)  Y beta(P)  X  alpha(R)  
alpha = TcpPos(4);beta = TcpPos(5);gama = TcpPos(6);%角度值
sa = sind(alpha);ca = cosd(alpha);
sb = sind(beta);cb = cosd(beta);
sy = sind(gama);cy = cosd(gama);
Rot = [cy*cb cy*sb*sa-sy*ca cy*sb*ca+sa*sy;
       sy*cb sy*sb*sa+ca*cy sy*sb*ca-cy*sa;
       -sb         cb*sa          cb*ca];
%% 2. 通过位姿矩阵求解机器人关节值

a1 = 40;   a2 = 275;  a3 = 25; d4 = 280; d6 = 73;

r11 = Rot(1,1);r12 = Rot(1,2);r13 = Rot(1,3);
r21 = Rot(2,1);r22 = Rot(2,2);r23 = Rot(2,3);
r31 = Rot(3,1);r32 = Rot(3,2);r33 = Rot(3,3);

%% 求解 关节角1 A.(弧度) [t1,t2,t3,t4,t5,t6]
 t11 = atan2(d6*r23-py,d6*r13-px);
 
 %后面的计算部分共享一个 t11 角度
r11_ = cos(t11)*r11+sin(t11)*r21;r12_ = cos(t11)*r12+sin(t11)*r22;r13_ = cos(t11)*r13+sin(t11)*r23;
r21_ = -r11*sin(t11)+r21*cos(t11);r22_ = -r12*sin(t11)+r22*cos(t11); r23_ = -r13*sin(t11)+r23*cos(t11);
r31_ = r31;r32_ = r32;r33_ = r33;
 
 m1 = cos(t11)*px+sin(t11)*py -d6*r13_-a1;
 n = pz - d6*r33; 
 pp1 = power(m1,2)+power(n,2);
 k1 = (pp1+power(a2,2)-power(a3,2)-power(d4,2))/(2*a2);
 
% 求解关节角 2 和 3 
% [t1,t2,t3, , , ]
%t21 = phaseRevise(atan2(k1,sqrt(pp1-power(k1,2)))-atan2(m1,n));
t21 = atan2(k1,sqrt(pp1-power(k1,2)))-atan2(m1,n);
p21 = m1-a2*cos(t21);
q21 = n-a2*sin(t21);
sum23_1 = atan2(a3*q21+d4*p21,a3*p21-d4*q21);
t31 = sum23_1-t21;

c23 = cos(sum23_1);  s23 = sin(sum23_1);
c4s5 = c23*r13_+s23*r33_;
s4s5 = -r23_;

% 求解当前[t1,t2,t3]组合下的两组 [t4,t5,t6]解
% 求解关节角 4
t41 = atan2(s4s5,c4s5);

s51 = cos(t41)*c4s5+sin(t41)*s4s5;
c51 = s23*r13_-c23*r33_;

% 求解关节角 5
t52 = atan2(s51,c51);

% 求解关节角 6
s61 = -sin(t41)*(c23*r11_+s23*r31_)-cos(t41)*r21_;
c61 = -sin(t41)*(c23*r12_+s23*r32_)-cos(t41)*r22_;

t61 = atan2(s61,c61);

%T1 = [t11 t21 t31 t41 t51 t61];
% 以下两个解均正向验证正确！！！
T1 = [rad2deg(t11) rad2deg(t21)-90 rad2deg(t31) rad2deg(t41) rad2deg(t52) rad2deg(t61)-90];
T2 = [rad2deg(t11) rad2deg(t21)-90 rad2deg(t31) rad2deg(t41+pi) rad2deg(-t52) rad2deg(t61+pi)-90];

%%
% 第二批解
% 求解关节角 2 和 3 
% [t1,t2,t3, , , ]
%t22 = phaseRevise(atan2(k1,-sqrt(pp1-power(k1,2)))-atan2(m1,n));
t22 = atan2(k1,-sqrt(pp1-power(k1,2)))-atan2(m1,n);
p22 = m1-a2*cos(t22);
q22 = n-a2*sin(t22);
sum23_2 = atan2(a3*q22+d4*p22,a3*p22-d4*q22);
t32 = sum23_2-t22;
 
c23 = cos(sum23_2);  s23 = sin(sum23_2);
c4s5 = c23*r13_+s23*r33_;
s4s5 = -r23_;

% 求解当前[t1,t2,t3]组合下的两组 [t4,t5,t6]解
% 求解关节角 4
t42 = atan2(s4s5,c4s5);

s52 = cos(t42)*c4s5+sin(t42)*s4s5;
c52 = s23*r13_-c23*r33_;

% 求解关节角 5
t52 = atan2(s52,c52);

% 求解关节角 6
s62 = -sin(t42)*(c23*r11_+s23*r31_)-cos(t42)*r21_;
c62 = -sin(t42)*(c23*r12_+s23*r32_)-cos(t42)*r22_;

t62 = atan2(s62,c62);

%T1 = [t11 t22 t32 t42 t52 t62];
% 以下两个解均正向验证正确！！！
T3 = [rad2deg(t11) rad2deg(t22)-90 rad2deg(t32) rad2deg(t42) rad2deg(t52) rad2deg(t62)-90];
T4 = [rad2deg(t11) rad2deg(t22)-90 rad2deg(t32) rad2deg(t42+pi) rad2deg(-t52) rad2deg(t62+pi)-90];

%% 求解 关节角1 B. %T1 = [t11 t21 t31 t41 t51 t61];
 t12 = atan2(-d6*r23+py,-d6*r13+px);
 
%后面的计算部分共享一个 t12 角度
r11_ = cos(t12)*r11+sin(t12)*r21;r12_ = cos(t12)*r12+sin(t12)*r22;r13_ = cos(t12)*r13+sin(t12)*r23;
r21_ = -r11*sin(t12)+r21*cos(t12);r22_ = -r12*sin(t12)+r22*cos(t12); r23_ = -r13*sin(t12)+r23*cos(t12);
r31_ = r31;r32_ = r32;r33_ = r33;
 
m2 = cos(t12)*px+sin(t12)*py -d6*r13_-a1;
pp2 = power(m2,2)+power(n,2);
k2 = (pp2+power(a2,2)-power(a3,2)-power(d4,2))/(2*a2);

%T1 = [t11 t21 t31 ... ... ...];
%%
% 第三批解
t23 = atan2(k2,sqrt(pp2-power(k2,2)))-atan2(m2,n);
p23 = m2-a2*cos(t23);
q23 = n-a2*sin(t23);
sum23_3 = atan2(a3*q23+d4*p23,a3*p23-d4*q23);
t33 = sum23_3-t23;

c23 = cos(sum23_3);  s23 = sin(sum23_3);
c4s5 = c23*r13_+s23*r33_;
s4s5 = -r23_;

% 求解当前[t1,t2,t3]组合下的两组 [t4,t5,t6]解
% 求解关节角 4
t43 = atan2(s4s5,c4s5);

s53 = cos(t43)*c4s5+sin(t43)*s4s5;
c53 = s23*r13_-c23*r33_;

% 求解关节角 5
t53 = atan2(s53,c53);

% 求解关节角 6
s63 = -sin(t43)*(c23*r11_+s23*r31_)-cos(t43)*r21_;
c63 = -sin(t43)*(c23*r12_+s23*r32_)-cos(t43)*r22_;

t63 = atan2(s63,c63);

% 以下两个解均正向验证正确！！！
T5 = [rad2deg(t12) rad2deg(t23)-90 rad2deg(t33) rad2deg(t43) rad2deg(t53) rad2deg(t63)-90];
T6 = [rad2deg(t12) rad2deg(t23)-90 rad2deg(t33) rad2deg(t43+pi) rad2deg(-t53) rad2deg(t63+pi)-90];

%%
% 第四批解
t24 = atan2(k2,-sqrt(pp2-power(k2,2)))-atan2(m2,n);
p24 = m2-a2*cos(t24);
q24 = n-a2*sin(t24);
sum23_4 = atan2(a3*q24+d4*p24,a3*p24-d4*q24);
t34 = sum23_4-t24;

c23 = cos(sum23_4);  s23 = sin(sum23_4);
c4s5 = c23*r13_+s23*r33_;
s4s5 = -r23_;

% 求解当前[t1,t2,t3]组合下的两组 [t4,t5,t6]解
% 求解关节角 4
t44 = atan2(s4s5,c4s5);

s54 = cos(t44)*c4s5+sin(t44)*s4s5;
c54 = s23*r13_-c23*r33_;

% 求解关节角 5
t54 = atan2(s54,c54);

% 求解关节角 6
s64 = -sin(t44)*(c23*r11_+s23*r31_)-cos(t44)*r21_;
c64 = -sin(t44)*(c23*r12_+s23*r32_)-cos(t44)*r22_;

t64 = atan2(s64,c64);

T7 = [rad2deg(t12) rad2deg(t24)-90 rad2deg(t34) rad2deg(t44) rad2deg(t54) rad2deg(t64)-90];
T8 = [rad2deg(t12) rad2deg(t24)-90 rad2deg(t34) rad2deg(t44+pi) rad2deg(-t54) rad2deg(t64+pi)-90];

% 用于验证逆解答案 正向求解是否正确
% T1 = Fkine6(T1);T2 = Fkine6(T2);T3 = Fkine6(T3);T4 = Fkine6(T4);
% T5 = Fkine6(T5);T6 = Fkine6(T6);T7 = Fkine6(T7);T8 = Fkine6(T8);

% J4 关节角处理,将合理的大角度转换到[-170,170]
T1 = phaseMod(T1);T2 = phaseMod(T2);T3 = phaseMod(T3);T4 = phaseMod(T4);
T5 = phaseMod(T5);T6 = phaseMod(T6);T7 = phaseMod(T7);T8 = phaseMod(T8);

res = {};%存储结果的元胞数组
p = 1;%元胞数组指针
% 将合理的逆解加入到元胞数组,此时逆解中的
if validJoints(T1) == 1
    res{p} = toRad(T1);
    p = p+1;
end

if validJoints(T2) == 1
    res{p} = toRad(T2);
    p = p+1;
end

if validJoints(T3) == 1
    res{p} =toRad(T3);
    p = p+1;
end

if validJoints(T4) == 1
    res{p} = toRad(T4);
    p = p+1;
end

if validJoints(T5) == 1
    res{p} = toRad(T5);
    p = p+1;
end

if validJoints(T6) == 1
    res{p} = toRad(T6);
    p = p+1;
end

if validJoints(T7) == 1
    res{p} = toRad(T7);
    p = p+1;
end

if validJoints(T8) == 1
    res{p} = toRad(T8);
    p = p+1;
end

end

