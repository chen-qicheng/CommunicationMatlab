clear;

%�˲�������
fp=2400;%ͨ���ս�Ƶ��
fs=5000;%�����ʼƵ��
Rp=10;%ͨ���ڲ���
Rs=25;%�������С˥��

%�˲�������
[n,fn]=buttord(fp,fs,Rp,Rs,'s');%������˹ģ���˲���
Wn=2*pi*fn;
[b,a]=butter(n,Wn,'s');%������˹ģ���˲��������ݺ���

%��ͼ1
figure(1);
freqs(b,a);     %ֱ�ӻ��Ƴ���Ƶ��Ӧ����Ƶ��Ӧ����

%��ͼ2
f=0:100:10000;
s=1i*2*pi*f;    %s=jw=j*2*pi*f
Hs=polyval(b,s)./polyval(a,s);%����H(s)

figure(2);
subplot(2,1,1);plot(f,20*log10(abs(Hs)));%��Ƶ����
axis([0 10000 -40 1]);
xlabel("Ƶ�� Hz");ylabel("���� dB");
grid on;

subplot(2,1,2);plot(f,angle(Hs));%��Ƶ����
xlabel("Ƶ�� Hz");ylabel("��λ rad");
grid on;
