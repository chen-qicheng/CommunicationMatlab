clear;

%滤波器参数
fp=2400;%通带拐角频率
fs=5000;%阻带起始频率
Rp=10;%通带内波动
Rs=25;%阻带内最小衰减

%滤波器参数
[n,fn]=buttord(fp,fs,Rp,Rs,'s');%波特沃斯模拟滤波器
Wn=2*pi*fn;
[b,a]=butter(n,Wn,'s');%波特沃斯模拟滤波器，传递函数

%绘图1
figure(1);
freqs(b,a);     %直接绘制出幅频响应，相频响应曲线

%绘图2
f=0:100:10000;
s=1i*2*pi*f;    %s=jw=j*2*pi*f
Hs=polyval(b,s)./polyval(a,s);%计算H(s)

figure(2);
subplot(2,1,1);plot(f,20*log10(abs(Hs)));%幅频特性
axis([0 10000 -40 1]);
xlabel("频率 Hz");ylabel("幅度 dB");
grid on;

subplot(2,1,2);plot(f,angle(Hs));%相频特性
xlabel("频率 Hz");ylabel("相位 rad");
grid on;
