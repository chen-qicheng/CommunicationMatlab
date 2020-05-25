%ʱ�����
clear;
dt=0.001;
T=15;
t=0:dt:T;

%״̬����
g=9.8;
L=1;
m=10;
k=5;

%��ʼ������
v0=0;
v=zeros(size(t));
v(1)=v0;

theta0=3.1;
theta=zeros(size(t));
theta(1)=theta0;

%��ֵ���
for n=1:length(t)
    v(n+1)=v(n)+(g*sin(theta(n))-k./m.*v(n)).*dt;
    theta(n+1)=theta(n)-1./L.*v(n).*dt;
end

yyaxis left;
plot(t,v(1,length(t)));ylabel('���ٶ�');

yyaxis right;
plot(t,theta(1,length(t)));ylabel('���ٶ�');

xlabel('ʱ�� t');