clear
Len = 1e6;
s = rand(Len, 1);

tic;
a = s * 5;
tElapsed1 = toc;
disp(['��������̺�ʱ��', num2str(tElapsed1), '�롣']);

% ͬʱ��JIT��accelerator
feature jit on
feature accel on
b = zeros(Len, 1, 'double');
tic;
for k = 1 : Len
	b(k) = a(k) * 5;
end
tElapsed2 = toc;
disp(['ͬʱ��JIT��accelerator��ʱ��', num2str(tElapsed2), '�롣']);

% �ر�JIT����accelerator
feature jit off
feature accel on
c = zeros(Len, 1, 'double');
tic;
for k = 1 : Len
	c(k) = a(k) * 5;
end
tElapsed3 = toc;
disp(['�ر�JIT����accelerator��ʱ��', num2str(tElapsed3), '�롣']);

% ��JIT���ر�accelerator
feature jit on
feature accel off
d = zeros(Len, 1, 'double');
tic;
for k = 1 : Len
	d(k) = a(k) * 5;
end
tElapsed4 = toc;
disp(['��JIT���ر�accelerator��ʱ��', num2str(tElapsed4), '�롣']);

% ͬʱ�ر�JIT��accelerator
feature jit off
feature accel off
e = zeros(Len, 1, 'double');
tic;
for k = 1 : Len
	e(k) = a(k) * 5;
end
tElapsed5 = toc;
disp(['ͬʱ�ر�JIT��accelerator��ʱ��', num2str(tElapsed5), '�롣']);

tElapsed2/tElapsed1
tElapsed3/tElapsed2
tElapsed4/tElapsed2
tElapsed5/tElapsed2