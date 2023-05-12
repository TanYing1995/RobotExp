function joints_rad = toRad(joints)
% 将各关节角度转换为关节弧度
% 
joints_rad = [];
joints_rad(1) = deg2rad(joints(1));
joints_rad(2) = deg2rad(joints(2));
joints_rad(3) = deg2rad(joints(3));
joints_rad(4) = deg2rad(joints(4));
joints_rad(5) = deg2rad(joints(5));
joints_rad(6) = deg2rad(joints(6));
end

