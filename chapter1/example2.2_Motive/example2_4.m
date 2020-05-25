%动态系统仿真（电容充电过程）

%时间参数
dt=1e-5;
T=5*1e-3;
t=-T:dt:T;

%状态参数
R=1e3;
C=1e-6;
L=0;

%初始化参数
x=zeros(size(t));
x=1*(t>=0);

y=zeros(size(t));
y0=0;
y(1)=y0;

%信号处理
for k=1:length(t)
    time=-T+k*dt;
    if time>=0
        y(k+1)=y(k)+1/(R*C).*x(k)*dt-1/(R*C).*y(k)*dt;
    else
        y(k+1)=y(k);
    end
end

%图像显示
subplot(2,1,1);plot(t,x(1:length(t)));
axis([-T T -1.1 1.1]);xlabel('t');ylabel('输入');

subplot(2,1,2);plot(t,y(1:length(t)));
axis([-T T -1.1 1.1]);xlabel('t');ylabel('输出');