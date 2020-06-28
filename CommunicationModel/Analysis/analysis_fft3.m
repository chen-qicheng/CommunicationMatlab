Df = 5;         %频率间隔
f_s = 2*500;    %采样率
N = f_s/Df;     %序列点数
t = 0:1/f_s:(N-1)/f_s;  %计算时间段
freq = 0:Df:(N-1)*Df;   %计算频率段
f_t = 2*sin(2*pi*100*t)+cos(2*pi*180*t);    %信号
F_f = 1/f_s*fft(f_t,N); %用FFT计算频谱

%作图
plot(freq-f_s/2,abs(fftshift(F_f)));        %将零频率移动到FFT中心
xlabel('频率');
ylabel('幅度谱');