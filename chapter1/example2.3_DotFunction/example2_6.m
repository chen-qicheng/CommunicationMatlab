%时间参数
clear;
dt=0.01;
T=5;
t=0:dt:T;

%状态参数
K=0.85;

%初始化参数
v0=0;y0=1;
x0=[v0,y0];

for n=1:length(t)
    [t_out,x_out]=ode45('example2_6fun',[t(n),t(n)+dt],x0);%状态方程求解
    
    x0=x_out(length(x_out),:);%状态更新
    
    if(x0(2)<=0)&(x0(1)<=0)%碰撞地面或者达到顶点，小球变向
        x0(1)=-K*x0(1);
    end    
    y=x0(2);
    
    %画图显示
    plot(0,y,'o');
    axis([-2 2 -0.1 1]);
    
    set(gcf,'DoubleBuffer','on');
    drawnow;
end
