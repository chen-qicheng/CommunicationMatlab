%״̬���̺���
function xdot=example3fun(t,x,flag,par)

xdot=zeros(2,1);
R=par(1);L=par(2);C=par(3);

A=[-R/L,-1/L;1/C,0];%ϵ������
B=[1/L;0];

xdot=A*x+B*f(t);%״̬�������

%���뺯������λ��Ծ����
function input=f(t)
input=(t>=0);
