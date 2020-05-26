clear
Len = 1e8;
tic;
for k = 1 : Len
	a(k) = k;
end
tElapsed1 = toc;
disp(['数组长度为', num2str(Len, '%g'), '时，', ...
     '不预分配内存耗时：', num2str(tElapsed1), '秒。']);

tic;
b = zeros(1, Len, 'double');
for k = 1 : Len
	b(k) = k;
end
tElapsed2 = toc;
disp(['数组长度为', num2str(Len, '%g'), '时，', ...
      '预分配内存耗时：', num2str(tElapsed2), '秒。']);
