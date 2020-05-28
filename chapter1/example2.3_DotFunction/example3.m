%时间参数
clear;
tstart=-1e-4;
tend=4e-4;
dt=2e-6;
t=tstart:dt:tend;

%状态参数
R=100;L=2e-3;C=1e-7;
par(1)=R;par(2)=L;par(3)=C;

%初始化参数
i0=0;
u0=0;
x0=[i0;u0];

%求解状态方程，
tic             %计算求解时间
[t_out,x_out]=ode45('example3fun',t,x0,[],par);
toc

y1=x_out(:,1);
y2=x_out(:,2);

%作图显示
figure(1);
%yyaxis left;
plot(t_out,y1);
axis([tstart tend 1.1*min(y1) 1.1*max(y1)]);
xlabel('时间');ylabel('电容电压v');
title('单位冲激响应仿真结果');
grid on;

figure(2);
%yyaxis right;
plot(t_out,x_out(:,2));
axis([tstart tend 1.1*min(y2) 1.1*max(y2)]);