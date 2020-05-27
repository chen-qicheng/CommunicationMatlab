function xdot = pendulumstateeqlinear(t,x,flag,par)
xdot=zeros(2,1);
g=par(1);k=par(2);m=par(3);L=par(4);

A=[-k/m,g;-1/L,0];
B=0;
f=0;

xdot=A*x+B*f;%×´Ì¬¾ØÕó