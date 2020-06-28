%ʱ�����
fs = 200;               % ������
Delta_f = 1;            % Ƶ�ʷֱ���
T = 1/fs;               % ʱ��ֱ���
L = 1/Delta_f;          % ʱ���ȡ����
N = floor(fs/Delta_f)+1;% ����ض��źŵĲ�������
t = 0:T:L;              % ��ȡʱ��κͲ���ʱ���
freq = 0: Delta_f:fs;   % ������Ƶ�ʷ�Χ��Ƶ�ʷֱ���

%�ź�
f_t = (sin(2*pi*50*t)+0.7*sin(2*pi*75*t))';                      % ԭ�ź�
f_t_rectwin = rectwin(N).*f_t./sqrt(sum(abs(rectwin(N).^2))./N); % ���δ�
f_t_hamming = hamming(N).*f_t./sqrt(sum(abs(rectwin(N).^2))./N); % ������
f_t_hann = hann(N).*f_t./sqrt(sum(abs(rectwin(N).^2))./N);       % ������

%�ź�ʱ����ͼ
figure(1);
subplot(2,2,1);plot(t,f_t);title('ԭ�ź�');
subplot(2,2,2);plot(t,f_t_rectwin);title('���δ�');
subplot(2,2,3);plot(t,f_t_hamming);title('������');
subplot(2,2,4);plot(t,f_t_hann);title('������');

%fft�任
F_w_rectwin = T.*fft(f_t_rectwin,N);
F_w_hamming = T.*fft(f_t_hamming,N);
F_w_hann = T.*fft(f_t_hann,N);

%�ź�Ƶ��ͼ
figure(2);
subplot(3,1,1);plot(freq,10*log10(abs(F_w_rectwin)));
title('���δ�Ƶ��');ylabel('���� dB');
axis([0,200,-50,0]);grid on;

subplot(3,1,2);plot(freq,10*log10(abs(F_w_hamming)));
title('������Ƶ��');ylabel('���� dB');
axis([0,200,-50,0]);grid on;

subplot(3,1,3);plot(freq,10*log10(abs(F_w_hann)));
title('������Ƶ��');ylabel('���� dB');
axis([0,200,-50,0]);grid on;

%�����źŹ���
p_original_signal = var(f_t)                        % ԭʼ�ź�ƽ������
p_hannwindowed = sum((abs(F_w_hann/T)).^2)/(N^2)    % �Ӻ���������źŹ���

