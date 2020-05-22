%调幅系统基时间流仿真

%时间参数
clear;
dt=1e-5;    %1采样间隔，步进
T=3*1e-3;   %2时间跨度，终止时间
t=0:dt:T;   %3时间采样   

%信号处理部分 (基于时间流仿真)
for k=1:length(t)
   input(k)=2*cos(2*pi*1000*t(k));
   carrier(k)=5*cos(2*pi*1e4*t(k));
   output(k)=(2+0.5*input(k))*carrier(k); 
end

%图形显示
subplot(3,1,1);plot(t,input);xlabel('时间/s');ylabel('被调信号');
subplot(3,1,2);plot(t,carrier);xlabel('时间/s');ylabel('载波');
subplot(3,1,3);plot(t,output);xlabel('时间/s');ylabel('调幅输出');