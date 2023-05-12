function joints = phaseMod(joints)
% 修正关节角4的角度可能正确但是超出限定范围的情况
% j4 [-170,170]
j4 = joints(1,4);
if j4 > 170
    joints(1,4) = j4-360;
elseif j4 < -170
    joints(1,4) = j4+360;
end
end

