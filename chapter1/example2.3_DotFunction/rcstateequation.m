function xdot = rcstateequation(t,x,flag,par)
R=par(1);
C=par(2);
xdot=(-1./(R*C).*x+(1/(R*C))).*f(t);%状态方程

function inputsignal =f(t)
inputsignal=(t>=0);%单位阶跃函数
 