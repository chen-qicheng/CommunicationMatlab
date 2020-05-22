%����ϵͳ��ʱ��������

%ʱ�����
clear;
dt=1e-5;    %1�������������
T=3*1e-3;   %2ʱ���ȣ���ֹʱ��
t=0:dt:T;   %3ʱ�����   

%�źŴ����� (����ʱ��������)
for k=1:length(t)
   input(k)=2*cos(2*pi*1000*t(k));
   carrier(k)=5*cos(2*pi*1e4*t(k));
   output(k)=(2+0.5*input(k))*carrier(k); 
end

%ͼ����ʾ
subplot(3,1,1);plot(t,input);xlabel('ʱ��/s');ylabel('�����ź�');
subplot(3,1,2);plot(t,carrier);xlabel('ʱ��/s');ylabel('�ز�');
subplot(3,1,3);plot(t,output);xlabel('ʱ��/s');ylabel('�������');