clc;
c = {};
p = 1;
% for i = 1:5
%     c{i} = [1,2];
% end
c{p} = [11];
p = p+1;
c{p} = [2,4];
p = p+1;
c{p} = [3,6,8];

a = zeros(1,7);
a(1,6) = 8;

p1 = {[1],[2]};
p2 = {[3,4]};
p = {};
p{1} = p1;
p{2} = p2;
