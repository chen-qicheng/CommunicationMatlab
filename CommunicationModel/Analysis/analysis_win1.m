%时间参数
fs = 200;               % 采样率
Delta_f = 1;            % 频率分辨率
T = 1/fs;               % 时间分辨率
L = 1/Delta_f;          % 时域截取长度
N = floor(fs/Delta_f)+1;% 计算截断信号的采样点数
t = 0:T:L;              % 截取时间段和采样时间点
freq = 0: Delta_f:fs;   % 分析的频率范围和频率分辨率

%信号
f_t = (sin(2*pi*50*t)+0.7*sin(2*pi*75*t))';                      % 原信号
f_t_rectwin = rectwin(N).*f_t./sqrt(sum(abs(rectwin(N).^2))./N); % 矩形窗
f_t_hamming = hamming(N).*f_t./sqrt(sum(abs(rectwin(N).^2))./N); % 海明窗
f_t_hann = hann(N).*f_t./sqrt(sum(abs(rectwin(N).^2))./N);       % 汉宁窗

%信号时域波形图
figure(1);
subplot(2,2,1);plot(t,f_t);title('原信号');
subplot(2,2,2);plot(t,f_t_rectwin);title('矩形窗');
subplot(2,2,3);plot(t,f_t_hamming);title('海明窗');
subplot(2,2,4);plot(t,f_t_hann);title('汉宁窗');

%fft变换
F_w_rectwin = T.*fft(f_t_rectwin,N);
F_w_hamming = T.*fft(f_t_hamming,N);
F_w_hann = T.*fft(f_t_hann,N);

%信号频谱图
figure(2);
subplot(3,1,1);plot(freq,10*log10(abs(F_w_rectwin)));
title('矩形窗频谱');ylabel('幅度 dB');
axis([0,200,-50,0]);grid on;

subplot(3,1,2);plot(freq,10*log10(abs(F_w_hamming)));
title('海明窗频谱');ylabel('幅度 dB');
axis([0,200,-50,0]);grid on;

subplot(3,1,3);plot(freq,10*log10(abs(F_w_hann)));
title('汉宁窗频谱');ylabel('幅度 dB');
axis([0,200,-50,0]);grid on;

%计算信号功率
p_original_signal = var(f_t)                        % 原始信号平均功率
p_hannwindowed = sum((abs(F_w_hann/T)).^2)/(N^2)    % 加汉宁窗后的信号功率

