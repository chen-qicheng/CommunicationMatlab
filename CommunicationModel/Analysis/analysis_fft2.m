%����
w_m=40;     %�ض�Ƶ��
T=pi/w_m;   %�������
L=5;
t= 0:T:L;           %ʱ��ض�
x_t=exp(-t).*(t>0); %�ź�����;
N=length(x_t);      %���г��ȣ�������

%FFT����
X_k=fft(x_t);

w0=2*pi/(N*T);      %��ɢƵ�ʼ��
kw=w0.* [0 : N-1];  %��ɢƵ������
X_kw=T.*X_k;

%��ͼ��ʾ
%subplot(2,1,1);
plot(kw,abs(X_kw),'.','MarkerSize',14);    %������ֵ����ķ���Ƶ��
axis([-40 90 -0.1 1.1]);
xlabel('freq(rad/s)');
hold on;

%��ͼ�Ա�
w=-40:0.1:40;%���ۼ���Ƶ�ױ��ʽ
X_w=1./(1+1j*w);
plot(w,abs(X_w));
