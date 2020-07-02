%采用海明窗的Welch方法
%参数设置
fs = 500;               % 采样率
Df = 1;                 % 频率分辨率
N = floor(fs/Df)+1;     % 计算的序列点数
t = 0:1/fs:(N-1)/fs;    % 截取信号的时间段
F = 0:Df:fs;            % 功率谱估计的频率分辨率和范围

%数值计算
xk = sin(2*pi*50*t)+2*sin(2*pi*130*t)+randn(1,length(t));   % 截取时间段上的离散信号样点序列

[Pxx,F] = pwelch(xk,hamming(256),128,512,500);

%作功率谱密度图
plot(0:3:fs,10*log(Pxx/(512/2)));
xlabel('频率 Hz');
ylabel('PSD dB');