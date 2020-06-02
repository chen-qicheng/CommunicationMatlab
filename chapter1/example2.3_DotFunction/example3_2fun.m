function xdot=example3_2fun(t,x,flag,R,L,C,input,inputtimespan)

xdot=zeros(2,1);
A=[-R/L,-1/L;1/C,0];
B=[1/L;0];

f_t=interp1(inputtimespan,input,t);

xdot=A*x+B*f_t;


