function xdot = pendulumstateeq(t,x,flag,par)

xdot=zeros(2,1);

g=par(1);k=par(2);m=par(3);L=par(4);

xdot(1)=g*sin(x(2))-k/m*x(1);
xdot(2)=-1/L*x(1);