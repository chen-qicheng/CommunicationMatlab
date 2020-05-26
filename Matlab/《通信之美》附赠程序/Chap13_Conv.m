Lx = 1e5;
Lh = 1e3;
x = rand(Lx, 1); % 生成随机的输入信号
h = rand(Lh, 1); % 生成随机的信道冲激响应

tic;
y1 = conv(x,h);
tElapsed1 = toc;
disp(['MATLAB built-in函数conv耗时：', num2str(tElapsed1), '秒。']);

tic;
y2 = zeros(Lx + Lh - 1, 1, 'double');
for n = 1 : Lx + Lh - 1
    Low = max(1, n+1-Lh);
    High = min(Lx, n);
    for k = Low : High 
        y2(n) = y2(n) + x(k) * h(n+1-k);
    end
end
tElapsed2 = toc;
disp(['MATLAB for循环耗时：', num2str(tElapsed2), '秒。']);

tic;
y3 = conv_mex(x,h);
tElapsed3 = toc;
disp(['C语言耗时：', num2str(tElapsed3), '秒。']);
 
% isequal(y1, y2)
sum(abs((y1 - y2)))
 
sum(abs((y1 - y3)))
