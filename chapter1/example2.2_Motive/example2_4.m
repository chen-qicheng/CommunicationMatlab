%��̬ϵͳ���棨���ݳ����̣�

%ʱ�����
dt=1e-5;
T=5*1e-3;
t=-T:dt:T;

%״̬����
R=1e3;
C=1e-6;
L=0;

%��ʼ������
x=zeros(size(t));
x=1*(t>=0);

y=zeros(size(t));
y0=0;
y(1)=y0;

%�źŴ���
for k=1:length(t)
    time=-T+k*dt;
    if time>=0
        y(k+1)=y(k)+1/(R*C).*x(k)*dt-1/(R*C).*y(k)*dt;
    else
        y(k+1)=y(k);
    end
end

%ͼ����ʾ
subplot(2,1,1);plot(t,x(1:length(t)));
axis([-T T -1.1 1.1]);xlabel('t');ylabel('����');

subplot(2,1,2);plot(t,y(1:length(t)));
axis([-T T -1.1 1.1]);xlabel('t');ylabel('���');