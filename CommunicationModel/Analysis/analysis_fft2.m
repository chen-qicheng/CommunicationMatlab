%参数
w_m=40;     %截断频率
T=pi/w_m;   %采样间隔
L=5;
t= 0:T:L;           %时域截断
x_t=exp(-t).*(t>0); %信号序列;
N=length(x_t);      %序列长度（点数）

%FFT计算
X_k=fft(x_t);

w0=2*pi/(N*T);      %离散频率间隔
kw=w0.* [0 : N-1];  %离散频率样点
X_kw=T.*X_k;

%作图显示
%subplot(2,1,1);
plot(kw,abs(X_kw),'.','MarkerSize',14);    %作出数值计算的幅度频点
axis([-40 90 -0.1 1.1]);
xlabel('freq(rad/s)');
hold on;

%作图对比
w=-40:0.1:40;%理论计算频谱表达式
X_w=1./(1+1j*w);
plot(w,abs(X_w));
