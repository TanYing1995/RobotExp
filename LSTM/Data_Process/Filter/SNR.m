function snr = SNR(data, filter_data)
    % 计算信号的功率
    signal_power = mean(data.^2);

    % 计算噪声的功率
    noise = data - filter_data; % 计算滤波后的噪声信号
    noise_power = mean(noise.^2);

    % 计算信噪比
    snr = signal_power / noise_power;
end
