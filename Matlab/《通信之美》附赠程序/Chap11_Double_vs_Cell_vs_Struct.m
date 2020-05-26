AccessCnt = 1e6;
a = magic(2);
b{1} = magic(2);
c.data = magic(2);

tic;
for i = 1 : AccessCnt
    a;
end
tElapsed1 = toc;
disp(['访问double型变量', num2str(AccessCnt, '%.1e'), '次，', ...
      '共耗时：', num2str(tElapsed1), '秒。']);

tic;
for i = 1 : AccessCnt
    b{1};
end
tElapsed2 = toc;
disp(['访问cell型变量', num2str(AccessCnt, '%.1e'), '次，', ...
      '共耗时：', num2str(tElapsed2), '秒。']);

tic;
for i = 1 : AccessCnt
    c.data;
end
tElapsed3 = toc;
disp(['访问struct型变量', num2str(AccessCnt, '%.1e'), '次，', ...
      '共耗时：', num2str(tElapsed3), '秒。']);

