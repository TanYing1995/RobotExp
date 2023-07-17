clc;    

time_interval = 0.001;
acceleration = diff(vel,1,2) ./ time_interval;
acceleration = [zeros(6,1) acceleration];

ans = kalman_filter(acceleration);