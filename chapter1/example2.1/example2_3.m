%����ϵͳ����ʵ����·���
%1.�ز��źż�����λ����
%2.����źż��ϼ�������
%3.�ź������뷴��֡�����ڲ����������Ĺ�ϵ��ʵ�ֲ����ƶ�����

%ʱ�����
clear;
dt=1e-6;
T=2*1e-3;

for N=0:500
    t=N*T+(0:dt:T);%ʱ�����
   
    %�źŴ����� 
    input=2*cos(2*pi*1005*t);%�����ź�Ƶ������Ϊ1005
    carrier=5*cos(2*pi*1e4*t+0.1*randn);
    output=(2+0.5*input).*carrier;
    noise=rand(size(t));%��������
    r=output+noise;
    
    %ͼ����ʾ
    text(T*2/3,1.5,['��ǰ֡����N=',num2str(N)]);%��ʾ֡��
    subplot(3,1,1);plot([0:dt:T],input);xlabel('ʱ��/s');ylabel('�����ź�');
    subplot(3,1,2);plot([0:dt:T],carrier);xlabel('ʱ��/s');ylabel('�ز�');
    subplot(3,1,3);plot([0:dt:T],output);xlabel('ʱ��/s');ylabel('�������');
    
    set(gcf,'DoubleBuffer','on');%˫���������ͼ��˸
    drawnow;
end