% ע�ⵥλ��dt��mm��������m
%% DH parameters, unit m
%XB4
d1=0.342;a1=0.040;a2=0.275;a3=0.025;d4=0.280;dt=73;d3=0;
%XB6
% d1=0.380;a1=0.030;a2=0.340;a3=0.035;d4=0.345;dt=90;d3=0;
%XB7
% d1=0.380;a1=0.030;a2=0.340;a3=0.035;d4=0.345;dt=87;d3=0;
%siasun
% d1=0.330;a1=0.040;a2=0.315;a3=0.070;d4=0.3245;dt=78;d3=0;
% %% 
% 
% init_theta_x_deg = 0;
% init_theta_y_deg = 0;
% 
% Moffset = [0,0,0,0,0,0;
%            0,0,0,0,pi/2,0;
%            pi/3,pi/3,0,0,pi/6,pi/3;
%            pi/4,pi/4,0,0,pi/4,pi/4;
%            0,pi/4,0,0,pi/4,0;
%            0,pi/6,pi/6,0,pi/6,0];
% 
% Mpos = [365,0,715;
%         365,0,715;
%         268,464,241;
%         383,383,373;
%         542,0,373;
%         420,0,357];
% 
% index = 6;
%     
% offset = Moffset(index,:);
% pos = Mpos(index,:);
% 
% offset1 = offset(1);
% offset2 = offset(2);
% offset3 = offset(3);
% offset4 = offset(4);
% offset5 = offset(5);
% offset6 = offset(6);
% 
% x0 = pos(1);
% y0 = pos(2);
% z0 = pos(3)-dt;



m1=0.167;  m2=1;  m3=0.5;  m4=0.333;  m5=0.25;  m6=0.2;

mc11=0;  mc12=0;  mc13=0.2;
mc21=0.1291;  mc22=0;  mc23=3.3117;
mc31=1.6484;  mc32=0;  mc33=0.8748;
mc41=0.3200;  mc42=0.2324;  mc43=0.7083;
mc51=0.4574;  mc52=0;  mc53=0.6427;
mc61=0.3200;  mc62=-0.0513;  mc63=0.6417;%����λ��

Ic111=0;  Ic122=0;  Ic133=1.3676;  Ic112=0;  Ic113=0;  Ic123=0;
Ic211=8.8194;  Ic222=6.0549;  Ic233=0.9569;  Ic212=0;  Ic213=0;  Ic223=0;
Ic311=0.0332;  Ic322=1.8442;  Ic333=1.0560;  Ic312=0;  Ic313=0;  Ic323=0;
Ic411=0.1448;  Ic422=0.0015;  Ic433=0.0822;  Ic412=0;  Ic413=0;  Ic423=0;
Ic511=0;  Ic522=0.0121;  Ic533=0.0299;  Ic512=0;  Ic513=0;  Ic523=0;
Ic611=0.0134;  Ic622=0;  Ic633=0.0051;  Ic612=0;  Ic613=0;  Ic623=0;%���Ծ�

g=9.80200;

Ia1=0; Ia2=0; Ia3=0; Ia4=0; Ia5=0; Ia6=0;%�ؽڹ���
fv1=0; fc1=0; fv2=0; fc2=0; fv3=0; fc3=0; 
fv4=0; fc4=0; fv5=0; fc5=0; fv6=0; fc6=0;%ճ��Ħ��,����Ħ��

