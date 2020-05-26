close all
CNT = 1e2; % ������������еĸ���
SNR = 10; % dBֵ
N = 1024; % DFT����
rng(round(100 * sum(clock)));
SignalPower = 0; % dBֵ
NoisePower = SignalPower - SNR; % dBֵ
Sigma_I = sqrt(10^(NoisePower/10)/2); % ʵ���ı�׼��
Sigma_Q = sqrt(10^(NoisePower/10)/2); % �鲿�ı�׼��
z = zeros(1024, CNT, 'double');
Noise = zeros(1024, CNT, 'double');
for i = 1 : CNT
    Noise(:,i) = wgn(N, 1, NoisePower, 'complex');
    z(:,i) = 1/sqrt(N) * fft(Noise(:,i));
end

% ����ʱ������ʵ���ķ������ߺ���������
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

% ����ʱ�������鲿�ķ������ߺ���������
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

% ����Ƶ������ʵ���ķ������ߺ���������
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

% ����Ƶ�������鲿�ķ������ߺ���������
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
