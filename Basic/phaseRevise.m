function v = phaseRevise(input)
% 求解角度的相位修正,传入值为弧度，返回值为弧度,此部分为了保证求解出来的关节角度值在(-180，180】之间
%   此处显示详细说明
v = 0;
if input > pi
    v = input-2*pi;
elseif input <= -pi
    v = input+2*pi;
end
end

