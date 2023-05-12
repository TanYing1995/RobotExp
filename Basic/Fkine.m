function fkine4 = Fkine(theta)
% M-DH法建立模型下的正向运动学求解
% 计算过程选择 角度(非弧度)
% 传入的 theta = [t1 t2 t3 t4 t5 t6] 若需要转换为弧度 *pi/180
% 返回 4x4 的
% M-DH 模型下必要的模型参数
%   i   alpha   a   d   theta 
%   1   0       0   0   0
%   2   90      40  0   90
%   3   0       275 0   0
%   4   90      25  280 0
%   5   -90     0   0   0
%   6   90      0   73  90
t1=theta(1);t2=theta(2)+90;t3=theta(3);t4=theta(4);t5=theta(5);t6=theta(6)+90;
% 计算角度值用 sind ,弧度制用 sin
s1=sind(t1);s2=sind(t2);s3=sind(t3);s4=sind(t4);s5=sind(t5);s6=sind(t6);
c1=cosd(t1);c2=cosd(t2);c3=cosd(t3);c4=cosd(t4);c5=cosd(t5);c6=cosd(t6);
d4 = 280;d6 = 73;
a1 = 40;a2 = 275;a3 = 25;

T1 = [c1 -s1  0  0;
      s1  c1  0  0;
      0   0   1  0;
      0   0   0  1];
  
T2 = [c2 -s2  0  a1;
      0    0  -1 0;
      s2  c2  0  0;
      0   0   0  1];
  
T3 = [c3 -s3  0  a2;
      s3  c3  0  0;
      0   0   1  0;
      0   0   0  1];

T4 = [c4 -s4  0  a3;
      0    0  -1 -d4;
      s4  c4  0   0;
      0   0   0   1];
  
T5 = [c5 -s5  0  0;
      0    0  1  0;
     -s5 -c5  0  0;
      0   0   0  1];

T6 = [c6 -s6  0   0;
      0    0  -1 -d6;
      s6  c6  0   0;
      0   0   0   1];

%res = [r11 r12 r13 px;r21 r22 r23 py;r31 r32 r33 pz;0 0 0 1];%末端位姿矩阵
fkine4 = T1*T2*T3*T4*T5*T6;
end

