function traj = testVar()

S = load('path.mat');

traj = S.path;
figure(1);
plot(traj(1,:));
% figure(2);
% plot(traj(2,:));
% figure(3);
% plot(traj(3,:));
% figure(4);
% plot(traj(4,:));
% figure(5);
% plot(traj(5,:));
% figure(6);
% plot(traj(6,:));
end

