%参数设置
fs = 500;               % 采样率
Df = 1;                 % 频率分辨率
N = floor(fs/Df)+1;     % 计算的序列点数
t = 0:1/fs:(N-1)/fs;    % 截取信号的时间段
F = 0:Df:fs;            % 功率谱估计的频率分辨率和范围

%数值计算
xk = sin(2*pi*50*t)+2*sin(2*pi*130*t)+randn(1,length(t));   % 截取时间段上的离散信号样点序列

Pxx = (abs(fft(xk(1:167))).^2+...                           % 功率谱估计
       abs(fft(xk(83:249))).^2+... 
       abs(fft(xk(168:334))).^2+... 
       abs(fft(xk(250:416))).^2+... 
       abs(fft(xk(335:501))).^2)/5/(N/3)^2;   
   
Pav_timedomain = sum(xk.^2)/N;                              % 在时域计算信号功率
Pav_freqdomain = sum(Pxx);                                  % 通过功率谱计算信号功率

%作功率谱密度图
plot(0:3:fs,10*log(Pxx));
xlabel('频率 Hz');
ylabel('PSD dB');