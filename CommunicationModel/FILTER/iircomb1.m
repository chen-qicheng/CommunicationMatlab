clear;

%梳妆滤波器
fs=8000;ts=1/fs;   %采样率
f0=500;            %梳状滤波器开槽基频率
bw=60/(fs/2);      %归一化开槽带宽
ab=-3;             %开槽带宽处的衰减分贝值
n=fs/f0;           %滤波器阶数

[num,den]=iircomb(n,bw,ab,'notch'); %梳妆滤波器

freqz(num,den,4000,8000);
axis([0 4000 -40 3]);