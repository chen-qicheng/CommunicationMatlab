Df = 5;         %Ƶ�ʼ��
f_s = 2*500;    %������
N = f_s/Df;     %���е���
t = 0:1/f_s:(N-1)/f_s;  %����ʱ���
freq = 0:Df:(N-1)*Df;   %����Ƶ�ʶ�
f_t = 2*sin(2*pi*100*t)+cos(2*pi*180*t);    %�ź�
F_f = 1/f_s*fft(f_t,N); %��FFT����Ƶ��

%��ͼ
plot(freq-f_s/2,abs(fftshift(F_f)));        %����Ƶ���ƶ���FFT����
xlabel('Ƶ��');
ylabel('������');