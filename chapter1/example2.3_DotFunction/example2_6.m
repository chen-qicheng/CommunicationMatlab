%ʱ�����
clear;
dt=0.01;
T=5;
t=0:dt:T;

%״̬����
K=0.85;

%��ʼ������
v0=0;y0=1;
x0=[v0,y0];

for n=1:length(t)
    [t_out,x_out]=ode45('example2_6fun',[t(n),t(n)+dt],x0);%״̬�������
    
    x0=x_out(length(x_out),:);%״̬����
    
    if(x0(2)<=0)&(x0(1)<=0)%��ײ������ߴﵽ���㣬С�����
        x0(1)=-K*x0(1);
    end    
    y=x0(2);
    
    %��ͼ��ʾ
    plot(0,y,'o');
    axis([-2 2 -0.1 1]);
    
    set(gcf,'DoubleBuffer','on');
    drawnow;
end
