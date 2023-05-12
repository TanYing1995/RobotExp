
subplot(4,1,1),plot(q5,'r'),xlabel('t/s'),ylabel('rad');grid on;
title('关节位移曲线');
subplot(4,1,2),plot(dq5,'b'),xlabel('t/s'),ylabel('rad/s');grid on;
title('关节速度曲线');
subplot(4,1,3),plot(ddq5,'g'),xlabel('t/s'),ylabel('rad/s^2');grid on;
title('关节加速度曲线');
subplot(4,1,4),plot(t5,'m'),xlabel('t/s'),ylabel('Nm');grid on;
title('关节力矩曲线');
