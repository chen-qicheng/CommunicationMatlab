clear;

t_start = 0;
t_end = 10e-3;
dt = 1e-6;
t = t_start:dt;t_end;

R = 100;
L = 2e-3;
C = 1e-7;

i_L0 = 0;
u_C0 = 0;
x0 = [i_L0;u_C0];

input=sin(2*pi*(2e3*t+3e6/2*(t.^2)));
inputtimespan=t;

tic
[t_out,x_out]=ode45('example3_2fun',t,x0,[],R,L,C,input,inputtimespan);
toc

s_t_out=x_out(:,2);   
plot(t_out,s_t_out);
                

