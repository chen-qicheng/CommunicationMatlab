%调制系统的现实情况下仿真
%1.载波信号加上相位噪声
%2.输出信号加上加性噪声
%3.信号周期与反震帧数周期不是整数倍的关系，实现波形移动现象

%时间参数
clear;
dt=1e-6;
T=2*1e-3;

for N=0:500
    t=N*T+(0:dt:T);%时间参数
   
    %信号处理部分 
    input=2*cos(2*pi*1005*t);%输入信号频率设置为1005
    carrier=5*cos(2*pi*1e4*t+0.1*randn);
    output=(2+0.5*input).*carrier;
    noise=rand(size(t));%加性噪声
    r=output+noise;
    
    %图形显示
    text(T*2/3,1.5,['当前帧数：N=',num2str(N)]);%显示帧数
    subplot(3,1,1);plot([0:dt:T],input);xlabel('时间/s');ylabel('被调信号');
    subplot(3,1,2);plot([0:dt:T],carrier);xlabel('时间/s');ylabel('载波');
    subplot(3,1,3);plot([0:dt:T],output);xlabel('时间/s');ylabel('调幅输出');
    
    set(gcf,'DoubleBuffer','on');%双缓冲避免作图闪烁
    drawnow;
end