%时间参数
clear;
dt=0.001;
T=15;
t=0:dt:T;

%状态参数
g=9.8;
L=1;
m=10;
k=5;

%初始化参数
v0=0;
v=zeros(size(t));
v(1)=v0;

theta0=3.1;
theta=zeros(size(t));
theta(1)=theta0;

%数值求解
for n=1:length(t)
    v(n+1)=v(n)+(g*sin(theta(n))-k./m.*v(n)).*dt;
    theta(n+1)=theta(n)-1./L.*v(n).*dt;
end

yyaxis left;
plot(t,v(1,length(t)));ylabel('线速度');

yyaxis right;
plot(t,theta(1,length(t)));ylabel('角速度');

xlabel('时间 t');