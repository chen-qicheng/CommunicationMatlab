clear
Len = 1e6;
s = rand(Len, 1);

tic;
a = s * 5;
tElapsed1 = toc;
disp(['向量化编程耗时：', num2str(tElapsed1), '秒。']);

% 同时打开JIT和accelerator
feature jit on
feature accel on
b = zeros(Len, 1, 'double');
tic;
for k = 1 : Len
	b(k) = a(k) * 5;
end
tElapsed2 = toc;
disp(['同时打开JIT和accelerator耗时：', num2str(tElapsed2), '秒。']);

% 关闭JIT，打开accelerator
feature jit off
feature accel on
c = zeros(Len, 1, 'double');
tic;
for k = 1 : Len
	c(k) = a(k) * 5;
end
tElapsed3 = toc;
disp(['关闭JIT，打开accelerator耗时：', num2str(tElapsed3), '秒。']);

% 打开JIT，关闭accelerator
feature jit on
feature accel off
d = zeros(Len, 1, 'double');
tic;
for k = 1 : Len
	d(k) = a(k) * 5;
end
tElapsed4 = toc;
disp(['打开JIT，关闭accelerator耗时：', num2str(tElapsed4), '秒。']);

% 同时关闭JIT和accelerator
feature jit off
feature accel off
e = zeros(Len, 1, 'double');
tic;
for k = 1 : Len
	e(k) = a(k) * 5;
end
tElapsed5 = toc;
disp(['同时关闭JIT和accelerator耗时：', num2str(tElapsed5), '秒。']);

tElapsed2/tElapsed1
tElapsed3/tElapsed2
tElapsed4/tElapsed2
tElapsed5/tElapsed2