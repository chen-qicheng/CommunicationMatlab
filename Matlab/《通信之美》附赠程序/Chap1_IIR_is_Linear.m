[Num, Den] = butter(5, 0.4); % butterworth 滤波器，5阶，截止频率0.4pi
x1 = rand(100, 1); % 输入的序列1，长度100
x2 = rand(100, 1); % 输入的序列2，长度100

y1 = filter(Num, Den, x1);
y2 = filter(Num, Den, x2);

alpha = 5;
beta = 6;
x3 = alpha * x1 + beta * x2; % x1和x2的线性组合
y3 = filter(Num, Den, x3);

figure;
stem(y3 - (alpha * y1 + beta * y2)); grid on; % 画出两者的差
xlabel('Time Index'); ylabel('Error');

