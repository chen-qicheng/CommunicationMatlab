[Num, Den] = butter(5, 0.4); % butterworth �˲�����5�ף���ֹƵ��0.4pi
x1 = rand(100, 1); % ���������1������100
x2 = rand(100, 1); % ���������2������100

y1 = filter(Num, Den, x1);
y2 = filter(Num, Den, x2);

alpha = 5;
beta = 6;
x3 = alpha * x1 + beta * x2; % x1��x2���������
y3 = filter(Num, Den, x3);

figure;
stem(y3 - (alpha * y1 + beta * y2)); grid on; % �������ߵĲ�
xlabel('Time Index'); ylabel('Error');

