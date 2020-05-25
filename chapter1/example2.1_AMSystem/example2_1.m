%调幅系统 基时间流仿真

%系统的最高工作频率为 m+fc=11kHz
%根据采样定理，离散采样率高于系统最高工作频率，无失真
%22khz -->  dt< 4.5e-5

%时间参数
clear;
dt=1e-5;    %1采样间隔，步进
T=3*1e-3;   %2时间跨度，终止时间
t=0:dt:T;   %3时间采样 

%信号处理部分 (基于数据流仿真)
input=2*cos(2*pi*1000*t);
carrier=5*cos(2*pi*1e4*t);
output=(2+0.5*input).*carrier;

%图形显示
subplot(3,1,1);plot(t,input);xlabel('时间/s');ylabel('被调信号');
subplot(3,1,2);plot(t,carrier);xlabel('时间/s');ylabel('载波');
subplot(3,1,3);plot(t,output);xlabel('时间/s');ylabel('调幅输出');