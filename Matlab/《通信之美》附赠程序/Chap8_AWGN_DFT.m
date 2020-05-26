close all
CNT = 1e2; % 仿真的噪声序列的个数
SNR = 10; % dB值
N = 1024; % DFT点数
rng(round(100 * sum(clock)));
SignalPower = 0; % dB值
NoisePower = SignalPower - SNR; % dB值
Sigma_I = sqrt(10^(NoisePower/10)/2); % 实部的标准差
Sigma_Q = sqrt(10^(NoisePower/10)/2); % 虚部的标准差
z = zeros(1024, CNT, 'double');
Noise = zeros(1024, CNT, 'double');
for i = 1 : CNT
    Noise(:,i) = wgn(N, 1, NoisePower, 'complex');
    z(:,i) = 1/sqrt(N) * fft(Noise(:,i));
end

% 画出时域噪声实部的仿真曲线和理论曲线
figure;
edges = -1 : 0.02 : 1;
histogram(real(Noise), edges, 'Normalization','pdf'); 
ylim([0 2]); hold on
x = -1:0.02:1;
mu = 0;
f = exp(-(x - mu).^2 / (2 * Sigma_I^2)) / (Sigma_I * sqrt(2*pi));
plot(x, f, 'LineWidth', 2);
xlabel('real part'); ylabel('pdf');
legend('Simulation', 'Theory');

% 画出时域噪声虚部的仿真曲线和理论曲线
figure;
edges = -1:0.02:1;
histogram(imag(Noise), edges, 'Normalization','pdf');
ylim([0 2]); hold on
x = -1:0.02:1;
mu = 0;
f = exp(-(x - mu).^2 ./ (2 * Sigma_I^2)) ./ (Sigma_I * sqrt(2*pi));
plot(x, f, 'LineWidth', 2);
xlabel('imag part'); ylabel('pdf');
legend('Simulation', 'Theory');

% 画出频域噪声实部的仿真曲线和理论曲线
figure;
edges = -1:0.02:1;
histogram(real(z), edges, 'Normalization','pdf');
ylim([0 2]); hold on
x = -1 : 0.02 : 1;
mu = 0;
f = exp(-(x - mu).^2 ./ (2 * Sigma_I^2)) ./ (Sigma_I * sqrt(2*pi));
plot(x, f, 'LineWidth', 2);
xlabel('real part'); ylabel('pdf');
legend('Simulation', 'Theory');

% 画出频域噪声虚部的仿真曲线和理论曲线
figure;
edges = -1 : 0.02 : 1;
histogram(imag(z), edges, 'Normalization','pdf');
ylim([0 2]); hold on
x = -1 : 0.02 : 1;
mu = 0;
f = exp(-(x - mu).^2 ./ (2 * Sigma_Q^2)) ./ (Sigma_Q * sqrt(2*pi));
plot(x, f, 'LineWidth', 2);
xlabel('imag part'); ylabel('pdf');
legend('Simulation', 'Theory');
