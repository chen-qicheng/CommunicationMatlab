%时间参数
clear;
dt=0.01;
T=15;
t=0:dt:T;

%状态参数
g=9.8;L=1;m=10;k=5;

%初始化参数
theta0=3.1;v0=0;
x0=[v0;theta0];
par=[g;k;m;L];

[t_out,x_out]=ode45('pendulumstateeq',t',x0,[],par);%状态方程求解函数
plot(t_out,x_out(:,1),'-k');hold on;%图形显示

[t_out,x_out]=ode45('pendulumstateeqlinear',t',x0,[],par);
plot(t_out,x_out(:,1),'-.r');

xlabel('时间');ylabel('线速度');
legend('状态方程','状态矩阵');