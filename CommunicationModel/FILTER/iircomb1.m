clear;

%��ױ�˲���
fs=8000;ts=1/fs;   %������
f0=500;            %��״�˲������ۻ�Ƶ��
bw=60/(fs/2);      %��һ�����۴���
ab=-3;             %���۴�������˥���ֱ�ֵ
n=fs/f0;           %�˲�������

[num,den]=iircomb(n,bw,ab,'notch'); %��ױ�˲���

freqz(num,den,4000,8000);
axis([0 4000 -40 3]);