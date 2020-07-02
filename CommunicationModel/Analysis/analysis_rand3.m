%��������
fs = 500;               % ������
Df = 1;                 % Ƶ�ʷֱ���
N = floor(fs/Df)+1;     % ��������е���
t = 0:1/fs:(N-1)/fs;    % ��ȡ�źŵ�ʱ���
F = 0:Df:fs;            % �����׹��Ƶ�Ƶ�ʷֱ��ʺͷ�Χ

%��ֵ����
xk = sin(2*pi*50*t)+2*sin(2*pi*130*t)+randn(1,length(t));   % ��ȡʱ����ϵ���ɢ�ź���������

Pxx = (abs(fft(xk(1:167))).^2+...                           % �����׹���
       abs(fft(xk(83:249))).^2+... 
       abs(fft(xk(168:334))).^2+... 
       abs(fft(xk(250:416))).^2+... 
       abs(fft(xk(335:501))).^2)/5/(N/3)^2;   
   
Pav_timedomain = sum(xk.^2)/N;                              % ��ʱ������źŹ���
Pav_freqdomain = sum(Pxx);                                  % ͨ�������׼����źŹ���

%���������ܶ�ͼ
plot(0:3:fs,10*log(Pxx));
xlabel('Ƶ�� Hz');
ylabel('PSD dB');