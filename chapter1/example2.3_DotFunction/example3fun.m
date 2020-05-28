%状态方程函数
function xdot=example3fun(t,x,flag,par)

xdot=zeros(2,1);
R=par(1);L=par(2);C=par(3);

A=[-R/L,-1/L;1/C,0];%系数矩阵
B=[1/L;0];

xdot=A*x+B*f(t);%状态方程求解

%输入函数，单位阶跃函数
function input=f(t)
input=(t>=0);
