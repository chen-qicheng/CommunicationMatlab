%ʱ�����
clear;
dt=0.01;
T=15;
t=0:dt:T;

%״̬����
g=9.8;L=1;m=10;k=5;

%��ʼ������
theta0=3.1;v0=0;
x0=[v0;theta0];
par=[g;k;m;L];

[t_out,x_out]=ode45('pendulumstateeq',t',x0,[],par);%״̬������⺯��
plot(t_out,x_out(:,1),'-k');hold on;%ͼ����ʾ

[t_out,x_out]=ode45('pendulumstateeqlinear',t',x0,[],par);
plot(t_out,x_out(:,1),'-.r');

xlabel('ʱ��');ylabel('���ٶ�');
legend('״̬����','״̬����');