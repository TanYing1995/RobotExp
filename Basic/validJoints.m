function bool = validJoints(joints)
% 输入角度应该是在消除原始偏移角后的角度值，主要是为了消除关节2和关节6的原始偏置角
% 用来判断当前的关节角（角度）组合是否在机器人允许的工作空间内
% j1 [-170,170] j2 [-144,80] j3 [-119,265]  
% j4 [-170,170]  j5 [-119,119] j6[-360,360]

j1 = joints(1);j2 = joints(2);j3 = joints(3);
j4 = joints(4);j5 = joints(5);j6 = joints(6);

% 返回代表逻辑值的数组：0为假 1为真
bool = (j1 > -170 && j1 < 170) && (j2 > -144 && j2 < 80) && (j3 < 265 && j3 > -119) && (j4 > -170 && j4 < 170) && (j5 < 119 && j5 > -119);

end

