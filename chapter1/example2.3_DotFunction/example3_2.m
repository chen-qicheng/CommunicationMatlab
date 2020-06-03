
clear;
%ʱ�����
ts=1e-6;
t_start=0;
t_end=10e-3;
t=t_start:ts:t_end;
%״̬����
R=100;
L=2e-3;
C=1e-7;
%��ʼ������
i_L0=0;
u_C0=0;
x0=[i_L0;u_C0];

inputtimespan=t;
input=sin(2*pi*(2e3*t+3e6/2*(t.^2)));

tic
[t_out,x_out]=ode45('example3_2fun',t,x0,[],R,L,C,input,inputtimespan);
toc

%ͼ�λ���
s_t_simu=x_out(:,2);
figure(1);
plot(t_out,s_t_simu,'-');

title("��Ƶ��Ӧ");
xlabel("ʱ��");
ylabel("���ݵ�ѹ");
legend("ϵͳɨƵ��Ӧ������");

axis([t_start t_end 1.1*min(s_t_simu) 1.1*max(s_t_simu)]);
grid on;